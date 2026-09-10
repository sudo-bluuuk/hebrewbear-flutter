import 'package:flutter_test/flutter_test.dart';
import 'package:hebrewbear/data/alphabet.dart';
import 'package:hebrewbear/data/conjugation.dart';

import 'fixtures/verbs.dart';

/// Cases the rules are known to get wrong today.
///
/// A ratchet, not a wish list: when a rule lands, the entries it fixes must be
/// deleted from here. The test fails if anything moves in either direction, so
/// a fix cannot be forgotten and a regression cannot slip through.
const Set<String> knownFailures = {
  'אמר Paal',
  'נפל Paal',
  'נתן Paal',
  'ראה Nifal',
  'סבב Paal',
  'הלך Paal',
  'בין Hiphil',
  'נגע Hiphil',
  'כנס Nifal',
  'שבר Nifal',
  'דבר Pual',
};

/// Pointed forms the vowel layer still gets wrong; same ratchet as above.
const Set<String> knownVocalisedFailures = {
  'ברך Piel Infinitive inf',
  'כתב Paal Infinitive inf',
  'כתב Hiphil Infinitive inf',
  'לבש Hitpael Infinitive inf',
  'תרגם Piel Infinitive inf',
};



void main() {
  String consonantsOf(String form) =>
      form.split('').where(isHebrewLetter).join();

  String generatedFor(VerbCase c) =>
      consonantsOf(createInfinitive(c.root, c.binyan, gizrah: c.storedClass).values.first);

  bool passes(VerbCase c) => generatedFor(c) == c.infinitive;

  String report(Iterable<VerbCase> cases) {
    final byGizrah = <String, List<VerbCase>>{};
    for (final c in cases) {
      byGizrah.putIfAbsent(c.gizrah, () => []).add(c);
    }
    final lines = <String>[];
    for (final entry in byGizrah.entries.toList()
      ..sort((a, b) => b.value.length.compareTo(a.value.length))) {
      lines.add('  ${entry.key} (${entry.value.length}):');
      for (final c in entry.value) {
        lines.add('    ${c.root} ${c.binyan}: '
            'got ${generatedFor(c)}, want ${c.infinitive}'
            '${c.note.isEmpty ? '' : "  — ${c.note}"}');
      }
    }
    return lines.join('\n');
  }

  test('fixtures are well formed', () {
    for (final c in verbCases) {
      expect(c.root.length, anyOf(3, 4), reason: '${c.id} root length');
      expect(c.root.split('').every(isHebrewLetter), isTrue,
          reason: '${c.id} root is not bare Hebrew');
      expect(c.infinitive.split('').every(isHebrewLetter), isTrue,
          reason: '${c.id} expectation is not bare Hebrew');
    }
    expect(verbCases.map((c) => c.id).toSet(), hasLength(verbCases.length),
        reason: 'duplicate cases');
  });

  test('the set of failing infinitives is exactly the known set', () {
    final failing = {for (final c in verbCases) if (!passes(c)) c.id};

    final regressed = failing.difference(knownFailures);
    final fixed = knownFailures.difference(failing);
    final passRate =
        '${verbCases.length - failing.length}/${verbCases.length}';

    expect(
      failing,
      knownFailures,
      reason: 'infinitive accuracy: $passRate\n'
          '${regressed.isEmpty ? '' : '\nNEWLY FAILING (regression):\n'
              '${report(verbCases.where((c) => regressed.contains(c.id)))}\n'}'
          '${fixed.isEmpty ? '' : '\nNOW PASSING — remove from knownFailures:\n  '
              '${fixed.join('\n  ')}\n'}'
          '\nAll current failures by class:\n${report(verbCases.where((c) => !passes(c)))}',
    );
  });

  // The vowel layer fails independently of the consonants, so it gets its own
  // ratchet: a mispointed form must not be counted as a morphology bug, nor
  // hide one.
  group('vowel layer', () {
    String generatedFor(VocalisedCase c) {
      final forms = switch (c.tense) {
        'Infinitive' => createInfinitive(c.root, c.binyan),
        'Present' => conjugatePresent(c.root, c.binyan),
        'Past' => conjugatePast(c.root, c.binyan),
        _ => conjugateFuture(c.root, c.binyan),
      };
      return forms[c.person]!;
    }

    test('the set of failing pointed forms is exactly the known set', () {
      final failing = {
        for (final c in vocalisedCases)
          if (generatedFor(c) != c.expected) c.id
      };

      final detail = vocalisedCases
          .where((c) => generatedFor(c) != c.expected)
          .map((c) => '    ${c.id}: got ${generatedFor(c)}, '
              'want ${c.expected}${c.note.isEmpty ? '' : "  — ${c.note}"}')
          .join('\n');

      expect(
        failing,
        knownVocalisedFailures,
        reason: 'pointed accuracy: '
            '${vocalisedCases.length - failing.length}/${vocalisedCases.length}'
            '\n$detail',
      );
    });

    test('the intensive binyanim now mark gemination', () {
      // Piel, Pual and Hitpael are defined by a doubled middle radical. This
      // was absent entirely before the vowel work.
      expect(createInfinitive('דבר', 'Piel').values.first, contains(dagesh));
      expect(createInfinitive('לבש', 'Hitpael').values.first, contains(dagesh));
    });

    test('a radical that cannot take a dagesh does not get one', () {
      for (final radical in rejectsDagesh) {
        final root = 'ד$radical' 'ר';
        expect(createInfinitive(root, 'Piel').values.first,
            isNot(contains(dagesh)),
            reason: '$radical cannot be doubled');
      }
    });
  });
}
