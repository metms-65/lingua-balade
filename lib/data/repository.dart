import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart';
import 'package:flutter/services.dart';

import 'database.dart';
import 'srs.dart';

extension WordText on Word {
  /// Le mot tel qu'il est prononcé et affiché : « der Tisch ».
  String get withArticle => article == null ? word : '$article $word';

  List<String> get translationList => translations.split(';').map((t) => t.trim()).toList();

  String get translationText => translationList.join(', ');
}

/// Situation des mots ajoutés par un thème de l'utilisateur.
const themeSituation = 'theme';

/// Clé de sélection d'un thème, à côté des situations intégrées (« theme:velo_ab12 »).
const themeKeyPrefix = 'theme:';

class WordWithProgress {
  const WordWithProgress(this.word, this.progress);

  final Word word;
  final WordProgress? progress;

  int get box => progress?.box ?? 0;
}

class ContentRepository {
  ContentRepository(this.db);

  final AppDatabase db;

  /// Importe le contenu livré dans les assets s'il a changé depuis le dernier lancement.
  Future<void> importContent(String lang) async {
    final vocab = await rootBundle.loadString('assets/content/$lang/vocabulary.json');
    final grammar = await rootBundle.loadString('assets/content/$lang/grammar.json');
    final hash = md5.convert(utf8.encode(vocab + grammar)).toString();
    final metaKey = 'content_$lang';
    if (await db.getMeta(metaKey) == hash) return;

    final words = jsonDecode(vocab) as List;
    final sheets = jsonDecode(grammar) as List;
    await db.transaction(() async {
      // Les mots ajoutés par les thèmes de l'utilisateur sont conservés.
      await (db.delete(db.words)..where((w) => w.lang.equals(lang) & w.situation.equals(themeSituation).not())).go();
      await (db.delete(db.grammarSheets)..where((g) => g.lang.equals(lang))).go();
      await db.batch((b) {
        b.insertAll(db.words, [
          for (final w in words.cast<Map<String, dynamic>>())
            WordsCompanion.insert(
              id: w['id'] as String,
              lang: lang,
              concept: w['concept'] as String,
              word: w['word'] as String,
              article: Value(w['article'] as String?),
              gender: Value(w['gender'] as String?),
              plural: Value(w['plural'] as String?),
              forms: Value(w['forms'] as String?),
              note: Value(w['note'] as String?),
              transliteration: Value(w['transliteration'] as String?),
              exampleTransliteration: Value((w['example'] as Map)['transliteration'] as String?),
              pos: w['pos'] as String,
              translations: (w['translations_fr'] as List).join('; '),
              rank: w['frequency_rank'] as int,
              situation: w['situation'] as String,
              exampleTarget: (w['example'] as Map)['target'] as String,
              exampleFr: (w['example'] as Map)['fr'] as String,
            ),
        ]);
        b.insertAll(db.grammarSheets, [
          for (final (i, g) in sheets.cast<Map<String, dynamic>>().indexed)
            GrammarSheetsCompanion.insert(
              id: g['id'] as String,
              lang: lang,
              title: g['title'] as String,
              level: g['level'] as String,
              position: i,
              body: jsonEncode(g),
            ),
        ]);
      });
      await db.setMeta(metaKey, hash);
    });
  }

  /// Filtre sur une situation intégrée, ou sur les mots d'un thème de l'utilisateur.
  Expression<bool> _inSituation(String key) {
    if (!key.startsWith(themeKeyPrefix)) return db.words.situation.equals(key);
    final themeId = key.substring(themeKeyPrefix.length);
    return db.words.id.isInQuery(db.selectOnly(db.themeWords)
      ..addColumns([db.themeWords.wordId])
      ..where(db.themeWords.themeId.equals(themeId)));
  }

  JoinedSelectStatement<HasResultSet, dynamic> _wordsJoin() => db.select(db.words).join([
        leftOuterJoin(db.progress, db.progress.wordId.equalsExp(db.words.id)),
      ]);

  WordWithProgress _row(TypedResult r) => WordWithProgress(r.readTable(db.words), r.readTableOrNull(db.progress));

