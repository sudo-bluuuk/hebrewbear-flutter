import 'package:flutter_test/flutter_test.dart';
import 'package:hebrewbear/data/alphabet.dart';
import 'package:hebrewbear/data/conjugation.dart';
import 'package:hebrewbear/data/wordtypes.dart';

void main() {
  final kaf = letters['kaf']!;
  final tav = letters['tav']!;
  final bet = letters['bet']!;
  final shin = letters['shin']!;
  final nun = letters['nun']!;
  final finalNun = letters['nunSofit']!;
  final hiriq = vowels['i']!;

  final katav = '$kaf$tav$bet'; // to write
  final shakan = '$shin$kaf$nun'; // third radical takes a final form

  group('normalizeRoot', () {
    test('strips niqqud so the root stays indexable', () {
      expect(normalizeRoot('$kaf$hiriq$tav$bet'), katav);
      expect(isSupportedRoot('$kaf$hiriq$tav$bet'), isTrue);
    });

    test('rewrites final letters back to their base shape', () {
      expect(normalizeRoot('$shin$kaf$finalNun'), shakan);
    });
  });

  group('root length', () {
    test('a triliteral root conjugates', () {
      expect(isSupportedRoot(katav), isTrue);
      expect(conjugatePresent(katav, 'Paal'), hasLength(4));
      expect(conjugatePast(katav, 'Paal'), hasLength(9));
      expect(conjugateFuture(katav, 'Paal'), hasLength(8));
    });

    test('a quadriliteral root falls back instead of throwing', () {
      final quad = '$katav$nun';
      expect(isSupportedRoot(quad), isFalse);
      expect(createInfinitive(quad, 'Piel'), {'inf': quad});
      expect(conjugatePast(quad, 'Piel'), {'root': quad});
    });

    test('a too-short root falls back instead of throwing', () {
      expect(() => conjugatePresent(kaf, 'Paal'), returnsNormally);
      expect(conjugatePresent(kaf, 'Paal'), {'root': kaf});
    });
  });

  group('finalizeWord', () {
    test('rewrites a word-final radical', () {
      expect(finalizeWord('$shin$kaf$nun'), '$shin$kaf$finalNun');
    });

    test('leaves a radical alone when a suffix follows it', () {
      expect(finalizeWord('$shin$kaf$nun$tav'), '$shin$kaf$nun$tav');
    });

    test('is applied to generated forms', () {
      expect(createInfinitive(shakan, 'Paal').values.first, endsWith(finalNun));
      expect(conjugatePresent(shakan, 'Paal')['S M'], endsWith(finalNun));
      // The plural suffix keeps the third radical mid-word.
      expect(conjugatePresent(shakan, 'Paal')['P M'], contains(nun));
      expect(conjugatePresent(shakan, 'Paal')['P M'], isNot(endsWith(nun)));
    });
  });

  group('wordTypes', () {
    test('adjectives and nouns are not verbs', () {
      expect(isVerb('Adjective'), isFalse);
      expect(isVerb('Noun'), isFalse);
    });

    test('every binyan is a verb', () {
      expect(isVerb('Paal'), isTrue);
      expect(isVerb('Hitpael'), isTrue);
      expect(isVerb('Hufal'), isTrue);
    });

    test('an unknown type is not a verb', () {
      expect(isVerb('Nonsense'), isFalse);
    });
  });
}
