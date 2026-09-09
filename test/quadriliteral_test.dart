import 'package:flutter_test/flutter_test.dart';
import 'package:hebrewbear/data/alphabet.dart';
import 'package:hebrewbear/data/conjugation.dart';

void main() {
  String consonantsOf(String form) =>
      form.split('').where(isHebrewLetter).join();

  group('rootSlots', () {
    test('a triliteral root is one letter per slot', () {
      expect(rootSlots('כתב'), ['כ', 'ת', 'ב']);
    });

    // The whole reason four-letter roots need no templates of their own.
    test('a quadriliteral root puts a two-consonant cluster in the middle', () {
      final sheva = vowels['_e']!;
      final resh = letters['resh']!;
      final gimel = letters['gimel']!;
      // Slots hold bare consonants: the root's final mem is normalised to its
      // base shape here, and finalizeWord restores it at the end of the word.
      expect(rootSlots('תרגם'), ['ת', '$resh$sheva$gimel', 'מ']);
    });

    test('niqqud and final letters are normalised away first', () {
      expect(rootSlots('כִתֵב'), ['כ', 'ת', 'ב']);
      expect(rootSlots('שכפל'), hasLength(3));
    });
  });

  group('which binyanim accept four letters', () {
    test('Piel, Pual and Hitpael do', () {
      expect(quadriliteralBinyanim, {'Piel', 'Pual', 'Hitpael'});
      for (final binyan in quadriliteralBinyanim) {
        expect(isSupportedRoot('תרגם', binyan), isTrue, reason: binyan);
      }
    });

    test('the other four do not, so טלפן in Paal is rejected', () {
      for (final binyan in ['Paal', 'Hiphil', 'Nifal', 'Hufal']) {
        expect(isSupportedRoot('טלפן', binyan), isFalse, reason: binyan);
      }
    });

    test('three letters are accepted everywhere', () {
      for (final binyan in [
        'Paal', 'Piel', 'Hiphil', 'Hitpael', 'Nifal', 'Pual', 'Hufal'
      ]) {
        expect(isSupportedRoot('כתב', binyan), isTrue, reason: binyan);
      }
    });
  });

  group('quadriliteral forms', () {
    test('תרגם is built across every tense', () {
      expect(consonantsOf(createInfinitive('תרגם', 'Piel').values.first),
          'לתרגם');
      expect(consonantsOf(conjugatePresent('תרגם', 'Piel')['S M']!), 'מתרגם');
      expect(consonantsOf(conjugatePast('תרגם', 'Piel')['He']!), 'תירגם');
      expect(consonantsOf(conjugateFuture('תרגם', 'Piel')['He']!), 'יתרגם');
    });

    test('טלפן and ארגן too', () {
      expect(consonantsOf(createInfinitive('טלפן', 'Piel').values.first),
          'לטלפן');
      expect(consonantsOf(createInfinitive('ארגן', 'Piel').values.first),
          'לארגן');
    });

    test('a full table is produced, not a fallback', () {
      expect(conjugatePresent('תרגם', 'Piel'), hasLength(4));
      expect(conjugatePast('תרגם', 'Piel'), hasLength(9));
      expect(conjugateFuture('תרגם', 'Piel'), hasLength(8));
    });

    // Composes with the metathesis rule: שכפל is four letters AND starts with
    // a sibilant, so both rules have to fire on the same word.
    test('a four-letter root starting with a sibilant also metathesises', () {
      expect(consonantsOf(createInfinitive('שכפל', 'Hitpael').values.first),
          'להשתכפל');
    });

    test('a four-letter root with an ordinary first radical does not', () {
      expect(consonantsOf(createInfinitive('ארגן', 'Hitpael').values.first),
          'להתארגן');
    });

    test('an unsupported pairing still falls back rather than throwing', () {
      expect(() => conjugatePast('טלפן', 'Paal'), returnsNormally);
      expect(conjugatePast('טלפן', 'Paal'), {'root': 'טלפן'});
    });
  });
}
