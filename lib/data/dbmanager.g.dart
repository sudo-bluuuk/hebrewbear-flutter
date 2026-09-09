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
  @override
  List<GeneratedColumn> get $columns => [id, root, translate, type];
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
  const WordsSchemaData({
    required this.id,
    required this.root,
    required this.translate,
    required this.type,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['root'] = Variable<String>(root);
    map['translate'] = Variable<String>(translate);
    map['type'] = Variable<String>(type);
    return map;
  }

  WordsSchemaCompanion toCompanion(bool nullToAbsent) {
    return WordsSchemaCompanion(
      id: Value(id),
      root: Value(root),
      translate: Value(translate),
      type: Value(type),
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
    };
  }

  WordsSchemaData copyWith({
    int? id,
    String? root,
    String? translate,
    String? type,
  }) => WordsSchemaData(
    id: id ?? this.id,
    root: root ?? this.root,
    translate: translate ?? this.translate,
    type: type ?? this.type,
  );
  WordsSchemaData copyWithCompanion(WordsSchemaCompanion data) {
    return WordsSchemaData(
      id: data.id.present ? data.id.value : this.id,
      root: data.root.present ? data.root.value : this.root,
      translate: data.translate.present ? data.translate.value : this.translate,
      type: data.type.present ? data.type.value : this.type,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WordsSchemaData(')
          ..write('id: $id, ')
          ..write('root: $root, ')
          ..write('translate: $translate, ')
          ..write('type: $type')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, root, translate, type);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WordsSchemaData &&
          other.id == this.id &&
          other.root == this.root &&
          other.translate == this.translate &&
          other.type == this.type);
}

class WordsSchemaCompanion extends UpdateCompanion<WordsSchemaData> {
  final Value<int> id;
  final Value<String> root;
  final Value<String> translate;
  final Value<String> type;
  const WordsSchemaCompanion({
    this.id = const Value.absent(),
    this.root = const Value.absent(),
    this.translate = const Value.absent(),
    this.type = const Value.absent(),
  });
  WordsSchemaCompanion.insert({
    this.id = const Value.absent(),
    required String root,
    required String translate,
    required String type,
  }) : root = Value(root),
       translate = Value(translate),
       type = Value(type);
  static Insertable<WordsSchemaData> custom({
    Expression<int>? id,
    Expression<String>? root,
    Expression<String>? translate,
    Expression<String>? type,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (root != null) 'root': root,
      if (translate != null) 'translate': translate,
      if (type != null) 'type': type,
    });
  }

  WordsSchemaCompanion copyWith({
    Value<int>? id,
    Value<String>? root,
    Value<String>? translate,
    Value<String>? type,
  }) {
    return WordsSchemaCompanion(
      id: id ?? this.id,
      root: root ?? this.root,
      translate: translate ?? this.translate,
      type: type ?? this.type,
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
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WordsSchemaCompanion(')
          ..write('id: $id, ')
          ..write('root: $root, ')
          ..write('translate: $translate, ')
          ..write('type: $type')
          ..write(')'))
        .toString();
  }
}

abstract class _$WordsDB extends GeneratedDatabase {
  _$WordsDB(QueryExecutor e) : super(e);
  $WordsDBManager get managers => $WordsDBManager(this);
  late final $WordsSchemaTable wordsSchema = $WordsSchemaTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [wordsSchema];
}

typedef $$WordsSchemaTableCreateCompanionBuilder =
    WordsSchemaCompanion Function({
      Value<int> id,
      required String root,
      required String translate,
      required String type,
    });
typedef $$WordsSchemaTableUpdateCompanionBuilder =
    WordsSchemaCompanion Function({
      Value<int> id,
      Value<String> root,
      Value<String> translate,
      Value<String> type,
    });

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
          (
            WordsSchemaData,
            BaseReferences<_$WordsDB, $WordsSchemaTable, WordsSchemaData>,
          ),
          WordsSchemaData,
          PrefetchHooks Function()
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
              }) => WordsSchemaCompanion(
                id: id,
                root: root,
                translate: translate,
                type: type,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String root,
                required String translate,
                required String type,
              }) => WordsSchemaCompanion.insert(
                id: id,
                root: root,
                translate: translate,
                type: type,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WordsSchemaTable, WordsSchemaData>(table),
                  BaseReferences<_$WordsDB, $WordsSchemaTable, WordsSchemaData>(
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
      (
        WordsSchemaData,
        BaseReferences<_$WordsDB, $WordsSchemaTable, WordsSchemaData>,
      ),
      WordsSchemaData,
      PrefetchHooks Function()
    >;

class $WordsDBManager {
  final _$WordsDB _db;
  $WordsDBManager(this._db);
  $$WordsSchemaTableTableManager get wordsSchema =>
      $$WordsSchemaTableTableManager(_db, _db.wordsSchema);
}
