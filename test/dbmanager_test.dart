import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hebrewbear/data/alphabet.dart';
import 'package:hebrewbear/data/conjugation.dart';
import 'package:hebrewbear/data/dbmanager.dart';
import 'package:hebrewbear/data/wordtypes.dart';

void main() {
  final katav = '${letters['kaf']}${letters['tav']}${letters['bet']}';
  final lamad = '${letters['lamed']}${letters['mem']}${letters['dalet']}';
  final bayit = '${letters['bet']}${letters['yod']}${letters['tav']}';
  final gadol =
      '${letters['gimel']}${letters['dalet']}${letters['vav']}${letters['lamed']}';

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
    expect(matches.single.word.translate, 'write');
  });

  test('a latin filter matches the translation', () async {
    await add(katav, 'write', 'Paal');
    await add(lamad, 'learn', 'Paal');

    final matches = await db.watchWords('lear').first;
    expect(matches, hasLength(1));
    expect(matches.single.word.root, lamad);
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

  group('category filter', () {
    Future<void> seed() async {
      await add(katav, 'write', 'Paal');
      await add(lamad, 'teach', 'Piel');
      await add(bayit, 'house', nounType);
      await add(gadol, 'big', adjectiveType);
    }

    test('a null category returns every kind of word', () async {
      await seed();

      expect(await db.watchWords('').first, hasLength(4));
    });

    test('verbs cover every binyan, not one type', () async {
      await seed();

      final verbs = await db.watchWords('', category: WordCategory.verb).first;
      expect(verbs.map((w) => w.word.type), containsAll(['Paal', 'Piel']));
      expect(verbs, hasLength(2));
    });

    test('nouns and adjectives are kept apart', () async {
      await seed();

      final nouns = await db.watchWords('', category: WordCategory.noun).first;
      expect(nouns.single.word.translate, 'house');

      final adjectives =
          await db.watchWords('', category: WordCategory.adjective).first;
      expect(adjectives.single.word.translate, 'big');
    });

    test('a category and a text filter apply together', () async {
      await seed();
      await add(bayit, 'big house', nounType);

      final matches =
          await db.watchWords('big', category: WordCategory.noun).first;
      expect(matches.single.word.translate, 'big house');
    });
  });

  group('conjugation overrides', () {
    const tense = 'Past';
    const person = 'I';

    test('a correction is stored and read back', () async {
      final id = await add(katav, 'write', 'Paal');
      await db.setOverride(
          wordId: id, tense: tense, person: person, form: 'manual');

      final stored = await db.watchOverrides(id).first;
      expect(stored.single.form, 'manual');
      expect(stored.single.tense, tense);
      expect(stored.single.person, person);
    });

    test('correcting the same form twice replaces it', () async {
      final id = await add(katav, 'write', 'Paal');
      await db.setOverride(
          wordId: id, tense: tense, person: person, form: 'first');
      await db.setOverride(
          wordId: id, tense: tense, person: person, form: 'second');

      final stored = await db.watchOverrides(id).first;
      expect(stored, hasLength(1));
      expect(stored.single.form, 'second');
    });

    test('corrections to different forms live side by side', () async {
      final id = await add(katav, 'write', 'Paal');
      await db.setOverride(wordId: id, tense: 'Past', person: 'I', form: 'a');
      await db.setOverride(wordId: id, tense: 'Past', person: 'We', form: 'b');
      await db.setOverride(
          wordId: id, tense: 'Future', person: 'I', form: 'c');

      expect(await db.watchOverrides(id).first, hasLength(3));
    });

    test('clearing a correction falls back to the generated form', () async {
      final id = await add(katav, 'write', 'Paal');
      await db.setOverride(
          wordId: id, tense: tense, person: person, form: 'manual');

      expect(
          await db.clearOverride(wordId: id, tense: tense, person: person), 1);
      expect(await db.watchOverrides(id).first, isEmpty);
    });

    test('deleting a word takes its corrections with it', () async {
      final id = await add(katav, 'write', 'Paal');
      await db.setOverride(
          wordId: id, tense: tense, person: person, form: 'manual');

      await db.deleteWord(id);

      expect(await db.watchOverrides(id).first, isEmpty);
    });
  });

  group('WordEntry.infinitive', () {
    test('falls back to the generated form', () async {
      await add(katav, 'write', 'Paal');

      final entry = (await db.watchWords('').first).single;
      expect(entry.isInfinitiveManual, isFalse);
      expect(entry.infinitive, createInfinitive(katav, 'Paal').values.first);
    });

    test('uses the correction once one is set', () async {
      final id = await add(katav, 'write', 'Paal');
      await db.setOverride(
        wordId: id,
        tense: WordsDB.infinitiveTense,
        person: WordsDB.infinitiveKey,
        form: 'manual-infinitive',
      );

      final entry = (await db.watchWords('').first).single;
      expect(entry.isInfinitiveManual, isTrue);
      expect(entry.infinitive, 'manual-infinitive');
    });

    test('a correction to another tense does not leak into the list',
        () async {
      final id = await add(katav, 'write', 'Paal');
      await db.setOverride(
          wordId: id, tense: 'Past', person: 'I', form: 'not-the-infinitive');

      final entry = (await db.watchWords('').first).single;
      expect(entry.isInfinitiveManual, isFalse);
    });
  });
}
