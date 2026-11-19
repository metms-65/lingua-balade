// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $WordsTable extends Words with TableInfo<$WordsTable, Word> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _langMeta = const VerificationMeta('lang');
  @override
  late final GeneratedColumn<String> lang = GeneratedColumn<String>(
    'lang',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _conceptMeta = const VerificationMeta(
    'concept',
  );
  @override
  late final GeneratedColumn<String> concept = GeneratedColumn<String>(
    'concept',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _wordMeta = const VerificationMeta('word');
  @override
  late final GeneratedColumn<String> word = GeneratedColumn<String>(
    'word',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _articleMeta = const VerificationMeta(
    'article',
  );
  @override
  late final GeneratedColumn<String> article = GeneratedColumn<String>(
    'article',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _genderMeta = const VerificationMeta('gender');
  @override
  late final GeneratedColumn<String> gender = GeneratedColumn<String>(
    'gender',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pluralMeta = const VerificationMeta('plural');
  @override
  late final GeneratedColumn<String> plural = GeneratedColumn<String>(
    'plural',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _formsMeta = const VerificationMeta('forms');
  @override
  late final GeneratedColumn<String> forms = GeneratedColumn<String>(
    'forms',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _transliterationMeta = const VerificationMeta(
    'transliteration',
  );
  @override
  late final GeneratedColumn<String> transliteration = GeneratedColumn<String>(
    'transliteration',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _exampleTransliterationMeta =
      const VerificationMeta('exampleTransliteration');
  @override
  late final GeneratedColumn<String> exampleTransliteration =
      GeneratedColumn<String>(
        'example_transliteration',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _posMeta = const VerificationMeta('pos');
  @override
  late final GeneratedColumn<String> pos = GeneratedColumn<String>(
    'pos',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _translationsMeta = const VerificationMeta(
    'translations',
  );
  @override
  late final GeneratedColumn<String> translations = GeneratedColumn<String>(
    'translations',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rankMeta = const VerificationMeta('rank');
  @override
  late final GeneratedColumn<int> rank = GeneratedColumn<int>(
    'rank',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _situationMeta = const VerificationMeta(
    'situation',
  );
  @override
  late final GeneratedColumn<String> situation = GeneratedColumn<String>(
    'situation',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _exampleTargetMeta = const VerificationMeta(
    'exampleTarget',
  );
  @override
  late final GeneratedColumn<String> exampleTarget = GeneratedColumn<String>(
    'example_target',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _exampleFrMeta = const VerificationMeta(
    'exampleFr',
  );
  @override
  late final GeneratedColumn<String> exampleFr = GeneratedColumn<String>(
    'example_fr',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    lang,
    concept,
    word,
    article,
    gender,
    plural,
    forms,
    note,
    transliteration,
    exampleTransliteration,
    pos,
    translations,
    rank,
    situation,
    exampleTarget,
    exampleFr,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'words';
  @override
  VerificationContext validateIntegrity(
    Insertable<Word> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('lang')) {
      context.handle(
        _langMeta,
        lang.isAcceptableOrUnknown(data['lang']!, _langMeta),
      );
    } else if (isInserting) {
      context.missing(_langMeta);
    }
    if (data.containsKey('concept')) {
      context.handle(
        _conceptMeta,
        concept.isAcceptableOrUnknown(data['concept']!, _conceptMeta),
      );
    } else if (isInserting) {
      context.missing(_conceptMeta);
    }
    if (data.containsKey('word')) {
      context.handle(
        _wordMeta,
        word.isAcceptableOrUnknown(data['word']!, _wordMeta),
      );
    } else if (isInserting) {
      context.missing(_wordMeta);
    }
    if (data.containsKey('article')) {
      context.handle(
        _articleMeta,
        article.isAcceptableOrUnknown(data['article']!, _articleMeta),
      );
    }
    if (data.containsKey('gender')) {
      context.handle(
        _genderMeta,
        gender.isAcceptableOrUnknown(data['gender']!, _genderMeta),
      );
    }
    if (data.containsKey('plural')) {
      context.handle(
        _pluralMeta,
        plural.isAcceptableOrUnknown(data['plural']!, _pluralMeta),
      );
    }
    if (data.containsKey('forms')) {
      context.handle(
        _formsMeta,
        forms.isAcceptableOrUnknown(data['forms']!, _formsMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('transliteration')) {
      context.handle(
        _transliterationMeta,
        transliteration.isAcceptableOrUnknown(
          data['transliteration']!,
          _transliterationMeta,
        ),
      );
    }
    if (data.containsKey('example_transliteration')) {
      context.handle(
        _exampleTransliterationMeta,
        exampleTransliteration.isAcceptableOrUnknown(
          data['example_transliteration']!,
          _exampleTransliterationMeta,
        ),
      );
    }
    if (data.containsKey('pos')) {
      context.handle(
        _posMeta,
        pos.isAcceptableOrUnknown(data['pos']!, _posMeta),
      );
    } else if (isInserting) {
      context.missing(_posMeta);
    }
    if (data.containsKey('translations')) {
      context.handle(
        _translationsMeta,
        translations.isAcceptableOrUnknown(
          data['translations']!,
          _translationsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_translationsMeta);
    }
    if (data.containsKey('rank')) {
      context.handle(
        _rankMeta,
        rank.isAcceptableOrUnknown(data['rank']!, _rankMeta),
      );
    } else if (isInserting) {
      context.missing(_rankMeta);
    }
    if (data.containsKey('situation')) {
      context.handle(
        _situationMeta,
        situation.isAcceptableOrUnknown(data['situation']!, _situationMeta),
      );
    } else if (isInserting) {
      context.missing(_situationMeta);
    }
    if (data.containsKey('example_target')) {
      context.handle(
        _exampleTargetMeta,
        exampleTarget.isAcceptableOrUnknown(
          data['example_target']!,
          _exampleTargetMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_exampleTargetMeta);
    }
    if (data.containsKey('example_fr')) {
      context.handle(
        _exampleFrMeta,
        exampleFr.isAcceptableOrUnknown(data['example_fr']!, _exampleFrMeta),
      );
    } else if (isInserting) {
      context.missing(_exampleFrMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Word map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Word(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      lang: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lang'],
      )!,
      concept: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}concept'],
      )!,
      word: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}word'],
      )!,
      article: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}article'],
      ),
      gender: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gender'],
      ),
      plural: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}plural'],
      ),
      forms: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}forms'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      transliteration: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}transliteration'],
      ),
      exampleTransliteration: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}example_transliteration'],
      ),
      pos: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pos'],
      )!,
      translations: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}translations'],
      )!,
      rank: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rank'],
      )!,
      situation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}situation'],
      )!,
      exampleTarget: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}example_target'],
      )!,
      exampleFr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}example_fr'],
      )!,
    );
  }

  @override
  $WordsTable createAlias(String alias) {
    return $WordsTable(attachedDatabase, alias);
  }
}

class Word extends DataClass implements Insertable<Word> {
  final String id;
  final String lang;
  final String concept;
  final String word;
  final String? article;
  final String? gender;
  final String? plural;
  final String? forms;
  final String? note;

  /// Transcription en lettres latines (grec) du mot et de l'exemple.
  final String? transliteration;
  final String? exampleTransliteration;
  final String pos;

