import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hebrewbear/data/alphabet.dart';
import 'package:hebrewbear/data/conjugation.dart';
import 'package:hebrewbear/data/dbmanager.dart';
import 'package:hebrewbear/data/gizrah.dart';

void main() {
  String consonantsOf(String f) => f.split('').where(isHebrewLetter).join();

  group('when the class has to be asked for', () {
    test('a Paal root starting with nun or yod is ambiguous', () {
      for (final root in ['נפל', 'נסע', 'ישב', 'ישן']) {
        expect(needsGizrah(root, 'Paal'), isTrue, reason: root);
      }
    });

    test('any other first letter settles itself', () {
      for (final root in ['כתב', 'אכל', 'קום', 'שלח']) {
        expect(needsGizrah(root, 'Paal'), isFalse, reason: root);
      }
    });

    // A root ending in ה is lamed-he whatever it starts with, and that class is
    // predictable, so there is nothing to ask.
    test('a lamed-he root is settled even when it starts with nun or yod', () {
      expect(needsGizrah('נטה', 'Paal'), isFalse);
      expect(needsGizrah('ינה', 'Paal'), isFalse);
    });

    test('only Paal is ever ambiguous', () {
      for (final binyan in ['Piel', 'Hiphil', 'Hitpael', 'Nifal']) {
        expect(needsGizrah('נפל', binyan), isFalse, reason: binyan);
      }
    });
  });

  group('the stored class changes the forms', () {
    test('dropping the first letter gives the ת infinitive', () {
      for (final entry in {
        'ישב': 'לשבת',
        'ידע': 'לדעת',
        'ירד': 'לרדת',
        'יצא': 'לצאת',
      }.entries) {
        expect(
            consonantsOf(createInfinitive(entry.key, 'Paal',
                    gizrah: Gizrah.droppingFirst)
                .values
                .first),
            entry.value,
            reason: entry.key);
      }
    });

    // The whole point of storing it: same shape, different answer.
    test('the same root gives a different form under each class', () {
      final kept = createInfinitive('ישב', 'Paal').values.first;
      final dropped =
          createInfinitive('ישב', 'Paal', gizrah: Gizrah.droppingFirst)
              .values
              .first;
      expect(kept, isNot(dropped));
      expect(consonantsOf(kept), 'לישוב');
      expect(consonantsOf(dropped), 'לשבת');
    });

    test('automatic leaves every other class exactly as it was', () {
      expect(consonantsOf(createInfinitive('ישן', 'Paal').values.first),
          'לישון');
      expect(consonantsOf(createInfinitive('נסע', 'Paal').values.first),
          'לנסוע');
      expect(consonantsOf(createInfinitive('כתב', 'Paal').values.first),
          'לכתוב');
      expect(consonantsOf(createInfinitive('קנה', 'Paal').values.first),
          'לקנות');
    });
  });

  group('storage', () {
    late WordsDB db;
    setUp(() => db = WordsDB.withExecutor(NativeDatabase.memory()));
    tearDown(() => db.close());

    test('a word defaults to automatic', () async {
      await db.insertWord(WordsSchemaCompanion(
        root: Value('כתב'),
        translate: Value('write'),
        type: Value('Paal'),
      ));

      final entry = (await db.watchWords('').first).single;
      expect(entry.word.gizrah, Gizrah.automatic.name);
    });

    test('a stored class reaches the generated infinitive', () async {
      await db.insertWord(WordsSchemaCompanion(
        root: Value('ישב'),
        translate: Value('sit'),
        type: Value('Paal'),
        gizrah: Value(Gizrah.droppingFirst.name),
      ));

      final entry = (await db.watchWords('').first).single;
      expect(consonantsOf(entry.infinitive), 'לשבת');
    });

    test('an unknown stored name falls back rather than throwing', () {
      expect(gizrahFromName('nonsense'), Gizrah.automatic);
      expect(gizrahFromName(null), Gizrah.automatic);
      expect(gizrahFromName('droppingFirst'), Gizrah.droppingFirst);
    });
  });
}
