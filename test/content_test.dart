import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lingua_balade/core/languages.dart';
import 'package:lingua_balade/data/database.dart';
import 'package:lingua_balade/data/grammar.dart';
import 'package:lingua_balade/data/repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  final vocab = jsonDecode(File('assets/content/de/vocabulary.json').readAsStringSync()) as List;
  final grammar = jsonDecode(File('assets/content/de/grammar.json').readAsStringSync()) as List;

  test('au moins 1000 mots, identifiants uniques, situations connues', () {
    expect(vocab.length, greaterThanOrEqualTo(1000));
    final ids = vocab.map((w) => w['id']).toSet();
    expect(ids.length, vocab.length);
    for (final w in vocab.cast<Map<String, dynamic>>()) {
      expect(situationLabels.keys, contains(w['situation']), reason: '${w['word']}');
      expect((w['translations_fr'] as List), isNotEmpty, reason: '${w['word']}');
      expect((w['example'] as Map)['target'], isNotEmpty, reason: '${w['word']}');
    }
  });

  test('les noms avec article ont un genre cohérent', () {
    const expected = {'der': 'm', 'die': 'f', 'das': 'n'};
    for (final w in vocab.cast<Map<String, dynamic>>().where((w) => w['article'] != null)) {
      expect(w['gender'], expected[w['article']], reason: '${w['word']}');
    }
  });

  test('chaque fiche de grammaire a un tableau rectangulaire', () {
    for (final g in grammar.cast<Map<String, dynamic>>()) {
      final sheet = GrammarContent.fromJson(g);
      expect(sheet.columnLangs.length, sheet.headers.length, reason: sheet.id);
      expect(sheet.columnGenders.length, sheet.headers.length, reason: sheet.id);
      for (final r in sheet.rows) {
        expect(r.length, sheet.headers.length, reason: sheet.id);
      }
    }
  });

  test('grec : plus de 1000 entrées, toutes transcrites, tableaux rectangulaires', () {
    final el = jsonDecode(File('assets/content/el/vocabulary.json').readAsStringSync()) as List;
    expect(el.length, greaterThanOrEqualTo(1000));
    for (final w in el.cast<Map<String, dynamic>>()) {
      expect(w['transliteration'], isNotNull, reason: '${w['word']}');
      expect(RegExp('[\u0370-\u03ff]').hasMatch(w['transliteration'] as String), isFalse, reason: '${w['word']}');
      expect(situationLabels.keys, contains(w['situation']), reason: '${w['word']}');
    }
    final g = jsonDecode(File('assets/content/el/grammar.json').readAsStringSync()) as List;
    for (final s in g.cast<Map<String, dynamic>>()) {
      final sheet = GrammarContent.fromJson(s);
      expect(sheet.columnLangs.length, sheet.headers.length, reason: sheet.id);
      for (final r in sheet.rows) {
        expect(r.length, sheet.headers.length, reason: sheet.id);
      }
    }
  });

  test('latin : plus de 1000 entrées, genre des noms, tableaux rectangulaires', () {
    final la = jsonDecode(File('assets/content/la/vocabulary.json').readAsStringSync()) as List;
    expect(la.length, greaterThanOrEqualTo(1000));
    for (final w in la.cast<Map<String, dynamic>>()) {
      expect(w['article'], isNull, reason: '${w['word']}');
      if (w['pos'] == 'noun') expect(['m', 'f', 'n'], contains(w['gender']), reason: '${w['word']}');
      expect(situationLabels.keys, contains(w['situation']), reason: '${w['word']}');
    }
    final g = jsonDecode(File('assets/content/la/grammar.json').readAsStringSync()) as List;
    for (final s in g.cast<Map<String, dynamic>>()) {
      final sheet = GrammarContent.fromJson(s);
      for (final r in sheet.rows) {
        expect(r.length, sheet.headers.length, reason: sheet.id);
      }
    }
  });

  group('base de données', () {
    late AppDatabase db;
    late ContentRepository repo;

    setUp(() async {
      db = AppDatabase(NativeDatabase.memory());
      repo = ContentRepository(db);
      await repo.importContent('de');
    });
    tearDown(() => db.close());

    test('l\'import charge tout le contenu, une seule fois', () async {
      expect(await db.words.count().getSingle(), vocab.length);
      expect(await db.grammarSheets.count().getSingle(), grammar.length);
      await repo.importContent('de');
      expect(await db.words.count().getSingle(), vocab.length);
    });

    test('une séance propose d\'abord les mots à revoir, puis les plus fréquents', () async {
      final first = await repo.sessionWords(lang: 'de', size: 5);
      expect(first.map((w) => w.rank), [1, 2, 3, 4, 5]);

      await repo.markForReview(first[3].id);
      final next = await repo.sessionWords(lang: 'de', size: 5);
      expect(next.first.id, first[3].id);
    });

    test('un mot entendu n\'est plus proposé avant son échéance', () async {
      final first = await repo.sessionWords(lang: 'de', size: 3);
      await repo.markHeard(first[0].id);
      final next = await repo.sessionWords(lang: 'de', size: 3);
      expect(next.map((w) => w.id), isNot(contains(first[0].id)));
    });

    test('un mot signalé « à revoir » est compté immédiatement', () async {
      final counts = repo.watchDueCount('de');
      expect(await counts.first, 0);
      final first = await repo.sessionWords(lang: 'de', size: 1);
      final next = counts.firstWhere((n) => n == 1);
      await repo.markForReview(first.single.id);
      expect(await next, 1);
    });

    test('les mots du bilan sont retrouvés avec ou sans article', () async {
      final found = await repo.findWords('de', ['Tisch', 'der Bahnhof', 'inconnu']);
      expect(found.map((w) => w.word).toSet(), {'Tisch', 'Bahnhof'});
    });
  });
}
