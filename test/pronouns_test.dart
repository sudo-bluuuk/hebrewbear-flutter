import 'package:flutter_test/flutter_test.dart';
import 'package:hebrewbear/data/alphabet.dart';
import 'package:hebrewbear/data/conjugation.dart';
import 'package:hebrewbear/data/pronouns.dart';

void main() {
  // Every slot the engine can produce, gathered from the engine itself rather
  // than written out again by hand.
  Set<String> engineSlots() => {
        ...createInfinitive('כתב', 'Paal').keys,
        for (final binyan in [
          'Paal', 'Piel', 'Hiphil', 'Hitpael', 'Nifal', 'Pual', 'Hufal'
        ]) ...[
          ...conjugatePresent('כתב', binyan).keys,
          ...conjugatePast('כתב', binyan).keys,
          ...conjugateFuture('כתב', binyan).keys,
        ],
      };

  group('hebrewLabels', () {
    test('every slot the engine produces has a label', () {
      for (final slot in engineSlots()) {
        expect(hebrewLabels, contains(slot), reason: '$slot has no label');
      }
    });

    // The other direction: an entry for a slot that no longer exists is dead
    // weight, and usually means a key was renamed somewhere.
    test('no label is left over for a slot that does not exist', () {
      expect(hebrewLabels.keys.toSet().difference(engineSlots()), isEmpty);
    });

    test('every label is Hebrew', () {
      for (final entry in hebrewLabels.entries) {
        expect(entry.value.split('').any(isHebrewLetter), isTrue,
            reason: '${entry.key} -> ${entry.value}');
      }
    });

    test('the pronouns are the ones asked for', () {
      expect(hebrewLabelFor('I'), 'אֲנִי');
      expect(hebrewLabelFor('You M'), 'אַתָּה');
      expect(hebrewLabelFor('You F'), 'אַתְּ');
      expect(hebrewLabelFor('He'), 'הוּא');
      expect(hebrewLabelFor('She'), 'הִיא');
      expect(hebrewLabelFor('We'), 'אֲנַחְנוּ');
      expect(hebrewLabelFor('You M P'), 'אַתֶּם');
      expect(hebrewLabelFor('You F P'), 'אַתֶּן');
      expect(hebrewLabelFor('They'), 'הֵם');
    });

    test('masculine and feminine are never given the same label', () {
      expect(hebrewLabelFor('You M'), isNot(hebrewLabelFor('You F')));
      expect(hebrewLabelFor('You M P'), isNot(hebrewLabelFor('You F P')));
      // The gap that made icons unworkable: plural gender must stay distinct.
      expect(hebrewLabelFor('P M'), isNot(hebrewLabelFor('P F')));
    });

    test('an unknown slot falls back to its own name', () {
      expect(hebrewLabelFor('Nonsense'), 'Nonsense');
    });
  });

  // Renaming a key would silently orphan every correction stored against the
  // old one, since the overrides table keys on these exact strings.
  test('the slot names themselves are unchanged', () {
    expect(conjugatePast('כתב', 'Paal').keys,
        containsAll(['I', 'You F', 'You M', 'He', 'She', 'We', 'They']));
    expect(conjugatePresent('כתב', 'Paal').keys,
        containsAll(['S M', 'S F', 'P M', 'P F']));
  });
}