  /// Mots d'une séance : d'abord ceux arrivés à échéance, puis des mots nouveaux par fréquence.
  Future<List<Word>> sessionWords({required String lang, String? situation, required int size}) async {
    final now = DateTime.now();
    Expression<bool> scope = db.words.lang.equals(lang);
    if (situation != null) scope = scope & _inSituation(situation);

    final due = await (_wordsJoin()
          ..where(scope & db.progress.box.isBiggerThanValue(0) & db.progress.due.isSmallerOrEqualValue(now))
          ..orderBy([OrderingTerm.asc(db.progress.due)])
          ..limit(size))
        .get();
    final result = due.map((r) => r.readTable(db.words)).toList();
    if (result.length < size) {
      final fresh = await (_wordsJoin()
            ..where(scope & (db.progress.wordId.isNull() | db.progress.box.equals(0)))
            ..orderBy([OrderingTerm.asc(db.words.rank)])
            ..limit(size - result.length))
          .get();
      result.addAll(fresh.map((r) => r.readTable(db.words)));
    }
    return result;
  }

  Stream<List<WordWithProgress>> watchWords(String lang, String situation) {
    final q = _wordsJoin()
      ..where(db.words.lang.equals(lang) & _inSituation(situation))
      ..orderBy([OrderingTerm.asc(db.words.rank)]);
    return q.watch().map((rows) => rows.map(_row).toList());
  }

  /// Nombre de mots par boîte de Leitner (0 = jamais entendus).
  Stream<Map<int, int>> watchBoxCounts(String lang) {
    final box = coalesce([db.progress.box, const Constant(0)]);
    final count = db.words.id.count();
    final q = db.selectOnly(db.words).join([
      leftOuterJoin(db.progress, db.progress.wordId.equalsExp(db.words.id), useColumns: false),
    ])
      ..addColumns([box, count])
      ..where(db.words.lang.equals(lang))
      ..groupBy([box]);
    return q.watch().map((rows) => {for (final r in rows) r.read(box)!: r.read(count)!});
  }

  /// Mots à revoir d'ici la fin de la journée (le flux reste juste quand on en signale de nouveaux).
  Stream<int> watchDueCount(String lang) {
    final now = DateTime.now();
    final endOfDay = DateTime(now.year, now.month, now.day + 1);
    final count = db.words.id.count();
    final q = db.selectOnly(db.words).join([
      innerJoin(db.progress, db.progress.wordId.equalsExp(db.words.id), useColumns: false),
    ])
      ..addColumns([count])
      ..where(db.words.lang.equals(lang) &
          db.progress.box.isBiggerThanValue(0) &
          db.progress.due.isSmallerThanValue(endOfDay));
    return q.watchSingle().map((r) => r.read(count) ?? 0);
  }

  Future<WordProgress?> _progress(String wordId) =>
      (db.select(db.progress)..where((p) => p.wordId.equals(wordId))).getSingleOrNull();

  Future<void> markHeard(String wordId) async {
    final now = DateTime.now();
    final p = await _progress(wordId);
    final next = afterHeard(p?.box ?? 0, p?.due, now);
    await db.into(db.progress).insertOnConflictUpdate(ProgressCompanion.insert(
          wordId: wordId,
          box: Value(next.box),
          due: Value(next.due),
          lastSeen: Value(now),
          lapses: Value(p?.lapses ?? 0),
        ));
  }

  Future<void> markForReview(String wordId) async {
    final now = DateTime.now();
    final p = await _progress(wordId);
    final next = afterLapse(now);
    await db.into(db.progress).insertOnConflictUpdate(ProgressCompanion.insert(
          wordId: wordId,
          box: Value(next.box),
          due: Value(next.due),
          lastSeen: Value(now),
          lapses: Value((p?.lapses ?? 0) + 1),
        ));
  }

  /// Mots étudiés récemment, pour que le compagnon les réutilise.
  Future<List<Word>> recentWords(String lang, {int limit = 25}) async {
    final rows = await (_wordsJoin()
          ..where(db.words.lang.equals(lang) & db.progress.lastSeen.isNotNull())
          ..orderBy([OrderingTerm.desc(db.progress.lastSeen)])
          ..limit(limit))
        .get();
    return rows.map((r) => r.readTable(db.words)).toList();
  }

