/// Verbs with their real infinitives, used to measure how much of Hebrew the
/// conjugation rules actually cover.
///
/// Expectations are written in ktiv male — the spelling a learner meets in
/// ordinary Hebrew text — and compared consonant-by-consonant, ignoring niqqud.
/// The vowel layer has its own separate gaps (no dagesh anywhere, missing
/// sheva) and is tracked apart from this, so that a vowel bug does not mask a
/// morphology bug or the reverse.
///
/// Each case carries the class it belongs to, so failures group into actionable
/// buckets rather than one undifferentiated count.
library;

import 'package:hebrewbear/data/gizrah.dart';

class VerbCase {
  const VerbCase(this.root, this.binyan, this.infinitive, this.gizrah,
      [this.note = '', this.storedClass = Gizrah.automatic]);

  final String root;
  final String binyan;

  /// The correct infinitive, consonants only, in ktiv male.
  final String infinitive;

  /// Which class this verb belongs to; failures are reported grouped by it.
  final String gizrah;
  final String note;

  /// What the user would have picked for this root, for the classes the
  /// letters do not settle. Left automatic everywhere else.
  final Gizrah storedClass;

  /// A root whose first letter drops — the user would have said so when
  /// adding it.
  const VerbCase.dropping(this.root, this.binyan, this.infinitive, this.gizrah,
      [this.note = ''])
      : storedClass = Gizrah.droppingFirst;

  String get id => '$root $binyan';

  @override
  String toString() => id;
}

const List<VerbCase> verbCases = [
  // Sound roots — the case the rules were written for.
  VerbCase('כתב', 'Paal', 'לכתוב', 'sound'),
  VerbCase('שמר', 'Paal', 'לשמור', 'sound'),
  VerbCase('סגר', 'Paal', 'לסגור', 'sound'),
  VerbCase('חשב', 'Paal', 'לחשוב', 'sound'),

  // First radical alef.
  VerbCase('אכל', 'Paal', 'לאכול', 'pe-alef'),
  VerbCase('אהב', 'Paal', 'לאהוב', 'pe-alef'),
  VerbCase('אמר', 'Paal', 'לומר', 'irregular', 'pe-alef but takes vav'),

  // Hollow roots (middle vav or yod).
  VerbCase('קום', 'Paal', 'לקום', 'hollow'),
  VerbCase('שים', 'Paal', 'לשים', 'hollow'),
  VerbCase('בוא', 'Paal', 'לבוא', 'hollow'),

  // First radical nun — sometimes kept, sometimes dropped.
  VerbCase('נסע', 'Paal', 'לנסוע', 'pe-nun', 'nun kept'),
  VerbCase('נפל', 'Paal', 'ליפול', 'pe-nun', 'nun replaced by yod'),
  VerbCase('נתן', 'Paal', 'לתת', 'irregular'),

  // First radical yod — note ישן behaves unlike the rest.
  VerbCase.dropping('ישב', 'Paal', 'לשבת', 'pe-yod'),
  VerbCase.dropping('ידע', 'Paal', 'לדעת', 'pe-yod'),
  VerbCase.dropping('ירד', 'Paal', 'לרדת', 'pe-yod'),
  VerbCase.dropping('יצא', 'Paal', 'לצאת', 'pe-yod'),
  VerbCase('ישן', 'Paal', 'לישון', 'pe-yod', 'keeps the yod, unlike ישב'),

  // Third radical he — very common.
  VerbCase('קנה', 'Paal', 'לקנות', 'lamed-he'),
  VerbCase('רצה', 'Paal', 'לרצות', 'lamed-he'),
  VerbCase('עשה', 'Paal', 'לעשות', 'lamed-he'),
  VerbCase('ראה', 'Paal', 'לראות', 'lamed-he'),
  VerbCase('שתה', 'Paal', 'לשתות', 'lamed-he'),

  // Lamed-he outside Paal. Not handled yet, but measured so the gap is visible
  // rather than merely absent from the fixtures.
  VerbCase('כסה', 'Piel', 'לכסות', 'lamed-he', 'other binyanim'),
  VerbCase('עלה', 'Hiphil', 'להעלות', 'lamed-he', 'other binyanim'),
  // The ות ending is right now; what is left is the same missing ktiv male yod
  // as the other Nifal infinitives, so it belongs in the spelling bucket.
  VerbCase('ראה', 'Nifal', 'להיראות', 'spelling', 'lamed-he ending is correct'),
  VerbCase('כסה', 'Hitpael', 'להתכסות', 'lamed-he', 'other binyanim'),

  // Third radical alef or a guttural.
  VerbCase('מצא', 'Paal', 'למצוא', 'lamed-alef'),
  VerbCase('קרא', 'Paal', 'לקרוא', 'lamed-alef'),
  VerbCase('שלח', 'Paal', 'לשלוח', 'lamed-guttural'),
  VerbCase('שמע', 'Paal', 'לשמוע', 'lamed-guttural'),
  VerbCase('עמד', 'Paal', 'לעמוד', 'pe-guttural'),

  // Doubled second and third radical.
  VerbCase('סבב', 'Paal', 'לסוב', 'geminate'),

  VerbCase('הלך', 'Paal', 'ללכת', 'irregular'),

  // Piel.
  VerbCase('דבר', 'Piel', 'לדבר', 'sound'),
  VerbCase('בקש', 'Piel', 'לבקש', 'sound'),
  VerbCase('למד', 'Piel', 'ללמד', 'sound'),

  // Four-letter roots; these exist only in Piel, Pual and Hitpael.
  VerbCase('תרגם', 'Piel', 'לתרגם', 'quadriliteral'),
  VerbCase('טלפן', 'Piel', 'לטלפן', 'quadriliteral'),
  VerbCase('ארגן', 'Piel', 'לארגן', 'quadriliteral'),

  // Hiphil.
  VerbCase('כתב', 'Hiphil', 'להכתיב', 'sound'),
  VerbCase('בין', 'Hiphil', 'להבין', 'hollow'),
  VerbCase('נגע', 'Hiphil', 'להגיע', 'pe-nun'),

  // Hitpael. The sibilant-initial roots need metathesis.
  VerbCase('לבש', 'Hitpael', 'להתלבש', 'sound'),
  VerbCase('שתף', 'Hitpael', 'להשתתף', 'metathesis', 'shin swaps with the tav'),
  VerbCase('סדר', 'Hitpael', 'להסתדר', 'metathesis'),
  VerbCase('צלם', 'Hitpael', 'להצטלם', 'metathesis', 'tav becomes tet'),
  VerbCase('זקן', 'Hitpael', 'להזדקן', 'metathesis', 'tav becomes dalet'),
  VerbCase('ארגן', 'Hitpael', 'להתארגן', 'quadriliteral'),

  // Nifal.
  // These two are only "wrong" once niqqud is stripped: the engine writes
  // לְהִכָּנֵס in ktiv haser, which is correct vocalised but lacks the yod a reader
  // expects unvocalised. A spelling-convention gap, not a morphology one.
  VerbCase('כנס', 'Nifal', 'להיכנס', 'spelling', 'vocalised form is correct'),
  VerbCase('שבר', 'Nifal', 'להישבר', 'spelling', 'vocalised form is correct'),

  // Pual and Hufal have no infinitive; the app shows the participle instead.
  VerbCase('דבר', 'Pual', 'מדובר', 'spelling', 'מְדֻבָּר is correct vocalised'),
  VerbCase('מלצ', 'Hufal', 'מומלץ', 'participle'),
];

