// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dbmanager.dart';

// ignore_for_file: type=lint
class $WordsSchemaTable extends WordsSchema
    with TableInfo<$WordsSchemaTable, WordsSchemaData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WordsSchemaTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _rootMeta = const VerificationMeta('root');
  @override
  late final GeneratedColumn<String> root = GeneratedColumn<String>(
    'root',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _translateMeta = const VerificationMeta(
    'translate',
  );
  @override
  late final GeneratedColumn<String> translate = GeneratedColumn<String>(
    'translate',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _gizrahMeta = const VerificationMeta('gizrah');
  @override
  late final GeneratedColumn<String> gizrah = GeneratedColumn<String>(
    'gizrah',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('automatic'),
  );
  @override
  List<GeneratedColumn> get $columns => [id, root, translate, type, gizrah];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'words_schema';
  @override
  VerificationContext validateIntegrity(
    Insertable<WordsSchemaData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('root')) {
      context.handle(
        _rootMeta,
        root.isAcceptableOrUnknown(data['root']!, _rootMeta),
      );
    } else if (isInserting) {
      context.missing(_rootMeta);
    }
    if (data.containsKey('translate')) {
      context.handle(
        _translateMeta,
        translate.isAcceptableOrUnknown(data['translate']!, _translateMeta),
      );
    } else if (isInserting) {
      context.missing(_translateMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('gizrah')) {
      context.handle(
        _gizrahMeta,
        gizrah.isAcceptableOrUnknown(data['gizrah']!, _gizrahMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WordsSchemaData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WordsSchemaData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      root: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}root'],
      )!,
      translate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}translate'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      gizrah: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gizrah'],
      )!,
    );
  }

  @override
  $WordsSchemaTable createAlias(String alias) {
    return $WordsSchemaTable(attachedDatabase, alias);
  }
}

class WordsSchemaData extends DataClass implements Insertable<WordsSchemaData> {
  final int id;
  final String root;
  final String translate;
  final String type;

