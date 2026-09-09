import 'package:flutter_test/flutter_test.dart';
import 'package:hebrewbear/data/alphabet.dart';
import 'package:hebrewbear/data/conjugation.dart';

void main() {
  String consonantsOf(String form) =>
      form.split('').where(isHebrewLetter).join();

  group('hitpaelOnset', () {
    test('an ordinary radical keeps the prefix in front', () {
      expect(hitpaelOnset('לבש'), 'תל');
      expect(hitpaelOnset('פעל'), 'תפ');
    });

    test('a sibilant swaps with the prefix', () {
      expect(hitpaelOnset('שתף'), 'שת');
      expect(hitpaelOnset('סדר'), 'סת');
    });

    test('tsadi swaps and turns the prefix into tet', () {
      expect(hitpaelOnset('צלם'), 'צט');
    });

    test('zayin swaps and turns the prefix into dalet', () {
      expect(hitpaelOnset('זקן'), 'זד');
    });

    test('the vowel between keeps its slot rather than moving', () {
      final sheva = vowels['_e']!;
      final tav = letters['tav']!;
      final lamed = letters['lamed']!;
      final shin = letters['shin']!;

      // Prefix first: ת takes the vowel. Swapped: the radical takes it, and
      // the vowel stays in the same slot either way.
      expect(hitpaelOnset('לבש', sheva), '$tav$sheva$lamed');
      expect(hitpaelOnset('שתף', sheva), '$shin$sheva$tav');
    });
  });

  // Metathesis is not an infinitive quirk: it applies to all 22 forms, so the
  // accuracy harness alone (infinitives only) would not have caught a miss here.
  group('metathesis across every tense', () {
    const cases = {
      'שתף': ('להשתתף', 'משתתף', 'השתתף', 'ישתתף'),
      'סדר': ('להסתדר', 'מסתדר', 'הסתדר', 'יסתדר'),
      'צלם': ('להצטלם', 'מצטלם', 'הצטלם', 'יצטלם'),
      'זקן': ('להזדקן', 'מזדקן', 'הזדקן', 'יזדקן'),
    };

    cases.forEach((root, expected) {
      final (infinitive, present, past, future) = expected;

      test('$root is written correctly in all four', () {
        expect(consonantsOf(createInfinitive(root, 'Hitpael').values.first),
            infinitive);
        expect(consonantsOf(conjugatePresent(root, 'Hitpael')['S M']!),
            present);
        expect(consonantsOf(conjugatePast(root, 'Hitpael')['He']!), past);
        expect(consonantsOf(conjugateFuture(root, 'Hitpael')['He']!), future);
      });
    });

    test('a root needing no swap is left alone', () {
      expect(consonantsOf(createInfinitive('לבש', 'Hitpael').values.first),
          'להתלבש');
      expect(consonantsOf(conjugatePresent('לבש', 'Hitpael')['S M']!),
          'מתלבש');
      expect(consonantsOf(conjugatePast('לבש', 'Hitpael')['He']!), 'התלבש');
    });

    test('a root whose own second radical is tav is not confused', () {
      // שתף has a tav of its own; a naive string swap could move the wrong one.
      expect(consonantsOf(conjugatePast('שתף', 'Hitpael')['I']!), 'השתתפתי');
    });
  });
}