/// A sample of fully pointed forms, for measuring the vowel layer.
///
/// Separate from [verbCases] because the two layers fail independently: a form
/// can have every consonant right and still be mispointed, and counting them
/// together would hide both.
class VocalisedCase {
  const VocalisedCase(
      this.root, this.binyan, this.tense, this.person, this.expected,
      [this.note = '']);

  final String root;
  final String binyan;

  /// 'Infinitive', 'Present', 'Past' or 'Future'.
  final String tense;

  /// The key within that tense; 'inf' for the infinitive.
  final String person;

  /// The correct form, fully pointed.
  final String expected;
  final String note;

  String get id => '$root $binyan $tense $person';
}

const List<VocalisedCase> vocalisedCases = [
  // Gemination in the intensive binyanim.
  VocalisedCase('דבר', 'Piel', 'Infinitive', 'inf', 'לְדַבֵּר'),
  VocalisedCase('דבר', 'Piel', 'Present', 'S M', 'מְדַבֵּר'),
  VocalisedCase('דבר', 'Piel', 'Future', 'He', 'יְדַבֵּר'),

  // ח cannot take a dagesh and is written undoubled, vowel unchanged.
  VocalisedCase('נחם', 'Piel', 'Infinitive', 'inf', 'לְנַחֵם'),

  // ר cannot either, and additionally lengthens the vowel before it.
  VocalisedCase('ברך', 'Piel', 'Infinitive', 'inf', 'לְבָרֵךְ',
      'needs compensatory lengthening'),

  // Sheva closing a syllable.
  VocalisedCase('כתב', 'Paal', 'Infinitive', 'inf', 'לִכְתּוֹב',
      'needs dagesh kal after the silent sheva'),
  VocalisedCase('כתב', 'Hiphil', 'Infinitive', 'inf', 'לְהַכְתִּיב',
      'needs dagesh kal'),
  VocalisedCase('לבש', 'Hitpael', 'Infinitive', 'inf', 'לְהִתְלַבֵּשׁ',
      'needs the shin dot'),
  VocalisedCase('תרגם', 'Piel', 'Infinitive', 'inf', 'לְתַרְגֵּם',
      'needs dagesh kal, not gemination'),

  // Lamed-he in Paal, exact down to the vowels.
  VocalisedCase('קנה', 'Paal', 'Infinitive', 'inf', 'לִקְנוֹת'),
  VocalisedCase('קנה', 'Paal', 'Present', 'S M', 'קוֹנֶה'),
  VocalisedCase('קנה', 'Paal', 'Past', 'She', 'קָנְתָה'),
  VocalisedCase('קנה', 'Paal', 'Future', 'He', 'יִקְנֶה'),
];