  /// Retrouve des mots du vocabulaire à partir de leur forme écrite (« Tisch », « der Tisch »).
  Future<List<Word>> findWords(String lang, List<String> texts) async {
    final wanted = <String>{};
    for (final t in texts) {
      final parts = t.trim().toLowerCase().split(RegExp(r'\s+'));
      wanted.add(parts.join(' '));
      if (parts.length > 1) wanted.add(parts.sublist(1).join(' '));
    }
    if (wanted.isEmpty) return [];
    return (db.select(db.words)..where((w) => w.lang.equals(lang) & w.word.lower().isIn(wanted))).get();
  }

  Stream<List<GrammarSheet>> watchGrammar(String lang) => (db.select(db.grammarSheets)
        ..where((g) => g.lang.equals(lang))
        ..orderBy([(g) => OrderingTerm.asc(g.position)]))
      .watch();

  /// Range une correction ou une traduction de la balade dans la révision (sans doublon).
  Future<void> addRevision({
    required String lang,
    required String kind,
    required String prompt,
    required String answer,
    String? explanation,
  }) async {
    final existing = await (db.select(db.revisionItems)
          ..where((r) => r.lang.equals(lang) & r.answer.equals(answer) & r.prompt.equals(prompt)))
        .getSingleOrNull();
    if (existing != null) return;
    await db.into(db.revisionItems).insert(RevisionItemsCompanion.insert(
          lang: lang,
          kind: kind,
          prompt: prompt,
          answer: answer,
          explanation: Value(explanation),
          createdAt: DateTime.now(),
        ));
  }

  Stream<List<RevisionItem>> watchRevisions(String lang) => (db.select(db.revisionItems)
        ..where((r) => r.lang.equals(lang))
        ..orderBy([(r) => OrderingTerm.desc(r.createdAt)]))
      .watch();

  /// Éléments à travailler maintenant : nouveaux, ou arrivés à échéance.
  Future<List<RevisionItem>> dueRevisions(String lang) {
    final now = DateTime.now();
    return (db.select(db.revisionItems)
          ..where((r) => r.lang.equals(lang) & (r.box.equals(0) | r.due.isSmallerOrEqualValue(now)))
          ..orderBy([(r) => OrderingTerm.asc(r.box), (r) => OrderingTerm.asc(r.createdAt)]))
        .get();
  }

  Stream<int> watchDueRevisionCount(String lang) {
    final now = DateTime.now();
    final endOfDay = DateTime(now.year, now.month, now.day + 1);
    final count = db.revisionItems.id.count();
    final q = db.selectOnly(db.revisionItems)
      ..addColumns([count])
      ..where(db.revisionItems.lang.equals(lang) &
          (db.revisionItems.box.equals(0) | db.revisionItems.due.isSmallerThanValue(endOfDay)));
    return q.watchSingle().map((r) => r.read(count) ?? 0);
  }

  /// « Je savais » fait monter l'élément d'une boîte ; « À revoir » le renvoie en boîte 1.
  Future<void> answerRevision(RevisionItem item, {required bool known}) {
    final now = DateTime.now();
    final next = known ? afterHeard(item.box, null, now) : afterLapse(now);
    return (db.update(db.revisionItems)..where((r) => r.id.equals(item.id)))
        .write(RevisionItemsCompanion(box: Value(next.box), due: Value(next.due)));
  }

  Future<void> deleteRevision(int id) => (db.delete(db.revisionItems)..where((r) => r.id.equals(id))).go();

  /// Parmi [words], ceux que l'application connaît déjà (en minuscules).
  Future<Set<String>> knownWords(String lang, Iterable<String> words) async {
    final wanted = {for (final w in words) w.toLowerCase()};
    if (wanted.isEmpty) return {};
    final rows = await (db.select(db.words)..where((w) => w.lang.equals(lang) & w.word.lower().isIn(wanted))).get();
    return {for (final r in rows) r.word.toLowerCase()};
  }

  /// Recherche un mot dans tout le vocabulaire, dans la langue cible ou en français.
  Future<List<WordWithProgress>> searchWords(String lang, String query) async {
    final q = query.trim().toLowerCase();
    if (q.length < 2) return [];
    final pattern = '%$q%';
    final rows = await (_wordsJoin()
          ..where(db.words.lang.equals(lang) &
              (db.words.word.lower().like(pattern) | db.words.translations.lower().like(pattern)))
          ..orderBy([OrderingTerm.asc(db.words.rank)])
          ..limit(60))
        .get();
    return rows.map(_row).toList();
  }