  /// Traductions séparées par « ; ».
  final String translations;
  final int rank;
  final String situation;
  final String exampleTarget;
  final String exampleFr;
  const Word({
    required this.id,
    required this.lang,
    required this.concept,
    required this.word,
    this.article,
    this.gender,
    this.plural,
    this.forms,
    this.note,
    this.transliteration,
    this.exampleTransliteration,
    required this.pos,
    required this.translations,
    required this.rank,
    required this.situation,
    required this.exampleTarget,
    required this.exampleFr,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['lang'] = Variable<String>(lang);
    map['concept'] = Variable<String>(concept);
    map['word'] = Variable<String>(word);
    if (!nullToAbsent || article != null) {
      map['article'] = Variable<String>(article);
    }
    if (!nullToAbsent || gender != null) {
      map['gender'] = Variable<String>(gender);
    }
    if (!nullToAbsent || plural != null) {
      map['plural'] = Variable<String>(plural);
    }
    if (!nullToAbsent || forms != null) {
      map['forms'] = Variable<String>(forms);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    if (!nullToAbsent || transliteration != null) {
      map['transliteration'] = Variable<String>(transliteration);
    }
    if (!nullToAbsent || exampleTransliteration != null) {
      map['example_transliteration'] = Variable<String>(exampleTransliteration);
    }
    map['pos'] = Variable<String>(pos);
    map['translations'] = Variable<String>(translations);
    map['rank'] = Variable<int>(rank);
    map['situation'] = Variable<String>(situation);
    map['example_target'] = Variable<String>(exampleTarget);
    map['example_fr'] = Variable<String>(exampleFr);
    return map;
  }

  WordsCompanion toCompanion(bool nullToAbsent) {
    return WordsCompanion(
      id: Value(id),
      lang: Value(lang),
      concept: Value(concept),
      word: Value(word),
      article: article == null && nullToAbsent
          ? const Value.absent()
          : Value(article),
      gender: gender == null && nullToAbsent
          ? const Value.absent()
          : Value(gender),
      plural: plural == null && nullToAbsent
          ? const Value.absent()
          : Value(plural),
      forms: forms == null && nullToAbsent
          ? const Value.absent()
          : Value(forms),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      transliteration: transliteration == null && nullToAbsent
          ? const Value.absent()
          : Value(transliteration),
      exampleTransliteration: exampleTransliteration == null && nullToAbsent
          ? const Value.absent()
          : Value(exampleTransliteration),
      pos: Value(pos),
      translations: Value(translations),
      rank: Value(rank),
      situation: Value(situation),
      exampleTarget: Value(exampleTarget),
      exampleFr: Value(exampleFr),
    );
  }

  factory Word.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Word(
      id: serializer.fromJson<String>(json['id']),
      lang: serializer.fromJson<String>(json['lang']),
      concept: serializer.fromJson<String>(json['concept']),
      word: serializer.fromJson<String>(json['word']),
      article: serializer.fromJson<String?>(json['article']),
      gender: serializer.fromJson<String?>(json['gender']),
      plural: serializer.fromJson<String?>(json['plural']),
      forms: serializer.fromJson<String?>(json['forms']),
      note: serializer.fromJson<String?>(json['note']),
      transliteration: serializer.fromJson<String?>(json['transliteration']),
      exampleTransliteration: serializer.fromJson<String?>(
        json['exampleTransliteration'],
      ),
      pos: serializer.fromJson<String>(json['pos']),
      translations: serializer.fromJson<String>(json['translations']),
      rank: serializer.fromJson<int>(json['rank']),
      situation: serializer.fromJson<String>(json['situation']),
      exampleTarget: serializer.fromJson<String>(json['exampleTarget']),
      exampleFr: serializer.fromJson<String>(json['exampleFr']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'lang': serializer.toJson<String>(lang),
      'concept': serializer.toJson<String>(concept),
      'word': serializer.toJson<String>(word),
      'article': serializer.toJson<String?>(article),
      'gender': serializer.toJson<String?>(gender),
      'plural': serializer.toJson<String?>(plural),
      'forms': serializer.toJson<String?>(forms),
      'note': serializer.toJson<String?>(note),
      'transliteration': serializer.toJson<String?>(transliteration),
      'exampleTransliteration': serializer.toJson<String?>(
        exampleTransliteration,
      ),
      'pos': serializer.toJson<String>(pos),
      'translations': serializer.toJson<String>(translations),
      'rank': serializer.toJson<int>(rank),
      'situation': serializer.toJson<String>(situation),
      'exampleTarget': serializer.toJson<String>(exampleTarget),
      'exampleFr': serializer.toJson<String>(exampleFr),
    };
  }

  Word copyWith({
    String? id,
    String? lang,
    String? concept,
    String? word,
    Value<String?> article = const Value.absent(),
    Value<String?> gender = const Value.absent(),
    Value<String?> plural = const Value.absent(),
    Value<String?> forms = const Value.absent(),
    Value<String?> note = const Value.absent(),
    Value<String?> transliteration = const Value.absent(),
    Value<String?> exampleTransliteration = const Value.absent(),
    String? pos,
    String? translations,
    int? rank,
    String? situation,
    String? exampleTarget,
    String? exampleFr,
  }) => Word(
    id: id ?? this.id,
    lang: lang ?? this.lang,
    concept: concept ?? this.concept,
    word: word ?? this.word,
    article: article.present ? article.value : this.article,
    gender: gender.present ? gender.value : this.gender,
    plural: plural.present ? plural.value : this.plural,
    forms: forms.present ? forms.value : this.forms,
    note: note.present ? note.value : this.note,
    transliteration: transliteration.present
        ? transliteration.value
        : this.transliteration,
    exampleTransliteration: exampleTransliteration.present
        ? exampleTransliteration.value
        : this.exampleTransliteration,
    pos: pos ?? this.pos,
    translations: translations ?? this.translations,
    rank: rank ?? this.rank,
    situation: situation ?? this.situation,
    exampleTarget: exampleTarget ?? this.exampleTarget,
    exampleFr: exampleFr ?? this.exampleFr,
  );
  Word copyWithCompanion(WordsCompanion data) {
    return Word(
      id: data.id.present ? data.id.value : this.id,
      lang: data.lang.present ? data.lang.value : this.lang,
      concept: data.concept.present ? data.concept.value : this.concept,
      word: data.word.present ? data.word.value : this.word,
      article: data.article.present ? data.article.value : this.article,
      gender: data.gender.present ? data.gender.value : this.gender,
      plural: data.plural.present ? data.plural.value : this.plural,
      forms: data.forms.present ? data.forms.value : this.forms,
      note: data.note.present ? data.note.value : this.note,
      transliteration: data.transliteration.present
          ? data.transliteration.value
          : this.transliteration,
      exampleTransliteration: data.exampleTransliteration.present
          ? data.exampleTransliteration.value
          : this.exampleTransliteration,
      pos: data.pos.present ? data.pos.value : this.pos,
      translations: data.translations.present
          ? data.translations.value
          : this.translations,
      rank: data.rank.present ? data.rank.value : this.rank,
      situation: data.situation.present ? data.situation.value : this.situation,
      exampleTarget: data.exampleTarget.present
          ? data.exampleTarget.value
          : this.exampleTarget,
      exampleFr: data.exampleFr.present ? data.exampleFr.value : this.exampleFr,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Word(')
          ..write('id: $id, ')
          ..write('lang: $lang, ')
          ..write('concept: $concept, ')
          ..write('word: $word, ')
          ..write('article: $article, ')
          ..write('gender: $gender, ')
          ..write('plural: $plural, ')
          ..write('forms: $forms, ')
          ..write('note: $note, ')
          ..write('transliteration: $transliteration, ')
          ..write('exampleTransliteration: $exampleTransliteration, ')
          ..write('pos: $pos, ')
          ..write('translations: $translations, ')
          ..write('rank: $rank, ')
          ..write('situation: $situation, ')
          ..write('exampleTarget: $exampleTarget, ')
          ..write('exampleFr: $exampleFr')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    lang,
    concept,
    word,
    article,
    gender,
    plural,
    forms,
    note,
    transliteration,
    exampleTransliteration,
    pos,
    translations,
    rank,
    situation,
    exampleTarget,
    exampleFr,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Word &&
          other.id == this.id &&
          other.lang == this.lang &&
          other.concept == this.concept &&
          other.word == this.word &&
          other.article == this.article &&
          other.gender == this.gender &&
          other.plural == this.plural &&
          other.forms == this.forms &&
          other.note == this.note &&
          other.transliteration == this.transliteration &&
          other.exampleTransliteration == this.exampleTransliteration &&
          other.pos == this.pos &&
          other.translations == this.translations &&
          other.rank == this.rank &&
          other.situation == this.situation &&
          other.exampleTarget == this.exampleTarget &&
          other.exampleFr == this.exampleFr);
}

class WordsCompanion extends UpdateCompanion<Word> {
  final Value<String> id;
  final Value<String> lang;
  final Value<String> concept;
  final Value<String> word;
  final Value<String?> article;
  final Value<String?> gender;
  final Value<String?> plural;
  final Value<String?> forms;
  final Value<String?> note;
  final Value<String?> transliteration;
  final Value<String?> exampleTransliteration;
  final Value<String> pos;
  final Value<String> translations;
  final Value<int> rank;
  final Value<String> situation;
  final Value<String> exampleTarget;
  final Value<String> exampleFr;
  final Value<int> rowid;
  const WordsCompanion({
    this.id = const Value.absent(),
    this.lang = const Value.absent(),
    this.concept = const Value.absent(),
    this.word = const Value.absent(),
    this.article = const Value.absent(),
    this.gender = const Value.absent(),
    this.plural = const Value.absent(),
    this.forms = const Value.absent(),
    this.note = const Value.absent(),
    this.transliteration = const Value.absent(),
    this.exampleTransliteration = const Value.absent(),
    this.pos = const Value.absent(),
    this.translations = const Value.absent(),
    this.rank = const Value.absent(),
    this.situation = const Value.absent(),
    this.exampleTarget = const Value.absent(),
    this.exampleFr = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WordsCompanion.insert({
    required String id,
    required String lang,
    required String concept,
    required String word,
    this.article = const Value.absent(),
    this.gender = const Value.absent(),
    this.plural = const Value.absent(),
    this.forms = const Value.absent(),
    this.note = const Value.absent(),
    this.transliteration = const Value.absent(),
    this.exampleTransliteration = const Value.absent(),
    required String pos,
    required String translations,
    required int rank,
    required String situation,
    required String exampleTarget,
    required String exampleFr,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       lang = Value(lang),
       concept = Value(concept),
       word = Value(word),
       pos = Value(pos),
       translations = Value(translations),
       rank = Value(rank),
       situation = Value(situation),
       exampleTarget = Value(exampleTarget),
       exampleFr = Value(exampleFr);
  static Insertable<Word> custom({
    Expression<String>? id,
    Expression<String>? lang,
    Expression<String>? concept,
    Expression<String>? word,
    Expression<String>? article,
    Expression<String>? gender,
    Expression<String>? plural,
    Expression<String>? forms,
    Expression<String>? note,
    Expression<String>? transliteration,
    Expression<String>? exampleTransliteration,
    Expression<String>? pos,
    Expression<String>? translations,
    Expression<int>? rank,
    Expression<String>? situation,
    Expression<String>? exampleTarget,
    Expression<String>? exampleFr,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (lang != null) 'lang': lang,
      if (concept != null) 'concept': concept,
      if (word != null) 'word': word,
      if (article != null) 'article': article,
      if (gender != null) 'gender': gender,
      if (plural != null) 'plural': plural,
      if (forms != null) 'forms': forms,
      if (note != null) 'note': note,
      if (transliteration != null) 'transliteration': transliteration,
      if (exampleTransliteration != null)
        'example_transliteration': exampleTransliteration,
      if (pos != null) 'pos': pos,
      if (translations != null) 'translations': translations,
      if (rank != null) 'rank': rank,
      if (situation != null) 'situation': situation,
      if (exampleTarget != null) 'example_target': exampleTarget,
      if (exampleFr != null) 'example_fr': exampleFr,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WordsCompanion copyWith({
    Value<String>? id,
    Value<String>? lang,
    Value<String>? concept,
    Value<String>? word,
    Value<String?>? article,
    Value<String?>? gender,
    Value<String?>? plural,
    Value<String?>? forms,
    Value<String?>? note,
    Value<String?>? transliteration,
    Value<String?>? exampleTransliteration,
    Value<String>? pos,
    Value<String>? translations,
    Value<int>? rank,
    Value<String>? situation,
    Value<String>? exampleTarget,
    Value<String>? exampleFr,
    Value<int>? rowid,
  }) {
    return WordsCompanion(
      id: id ?? this.id,
      lang: lang ?? this.lang,
      concept: concept ?? this.concept,
      word: word ?? this.word,
      article: article ?? this.article,
      gender: gender ?? this.gender,
      plural: plural ?? this.plural,
      forms: forms ?? this.forms,
      note: note ?? this.note,
      transliteration: transliteration ?? this.transliteration,
      exampleTransliteration:
          exampleTransliteration ?? this.exampleTransliteration,
      pos: pos ?? this.pos,
      translations: translations ?? this.translations,
      rank: rank ?? this.rank,
      situation: situation ?? this.situation,
      exampleTarget: exampleTarget ?? this.exampleTarget,
      exampleFr: exampleFr ?? this.exampleFr,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (lang.present) {
      map['lang'] = Variable<String>(lang.value);
    }
    if (concept.present) {
      map['concept'] = Variable<String>(concept.value);
    }
    if (word.present) {
      map['word'] = Variable<String>(word.value);
    }
    if (article.present) {
      map['article'] = Variable<String>(article.value);
    }
    if (gender.present) {
      map['gender'] = Variable<String>(gender.value);
    }
    if (plural.present) {
      map['plural'] = Variable<String>(plural.value);
    }
    if (forms.present) {
      map['forms'] = Variable<String>(forms.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (transliteration.present) {
      map['transliteration'] = Variable<String>(transliteration.value);
    }
    if (exampleTransliteration.present) {
      map['example_transliteration'] = Variable<String>(
        exampleTransliteration.value,
      );
    }
    if (pos.present) {
      map['pos'] = Variable<String>(pos.value);
    }
    if (translations.present) {
      map['translations'] = Variable<String>(translations.value);
    }
    if (rank.present) {
      map['rank'] = Variable<int>(rank.value);
    }
    if (situation.present) {
      map['situation'] = Variable<String>(situation.value);
    }
    if (exampleTarget.present) {
      map['example_target'] = Variable<String>(exampleTarget.value);
    }
    if (exampleFr.present) {
      map['example_fr'] = Variable<String>(exampleFr.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WordsCompanion(')
          ..write('id: $id, ')
          ..write('lang: $lang, ')
          ..write('concept: $concept, ')
          ..write('word: $word, ')
          ..write('article: $article, ')
          ..write('gender: $gender, ')
          ..write('plural: $plural, ')
          ..write('forms: $forms, ')
          ..write('note: $note, ')
          ..write('transliteration: $transliteration, ')
          ..write('exampleTransliteration: $exampleTransliteration, ')
          ..write('pos: $pos, ')
          ..write('translations: $translations, ')
          ..write('rank: $rank, ')
          ..write('situation: $situation, ')
          ..write('exampleTarget: $exampleTarget, ')
          ..write('exampleFr: $exampleFr, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GrammarSheetsTable extends GrammarSheets
    with TableInfo<$GrammarSheetsTable, GrammarSheet> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GrammarSheetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _langMeta = const VerificationMeta('lang');
  @override
  late final GeneratedColumn<String> lang = GeneratedColumn<String>(
    'lang',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<String> level = GeneratedColumn<String>(
    'level',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
    'body',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    lang,
    title,
    level,
    position,
    body,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'grammar_sheets';
  @override
  VerificationContext validateIntegrity(
    Insertable<GrammarSheet> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('lang')) {
      context.handle(
        _langMeta,
        lang.isAcceptableOrUnknown(data['lang']!, _langMeta),
      );
    } else if (isInserting) {
      context.missing(_langMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('level')) {
      context.handle(
        _levelMeta,
        level.isAcceptableOrUnknown(data['level']!, _levelMeta),
      );
    } else if (isInserting) {
      context.missing(_levelMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('body')) {
      context.handle(
        _bodyMeta,
        body.isAcceptableOrUnknown(data['body']!, _bodyMeta),
      );
    } else if (isInserting) {
      context.missing(_bodyMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GrammarSheet map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GrammarSheet(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      lang: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lang'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      level: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}level'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      body: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body'],
      )!,
    );
  }

  @override
  $GrammarSheetsTable createAlias(String alias) {
    return $GrammarSheetsTable(attachedDatabase, alias);
  }
}

class GrammarSheet extends DataClass implements Insertable<GrammarSheet> {
  final String id;
  final String lang;
  final String title;
  final String level;
  final int position;

  /// Fiche complète, au format JSON du cahier des charges.
  final String body;
  const GrammarSheet({
    required this.id,
    required this.lang,
    required this.title,
    required this.level,
    required this.position,
    required this.body,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['lang'] = Variable<String>(lang);
    map['title'] = Variable<String>(title);
    map['level'] = Variable<String>(level);
    map['position'] = Variable<int>(position);
    map['body'] = Variable<String>(body);
    return map;
  }

  GrammarSheetsCompanion toCompanion(bool nullToAbsent) {
    return GrammarSheetsCompanion(
      id: Value(id),
      lang: Value(lang),
      title: Value(title),
      level: Value(level),
      position: Value(position),
      body: Value(body),
    );
  }

  factory GrammarSheet.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GrammarSheet(
      id: serializer.fromJson<String>(json['id']),
      lang: serializer.fromJson<String>(json['lang']),
      title: serializer.fromJson<String>(json['title']),
      level: serializer.fromJson<String>(json['level']),
      position: serializer.fromJson<int>(json['position']),
      body: serializer.fromJson<String>(json['body']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'lang': serializer.toJson<String>(lang),
      'title': serializer.toJson<String>(title),
      'level': serializer.toJson<String>(level),
      'position': serializer.toJson<int>(position),
      'body': serializer.toJson<String>(body),
    };
  }

  GrammarSheet copyWith({
    String? id,
    String? lang,
    String? title,
    String? level,
    int? position,
    String? body,
  }) => GrammarSheet(
    id: id ?? this.id,
    lang: lang ?? this.lang,
    title: title ?? this.title,
    level: level ?? this.level,
    position: position ?? this.position,
    body: body ?? this.body,
  );
  GrammarSheet copyWithCompanion(GrammarSheetsCompanion data) {
    return GrammarSheet(
      id: data.id.present ? data.id.value : this.id,
      lang: data.lang.present ? data.lang.value : this.lang,
      title: data.title.present ? data.title.value : this.title,
      level: data.level.present ? data.level.value : this.level,
      position: data.position.present ? data.position.value : this.position,
      body: data.body.present ? data.body.value : this.body,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GrammarSheet(')
          ..write('id: $id, ')
          ..write('lang: $lang, ')
          ..write('title: $title, ')
          ..write('level: $level, ')
          ..write('position: $position, ')
          ..write('body: $body')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, lang, title, level, position, body);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GrammarSheet &&
          other.id == this.id &&
          other.lang == this.lang &&
          other.title == this.title &&
          other.level == this.level &&
          other.position == this.position &&
          other.body == this.body);
}

class GrammarSheetsCompanion extends UpdateCompanion<GrammarSheet> {
  final Value<String> id;
  final Value<String> lang;
  final Value<String> title;
  final Value<String> level;
  final Value<int> position;
  final Value<String> body;
  final Value<int> rowid;
  const GrammarSheetsCompanion({
    this.id = const Value.absent(),
    this.lang = const Value.absent(),
    this.title = const Value.absent(),
    this.level = const Value.absent(),
    this.position = const Value.absent(),
    this.body = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GrammarSheetsCompanion.insert({
    required String id,
    required String lang,
    required String title,
    required String level,
    required int position,
    required String body,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       lang = Value(lang),
       title = Value(title),
       level = Value(level),
       position = Value(position),
       body = Value(body);
  static Insertable<GrammarSheet> custom({
    Expression<String>? id,
    Expression<String>? lang,
    Expression<String>? title,
    Expression<String>? level,
    Expression<int>? position,
    Expression<String>? body,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (lang != null) 'lang': lang,
      if (title != null) 'title': title,
      if (level != null) 'level': level,
      if (position != null) 'position': position,
      if (body != null) 'body': body,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GrammarSheetsCompanion copyWith({
    Value<String>? id,
    Value<String>? lang,
    Value<String>? title,
    Value<String>? level,
    Value<int>? position,
    Value<String>? body,
    Value<int>? rowid,
  }) {
    return GrammarSheetsCompanion(
      id: id ?? this.id,
      lang: lang ?? this.lang,
      title: title ?? this.title,
      level: level ?? this.level,
      position: position ?? this.position,
      body: body ?? this.body,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (lang.present) {
      map['lang'] = Variable<String>(lang.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (level.present) {
      map['level'] = Variable<String>(level.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GrammarSheetsCompanion(')
          ..write('id: $id, ')
          ..write('lang: $lang, ')
          ..write('title: $title, ')
          ..write('level: $level, ')
          ..write('position: $position, ')
          ..write('body: $body, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProgressTable extends Progress
    with TableInfo<$ProgressTable, WordProgress> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProgressTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _wordIdMeta = const VerificationMeta('wordId');
  @override
  late final GeneratedColumn<String> wordId = GeneratedColumn<String>(
    'word_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _boxMeta = const VerificationMeta('box');
  @override
  late final GeneratedColumn<int> box = GeneratedColumn<int>(
    'box',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _dueMeta = const VerificationMeta('due');
  @override
  late final GeneratedColumn<DateTime> due = GeneratedColumn<DateTime>(
    'due',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastSeenMeta = const VerificationMeta(
    'lastSeen',
  );
  @override
  late final GeneratedColumn<DateTime> lastSeen = GeneratedColumn<DateTime>(
    'last_seen',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lapsesMeta = const VerificationMeta('lapses');
  @override
  late final GeneratedColumn<int> lapses = GeneratedColumn<int>(
    'lapses',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [wordId, box, due, lastSeen, lapses];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'progress';
  @override
  VerificationContext validateIntegrity(
    Insertable<WordProgress> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('word_id')) {
      context.handle(
        _wordIdMeta,
        wordId.isAcceptableOrUnknown(data['word_id']!, _wordIdMeta),
      );
    } else if (isInserting) {
      context.missing(_wordIdMeta);
    }
    if (data.containsKey('box')) {
      context.handle(
        _boxMeta,
        box.isAcceptableOrUnknown(data['box']!, _boxMeta),
      );
    }
    if (data.containsKey('due')) {
      context.handle(
        _dueMeta,
        due.isAcceptableOrUnknown(data['due']!, _dueMeta),
      );
    }
    if (data.containsKey('last_seen')) {
      context.handle(
        _lastSeenMeta,
        lastSeen.isAcceptableOrUnknown(data['last_seen']!, _lastSeenMeta),
      );
    }
    if (data.containsKey('lapses')) {
      context.handle(
        _lapsesMeta,
        lapses.isAcceptableOrUnknown(data['lapses']!, _lapsesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {wordId};
  @override
  WordProgress map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WordProgress(
      wordId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}word_id'],
      )!,
      box: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}box'],
      )!,
      due: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}due'],
      ),
      lastSeen: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_seen'],
      ),
      lapses: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}lapses'],
      )!,
    );
  }

  @override
  $ProgressTable createAlias(String alias) {
    return $ProgressTable(attachedDatabase, alias);
  }
}

class WordProgress extends DataClass implements Insertable<WordProgress> {
  final String wordId;
  final int box;
  final DateTime? due;
  final DateTime? lastSeen;
  final int lapses;
  const WordProgress({
    required this.wordId,
    required this.box,
    this.due,
    this.lastSeen,
    required this.lapses,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['word_id'] = Variable<String>(wordId);
    map['box'] = Variable<int>(box);
    if (!nullToAbsent || due != null) {
      map['due'] = Variable<DateTime>(due);
    }
    if (!nullToAbsent || lastSeen != null) {
      map['last_seen'] = Variable<DateTime>(lastSeen);
    }
    map['lapses'] = Variable<int>(lapses);
    return map;
  }

  ProgressCompanion toCompanion(bool nullToAbsent) {
    return ProgressCompanion(
      wordId: Value(wordId),
      box: Value(box),
      due: due == null && nullToAbsent ? const Value.absent() : Value(due),
      lastSeen: lastSeen == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSeen),
      lapses: Value(lapses),
    );
  }

  factory WordProgress.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WordProgress(
      wordId: serializer.fromJson<String>(json['wordId']),
      box: serializer.fromJson<int>(json['box']),
      due: serializer.fromJson<DateTime?>(json['due']),
      lastSeen: serializer.fromJson<DateTime?>(json['lastSeen']),
      lapses: serializer.fromJson<int>(json['lapses']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'wordId': serializer.toJson<String>(wordId),
      'box': serializer.toJson<int>(box),
      'due': serializer.toJson<DateTime?>(due),
      'lastSeen': serializer.toJson<DateTime?>(lastSeen),
      'lapses': serializer.toJson<int>(lapses),
    };
  }

  WordProgress copyWith({
    String? wordId,
    int? box,
    Value<DateTime?> due = const Value.absent(),
    Value<DateTime?> lastSeen = const Value.absent(),
    int? lapses,
  }) => WordProgress(
    wordId: wordId ?? this.wordId,
    box: box ?? this.box,
    due: due.present ? due.value : this.due,
    lastSeen: lastSeen.present ? lastSeen.value : this.lastSeen,
    lapses: lapses ?? this.lapses,
  );
  WordProgress copyWithCompanion(ProgressCompanion data) {
    return WordProgress(
      wordId: data.wordId.present ? data.wordId.value : this.wordId,
      box: data.box.present ? data.box.value : this.box,
      due: data.due.present ? data.due.value : this.due,
      lastSeen: data.lastSeen.present ? data.lastSeen.value : this.lastSeen,
      lapses: data.lapses.present ? data.lapses.value : this.lapses,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WordProgress(')
          ..write('wordId: $wordId, ')
          ..write('box: $box, ')
          ..write('due: $due, ')
          ..write('lastSeen: $lastSeen, ')
          ..write('lapses: $lapses')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(wordId, box, due, lastSeen, lapses);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WordProgress &&
          other.wordId == this.wordId &&
          other.box == this.box &&
          other.due == this.due &&
          other.lastSeen == this.lastSeen &&
          other.lapses == this.lapses);
}

class ProgressCompanion extends UpdateCompanion<WordProgress> {
  final Value<String> wordId;
  final Value<int> box;
  final Value<DateTime?> due;
  final Value<DateTime?> lastSeen;
  final Value<int> lapses;
  final Value<int> rowid;
  const ProgressCompanion({
    this.wordId = const Value.absent(),
    this.box = const Value.absent(),
    this.due = const Value.absent(),
    this.lastSeen = const Value.absent(),
    this.lapses = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProgressCompanion.insert({
    required String wordId,
    this.box = const Value.absent(),
    this.due = const Value.absent(),
    this.lastSeen = const Value.absent(),
    this.lapses = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : wordId = Value(wordId);
  static Insertable<WordProgress> custom({
    Expression<String>? wordId,
    Expression<int>? box,
    Expression<DateTime>? due,
    Expression<DateTime>? lastSeen,
    Expression<int>? lapses,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (wordId != null) 'word_id': wordId,
      if (box != null) 'box': box,
      if (due != null) 'due': due,
      if (lastSeen != null) 'last_seen': lastSeen,
      if (lapses != null) 'lapses': lapses,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProgressCompanion copyWith({
    Value<String>? wordId,
    Value<int>? box,
    Value<DateTime?>? due,
    Value<DateTime?>? lastSeen,
    Value<int>? lapses,
    Value<int>? rowid,
  }) {
    return ProgressCompanion(
      wordId: wordId ?? this.wordId,
      box: box ?? this.box,
      due: due ?? this.due,
      lastSeen: lastSeen ?? this.lastSeen,
      lapses: lapses ?? this.lapses,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (wordId.present) {
      map['word_id'] = Variable<String>(wordId.value);
    }
    if (box.present) {
      map['box'] = Variable<int>(box.value);
    }
    if (due.present) {
      map['due'] = Variable<DateTime>(due.value);
    }
    if (lastSeen.present) {
      map['last_seen'] = Variable<DateTime>(lastSeen.value);
    }
    if (lapses.present) {
      map['lapses'] = Variable<int>(lapses.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProgressCompanion(')
          ..write('wordId: $wordId, ')
          ..write('box: $box, ')
          ..write('due: $due, ')
          ..write('lastSeen: $lastSeen, ')
          ..write('lapses: $lapses, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MetaTable extends Meta with TableInfo<$MetaTable, MetaEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MetaTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'meta';
  @override
  VerificationContext validateIntegrity(
    Insertable<MetaEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  MetaEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MetaEntry(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $MetaTable createAlias(String alias) {
    return $MetaTable(attachedDatabase, alias);
  }
}

class MetaEntry extends DataClass implements Insertable<MetaEntry> {
  final String key;
  final String value;
  const MetaEntry({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  MetaCompanion toCompanion(bool nullToAbsent) {
    return MetaCompanion(key: Value(key), value: Value(value));
  }

  factory MetaEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MetaEntry(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  MetaEntry copyWith({String? key, String? value}) =>
      MetaEntry(key: key ?? this.key, value: value ?? this.value);
  MetaEntry copyWithCompanion(MetaCompanion data) {
    return MetaEntry(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MetaEntry(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MetaEntry &&
          other.key == this.key &&
          other.value == this.value);
}

class MetaCompanion extends UpdateCompanion<MetaEntry> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const MetaCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MetaCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<MetaEntry> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MetaCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return MetaCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MetaCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RevisionItemsTable extends RevisionItems
    with TableInfo<$RevisionItemsTable, RevisionItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RevisionItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _langMeta = const VerificationMeta('lang');
  @override
  late final GeneratedColumn<String> lang = GeneratedColumn<String>(
    'lang',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _promptMeta = const VerificationMeta('prompt');
  @override
  late final GeneratedColumn<String> prompt = GeneratedColumn<String>(
    'prompt',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _answerMeta = const VerificationMeta('answer');
  @override
  late final GeneratedColumn<String> answer = GeneratedColumn<String>(
    'answer',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _explanationMeta = const VerificationMeta(
    'explanation',
  );
  @override
  late final GeneratedColumn<String> explanation = GeneratedColumn<String>(
    'explanation',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _boxMeta = const VerificationMeta('box');
  @override
  late final GeneratedColumn<int> box = GeneratedColumn<int>(
    'box',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _dueMeta = const VerificationMeta('due');
  @override
  late final GeneratedColumn<DateTime> due = GeneratedColumn<DateTime>(
    'due',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    lang,
    kind,
    prompt,
    answer,
    explanation,
    createdAt,
    box,
    due,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'revision_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<RevisionItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('lang')) {
      context.handle(
        _langMeta,
        lang.isAcceptableOrUnknown(data['lang']!, _langMeta),
      );
    } else if (isInserting) {
      context.missing(_langMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('prompt')) {
      context.handle(
        _promptMeta,
        prompt.isAcceptableOrUnknown(data['prompt']!, _promptMeta),
      );
    } else if (isInserting) {
      context.missing(_promptMeta);
    }
    if (data.containsKey('answer')) {
      context.handle(
        _answerMeta,
        answer.isAcceptableOrUnknown(data['answer']!, _answerMeta),
      );
    } else if (isInserting) {
      context.missing(_answerMeta);
    }
    if (data.containsKey('explanation')) {
      context.handle(
        _explanationMeta,
        explanation.isAcceptableOrUnknown(
          data['explanation']!,
          _explanationMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('box')) {
      context.handle(
        _boxMeta,
        box.isAcceptableOrUnknown(data['box']!, _boxMeta),
      );
    }
    if (data.containsKey('due')) {
      context.handle(
        _dueMeta,
        due.isAcceptableOrUnknown(data['due']!, _dueMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RevisionItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RevisionItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      lang: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lang'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      prompt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}prompt'],
      )!,
      answer: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}answer'],
      )!,
      explanation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}explanation'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      box: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}box'],
      )!,
      due: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}due'],
      ),
    );
  }

  @override
  $RevisionItemsTable createAlias(String alias) {
    return $RevisionItemsTable(attachedDatabase, alias);
  }
}

class RevisionItem extends DataClass implements Insertable<RevisionItem> {
  final int id;
  final String lang;

  /// « correction » ou « traduction ».
  final String kind;

  /// Ce que l'utilisateur a dit : la phrase fautive, ou la phrase en français.
  final String prompt;

  /// La bonne phrase dans la langue cible.
  final String answer;
  final String? explanation;
  final DateTime createdAt;
  final int box;
  final DateTime? due;
  const RevisionItem({
    required this.id,
    required this.lang,
    required this.kind,
    required this.prompt,
    required this.answer,
    this.explanation,
    required this.createdAt,
    required this.box,
    this.due,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['lang'] = Variable<String>(lang);
    map['kind'] = Variable<String>(kind);
    map['prompt'] = Variable<String>(prompt);
    map['answer'] = Variable<String>(answer);
    if (!nullToAbsent || explanation != null) {
      map['explanation'] = Variable<String>(explanation);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['box'] = Variable<int>(box);
    if (!nullToAbsent || due != null) {
      map['due'] = Variable<DateTime>(due);
    }
    return map;
  }

  RevisionItemsCompanion toCompanion(bool nullToAbsent) {
    return RevisionItemsCompanion(
      id: Value(id),
      lang: Value(lang),
      kind: Value(kind),
      prompt: Value(prompt),
      answer: Value(answer),
      explanation: explanation == null && nullToAbsent
          ? const Value.absent()
          : Value(explanation),
      createdAt: Value(createdAt),
      box: Value(box),
      due: due == null && nullToAbsent ? const Value.absent() : Value(due),
    );
  }

  factory RevisionItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RevisionItem(
      id: serializer.fromJson<int>(json['id']),
      lang: serializer.fromJson<String>(json['lang']),
      kind: serializer.fromJson<String>(json['kind']),
      prompt: serializer.fromJson<String>(json['prompt']),
      answer: serializer.fromJson<String>(json['answer']),
      explanation: serializer.fromJson<String?>(json['explanation']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      box: serializer.fromJson<int>(json['box']),
      due: serializer.fromJson<DateTime?>(json['due']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'lang': serializer.toJson<String>(lang),
      'kind': serializer.toJson<String>(kind),
      'prompt': serializer.toJson<String>(prompt),
      'answer': serializer.toJson<String>(answer),
      'explanation': serializer.toJson<String?>(explanation),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'box': serializer.toJson<int>(box),
      'due': serializer.toJson<DateTime?>(due),
    };
  }

  RevisionItem copyWith({
    int? id,
    String? lang,
    String? kind,
    String? prompt,
    String? answer,
    Value<String?> explanation = const Value.absent(),
    DateTime? createdAt,
    int? box,
    Value<DateTime?> due = const Value.absent(),
  }) => RevisionItem(
    id: id ?? this.id,
    lang: lang ?? this.lang,
    kind: kind ?? this.kind,
    prompt: prompt ?? this.prompt,
    answer: answer ?? this.answer,
    explanation: explanation.present ? explanation.value : this.explanation,
    createdAt: createdAt ?? this.createdAt,
    box: box ?? this.box,
    due: due.present ? due.value : this.due,
  );
  RevisionItem copyWithCompanion(RevisionItemsCompanion data) {
    return RevisionItem(
      id: data.id.present ? data.id.value : this.id,
      lang: data.lang.present ? data.lang.value : this.lang,
      kind: data.kind.present ? data.kind.value : this.kind,
      prompt: data.prompt.present ? data.prompt.value : this.prompt,
      answer: data.answer.present ? data.answer.value : this.answer,
      explanation: data.explanation.present
          ? data.explanation.value
          : this.explanation,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      box: data.box.present ? data.box.value : this.box,
      due: data.due.present ? data.due.value : this.due,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RevisionItem(')
          ..write('id: $id, ')
          ..write('lang: $lang, ')
          ..write('kind: $kind, ')
          ..write('prompt: $prompt, ')
          ..write('answer: $answer, ')
          ..write('explanation: $explanation, ')
          ..write('createdAt: $createdAt, ')
          ..write('box: $box, ')
          ..write('due: $due')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    lang,
    kind,
    prompt,
    answer,
    explanation,
    createdAt,
    box,
    due,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RevisionItem &&
          other.id == this.id &&
          other.lang == this.lang &&
          other.kind == this.kind &&
          other.prompt == this.prompt &&
          other.answer == this.answer &&
          other.explanation == this.explanation &&
          other.createdAt == this.createdAt &&
          other.box == this.box &&
          other.due == this.due);
}

class RevisionItemsCompanion extends UpdateCompanion<RevisionItem> {
  final Value<int> id;
  final Value<String> lang;
  final Value<String> kind;
  final Value<String> prompt;
  final Value<String> answer;
  final Value<String?> explanation;
  final Value<DateTime> createdAt;
  final Value<int> box;
  final Value<DateTime?> due;
  const RevisionItemsCompanion({
    this.id = const Value.absent(),
    this.lang = const Value.absent(),
    this.kind = const Value.absent(),
    this.prompt = const Value.absent(),
    this.answer = const Value.absent(),
    this.explanation = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.box = const Value.absent(),
    this.due = const Value.absent(),
  });
  RevisionItemsCompanion.insert({
    this.id = const Value.absent(),
    required String lang,
    required String kind,
    required String prompt,
    required String answer,
    this.explanation = const Value.absent(),
    required DateTime createdAt,
    this.box = const Value.absent(),
    this.due = const Value.absent(),
  }) : lang = Value(lang),
       kind = Value(kind),
       prompt = Value(prompt),
       answer = Value(answer),
       createdAt = Value(createdAt);
  static Insertable<RevisionItem> custom({
    Expression<int>? id,
    Expression<String>? lang,
    Expression<String>? kind,
    Expression<String>? prompt,
    Expression<String>? answer,
    Expression<String>? explanation,
    Expression<DateTime>? createdAt,
    Expression<int>? box,
    Expression<DateTime>? due,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (lang != null) 'lang': lang,
      if (kind != null) 'kind': kind,
      if (prompt != null) 'prompt': prompt,
      if (answer != null) 'answer': answer,
      if (explanation != null) 'explanation': explanation,
      if (createdAt != null) 'created_at': createdAt,
      if (box != null) 'box': box,
      if (due != null) 'due': due,
    });
  }

  RevisionItemsCompanion copyWith({
    Value<int>? id,
    Value<String>? lang,
    Value<String>? kind,
    Value<String>? prompt,
    Value<String>? answer,
    Value<String?>? explanation,
    Value<DateTime>? createdAt,
    Value<int>? box,
    Value<DateTime?>? due,
  }) {
    return RevisionItemsCompanion(
      id: id ?? this.id,
      lang: lang ?? this.lang,
      kind: kind ?? this.kind,
      prompt: prompt ?? this.prompt,
      answer: answer ?? this.answer,
      explanation: explanation ?? this.explanation,
      createdAt: createdAt ?? this.createdAt,
      box: box ?? this.box,
      due: due ?? this.due,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (lang.present) {
      map['lang'] = Variable<String>(lang.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (prompt.present) {
      map['prompt'] = Variable<String>(prompt.value);
    }
    if (answer.present) {
      map['answer'] = Variable<String>(answer.value);
    }
    if (explanation.present) {
      map['explanation'] = Variable<String>(explanation.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (box.present) {
      map['box'] = Variable<int>(box.value);
    }
    if (due.present) {
      map['due'] = Variable<DateTime>(due.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RevisionItemsCompanion(')
          ..write('id: $id, ')
          ..write('lang: $lang, ')
          ..write('kind: $kind, ')
          ..write('prompt: $prompt, ')
          ..write('answer: $answer, ')
          ..write('explanation: $explanation, ')
          ..write('createdAt: $createdAt, ')
          ..write('box: $box, ')
          ..write('due: $due')
          ..write(')'))
        .toString();
  }
}

class $ThemesTable extends Themes with TableInfo<$ThemesTable, VocabTheme> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ThemesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _langMeta = const VerificationMeta('lang');
  @override
  late final GeneratedColumn<String> lang = GeneratedColumn<String>(
    'lang',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, lang, label, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'themes';
  @override
  VerificationContext validateIntegrity(
    Insertable<VocabTheme> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('lang')) {
      context.handle(
        _langMeta,
        lang.isAcceptableOrUnknown(data['lang']!, _langMeta),
      );
    } else if (isInserting) {
      context.missing(_langMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  VocabTheme map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VocabTheme(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      lang: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lang'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ThemesTable createAlias(String alias) {
    return $ThemesTable(attachedDatabase, alias);
  }
}

class VocabTheme extends DataClass implements Insertable<VocabTheme> {
  final String id;
  final String lang;
  final String label;
  final DateTime createdAt;
  const VocabTheme({
    required this.id,
    required this.lang,
    required this.label,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['lang'] = Variable<String>(lang);
    map['label'] = Variable<String>(label);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ThemesCompanion toCompanion(bool nullToAbsent) {
    return ThemesCompanion(
      id: Value(id),
      lang: Value(lang),
      label: Value(label),
      createdAt: Value(createdAt),
    );
  }

  factory VocabTheme.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VocabTheme(
      id: serializer.fromJson<String>(json['id']),
      lang: serializer.fromJson<String>(json['lang']),
      label: serializer.fromJson<String>(json['label']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'lang': serializer.toJson<String>(lang),
      'label': serializer.toJson<String>(label),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  VocabTheme copyWith({
    String? id,
    String? lang,
    String? label,
    DateTime? createdAt,
  }) => VocabTheme(
    id: id ?? this.id,
    lang: lang ?? this.lang,
    label: label ?? this.label,
    createdAt: createdAt ?? this.createdAt,
  );
  VocabTheme copyWithCompanion(ThemesCompanion data) {
    return VocabTheme(
      id: data.id.present ? data.id.value : this.id,
      lang: data.lang.present ? data.lang.value : this.lang,
      label: data.label.present ? data.label.value : this.label,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VocabTheme(')
          ..write('id: $id, ')
          ..write('lang: $lang, ')
          ..write('label: $label, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, lang, label, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VocabTheme &&
          other.id == this.id &&
          other.lang == this.lang &&
          other.label == this.label &&
          other.createdAt == this.createdAt);
}

class ThemesCompanion extends UpdateCompanion<VocabTheme> {
  final Value<String> id;
  final Value<String> lang;
  final Value<String> label;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const ThemesCompanion({
    this.id = const Value.absent(),
    this.lang = const Value.absent(),
    this.label = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ThemesCompanion.insert({
    required String id,
    required String lang,
    required String label,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       lang = Value(lang),
       label = Value(label),
       createdAt = Value(createdAt);
  static Insertable<VocabTheme> custom({
    Expression<String>? id,
    Expression<String>? lang,
    Expression<String>? label,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (lang != null) 'lang': lang,
      if (label != null) 'label': label,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ThemesCompanion copyWith({
    Value<String>? id,
    Value<String>? lang,
    Value<String>? label,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return ThemesCompanion(
      id: id ?? this.id,
      lang: lang ?? this.lang,
      label: label ?? this.label,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (lang.present) {
      map['lang'] = Variable<String>(lang.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ThemesCompanion(')
          ..write('id: $id, ')
          ..write('lang: $lang, ')
          ..write('label: $label, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ThemeWordsTable extends ThemeWords
    with TableInfo<$ThemeWordsTable, ThemeWord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ThemeWordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _themeIdMeta = const VerificationMeta(
    'themeId',
  );
  @override
  late final GeneratedColumn<String> themeId = GeneratedColumn<String>(
    'theme_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _wordIdMeta = const VerificationMeta('wordId');
  @override
  late final GeneratedColumn<String> wordId = GeneratedColumn<String>(
    'word_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [themeId, wordId, position];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'theme_words';
  @override
  VerificationContext validateIntegrity(
    Insertable<ThemeWord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('theme_id')) {
      context.handle(
        _themeIdMeta,
        themeId.isAcceptableOrUnknown(data['theme_id']!, _themeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_themeIdMeta);
    }
    if (data.containsKey('word_id')) {
      context.handle(
        _wordIdMeta,
        wordId.isAcceptableOrUnknown(data['word_id']!, _wordIdMeta),
      );
    } else if (isInserting) {
      context.missing(_wordIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {themeId, wordId};
  @override
  ThemeWord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ThemeWord(
      themeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}theme_id'],
      )!,
      wordId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}word_id'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
    );
  }

  @override
  $ThemeWordsTable createAlias(String alias) {
    return $ThemeWordsTable(attachedDatabase, alias);
  }
}

class ThemeWord extends DataClass implements Insertable<ThemeWord> {
  final String themeId;
  final String wordId;
  final int position;
  const ThemeWord({
    required this.themeId,
    required this.wordId,
    required this.position,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['theme_id'] = Variable<String>(themeId);
    map['word_id'] = Variable<String>(wordId);
    map['position'] = Variable<int>(position);
    return map;
  }

  ThemeWordsCompanion toCompanion(bool nullToAbsent) {
    return ThemeWordsCompanion(
      themeId: Value(themeId),
      wordId: Value(wordId),
      position: Value(position),
    );
  }

  factory ThemeWord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ThemeWord(
      themeId: serializer.fromJson<String>(json['themeId']),
      wordId: serializer.fromJson<String>(json['wordId']),
      position: serializer.fromJson<int>(json['position']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'themeId': serializer.toJson<String>(themeId),
      'wordId': serializer.toJson<String>(wordId),
      'position': serializer.toJson<int>(position),
    };
  }

  ThemeWord copyWith({String? themeId, String? wordId, int? position}) =>
      ThemeWord(
        themeId: themeId ?? this.themeId,
        wordId: wordId ?? this.wordId,
        position: position ?? this.position,
      );
  ThemeWord copyWithCompanion(ThemeWordsCompanion data) {
    return ThemeWord(
      themeId: data.themeId.present ? data.themeId.value : this.themeId,
      wordId: data.wordId.present ? data.wordId.value : this.wordId,
      position: data.position.present ? data.position.value : this.position,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ThemeWord(')
          ..write('themeId: $themeId, ')
          ..write('wordId: $wordId, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(themeId, wordId, position);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ThemeWord &&
          other.themeId == this.themeId &&
          other.wordId == this.wordId &&
          other.position == this.position);
}

class ThemeWordsCompanion extends UpdateCompanion<ThemeWord> {
  final Value<String> themeId;
  final Value<String> wordId;
  final Value<int> position;
  final Value<int> rowid;
  const ThemeWordsCompanion({
    this.themeId = const Value.absent(),
    this.wordId = const Value.absent(),
    this.position = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ThemeWordsCompanion.insert({
    required String themeId,
    required String wordId,
    required int position,
    this.rowid = const Value.absent(),
  }) : themeId = Value(themeId),
       wordId = Value(wordId),
       position = Value(position);
  static Insertable<ThemeWord> custom({
    Expression<String>? themeId,
    Expression<String>? wordId,
    Expression<int>? position,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (themeId != null) 'theme_id': themeId,
      if (wordId != null) 'word_id': wordId,
      if (position != null) 'position': position,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ThemeWordsCompanion copyWith({
    Value<String>? themeId,
    Value<String>? wordId,
    Value<int>? position,
    Value<int>? rowid,
  }) {
    return ThemeWordsCompanion(
      themeId: themeId ?? this.themeId,
      wordId: wordId ?? this.wordId,
      position: position ?? this.position,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (themeId.present) {
      map['theme_id'] = Variable<String>(themeId.value);
    }
    if (wordId.present) {
      map['word_id'] = Variable<String>(wordId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ThemeWordsCompanion(')
          ..write('themeId: $themeId, ')
          ..write('wordId: $wordId, ')
          ..write('position: $position, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $WordsTable words = $WordsTable(this);
  late final $GrammarSheetsTable grammarSheets = $GrammarSheetsTable(this);
  late final $ProgressTable progress = $ProgressTable(this);
  late final $MetaTable meta = $MetaTable(this);
  late final $RevisionItemsTable revisionItems = $RevisionItemsTable(this);
  late final $ThemesTable themes = $ThemesTable(this);
  late final $ThemeWordsTable themeWords = $ThemeWordsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    words,
    grammarSheets,
    progress,
    meta,
    revisionItems,
    themes,
    themeWords,
  ];
}

typedef $$WordsTableCreateCompanionBuilder = WordsCompanion Function({
  required String id,
  required String lang,
  required String concept,
  required String word,
  Value<String?> article,
  Value<String?> gender,
  Value<String?> plural,
  Value<String?> forms,
  Value<String?> note,
  Value<String?> transliteration,
  Value<String?> exampleTransliteration,
  required String pos,
  required String translations,
  required int rank,
  required String situation,
  required String exampleTarget,
  required String exampleFr,
  Value<int> rowid,
});
typedef $$WordsTableUpdateCompanionBuilder = WordsCompanion Function({
  Value<String> id,
  Value<String> lang,
  Value<String> concept,
  Value<String> word,
  Value<String?> article,
  Value<String?> gender,
  Value<String?> plural,
  Value<String?> forms,
  Value<String?> note,
  Value<String?> transliteration,
  Value<String?> exampleTransliteration,
  Value<String> pos,
  Value<String> translations,
  Value<int> rank,
  Value<String> situation,
  Value<String> exampleTarget,
  Value<String> exampleFr,
  Value<int> rowid,
});

class $$WordsTableFilterComposer extends Composer<_$AppDatabase, $WordsTable> {
  $$WordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lang => $composableBuilder(
    column: $table.lang,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get concept => $composableBuilder(
    column: $table.concept,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get word => $composableBuilder(
    column: $table.word,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get article => $composableBuilder(
    column: $table.article,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gender => $composableBuilder(
    column: $table.gender,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get plural => $composableBuilder(
    column: $table.plural,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get forms => $composableBuilder(
    column: $table.forms,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get transliteration => $composableBuilder(
    column: $table.transliteration,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get exampleTransliteration => $composableBuilder(
    column: $table.exampleTransliteration,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pos => $composableBuilder(
    column: $table.pos,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get translations => $composableBuilder(
    column: $table.translations,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rank => $composableBuilder(
    column: $table.rank,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get situation => $composableBuilder(
    column: $table.situation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get exampleTarget => $composableBuilder(
    column: $table.exampleTarget,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get exampleFr => $composableBuilder(
    column: $table.exampleFr,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WordsTableOrderingComposer
    extends Composer<_$AppDatabase, $WordsTable> {
  $$WordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lang => $composableBuilder(
    column: $table.lang,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get concept => $composableBuilder(
    column: $table.concept,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get word => $composableBuilder(
    column: $table.word,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get article => $composableBuilder(
    column: $table.article,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gender => $composableBuilder(
    column: $table.gender,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get plural => $composableBuilder(
    column: $table.plural,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get forms => $composableBuilder(
    column: $table.forms,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get transliteration => $composableBuilder(
    column: $table.transliteration,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get exampleTransliteration => $composableBuilder(
    column: $table.exampleTransliteration,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pos => $composableBuilder(
    column: $table.pos,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get translations => $composableBuilder(
    column: $table.translations,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rank => $composableBuilder(
    column: $table.rank,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get situation => $composableBuilder(
    column: $table.situation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get exampleTarget => $composableBuilder(
    column: $table.exampleTarget,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get exampleFr => $composableBuilder(
    column: $table.exampleFr,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WordsTable> {
  $$WordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get lang =>
      $composableBuilder(column: $table.lang, builder: (column) => column);

  GeneratedColumn<String> get concept =>
      $composableBuilder(column: $table.concept, builder: (column) => column);

  GeneratedColumn<String> get word =>
      $composableBuilder(column: $table.word, builder: (column) => column);

  GeneratedColumn<String> get article =>
      $composableBuilder(column: $table.article, builder: (column) => column);

  GeneratedColumn<String> get gender =>
      $composableBuilder(column: $table.gender, builder: (column) => column);

  GeneratedColumn<String> get plural =>
      $composableBuilder(column: $table.plural, builder: (column) => column);

  GeneratedColumn<String> get forms =>
      $composableBuilder(column: $table.forms, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get transliteration => $composableBuilder(
    column: $table.transliteration,
    builder: (column) => column,
  );

  GeneratedColumn<String> get exampleTransliteration => $composableBuilder(
    column: $table.exampleTransliteration,
    builder: (column) => column,
  );

  GeneratedColumn<String> get pos =>
      $composableBuilder(column: $table.pos, builder: (column) => column);

  GeneratedColumn<String> get translations => $composableBuilder(
    column: $table.translations,
    builder: (column) => column,
  );

  GeneratedColumn<int> get rank =>
      $composableBuilder(column: $table.rank, builder: (column) => column);

  GeneratedColumn<String> get situation =>
      $composableBuilder(column: $table.situation, builder: (column) => column);

  GeneratedColumn<String> get exampleTarget => $composableBuilder(
    column: $table.exampleTarget,
    builder: (column) => column,
  );

  GeneratedColumn<String> get exampleFr =>
      $composableBuilder(column: $table.exampleFr, builder: (column) => column);
}

class $$WordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WordsTable,
          Word,
          $$WordsTableFilterComposer,
          $$WordsTableOrderingComposer,
          $$WordsTableAnnotationComposer,
          $$WordsTableCreateCompanionBuilder,
          $$WordsTableUpdateCompanionBuilder,
          (Word, BaseReferences<_$AppDatabase, $WordsTable, Word>),
          Word,
          PrefetchHooks Function()
        > {
  $$WordsTableTableManager(_$AppDatabase db, $WordsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> lang = const Value.absent(),
                Value<String> concept = const Value.absent(),
                Value<String> word = const Value.absent(),
                Value<String?> article = const Value.absent(),
                Value<String?> gender = const Value.absent(),
                Value<String?> plural = const Value.absent(),
                Value<String?> forms = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String?> transliteration = const Value.absent(),
                Value<String?> exampleTransliteration = const Value.absent(),
                Value<String> pos = const Value.absent(),
                Value<String> translations = const Value.absent(),
                Value<int> rank = const Value.absent(),
                Value<String> situation = const Value.absent(),
                Value<String> exampleTarget = const Value.absent(),
                Value<String> exampleFr = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WordsCompanion(
                id: id,
                lang: lang,
                concept: concept,
                word: word,
                article: article,
                gender: gender,
                plural: plural,
                forms: forms,
                note: note,
                transliteration: transliteration,
                exampleTransliteration: exampleTransliteration,
                pos: pos,
                translations: translations,
                rank: rank,
                situation: situation,
                exampleTarget: exampleTarget,
                exampleFr: exampleFr,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String lang,
                required String concept,
                required String word,
                Value<String?> article = const Value.absent(),
                Value<String?> gender = const Value.absent(),
                Value<String?> plural = const Value.absent(),
                Value<String?> forms = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String?> transliteration = const Value.absent(),
                Value<String?> exampleTransliteration = const Value.absent(),
                required String pos,
                required String translations,
                required int rank,
                required String situation,
                required String exampleTarget,
                required String exampleFr,
                Value<int> rowid = const Value.absent(),
              }) => WordsCompanion.insert(
                id: id,
                lang: lang,
                concept: concept,
                word: word,
                article: article,
                gender: gender,
                plural: plural,
                forms: forms,
                note: note,
                transliteration: transliteration,
                exampleTransliteration: exampleTransliteration,
                pos: pos,
                translations: translations,
                rank: rank,
                situation: situation,
                exampleTarget: exampleTarget,
                exampleFr: exampleFr,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WordsTable, Word>(table),
                  BaseReferences<_$AppDatabase, $WordsTable, Word>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WordsTable,
      Word,
      $$WordsTableFilterComposer,
      $$WordsTableOrderingComposer,
      $$WordsTableAnnotationComposer,
      $$WordsTableCreateCompanionBuilder,
      $$WordsTableUpdateCompanionBuilder,
      (Word, BaseReferences<_$AppDatabase, $WordsTable, Word>),
      Word,
      PrefetchHooks Function()
    >;
typedef $$GrammarSheetsTableCreateCompanionBuilder =
    GrammarSheetsCompanion Function({
      required String id,
      required String lang,
      required String title,
      required String level,
      required int position,
      required String body,
      Value<int> rowid,
    });
typedef $$GrammarSheetsTableUpdateCompanionBuilder =
    GrammarSheetsCompanion Function({
      Value<String> id,
      Value<String> lang,
      Value<String> title,
      Value<String> level,
      Value<int> position,
      Value<String> body,
      Value<int> rowid,
    });

class $$GrammarSheetsTableFilterComposer
    extends Composer<_$AppDatabase, $GrammarSheetsTable> {
  $$GrammarSheetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lang => $composableBuilder(
    column: $table.lang,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnFilters(column),
  );
}

class $$GrammarSheetsTableOrderingComposer
    extends Composer<_$AppDatabase, $GrammarSheetsTable> {
  $$GrammarSheetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lang => $composableBuilder(
    column: $table.lang,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GrammarSheetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $GrammarSheetsTable> {
  $$GrammarSheetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get lang =>
      $composableBuilder(column: $table.lang, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);
}

class $$GrammarSheetsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GrammarSheetsTable,
          GrammarSheet,
          $$GrammarSheetsTableFilterComposer,
          $$GrammarSheetsTableOrderingComposer,
          $$GrammarSheetsTableAnnotationComposer,
          $$GrammarSheetsTableCreateCompanionBuilder,
          $$GrammarSheetsTableUpdateCompanionBuilder,
          (
            GrammarSheet,
            BaseReferences<_$AppDatabase, $GrammarSheetsTable, GrammarSheet>,
          ),
          GrammarSheet,
          PrefetchHooks Function()
        > {
  $$GrammarSheetsTableTableManager(_$AppDatabase db, $GrammarSheetsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GrammarSheetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GrammarSheetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GrammarSheetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> lang = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> level = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<String> body = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GrammarSheetsCompanion(
                id: id,
                lang: lang,
                title: title,
                level: level,
                position: position,
                body: body,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String lang,
                required String title,
                required String level,
                required int position,
                required String body,
                Value<int> rowid = const Value.absent(),
              }) => GrammarSheetsCompanion.insert(
                id: id,
                lang: lang,
                title: title,
                level: level,
                position: position,
                body: body,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$GrammarSheetsTable, GrammarSheet>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $GrammarSheetsTable,
                    GrammarSheet
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$GrammarSheetsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GrammarSheetsTable,
      GrammarSheet,
      $$GrammarSheetsTableFilterComposer,
      $$GrammarSheetsTableOrderingComposer,
      $$GrammarSheetsTableAnnotationComposer,
      $$GrammarSheetsTableCreateCompanionBuilder,
      $$GrammarSheetsTableUpdateCompanionBuilder,
      (
        GrammarSheet,
        BaseReferences<_$AppDatabase, $GrammarSheetsTable, GrammarSheet>,
      ),
      GrammarSheet,
      PrefetchHooks Function()
    >;
typedef $$ProgressTableCreateCompanionBuilder = ProgressCompanion Function({
  required String wordId,
  Value<int> box,
  Value<DateTime?> due,
  Value<DateTime?> lastSeen,
  Value<int> lapses,
  Value<int> rowid,
});
typedef $$ProgressTableUpdateCompanionBuilder = ProgressCompanion Function({
  Value<String> wordId,
  Value<int> box,
  Value<DateTime?> due,
  Value<DateTime?> lastSeen,
  Value<int> lapses,
  Value<int> rowid,
});

class $$ProgressTableFilterComposer
    extends Composer<_$AppDatabase, $ProgressTable> {
  $$ProgressTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get wordId => $composableBuilder(
    column: $table.wordId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get box => $composableBuilder(
    column: $table.box,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get due => $composableBuilder(
    column: $table.due,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSeen => $composableBuilder(
    column: $table.lastSeen,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lapses => $composableBuilder(
    column: $table.lapses,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProgressTableOrderingComposer
    extends Composer<_$AppDatabase, $ProgressTable> {
  $$ProgressTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get wordId => $composableBuilder(
    column: $table.wordId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get box => $composableBuilder(
    column: $table.box,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get due => $composableBuilder(
    column: $table.due,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSeen => $composableBuilder(
    column: $table.lastSeen,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lapses => $composableBuilder(
    column: $table.lapses,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProgressTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProgressTable> {
  $$ProgressTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get wordId =>
      $composableBuilder(column: $table.wordId, builder: (column) => column);

  GeneratedColumn<int> get box =>
      $composableBuilder(column: $table.box, builder: (column) => column);

  GeneratedColumn<DateTime> get due =>
      $composableBuilder(column: $table.due, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSeen =>
      $composableBuilder(column: $table.lastSeen, builder: (column) => column);

  GeneratedColumn<int> get lapses =>
      $composableBuilder(column: $table.lapses, builder: (column) => column);
}

class $$ProgressTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProgressTable,
          WordProgress,
          $$ProgressTableFilterComposer,
          $$ProgressTableOrderingComposer,
          $$ProgressTableAnnotationComposer,
          $$ProgressTableCreateCompanionBuilder,
          $$ProgressTableUpdateCompanionBuilder,
          (
            WordProgress,
            BaseReferences<_$AppDatabase, $ProgressTable, WordProgress>,
          ),
          WordProgress,
          PrefetchHooks Function()
        > {
  $$ProgressTableTableManager(_$AppDatabase db, $ProgressTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProgressTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProgressTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProgressTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> wordId = const Value.absent(),
                Value<int> box = const Value.absent(),
                Value<DateTime?> due = const Value.absent(),
                Value<DateTime?> lastSeen = const Value.absent(),
                Value<int> lapses = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProgressCompanion(
                wordId: wordId,
                box: box,
                due: due,
                lastSeen: lastSeen,
                lapses: lapses,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String wordId,
                Value<int> box = const Value.absent(),
                Value<DateTime?> due = const Value.absent(),
                Value<DateTime?> lastSeen = const Value.absent(),
                Value<int> lapses = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProgressCompanion.insert(
                wordId: wordId,
                box: box,
                due: due,
                lastSeen: lastSeen,
                lapses: lapses,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ProgressTable, WordProgress>(table),
                  BaseReferences<_$AppDatabase, $ProgressTable, WordProgress>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProgressTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProgressTable,
      WordProgress,
      $$ProgressTableFilterComposer,
      $$ProgressTableOrderingComposer,
      $$ProgressTableAnnotationComposer,
      $$ProgressTableCreateCompanionBuilder,
      $$ProgressTableUpdateCompanionBuilder,
      (
        WordProgress,
        BaseReferences<_$AppDatabase, $ProgressTable, WordProgress>,
      ),
      WordProgress,
      PrefetchHooks Function()
    >;
typedef $$MetaTableCreateCompanionBuilder = MetaCompanion Function({
  required String key,
  required String value,
  Value<int> rowid,
});
typedef $$MetaTableUpdateCompanionBuilder = MetaCompanion Function({
  Value<String> key,
  Value<String> value,
  Value<int> rowid,
});

class $$MetaTableFilterComposer extends Composer<_$AppDatabase, $MetaTable> {
  $$MetaTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MetaTableOrderingComposer extends Composer<_$AppDatabase, $MetaTable> {
  $$MetaTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MetaTableAnnotationComposer
    extends Composer<_$AppDatabase, $MetaTable> {
  $$MetaTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$MetaTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MetaTable,
          MetaEntry,
          $$MetaTableFilterComposer,
          $$MetaTableOrderingComposer,
          $$MetaTableAnnotationComposer,
          $$MetaTableCreateCompanionBuilder,
          $$MetaTableUpdateCompanionBuilder,
          (MetaEntry, BaseReferences<_$AppDatabase, $MetaTable, MetaEntry>),
          MetaEntry,
          PrefetchHooks Function()
        > {
  $$MetaTableTableManager(_$AppDatabase db, $MetaTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MetaTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MetaTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MetaTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => MetaCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback: ({
            required String key,
            required String value,
            Value<int> rowid = const Value.absent(),
          }) => MetaCompanion.insert(key: key, value: value, rowid: rowid),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MetaTable, MetaEntry>(table),
                  BaseReferences<_$AppDatabase, $MetaTable, MetaEntry>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MetaTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MetaTable,
      MetaEntry,
      $$MetaTableFilterComposer,
      $$MetaTableOrderingComposer,
      $$MetaTableAnnotationComposer,
      $$MetaTableCreateCompanionBuilder,
      $$MetaTableUpdateCompanionBuilder,
      (MetaEntry, BaseReferences<_$AppDatabase, $MetaTable, MetaEntry>),
      MetaEntry,
      PrefetchHooks Function()
    >;
typedef $$RevisionItemsTableCreateCompanionBuilder =
    RevisionItemsCompanion Function({
      Value<int> id,
      required String lang,
      required String kind,
      required String prompt,
      required String answer,
      Value<String?> explanation,
      required DateTime createdAt,
      Value<int> box,
      Value<DateTime?> due,
    });
typedef $$RevisionItemsTableUpdateCompanionBuilder =
    RevisionItemsCompanion Function({
      Value<int> id,
      Value<String> lang,
      Value<String> kind,
      Value<String> prompt,
      Value<String> answer,
      Value<String?> explanation,
      Value<DateTime> createdAt,
      Value<int> box,
      Value<DateTime?> due,
    });

class $$RevisionItemsTableFilterComposer
    extends Composer<_$AppDatabase, $RevisionItemsTable> {
  $$RevisionItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lang => $composableBuilder(
    column: $table.lang,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get prompt => $composableBuilder(
    column: $table.prompt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get answer => $composableBuilder(
    column: $table.answer,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get explanation => $composableBuilder(
    column: $table.explanation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get box => $composableBuilder(
    column: $table.box,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get due => $composableBuilder(
    column: $table.due,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RevisionItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $RevisionItemsTable> {
  $$RevisionItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lang => $composableBuilder(
    column: $table.lang,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get prompt => $composableBuilder(
    column: $table.prompt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get answer => $composableBuilder(
    column: $table.answer,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get explanation => $composableBuilder(
    column: $table.explanation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get box => $composableBuilder(
    column: $table.box,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get due => $composableBuilder(
    column: $table.due,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RevisionItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RevisionItemsTable> {
  $$RevisionItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get lang =>
      $composableBuilder(column: $table.lang, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get prompt =>
      $composableBuilder(column: $table.prompt, builder: (column) => column);

  GeneratedColumn<String> get answer =>
      $composableBuilder(column: $table.answer, builder: (column) => column);

  GeneratedColumn<String> get explanation => $composableBuilder(
    column: $table.explanation,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get box =>
      $composableBuilder(column: $table.box, builder: (column) => column);

  GeneratedColumn<DateTime> get due =>
      $composableBuilder(column: $table.due, builder: (column) => column);
}

class $$RevisionItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RevisionItemsTable,
          RevisionItem,
          $$RevisionItemsTableFilterComposer,
          $$RevisionItemsTableOrderingComposer,
          $$RevisionItemsTableAnnotationComposer,
          $$RevisionItemsTableCreateCompanionBuilder,
          $$RevisionItemsTableUpdateCompanionBuilder,
          (
            RevisionItem,
            BaseReferences<_$AppDatabase, $RevisionItemsTable, RevisionItem>,
          ),
          RevisionItem,
          PrefetchHooks Function()
        > {
  $$RevisionItemsTableTableManager(_$AppDatabase db, $RevisionItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RevisionItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RevisionItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RevisionItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> lang = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<String> prompt = const Value.absent(),
                Value<String> answer = const Value.absent(),
                Value<String?> explanation = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> box = const Value.absent(),
                Value<DateTime?> due = const Value.absent(),
              }) => RevisionItemsCompanion(
                id: id,
                lang: lang,
                kind: kind,
                prompt: prompt,
                answer: answer,
                explanation: explanation,
                createdAt: createdAt,
                box: box,
                due: due,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String lang,
                required String kind,
                required String prompt,
                required String answer,
                Value<String?> explanation = const Value.absent(),
                required DateTime createdAt,
                Value<int> box = const Value.absent(),
                Value<DateTime?> due = const Value.absent(),
              }) => RevisionItemsCompanion.insert(
                id: id,
                lang: lang,
                kind: kind,
                prompt: prompt,
                answer: answer,
                explanation: explanation,
                createdAt: createdAt,
                box: box,
                due: due,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RevisionItemsTable, RevisionItem>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $RevisionItemsTable,
                    RevisionItem
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RevisionItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RevisionItemsTable,
      RevisionItem,
      $$RevisionItemsTableFilterComposer,
      $$RevisionItemsTableOrderingComposer,
      $$RevisionItemsTableAnnotationComposer,
      $$RevisionItemsTableCreateCompanionBuilder,
      $$RevisionItemsTableUpdateCompanionBuilder,
      (
        RevisionItem,
        BaseReferences<_$AppDatabase, $RevisionItemsTable, RevisionItem>,
      ),
      RevisionItem,
      PrefetchHooks Function()
    >;
typedef $$ThemesTableCreateCompanionBuilder = ThemesCompanion Function({
  required String id,
  required String lang,
  required String label,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$ThemesTableUpdateCompanionBuilder = ThemesCompanion Function({
  Value<String> id,
  Value<String> lang,
  Value<String> label,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$ThemesTableFilterComposer
    extends Composer<_$AppDatabase, $ThemesTable> {
  $$ThemesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lang => $composableBuilder(
    column: $table.lang,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ThemesTableOrderingComposer
    extends Composer<_$AppDatabase, $ThemesTable> {
  $$ThemesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lang => $composableBuilder(
    column: $table.lang,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ThemesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ThemesTable> {
  $$ThemesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get lang =>
      $composableBuilder(column: $table.lang, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ThemesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ThemesTable,
          VocabTheme,
          $$ThemesTableFilterComposer,
          $$ThemesTableOrderingComposer,
          $$ThemesTableAnnotationComposer,
          $$ThemesTableCreateCompanionBuilder,
          $$ThemesTableUpdateCompanionBuilder,
          (VocabTheme, BaseReferences<_$AppDatabase, $ThemesTable, VocabTheme>),
          VocabTheme,
          PrefetchHooks Function()
        > {
  $$ThemesTableTableManager(_$AppDatabase db, $ThemesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ThemesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ThemesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ThemesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> lang = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ThemesCompanion(
                id: id,
                lang: lang,
                label: label,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String lang,
                required String label,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => ThemesCompanion.insert(
                id: id,
                lang: lang,
                label: label,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ThemesTable, VocabTheme>(table),
                  BaseReferences<_$AppDatabase, $ThemesTable, VocabTheme>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ThemesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ThemesTable,
      VocabTheme,
      $$ThemesTableFilterComposer,
      $$ThemesTableOrderingComposer,
      $$ThemesTableAnnotationComposer,
      $$ThemesTableCreateCompanionBuilder,
      $$ThemesTableUpdateCompanionBuilder,
      (VocabTheme, BaseReferences<_$AppDatabase, $ThemesTable, VocabTheme>),
      VocabTheme,
      PrefetchHooks Function()
    >;
typedef $$ThemeWordsTableCreateCompanionBuilder = ThemeWordsCompanion Function({
  required String themeId,
  required String wordId,
  required int position,
  Value<int> rowid,
});
typedef $$ThemeWordsTableUpdateCompanionBuilder = ThemeWordsCompanion Function({
  Value<String> themeId,
  Value<String> wordId,
  Value<int> position,
  Value<int> rowid,
});

class $$ThemeWordsTableFilterComposer
    extends Composer<_$AppDatabase, $ThemeWordsTable> {
  $$ThemeWordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get themeId => $composableBuilder(
    column: $table.themeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get wordId => $composableBuilder(
    column: $table.wordId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ThemeWordsTableOrderingComposer
    extends Composer<_$AppDatabase, $ThemeWordsTable> {
  $$ThemeWordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get themeId => $composableBuilder(
    column: $table.themeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get wordId => $composableBuilder(
    column: $table.wordId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ThemeWordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ThemeWordsTable> {
  $$ThemeWordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get themeId =>
      $composableBuilder(column: $table.themeId, builder: (column) => column);

  GeneratedColumn<String> get wordId =>
      $composableBuilder(column: $table.wordId, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);
}

class $$ThemeWordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ThemeWordsTable,
          ThemeWord,
          $$ThemeWordsTableFilterComposer,
          $$ThemeWordsTableOrderingComposer,
          $$ThemeWordsTableAnnotationComposer,
          $$ThemeWordsTableCreateCompanionBuilder,
          $$ThemeWordsTableUpdateCompanionBuilder,
          (
            ThemeWord,
            BaseReferences<_$AppDatabase, $ThemeWordsTable, ThemeWord>,
          ),
          ThemeWord,
          PrefetchHooks Function()
        > {
  $$ThemeWordsTableTableManager(_$AppDatabase db, $ThemeWordsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ThemeWordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ThemeWordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ThemeWordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> themeId = const Value.absent(),
                Value<String> wordId = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ThemeWordsCompanion(
                themeId: themeId,
                wordId: wordId,
                position: position,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String themeId,
                required String wordId,
                required int position,
                Value<int> rowid = const Value.absent(),
              }) => ThemeWordsCompanion.insert(
                themeId: themeId,
                wordId: wordId,
                position: position,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ThemeWordsTable, ThemeWord>(table),
                  BaseReferences<_$AppDatabase, $ThemeWordsTable, ThemeWord>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ThemeWordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ThemeWordsTable,
      ThemeWord,
      $$ThemeWordsTableFilterComposer,
      $$ThemeWordsTableOrderingComposer,
      $$ThemeWordsTableAnnotationComposer,
      $$ThemeWordsTableCreateCompanionBuilder,
      $$ThemeWordsTableUpdateCompanionBuilder,
      (ThemeWord, BaseReferences<_$AppDatabase, $ThemeWordsTable, ThemeWord>),
      ThemeWord,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$WordsTableTableManager get words =>
      $$WordsTableTableManager(_db, _db.words);
  $$GrammarSheetsTableTableManager get grammarSheets =>
      $$GrammarSheetsTableTableManager(_db, _db.grammarSheets);
  $$ProgressTableTableManager get progress =>
      $$ProgressTableTableManager(_db, _db.progress);
  $$MetaTableTableManager get meta => $$MetaTableTableManager(_db, _db.meta);
  $$RevisionItemsTableTableManager get revisionItems =>
      $$RevisionItemsTableTableManager(_db, _db.revisionItems);
  $$ThemesTableTableManager get themes =>
      $$ThemesTableTableManager(_db, _db.themes);
  $$ThemeWordsTableTableManager get themeWords =>
      $$ThemeWordsTableTableManager(_db, _db.themeWords);
}
