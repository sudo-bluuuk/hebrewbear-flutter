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
  'ישב Paal',
  'ידע Paal',
  'ירד Paal',
  'יצא Paal',
  'קנה Paal',
  'רצה Paal',
  'עשה Paal',
  'ראה Paal',
  'שתה Paal',
  'סבב Paal',
  'הלך Paal',
  'בין Hiphil',
  'נגע Hiphil',
  'כנס Nifal',
  'שבר Nifal',
  'דבר Pual',
};

void main() {
  String consonantsOf(String form) =>
      form.split('').where(isHebrewLetter).join();

  String generatedFor(VerbCase c) =>
      consonantsOf(createInfinitive(c.root, c.binyan).values.first);

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

  // The vowel layer fails independently of the consonants, so it is tracked
  // apart: a missing dagesh should not be counted as a morphology bug, nor hide
  // one. These pin the gaps found in research; delete them when the vowel work
  // lands and they start failing.
  group('vowel layer, known gaps', () {
    const dagesh = 'ּ';
    const sheva = 'ְ';

    test('gemination is never marked', () {
      // Piel, Pual and Hitpael are defined by a doubled middle radical, written
      // with dagesh. Nothing emits one.
      for (final c in verbCases.where(
          (c) => const ['Piel', 'Pual', 'Hitpael'].contains(c.binyan))) {
        expect(createInfinitive(c.root, c.binyan).values.first,
            isNot(contains(dagesh)),
            reason: '${c.id} now marks gemination — good, update this test');
      }
    });

    test('the Piel infinitive opens with tsere instead of sheva', () {
      // לְדַבֵּר takes a sheva under the lamed; the template uses tsere.
      final piel = createInfinitive('דבר', 'Piel').values.first;
      expect(piel.startsWith('ל$sheva'), isFalse,
          reason: 'the Piel lamed is fixed — update this test');
    });
  });
}
