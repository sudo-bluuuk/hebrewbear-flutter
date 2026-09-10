import 'package:flutter_test/flutter_test.dart';
import 'package:hebrewbear/data/alphabet.dart';
import 'package:hebrewbear/data/conjugation.dart';
import 'package:hebrewbear/data/irregulars.dart';

void main() {
  String consonantsOf(String f) => f.split('').where(isHebrewLetter).join();

  group('the irregulars table', () {
    // A key written with a final letter would never match, because lookups
    // normalise the root first. Silent miss, so guard it.
    test('every key uses bare consonants', () {
      for (final key in irregularForms.keys) {
        final root = key.split('|').first;
        expect(normalizeRoot(root), root,
            reason: '$key is not written in base letters');
      }
    });

    test('every key names a tense and person the engine produces', () {
      for (final key in irregularForms.keys) {
        final parts = key.split('|');
        expect(parts, hasLength(4), reason: key);
        expect(['Infinitive', 'Present', 'Past', 'Future'], contains(parts[2]),
            reason: key);
      }
    });

    test('a listed form replaces the generated one', () {
      expect(createInfinitive('נתן', 'Paal').values.first, 'לָתֵת');
      expect(createInfinitive('הלך', 'Paal').values.first, 'לָלֶכֶת');
      expect(createInfinitive('אמר', 'Paal').values.first, 'לוֹמַר');
      expect(createInfinitive('נפל', 'Paal').values.first, 'לִיפּוֹל');
    });

    // The point of listing slots rather than whole verbs: נתן is irregular in
    // the infinitive and perfectly regular in the present.
    test('slots that are not listed stay generated', () {
      expect(consonantsOf(conjugatePresent('נתן', 'Paal')['S M']!), 'נותן');
      expect(consonantsOf(conjugatePresent('הלך', 'Paal')['S M']!), 'הולך');
      expect(consonantsOf(conjugatePast('הלך', 'Paal')['He']!), 'הלך');
    });

    test('a verb with no entry is untouched', () {
      expect(applyIrregulars('כתב', 'Paal', 'Infinitive', {'inf': 'x'}),
          {'inf': 'x'});
    });

    test('the root is normalised before lookup, so final letters still match',
        () {
      // Typed with a final kaf, as a user would.
      expect(createInfinitive('הלך', 'Paal').values.first, 'לָלֶכֶת');
    });
  });

  group('rules added alongside', () {
    test('a geminate root collapses', () {
      expect(consonantsOf(createInfinitive('סבב', 'Paal').values.first),
          'לסוב');
    });

    test('Hiphil drops a first-radical nun', () {
      for (final entry in {'נגע': 'להגיע', 'נפל': 'להפיל', 'נגש': 'להגיש'}
          .entries) {
        expect(
            consonantsOf(createInfinitive(entry.key, 'Hiphil').values.first),
            entry.value,
            reason: entry.key);
      }
    });

    test('Hiphil drops a hollow middle letter', () {
      expect(consonantsOf(createInfinitive('בין', 'Hiphil').values.first),
          'להבין');
      expect(consonantsOf(createInfinitive('קום', 'Hiphil').values.first),
          'להקים');
    });

    test('an ordinary Hiphil root is unaffected by either', () {
      expect(consonantsOf(createInfinitive('כתב', 'Hiphil').values.first),
          'להכתיב');
    });

    test('Nifal and Pual now spell ktiv male like the rest', () {
      expect(consonantsOf(createInfinitive('כנס', 'Nifal').values.first),
          'להיכנס');
      expect(consonantsOf(createInfinitive('דבר', 'Pual').values.first),
          'מדובר');
    });
  });
}
