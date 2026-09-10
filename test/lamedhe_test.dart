import 'package:flutter_test/flutter_test.dart';
import 'package:hebrewbear/data/conjugation.dart';
import 'package:hebrewbear/data/alphabet.dart';

/// The full Paal table for קנה, taken from pealim. Pinned in full because a
/// gzarah changes every form, not just the citation form — the accuracy
/// harness only checks infinitives and would miss a break in the other 21.
void main() {
  group('lamed-he detection', () {
    test('a root ending in ה belongs to the class', () {
      expect(isLamedHe(rootSlots('קנה')), isTrue);
      expect(isLamedHe(rootSlots('עשה')), isTrue);
    });

    test('any other root does not', () {
      expect(isLamedHe(rootSlots('כתב')), isFalse);
      expect(isLamedHe(rootSlots('מצא')), isFalse, reason: 'lamed-alef');
      expect(isLamedHe(rootSlots('שלח')), isFalse, reason: 'lamed-guttural');
    });

    // ה elsewhere in the root is a different matter entirely.
    test('a ה in the first or middle slot is not this class', () {
      expect(isLamedHe(rootSlots('הלך')), isFalse);
      expect(isLamedHe(rootSlots('אהב')), isFalse);
    });
  });

  group('קנה in Paal, every form', () {
    test('infinitive', () {
      expect(createInfinitive('קנה', 'Paal').values.first, 'לִקְנוֹת');
    });

    test('present', () {
      expect(conjugatePresent('קנה', 'Paal'), {
        'S M': 'קוֹנֶה',
        'S F': 'קוֹנָה',
        'P M': 'קוֹנִים',
        'P F': 'קוֹנוֹת',
      });
    });

    test('past', () {
      expect(conjugatePast('קנה', 'Paal'), {
        'I': 'קָנִיתִי',
        'You F': 'קָנִית',
        'You M': 'קָנִיתָ',
        'He': 'קָנָה',
        'She': 'קָנְתָה',
        'We': 'קָנִינוּ',
        'You M P': 'קְנִיתֶם',
        'You F P': 'קְנִיתֶן',
        'They': 'קָנוּ',
      });
    });

    test('future', () {
      expect(conjugateFuture('קנה', 'Paal'), {
        'I': 'אֶקְנֶה',
        'We': 'נִקְנֶה',
        'You M': 'תִּקְנֶה',
        'You F': 'תִּקְנִי',
        'You': 'תִּקְנוּ',
        'He': 'יִקְנֶה',
        'She': 'תִּקְנֶה',
        'They': 'יִקְנוּ',
      });
    });
  });

  group('the class applies to the whole family', () {
    String consonantsOf(String f) =>
        f.split('').where(isHebrewLetter).join();

    test('other lamed-he roots follow the same pattern', () {
      for (final entry in {
        'רצה': 'לרצות',
        'עשה': 'לעשות',
        'ראה': 'לראות',
        'שתה': 'לשתות',
      }.entries) {
        expect(consonantsOf(createInfinitive(entry.key, 'Paal').values.first),
            entry.value,
            reason: entry.key);
      }
    });

    // חיה has a yod in the middle slot, which would otherwise send it down the
    // hollow-root branch. Lamed-he is tested first for exactly this reason.
    test('a lamed-he root is not mistaken for a hollow one', () {
      expect(consonantsOf(createInfinitive('חיה', 'Paal').values.first),
          'לחיות');
    });

    test('a root that is genuinely hollow still takes the hollow branch', () {
      expect(consonantsOf(createInfinitive('קום', 'Paal').values.first),
          'לקום');
    });
  });
}
