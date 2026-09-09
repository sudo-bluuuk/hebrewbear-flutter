import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hebrewbear/data/alphabet.dart';
import 'package:hebrewbear/data/dbmanager.dart';

void main() {
  final katav = '${letters['kaf']}${letters['tav']}${letters['bet']}';
  final lamad = '${letters['lamed']}${letters['mem']}${letters['dalet']}';

  late WordsDB db;

  setUp(() => db = WordsDB.withExecutor(NativeDatabase.memory()));
  tearDown(() => db.close());

  Future<int> add(String root, String translate, String type) {
    return db.insertWord(WordsSchemaCompanion(
      root: Value(root),
      translate: Value(translate),
      type: Value(type),
    ));
  }

  test('an empty filter returns every word', () async {
    await add(katav, 'write', 'Paal');
    await add(lamad, 'learn', 'Paal');

    expect(await db.watchWords('').first, hasLength(2));
  });

  test('a Hebrew filter matches the root', () async {
    await add(katav, 'write', 'Paal');
    await add(lamad, 'learn', 'Paal');

    final matches = await db.watchWords(katav).first;
    expect(matches, hasLength(1));
    expect(matches.single.translate, 'write');
  });

  test('a latin filter matches the translation', () async {
    await add(katav, 'write', 'Paal');
    await add(lamad, 'learn', 'Paal');

    final matches = await db.watchWords('lear').first;
    expect(matches, hasLength(1));
    expect(matches.single.root, lamad);
  });

  test('the stream re-emits when a word is inserted or deleted', () async {
    final emissions = <int>[];
    final subscription =
        db.watchWords('').listen((words) => emissions.add(words.length));
    await pumpEventQueue(); // let the initial (empty) emission land

    final id = await add(katav, 'write', 'Paal');
    await pumpEventQueue();
    await db.deleteWord(id);
    await pumpEventQueue();

    await subscription.cancel();
    expect(emissions, [0, 1, 0]);
  });
}
