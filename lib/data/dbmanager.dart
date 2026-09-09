import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

part 'dbmanager.g.dart';

class WordsSchema extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get root => text()();
  TextColumn get translate => text()();
  TextColumn get type => text()();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(path.join(dbFolder.path, 'words.sqlite3'));

    return NativeDatabase.createInBackground(file);
  });
}

@DriftDatabase(tables: [WordsSchema])
class WordsDB extends _$WordsDB {
  WordsDB() : super(_openConnection());

  /// Backs the database with [executor] instead of the on-disk file, so tests
  /// can run against `NativeDatabase.memory()`.
  WordsDB.withExecutor(super.executor);

  /// Any character in the Hebrew block; the regex engine resolves the escapes.
  static final _hebrew = RegExp(r'[\u0590-\u05FF]');

  @override
  int get schemaVersion => 1;

  /// Watches the word list, re-emitting whenever a row changes. A Hebrew
  /// [filter] is matched against the root, anything else against the
  /// translation.
  Stream<List<WordsSchemaData>> watchWords(String filter) {
    final query = select(wordsSchema);
    if (filter.isNotEmpty) {
      if (_hebrew.hasMatch(filter)) {
        query.where((tbl) => tbl.root.contains(filter));
      } else {
        query.where((tbl) => tbl.translate.contains(filter));
      }
    }
    return query.watch();
  }

  Future<int> insertWord(WordsSchemaCompanion entity) {
    return into(wordsSchema).insert(entity);
  }

  Future<int> deleteWord(int id) {
    return (delete(wordsSchema)..where((tbl) => tbl.id.equals(id))).go();
  }
}
