import 'package:flutter_test/flutter_test.dart';
import 'package:hebrewbear/data/corrections.dart';
import 'package:hebrewbear/data/dbmanager.dart';

void main() {
  ConjugationOverride override(String tense, String person, String form) =>
      ConjugationOverride(
          id: 1, wordId: 1, tense: tense, person: person, form: form);

  test('with nothing corrected, the generated form is used', () {
    expect(CorrectedForms.none.resolve('Past', 'I', 'generated'), 'generated');
    expect(CorrectedForms.none.isCorrected('Past', 'I'), isFalse);
    expect(CorrectedForms.none.isEmpty, isTrue);
  });

  test('a correction wins over the generated form', () {
    final forms = CorrectedForms.from([override('Past', 'I', 'manual')]);

    expect(forms.resolve('Past', 'I', 'generated'), 'manual');
    expect(forms.isCorrected('Past', 'I'), isTrue);
  });

  test('a correction applies only to its own person', () {
    final forms = CorrectedForms.from([override('Past', 'I', 'manual')]);

    expect(forms.resolve('Past', 'We', 'generated'), 'generated');
    expect(forms.isCorrected('Past', 'We'), isFalse);
  });

  // The bug this guards: 'I' exists in both Past and Future, so a flat
  // person-keyed map would leak a correction across tenses.
  test('a correction applies only to its own tense', () {
    final forms = CorrectedForms.from([override('Past', 'I', 'manual')]);

    expect(forms.resolve('Future', 'I', 'generated'), 'generated');
    expect(forms.isCorrected('Future', 'I'), isFalse);
  });

  test('the infinitive is just another tense', () {
    final forms = CorrectedForms.from([
      override(WordsDB.infinitiveTense, WordsDB.infinitiveKey, 'manual-inf')
    ]);

    expect(
        forms.resolve(
            WordsDB.infinitiveTense, WordsDB.infinitiveKey, 'generated'),
        'manual-inf');
    expect(forms.resolve('Present', WordsDB.infinitiveKey, 'generated'),
        'generated');
  });

  test('corrections across several tenses coexist', () {
    final forms = CorrectedForms.from([
      override('Past', 'I', 'a'),
      override('Future', 'I', 'b'),
      override('Present', 'S M', 'c'),
    ]);

    expect(forms.resolve('Past', 'I', 'x'), 'a');
    expect(forms.resolve('Future', 'I', 'x'), 'b');
    expect(forms.resolve('Present', 'S M', 'x'), 'c');
    expect(forms.resolve('Present', 'S F', 'x'), 'x');
  });
}
