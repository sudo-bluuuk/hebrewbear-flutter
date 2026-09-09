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

class VerbCase {
  const VerbCase(this.root, this.binyan, this.infinitive, this.gizrah,
      [this.note = '']);

  final String root;
  final String binyan;

  /// The correct infinitive, consonants only, in ktiv male.
  final String infinitive;

  /// Which class this verb belongs to; failures are reported grouped by it.
  final String gizrah;
  final String note;

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
  VerbCase('ישב', 'Paal', 'לשבת', 'pe-yod'),
  VerbCase('ידע', 'Paal', 'לדעת', 'pe-yod'),
  VerbCase('ירד', 'Paal', 'לרדת', 'pe-yod'),
  VerbCase('יצא', 'Paal', 'לצאת', 'pe-yod'),
  VerbCase('ישן', 'Paal', 'לישון', 'pe-yod', 'keeps the yod, unlike ישב'),

  // Third radical he — very common.
  VerbCase('קנה', 'Paal', 'לקנות', 'lamed-he'),
  VerbCase('רצה', 'Paal', 'לרצות', 'lamed-he'),
  VerbCase('עשה', 'Paal', 'לעשות', 'lamed-he'),
  VerbCase('ראה', 'Paal', 'לראות', 'lamed-he'),
  VerbCase('שתה', 'Paal', 'לשתות', 'lamed-he'),

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
