import 'package:flutter_test/flutter_test.dart';
import 'package:hebrewbear/data/alphabet.dart';
import 'package:hebrewbear/data/conjugation.dart';

void main() {
  group('geminate', () {
    test('an ordinary radical takes the dagesh', () {
      expect(geminate('ב', vowels['e']!), 'ב${vowels['e']}$dagesh');
    });

    // Canonical order is consonant, vowel, dagesh — appending the dagesh
    // straight after the letter renders identically but compares unequal to
    // Hebrew text from anywhere else.
    test('the dagesh is written after the vowel, not before it', () {
      final marked = geminate('ב', vowels['e']!);
      expect(marked.indexOf(vowels['e']!), lessThan(marked.indexOf(dagesh)));
    });

    test('a radical that cannot be doubled keeps its vowel and no dot', () {
      for (final radical in rejectsDagesh) {
        expect(geminate(radical, vowels['e']!), '$radical${vowels['e']}',
            reason: radical);
      }
    });

    test('a four-letter root has a cluster in the middle and is not doubled',
        () {
      final cluster = rootSlots('תרגם')[1];
      expect(geminate(cluster, vowels['e']!), '$cluster${vowels['e']}');
    });

    test('an absent vowel is handled', () {
      expect(geminate('ב', ''), 'ב$dagesh');
    });
  });

  group('gemination in the intensive binyanim', () {
    test('Piel, Pual and Hitpael double the middle radical', () {
      for (final binyan in intensiveBinyanim) {
        expect(createInfinitive('דבר', binyan).values.first, contains(dagesh),
            reason: binyan);
      }
    });

    // Asserted against the middle radical rather than the whole word, because
    // U+05BC is shared: it is the dagesh, but it is also the dot of the shuruq
    // in Hufal's מוּ. A plain "contains no dagesh" check reports that as a
    // doubling that is not there.
    test('the other binyanim do not double the middle radical', () {
      final bet = letters['bet']!;
      final doubled = RegExp('$bet.?$dagesh');

      for (final binyan in ['Paal', 'Hiphil', 'Nifal', 'Hufal']) {
        expect(createInfinitive('דבר', binyan).values.first,
            isNot(matches(doubled)),
            reason: binyan);
      }
      // The same check does fire for an intensive binyan.
      expect(createInfinitive('דבר', 'Piel').values.first, matches(doubled));
    });

    test('it applies across every tense, not just the infinitive', () {
      expect(conjugatePresent('דבר', 'Piel')['S M'], contains(dagesh));
      expect(conjugatePast('דבר', 'Piel')['He'], contains(dagesh));
      expect(conjugateFuture('דבר', 'Piel')['He'], contains(dagesh));
    });

    // The verified split: ה ח ע are simply written undoubled, while א and ר
    // additionally lengthen the vowel before them — לְנַחֵם keeps its patach but
    // לְבָרֵךְ takes a qamats. Only the missing dot is handled so far.
    test('a guttural middle radical is left undoubled', () {
      expect(createInfinitive('נחם', 'Piel').values.first, 'לְנַחֵם');
    });
  });

  group('sheva', () {
    test('the Paal infinitive closes its first syllable', () {
      expect(createInfinitive('כתב', 'Paal').values.first,
          startsWith('לִכ${vowels['_e']}'));
    });

    test('the infinitive lamed takes a sheva outside Paal', () {
      for (final binyan in ['Piel', 'Hiphil', 'Hitpael', 'Nifal']) {
        expect(createInfinitive('כתב', binyan).values.first,
            startsWith('ל${vowels['_e']}'),
            reason: binyan);
      }
    });

    test('the Piel infinitive no longer opens with a tsere', () {
      expect(createInfinitive('דבר', 'Piel').values.first,
          isNot(startsWith('ל${vowels['e']}')));
    });

    test('the Hitpael prefix tav closes its syllable, before and after a swap',
        () {
      expect(createInfinitive('לבש', 'Hitpael').values.first, 'לְהִתְלַבֵּש');
      expect(createInfinitive('שתף', 'Hitpael').values.first, 'לְהִשְתַתֵּף');
    });
  });
}