  Stream<List<VocabTheme>> watchThemes(String lang) => (db.select(db.themes)
        ..where((t) => t.lang.equals(lang))
        ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
      .watch();

  /// Crée un thème à partir des mots proposés par l'IA. Les mots déjà connus de
  /// l'application sont réutilisés (avec leur progression), les autres sont ajoutés.
  /// Retourne la clé de sélection du thème.
  Future<String> createTheme({
    required String lang,
    required String label,
    required List<ThemeEntry> entries,
    String? Function(String? article)? genderOf,
    bool articleIsGender = false,
  }) async {
    final themeId = '${slugify(label)}_${DateTime.now().millisecondsSinceEpoch.toRadixString(36)}';
    await db.transaction(() async {
      await db.into(db.themes).insert(ThemesCompanion.insert(id: themeId, lang: lang, label: label, createdAt: DateTime.now()));
      final linked = <String>{};
      for (final (i, e) in entries.indexed) {
        final existing = await (db.select(db.words)
              ..where((w) => w.lang.equals(lang) & w.word.lower().equals(e.word.toLowerCase()))
              ..orderBy([(w) => OrderingTerm.asc(w.rank)])
              ..limit(1))
            .getSingleOrNull();
        var wordId = existing?.id;
        if (wordId == null) {
          wordId = '${lang}_t_${themeId}_$i';
          await db.into(db.words).insert(WordsCompanion.insert(
                id: wordId,
                lang: lang,
                concept: slugify(e.translations.first),
                word: e.word,
                article: Value(articleIsGender ? null : e.article),
                gender: Value(genderOf?.call(e.article)),
                plural: Value(e.plural),
                forms: Value(e.forms),
                pos: e.pos,
                translations: e.translations.join('; '),
                rank: 10000 + i,
                situation: themeSituation,
                exampleTarget: e.exampleTarget,
                exampleFr: e.exampleFr,
                transliteration: Value(e.transliteration),
                exampleTransliteration: Value(e.exampleTransliteration),
              ));
        }
        if (!linked.add(wordId)) continue;
        await db.into(db.themeWords).insert(ThemeWordsCompanion.insert(themeId: themeId, wordId: wordId, position: i));
      }
    });
    return '$themeKeyPrefix$themeId';
  }

  /// Supprime un thème et les mots ajoutés pour lui seul.
  Future<void> deleteTheme(String themeId) => db.transaction(() async {
        await (db.delete(db.themeWords)..where((t) => t.themeId.equals(themeId))).go();
        await (db.delete(db.themes)..where((t) => t.id.equals(themeId))).go();
        await db.customStatement(
          'DELETE FROM words WHERE situation = ? AND id NOT IN (SELECT word_id FROM theme_words)',
          [themeSituation],
        );
      });
}

/// Mot proposé par l'IA pour un thème.
class ThemeEntry {
  const ThemeEntry({
    required this.word,
    required this.translations,
    required this.pos,
    required this.exampleTarget,
    required this.exampleFr,
    this.article,
    this.plural,
    this.forms,
    this.transliteration,
    this.exampleTransliteration,
  });

  final String word;
  final String? article;
  final String? plural;
  final String? forms;
  final String pos;
  final List<String> translations;
  final String exampleTarget;
  final String exampleFr;

  /// Transcription en lettres latines (grec).
  final String? transliteration;
  final String? exampleTransliteration;
}

String slugify(String text) {
  const accents = {'à': 'a', 'â': 'a', 'ä': 'a', 'ç': 'c', 'é': 'e', 'è': 'e', 'ê': 'e', 'ë': 'e', 'î': 'i', 'ï': 'i',
    'ô': 'o', 'ö': 'o', 'ù': 'u', 'û': 'u', 'ü': 'u', 'ß': 'ss'};
  final lower = text.toLowerCase().split('').map((c) => accents[c] ?? c).join();
  final slug = lower.replaceAll(RegExp(r'[^a-z0-9]+'), '_').replaceAll(RegExp(r'^_+|_+$'), '');
  return slug.isEmpty ? 'theme' : (slug.length > 30 ? slug.substring(0, 30) : slug);
}
