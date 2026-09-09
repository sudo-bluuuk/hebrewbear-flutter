import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:hebrewbear/data/conjugation.dart';
import 'package:hebrewbear/data/wordtypes.dart';

part 'dbmanager.g.dart';

class WordsSchema extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get root => text()();
  TextColumn get translate => text()();
  TextColumn get type => text()();
}

/// Forms the user has corrected by hand, replacing the generated ones.
///
/// The conjugation rules do not cover every verb — irregulars and several
/// weak-root classes come out wrong — so any single form can be overridden.
/// Only corrected forms are stored; everything else stays generated.
class ConjugationOverrides extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get wordId =>
      integer().references(WordsSchema, #id, onDelete: KeyAction.cascade)();

  /// 'Infinitive', 'Present', 'Past' or 'Future'.
  TextColumn get tense => text()();

  /// The key within that tense, e.g. 'S M' or 'They'.
  TextColumn get person => text()();
  TextColumn get form => text()();

  @override
  List<Set<Column>> get uniqueKeys => [
        {wordId, tense, person}
      ];
}

/// A stored word together with the manual infinitive, if the user set one.
class WordEntry {
  const WordEntry({required this.word, this.infinitiveOverride});

  final WordsSchemaData word;
  final String? infinitiveOverride;

  bool get isInfinitiveManual => infinitiveOverride != null;

  /// The corrected infinitive when there is one, otherwise the generated form.
  String get infinitive =>
      infinitiveOverride ?? createInfinitive(word.root, word.type).values.first;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(path.join(dbFolder.path, 'words.sqlite3'));

    return NativeDatabase.createInBackground(file);
  });
}

@DriftDatabase(tables: [WordsSchema, ConjugationOverrides])
class WordsDB extends _$WordsDB {
  WordsDB() : super(_openConnection());

  /// Backs the database with [executor] instead of the on-disk file, so tests
  /// can run against `NativeDatabase.memory()`.
  WordsDB.withExecutor(super.executor);

  /// Any character in the Hebrew block; the regex engine resolves the escapes.
  static final _hebrew = RegExp(r'[\u0590-\u05FF]');

  /// The infinitive is stored as a tense of its own, with a single key.
  static const String infinitiveTense = 'Infinitive';
  static const String infinitiveKey = 'inf';

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          if (from < 2) await m.createTable(conjugationOverrides);
        },
        beforeOpen: (details) async {
          // Required for the override rows to be removed with their word.
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );

  /// Watches the word list, re-emitting whenever a row changes. A Hebrew
  /// [filter] is matched against the root, anything else against the
  /// translation. A null [category] means every kind of word.
  Stream<List<WordEntry>> watchWords(String filter, {WordCategory? category}) {
    // Joined so the list shows a corrected infinitive rather than the generated
    // one, without a second query per row.
    final query = select(wordsSchema).join([
      leftOuterJoin(
        conjugationOverrides,
        conjugationOverrides.wordId.equalsExp(wordsSchema.id) &
            conjugationOverrides.tense.equals(infinitiveTense) &
            conjugationOverrides.person.equals(infinitiveKey),
      ),
    ]);

    if (category != null) {
      query.where(wordsSchema.type.isIn(category.types));
    }
    if (filter.isNotEmpty) {
      query.where(_hebrew.hasMatch(filter)
          ? wordsSchema.root.contains(filter)
          : wordsSchema.translate.contains(filter));
    }

    return query.watch().map((rows) => [
          for (final row in rows)
            WordEntry(
              word: row.readTable(wordsSchema),
              infinitiveOverride: row.readTableOrNull(conjugationOverrides)?.form,
            )
        ]);
  }

  /// Every manual form for one word, across all tenses.
  Stream<List<ConjugationOverride>> watchOverrides(int wordId) {
    return (select(conjugationOverrides)
          ..where((tbl) => tbl.wordId.equals(wordId)))
        .watch();
  }

  Future<void> setOverride({
    required int wordId,
    required String tense,
    required String person,
    required String form,
  }) async {
    await into(conjugationOverrides).insert(
      ConjugationOverridesCompanion.insert(
        wordId: wordId,
        tense: tense,
        person: person,
        form: form,
      ),
      onConflict: DoUpdate(
        (_) => ConjugationOverridesCompanion(form: Value(form)),
        target: [
          conjugationOverrides.wordId,
          conjugationOverrides.tense,
          conjugationOverrides.person,
        ],
      ),
    );
  }

  /// Drops a correction, so the form falls back to the generated one.
  Future<int> clearOverride({
    required int wordId,
    required String tense,
    required String person,
  }) {
    return (delete(conjugationOverrides)
          ..where((tbl) =>
              tbl.wordId.equals(wordId) &
              tbl.tense.equals(tense) &
              tbl.person.equals(person)))
        .go();
  }

  Future<int> insertWord(WordsSchemaCompanion entity) {
    return into(wordsSchema).insert(entity);
  }

  Future<int> deleteWord(int id) {
    return (delete(wordsSchema)..where((tbl) => tbl.id.equals(id))).go();
  }
}