  /// How the root conjugates, where the letters do not settle it. Defaults to
  /// automatic, which is what every row written before this column existed
  /// meant implicitly.
  final String gizrah;
  const WordsSchemaData({
    required this.id,
    required this.root,
    required this.translate,
    required this.type,
    required this.gizrah,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['root'] = Variable<String>(root);
    map['translate'] = Variable<String>(translate);
    map['type'] = Variable<String>(type);
    map['gizrah'] = Variable<String>(gizrah);
    return map;
  }

  WordsSchemaCompanion toCompanion(bool nullToAbsent) {
    return WordsSchemaCompanion(
      id: Value(id),
      root: Value(root),
      translate: Value(translate),
      type: Value(type),
      gizrah: Value(gizrah),
    );
  }

  factory WordsSchemaData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WordsSchemaData(
      id: serializer.fromJson<int>(json['id']),
      root: serializer.fromJson<String>(json['root']),
      translate: serializer.fromJson<String>(json['translate']),
      type: serializer.fromJson<String>(json['type']),
      gizrah: serializer.fromJson<String>(json['gizrah']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'root': serializer.toJson<String>(root),
      'translate': serializer.toJson<String>(translate),
      'type': serializer.toJson<String>(type),
      'gizrah': serializer.toJson<String>(gizrah),
    };
  }

  WordsSchemaData copyWith({
    int? id,
    String? root,
    String? translate,
    String? type,
    String? gizrah,
  }) => WordsSchemaData(
    id: id ?? this.id,
    root: root ?? this.root,
    translate: translate ?? this.translate,
    type: type ?? this.type,
    gizrah: gizrah ?? this.gizrah,
  );
  WordsSchemaData copyWithCompanion(WordsSchemaCompanion data) {
    return WordsSchemaData(
      id: data.id.present ? data.id.value : this.id,
      root: data.root.present ? data.root.value : this.root,
      translate: data.translate.present ? data.translate.value : this.translate,
      type: data.type.present ? data.type.value : this.type,
      gizrah: data.gizrah.present ? data.gizrah.value : this.gizrah,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WordsSchemaData(')
          ..write('id: $id, ')
          ..write('root: $root, ')
          ..write('translate: $translate, ')
          ..write('type: $type, ')
          ..write('gizrah: $gizrah')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, root, translate, type, gizrah);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WordsSchemaData &&
          other.id == this.id &&
          other.root == this.root &&
          other.translate == this.translate &&
          other.type == this.type &&
          other.gizrah == this.gizrah);
}

class WordsSchemaCompanion extends UpdateCompanion<WordsSchemaData> {
  final Value<int> id;
  final Value<String> root;
  final Value<String> translate;
  final Value<String> type;
  final Value<String> gizrah;
  const WordsSchemaCompanion({
    this.id = const Value.absent(),
    this.root = const Value.absent(),
    this.translate = const Value.absent(),
    this.type = const Value.absent(),
    this.gizrah = const Value.absent(),
  });
  WordsSchemaCompanion.insert({
    this.id = const Value.absent(),
    required String root,
    required String translate,
    required String type,
    this.gizrah = const Value.absent(),
  }) : root = Value(root),
       translate = Value(translate),
       type = Value(type);
  static Insertable<WordsSchemaData> custom({
    Expression<int>? id,
    Expression<String>? root,
    Expression<String>? translate,
    Expression<String>? type,
    Expression<String>? gizrah,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (root != null) 'root': root,
      if (translate != null) 'translate': translate,
      if (type != null) 'type': type,
      if (gizrah != null) 'gizrah': gizrah,
    });
  }

  WordsSchemaCompanion copyWith({
    Value<int>? id,
    Value<String>? root,
    Value<String>? translate,
    Value<String>? type,
    Value<String>? gizrah,
  }) {
    return WordsSchemaCompanion(
      id: id ?? this.id,
      root: root ?? this.root,
      translate: translate ?? this.translate,
      type: type ?? this.type,
      gizrah: gizrah ?? this.gizrah,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (root.present) {
      map['root'] = Variable<String>(root.value);
    }
    if (translate.present) {
      map['translate'] = Variable<String>(translate.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (gizrah.present) {
      map['gizrah'] = Variable<String>(gizrah.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WordsSchemaCompanion(')
          ..write('id: $id, ')
          ..write('root: $root, ')
          ..write('translate: $translate, ')
          ..write('type: $type, ')
          ..write('gizrah: $gizrah')
          ..write(')'))
        .toString();
  }
}

class $ConjugationOverridesTable extends ConjugationOverrides
    with TableInfo<$ConjugationOverridesTable, ConjugationOverride> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ConjugationOverridesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _wordIdMeta = const VerificationMeta('wordId');
  @override
  late final GeneratedColumn<int> wordId = GeneratedColumn<int>(
    'word_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES words_schema (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _tenseMeta = const VerificationMeta('tense');
  @override
  late final GeneratedColumn<String> tense = GeneratedColumn<String>(
    'tense',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _personMeta = const VerificationMeta('person');
  @override
  late final GeneratedColumn<String> person = GeneratedColumn<String>(
    'person',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _formMeta = const VerificationMeta('form');
  @override
  late final GeneratedColumn<String> form = GeneratedColumn<String>(
    'form',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, wordId, tense, person, form];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'conjugation_overrides';
  @override
  VerificationContext validateIntegrity(
    Insertable<ConjugationOverride> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('word_id')) {
      context.handle(
        _wordIdMeta,
        wordId.isAcceptableOrUnknown(data['word_id']!, _wordIdMeta),
      );
    } else if (isInserting) {
      context.missing(_wordIdMeta);
    }
    if (data.containsKey('tense')) {
      context.handle(
        _tenseMeta,
        tense.isAcceptableOrUnknown(data['tense']!, _tenseMeta),
      );
    } else if (isInserting) {
      context.missing(_tenseMeta);
    }
    if (data.containsKey('person')) {
      context.handle(
        _personMeta,
        person.isAcceptableOrUnknown(data['person']!, _personMeta),
      );
    } else if (isInserting) {
      context.missing(_personMeta);
    }
    if (data.containsKey('form')) {
      context.handle(
        _formMeta,
        form.isAcceptableOrUnknown(data['form']!, _formMeta),
      );
    } else if (isInserting) {
      context.missing(_formMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {wordId, tense, person},
  ];
  @override
  ConjugationOverride map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ConjugationOverride(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      wordId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}word_id'],
      )!,
      tense: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tense'],
      )!,
      person: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}person'],
      )!,
      form: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}form'],
      )!,
    );
  }

  @override
  $ConjugationOverridesTable createAlias(String alias) {
    return $ConjugationOverridesTable(attachedDatabase, alias);
  }
}

class ConjugationOverride extends DataClass
    implements Insertable<ConjugationOverride> {
  final int id;
  final int wordId;

  /// 'Infinitive', 'Present', 'Past' or 'Future'.
  final String tense;

  /// The key within that tense, e.g. 'S M' or 'They'.
  final String person;
  final String form;
  const ConjugationOverride({
    required this.id,
    required this.wordId,
    required this.tense,
    required this.person,
    required this.form,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['word_id'] = Variable<int>(wordId);
    map['tense'] = Variable<String>(tense);
    map['person'] = Variable<String>(person);
    map['form'] = Variable<String>(form);
    return map;
  }

  ConjugationOverridesCompanion toCompanion(bool nullToAbsent) {
    return ConjugationOverridesCompanion(
      id: Value(id),
      wordId: Value(wordId),
      tense: Value(tense),
      person: Value(person),
      form: Value(form),
    );
  }

  factory ConjugationOverride.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ConjugationOverride(
      id: serializer.fromJson<int>(json['id']),
      wordId: serializer.fromJson<int>(json['wordId']),
      tense: serializer.fromJson<String>(json['tense']),
      person: serializer.fromJson<String>(json['person']),
      form: serializer.fromJson<String>(json['form']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'wordId': serializer.toJson<int>(wordId),
      'tense': serializer.toJson<String>(tense),
      'person': serializer.toJson<String>(person),
      'form': serializer.toJson<String>(form),
    };
  }

  ConjugationOverride copyWith({
    int? id,
    int? wordId,
    String? tense,
    String? person,
    String? form,
  }) => ConjugationOverride(
    id: id ?? this.id,
    wordId: wordId ?? this.wordId,
    tense: tense ?? this.tense,
    person: person ?? this.person,
    form: form ?? this.form,
  );
  ConjugationOverride copyWithCompanion(ConjugationOverridesCompanion data) {
    return ConjugationOverride(
      id: data.id.present ? data.id.value : this.id,
      wordId: data.wordId.present ? data.wordId.value : this.wordId,
      tense: data.tense.present ? data.tense.value : this.tense,
      person: data.person.present ? data.person.value : this.person,
      form: data.form.present ? data.form.value : this.form,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ConjugationOverride(')
          ..write('id: $id, ')
          ..write('wordId: $wordId, ')
          ..write('tense: $tense, ')
          ..write('person: $person, ')
          ..write('form: $form')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, wordId, tense, person, form);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ConjugationOverride &&
          other.id == this.id &&
          other.wordId == this.wordId &&
          other.tense == this.tense &&
          other.person == this.person &&
          other.form == this.form);
}

class ConjugationOverridesCompanion
    extends UpdateCompanion<ConjugationOverride> {
  final Value<int> id;
  final Value<int> wordId;
  final Value<String> tense;
  final Value<String> person;
  final Value<String> form;
  const ConjugationOverridesCompanion({
    this.id = const Value.absent(),
    this.wordId = const Value.absent(),
    this.tense = const Value.absent(),
    this.person = const Value.absent(),
    this.form = const Value.absent(),
  });
  ConjugationOverridesCompanion.insert({
    this.id = const Value.absent(),
    required int wordId,
    required String tense,
    required String person,
    required String form,
  }) : wordId = Value(wordId),
       tense = Value(tense),
       person = Value(person),
       form = Value(form);
  static Insertable<ConjugationOverride> custom({
    Expression<int>? id,
    Expression<int>? wordId,
    Expression<String>? tense,
    Expression<String>? person,
    Expression<String>? form,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (wordId != null) 'word_id': wordId,
      if (tense != null) 'tense': tense,
      if (person != null) 'person': person,
      if (form != null) 'form': form,
    });
  }

  ConjugationOverridesCompanion copyWith({
    Value<int>? id,
    Value<int>? wordId,
    Value<String>? tense,
    Value<String>? person,
    Value<String>? form,
  }) {
    return ConjugationOverridesCompanion(
      id: id ?? this.id,
      wordId: wordId ?? this.wordId,
      tense: tense ?? this.tense,
      person: person ?? this.person,
      form: form ?? this.form,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (wordId.present) {
      map['word_id'] = Variable<int>(wordId.value);
    }
    if (tense.present) {
      map['tense'] = Variable<String>(tense.value);
    }
    if (person.present) {
      map['person'] = Variable<String>(person.value);
    }
    if (form.present) {
      map['form'] = Variable<String>(form.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ConjugationOverridesCompanion(')
          ..write('id: $id, ')
          ..write('wordId: $wordId, ')
          ..write('tense: $tense, ')
          ..write('person: $person, ')
          ..write('form: $form')
          ..write(')'))
        .toString();
  }
}

abstract class _$WordsDB extends GeneratedDatabase {
  _$WordsDB(QueryExecutor e) : super(e);
  $WordsDBManager get managers => $WordsDBManager(this);
  late final $WordsSchemaTable wordsSchema = $WordsSchemaTable(this);
  late final $ConjugationOverridesTable conjugationOverrides =
      $ConjugationOverridesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    wordsSchema,
    conjugationOverrides,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'words_schema',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('conjugation_overrides', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$WordsSchemaTableCreateCompanionBuilder =
    WordsSchemaCompanion Function({
      Value<int> id,
      required String root,
      required String translate,
      required String type,
      Value<String> gizrah,
    });
typedef $$WordsSchemaTableUpdateCompanionBuilder =
    WordsSchemaCompanion Function({
      Value<int> id,
      Value<String> root,
      Value<String> translate,
      Value<String> type,
      Value<String> gizrah,
    });

final class $$WordsSchemaTableReferences
    extends BaseReferences<_$WordsDB, $WordsSchemaTable, WordsSchemaData> {
  $$WordsSchemaTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<
    $ConjugationOverridesTable,
    List<ConjugationOverride>
  >
  _conjugationOverridesRefsTable(_$WordsDB db) => MultiTypedResultKey.fromTable(
    db.conjugationOverrides,
    aliasName: 'words_schema__id__conjugation_overrides__word_id',
  );

  $$ConjugationOverridesTableProcessedTableManager
  get conjugationOverridesRefs {
    final manager = $$ConjugationOverridesTableTableManager(
      $_db,
      $_db.conjugationOverrides,
    ).filter((f) => f.wordId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _conjugationOverridesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$WordsSchemaTableFilterComposer
    extends Composer<_$WordsDB, $WordsSchemaTable> {
  $$WordsSchemaTableFilterComposer({
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

  ColumnFilters<String> get root => $composableBuilder(
    column: $table.root,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get translate => $composableBuilder(
    column: $table.translate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gizrah => $composableBuilder(
    column: $table.gizrah,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> conjugationOverridesRefs(
    Expression<bool> Function($$ConjugationOverridesTableFilterComposer f) f,
  ) {
    final $$ConjugationOverridesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.conjugationOverrides,
      getReferencedColumn: (t) => t.wordId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ConjugationOverridesTableFilterComposer(
            $db: $db,
            $table: $db.conjugationOverrides,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WordsSchemaTableOrderingComposer
    extends Composer<_$WordsDB, $WordsSchemaTable> {
  $$WordsSchemaTableOrderingComposer({
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

  ColumnOrderings<String> get root => $composableBuilder(
    column: $table.root,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get translate => $composableBuilder(
    column: $table.translate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gizrah => $composableBuilder(
    column: $table.gizrah,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WordsSchemaTableAnnotationComposer
    extends Composer<_$WordsDB, $WordsSchemaTable> {
  $$WordsSchemaTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get root =>
      $composableBuilder(column: $table.root, builder: (column) => column);

  GeneratedColumn<String> get translate =>
      $composableBuilder(column: $table.translate, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get gizrah =>
      $composableBuilder(column: $table.gizrah, builder: (column) => column);

  Expression<T> conjugationOverridesRefs<T extends Object>(
    Expression<T> Function($$ConjugationOverridesTableAnnotationComposer a) f,
  ) {
    final $$ConjugationOverridesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.conjugationOverrides,
          getReferencedColumn: (t) => t.wordId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ConjugationOverridesTableAnnotationComposer(
                $db: $db,
                $table: $db.conjugationOverrides,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$WordsSchemaTableTableManager
    extends
        RootTableManager<
          _$WordsDB,
          $WordsSchemaTable,
          WordsSchemaData,
          $$WordsSchemaTableFilterComposer,
          $$WordsSchemaTableOrderingComposer,
          $$WordsSchemaTableAnnotationComposer,
          $$WordsSchemaTableCreateCompanionBuilder,
          $$WordsSchemaTableUpdateCompanionBuilder,
          (WordsSchemaData, $$WordsSchemaTableReferences),
          WordsSchemaData,
          PrefetchHooks Function({bool conjugationOverridesRefs})
        > {
  $$WordsSchemaTableTableManager(_$WordsDB db, $WordsSchemaTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WordsSchemaTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WordsSchemaTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WordsSchemaTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> root = const Value.absent(),
                Value<String> translate = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> gizrah = const Value.absent(),
              }) => WordsSchemaCompanion(
                id: id,
                root: root,
                translate: translate,
                type: type,
                gizrah: gizrah,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String root,
                required String translate,
                required String type,
                Value<String> gizrah = const Value.absent(),
              }) => WordsSchemaCompanion.insert(
                id: id,
                root: root,
                translate: translate,
                type: type,
                gizrah: gizrah,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WordsSchemaTable, WordsSchemaData>(table),
                  $$WordsSchemaTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({conjugationOverridesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (conjugationOverridesRefs) db.conjugationOverrides,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (conjugationOverridesRefs)
                    await $_getPrefetchedData<
                      WordsSchemaData,
                      $WordsSchemaTable,
                      ConjugationOverride
                    >(
                      currentTable: table,
                      referencedTable: $$WordsSchemaTableReferences
                          ._conjugationOverridesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$WordsSchemaTableReferences(
                            db,
                            table,
                            p0,
                          ).conjugationOverridesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.wordId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$WordsSchemaTableProcessedTableManager =
    ProcessedTableManager<
      _$WordsDB,
      $WordsSchemaTable,
      WordsSchemaData,
      $$WordsSchemaTableFilterComposer,
      $$WordsSchemaTableOrderingComposer,
      $$WordsSchemaTableAnnotationComposer,
      $$WordsSchemaTableCreateCompanionBuilder,
      $$WordsSchemaTableUpdateCompanionBuilder,
      (WordsSchemaData, $$WordsSchemaTableReferences),
      WordsSchemaData,
      PrefetchHooks Function({bool conjugationOverridesRefs})
    >;
typedef $$ConjugationOverridesTableCreateCompanionBuilder =
    ConjugationOverridesCompanion Function({
      Value<int> id,
      required int wordId,
      required String tense,
      required String person,
      required String form,
    });
typedef $$ConjugationOverridesTableUpdateCompanionBuilder =
    ConjugationOverridesCompanion Function({
      Value<int> id,
      Value<int> wordId,
      Value<String> tense,
      Value<String> person,
      Value<String> form,
    });

final class $$ConjugationOverridesTableReferences
    extends
        BaseReferences<
          _$WordsDB,
          $ConjugationOverridesTable,
          ConjugationOverride
        > {
  $$ConjugationOverridesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $WordsSchemaTable _wordIdTable(_$WordsDB db) => db.wordsSchema
      .createAlias('conjugation_overrides__word_id__words_schema__id');

  $$WordsSchemaTableProcessedTableManager get wordId {
    final $_column = $_itemColumn<int>('word_id')!;

    final manager = $$WordsSchemaTableTableManager(
      $_db,
      $_db.wordsSchema,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_wordIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ConjugationOverridesTableFilterComposer
    extends Composer<_$WordsDB, $ConjugationOverridesTable> {
  $$ConjugationOverridesTableFilterComposer({
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

  ColumnFilters<String> get tense => $composableBuilder(
    column: $table.tense,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get person => $composableBuilder(
    column: $table.person,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get form => $composableBuilder(
    column: $table.form,
    builder: (column) => ColumnFilters(column),
  );

  $$WordsSchemaTableFilterComposer get wordId {
    final $$WordsSchemaTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.wordId,
      referencedTable: $db.wordsSchema,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WordsSchemaTableFilterComposer(
            $db: $db,
            $table: $db.wordsSchema,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ConjugationOverridesTableOrderingComposer
    extends Composer<_$WordsDB, $ConjugationOverridesTable> {
  $$ConjugationOverridesTableOrderingComposer({
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

  ColumnOrderings<String> get tense => $composableBuilder(
    column: $table.tense,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get person => $composableBuilder(
    column: $table.person,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get form => $composableBuilder(
    column: $table.form,
    builder: (column) => ColumnOrderings(column),
  );

  $$WordsSchemaTableOrderingComposer get wordId {
    final $$WordsSchemaTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.wordId,
      referencedTable: $db.wordsSchema,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WordsSchemaTableOrderingComposer(
            $db: $db,
            $table: $db.wordsSchema,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ConjugationOverridesTableAnnotationComposer
    extends Composer<_$WordsDB, $ConjugationOverridesTable> {
  $$ConjugationOverridesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tense =>
      $composableBuilder(column: $table.tense, builder: (column) => column);

  GeneratedColumn<String> get person =>
      $composableBuilder(column: $table.person, builder: (column) => column);

  GeneratedColumn<String> get form =>
      $composableBuilder(column: $table.form, builder: (column) => column);

  $$WordsSchemaTableAnnotationComposer get wordId {
    final $$WordsSchemaTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.wordId,
      referencedTable: $db.wordsSchema,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WordsSchemaTableAnnotationComposer(
            $db: $db,
            $table: $db.wordsSchema,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ConjugationOverridesTableTableManager
    extends
        RootTableManager<
          _$WordsDB,
          $ConjugationOverridesTable,
          ConjugationOverride,
          $$ConjugationOverridesTableFilterComposer,
          $$ConjugationOverridesTableOrderingComposer,
          $$ConjugationOverridesTableAnnotationComposer,
          $$ConjugationOverridesTableCreateCompanionBuilder,
          $$ConjugationOverridesTableUpdateCompanionBuilder,
          (ConjugationOverride, $$ConjugationOverridesTableReferences),
          ConjugationOverride,
          PrefetchHooks Function({bool wordId})
        > {
  $$ConjugationOverridesTableTableManager(
    _$WordsDB db,
    $ConjugationOverridesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ConjugationOverridesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ConjugationOverridesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ConjugationOverridesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> wordId = const Value.absent(),
                Value<String> tense = const Value.absent(),
                Value<String> person = const Value.absent(),
                Value<String> form = const Value.absent(),
              }) => ConjugationOverridesCompanion(
                id: id,
                wordId: wordId,
                tense: tense,
                person: person,
                form: form,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int wordId,
                required String tense,
                required String person,
                required String form,
              }) => ConjugationOverridesCompanion.insert(
                id: id,
                wordId: wordId,
                tense: tense,
                person: person,
                form: form,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ConjugationOverridesTable, ConjugationOverride>(
                    table,
                  ),
                  $$ConjugationOverridesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({wordId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (wordId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.wordId,
                        referencedTable: $$ConjugationOverridesTableReferences
                            ._wordIdTable(db),
                        referencedColumn: $$ConjugationOverridesTableReferences
                            ._wordIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ConjugationOverridesTableProcessedTableManager =
    ProcessedTableManager<
      _$WordsDB,
      $ConjugationOverridesTable,
      ConjugationOverride,
      $$ConjugationOverridesTableFilterComposer,
      $$ConjugationOverridesTableOrderingComposer,
      $$ConjugationOverridesTableAnnotationComposer,
      $$ConjugationOverridesTableCreateCompanionBuilder,
      $$ConjugationOverridesTableUpdateCompanionBuilder,
      (ConjugationOverride, $$ConjugationOverridesTableReferences),
      ConjugationOverride,
      PrefetchHooks Function({bool wordId})
    >;

class $WordsDBManager {
  final _$WordsDB _db;
  $WordsDBManager(this._db);
  $$WordsSchemaTableTableManager get wordsSchema =>
      $$WordsSchemaTableTableManager(_db, _db.wordsSchema);
  $$ConjugationOverridesTableTableManager get conjugationOverrides =>
      $$ConjugationOverridesTableTableManager(_db, _db.conjugationOverrides);
}
