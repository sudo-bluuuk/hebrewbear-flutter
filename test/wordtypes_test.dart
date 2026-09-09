import 'package:flutter_test/flutter_test.dart';
import 'package:hebrewbear/data/wordtypes.dart';

void main() {
  group('isVerb', () {
    test('every binyan is a verb', () {
      expect(binyanim, hasLength(7));
      for (final binyan in binyanim) {
        expect(isVerb(binyan), isTrue, reason: '$binyan should be a verb');
      }
    });

    test('nouns and adjectives are not verbs', () {
      expect(isVerb(nounType), isFalse);
      expect(isVerb(adjectiveType), isFalse);
    });

    test('an unknown type is not a verb', () {
      expect(isVerb('Nonsense'), isFalse);
    });
  });

  group('WordCategory', () {
    test('the sidebar offers exactly verb, noun and adjective', () {
      expect(WordCategory.values.map((c) => c.label),
          ['verb', 'noun', 'adjective']);
    });

    test('verbs need a binyan picked', () {
      expect(WordCategory.verb.needsTypeChoice, isTrue);
      expect(WordCategory.verb.types, binyanim);
    });

    test('nouns and adjectives have a single implied type', () {
      expect(WordCategory.noun.needsTypeChoice, isFalse);
      expect(WordCategory.noun.types, [nounType]);
      expect(WordCategory.adjective.needsTypeChoice, isFalse);
      expect(WordCategory.adjective.types, [adjectiveType]);
    });

    test('every category maps only to types the app knows', () {
      for (final category in WordCategory.values) {
        expect(category.types, isNotEmpty);
        for (final type in category.types) {
          expect(isVerb(type), category == WordCategory.verb,
              reason: '$type under ${category.label}');
        }
      }
    });
  });
}
