import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lingua_balade/companion/theme_generator.dart';
import 'package:lingua_balade/core/languages.dart';
import 'package:lingua_balade/data/database.dart';
import 'package:lingua_balade/data/repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  test('la liste de l\'IA est lue, article collé au mot compris', () {
    final r = parseThemeVocabulary('''
{"titre":"Course cycliste","mots":[
 {"mot":"der Helm","article":null,"pluriel":"Helme","nature":"n","traductions_fr":["casque"],"exemple":"Der Helm ist rot.","exemple_fr":"Le casque est rouge."},
 {"mot":"anfeuern","article":null,"formes":"feuerte an, hat angefeuert","nature":"v","traductions_fr":["encourager"],"exemple":"Wir feuern ihn an!","exemple_fr":"Nous l'encourageons !"},
 {"mot":"","traductions_fr":["vide"]}
]}''', fallbackTitle: 'vélo');
    expect(r.title, 'Course cycliste');
    expect(r.entries, hasLength(2));
    expect(r.entries.first.word, 'Helm');
    expect(r.entries.first.article, 'der');
    expect(r.entries[1].pos, 'verb');
  });

  group('thèmes en base', () {
    late AppDatabase db;
    late ContentRepository repo;

    setUp(() async {
      db = AppDatabase(NativeDatabase.memory());
      repo = ContentRepository(db);
      await repo.importContent('de');
    });
    tearDown(() => db.close());

    const entries = [
      ThemeEntry(word: 'Fahrrad', article: 'das', pos: 'noun', translations: ['vélo'], exampleTarget: 'x', exampleFr: 'x'),
      ThemeEntry(word: 'Helm', article: 'der', pos: 'noun', translations: ['casque'], exampleTarget: 'y', exampleFr: 'y'),
      ThemeEntry(word: 'Helm', article: 'der', pos: 'noun', translations: ['casque'], exampleTarget: 'y', exampleFr: 'y'),
    ];

    test('la recherche trouve un mot par l\'allemand ou par le français', () async {
      expect((await repo.searchWords('de', 'mehl')).map((w) => w.word.word), contains('Mehl'));
      expect((await repo.searchWords('de', 'farine')).map((w) => w.word.word), contains('Mehl'));
      expect(await repo.searchWords('de', 'x'), isEmpty);
    });

    test('l\'aperçu signale les mots déjà connus', () async {
      final known = await repo.knownWords('de', ['Mehl', 'Zimt', 'pfeffer']);
      expect(known, {'mehl', 'pfeffer'});
    });

    test('un thème réutilise les mots connus et ajoute les autres', () async {
      final key = await repo.createTheme(lang: 'de', label: 'Course cycliste', entries: entries,
          genderOf: (a) => genderFromArticle('de', a));
      final words = await repo.watchWords('de', key).first;
      expect(words.map((w) => w.word.word), ['Fahrrad', 'Helm']);
      expect(words.first.word.situation, isNot(themeSituation), reason: 'Fahrrad vient des 1000 mots');
      expect(words.last.word.gender, 'm');

      final session = await repo.sessionWords(lang: 'de', situation: key, size: 10);
      expect(session, hasLength(2));
    });

    test('une mise à jour du contenu garde les mots des thèmes', () async {
      final key = await repo.createTheme(lang: 'de', label: 'Vélo', entries: entries);
      await db.setMeta('content_de', 'ancienne version');
      await repo.importContent('de');
      expect((await repo.watchWords('de', key).first).map((w) => w.word.word), contains('Helm'));
    });

    test('supprimer un thème retire ses mots propres, pas les mots communs', () async {
      final key = await repo.createTheme(lang: 'de', label: 'Vélo', entries: entries);
      await repo.deleteTheme(key.substring(themeKeyPrefix.length));
      final helm = await (db.select(db.words)..where((w) => w.word.equals('Helm'))).get();
      final fahrrad = await (db.select(db.words)..where((w) => w.word.equals('Fahrrad'))).get();
      expect(helm, isEmpty);
      expect(fahrrad, hasLength(1));
      expect(await repo.watchThemes('de').first, isEmpty);
    });
  });
}
