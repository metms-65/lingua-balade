import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'database.g.dart';

class Words extends Table {
  TextColumn get id => text()();
  TextColumn get lang => text()();
  TextColumn get concept => text()();
  TextColumn get word => text()();
  TextColumn get article => text().nullable()();
  TextColumn get gender => text().nullable()();
  TextColumn get plural => text().nullable()();
  TextColumn get forms => text().nullable()();
  TextColumn get note => text().nullable()();

  /// Transcription en lettres latines (grec) du mot et de l'exemple.
  TextColumn get transliteration => text().nullable()();
  TextColumn get exampleTransliteration => text().nullable()();
  TextColumn get pos => text()();

  /// Traductions séparées par « ; ».
  TextColumn get translations => text()();
  IntColumn get rank => integer()();
  TextColumn get situation => text()();
  TextColumn get exampleTarget => text()();
  TextColumn get exampleFr => text()();

  @override
  Set<Column> get primaryKey => {id};
}

class GrammarSheets extends Table {
  TextColumn get id => text()();
  TextColumn get lang => text()();
  TextColumn get title => text()();
  TextColumn get level => text()();
  IntColumn get position => integer()();

  /// Fiche complète, au format JSON du cahier des charges.
  TextColumn get body => text()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Progression par mot (boîtes de Leitner). Conservée lors des mises à jour du contenu.
@DataClassName('WordProgress')
class Progress extends Table {
  TextColumn get wordId => text()();
  IntColumn get box => integer().withDefault(const Constant(0))();
  DateTimeColumn get due => dateTime().nullable()();
  DateTimeColumn get lastSeen => dateTime().nullable()();
  IntColumn get lapses => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {wordId};
}

@DataClassName('MetaEntry')
class Meta extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}

/// Phrases issues des balades avec le compagnon, à retravailler :
/// corrections de l'utilisateur et traductions demandées en français.
@DataClassName('RevisionItem')
class RevisionItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get lang => text()();

  /// « correction » ou « traduction ».
  TextColumn get kind => text()();

  /// Ce que l'utilisateur a dit : la phrase fautive, ou la phrase en français.
  TextColumn get prompt => text()();

  /// La bonne phrase dans la langue cible.
  TextColumn get answer => text()();
  TextColumn get explanation => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  IntColumn get box => integer().withDefault(const Constant(0))();
  DateTimeColumn get due => dateTime().nullable()();
}

/// Thème ajouté par l'utilisateur (« compétition de cyclisme »), dont l'IA a établi le vocabulaire.
@DataClassName('VocabTheme')
class Themes extends Table {
  TextColumn get id => text()();
  TextColumn get lang => text()();
  TextColumn get label => text()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Mots d'un thème : mots existants réutilisés, ou mots ajoutés pour lui (situation « theme »).
@DataClassName('ThemeWord')
class ThemeWords extends Table {
  TextColumn get themeId => text()();
  TextColumn get wordId => text()();
  IntColumn get position => integer()();

  @override
  Set<Column> get primaryKey => {themeId, wordId};
}

@DriftDatabase(tables: [Words, GrammarSheets, Progress, Meta, RevisionItems, Themes, ThemeWords])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? driftDatabase(name: 'lingua_balade'));

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onUpgrade: (m, from, to) async {
          if (from < 2) await m.createTable(revisionItems);
          if (from < 3) {
            await m.createTable(themes);
            await m.createTable(themeWords);
          }
          if (from < 4) {
            await m.addColumn(words, words.transliteration);
            await m.addColumn(words, words.exampleTransliteration);
          }
        },
      );

  Future<String?> getMeta(String key) async =>
      (await (select(meta)..where((m) => m.key.equals(key))).getSingleOrNull())?.value;

  Future<void> setMeta(String key, String value) =>
      into(meta).insertOnConflictUpdate(MetaCompanion.insert(key: key, value: value));
}
