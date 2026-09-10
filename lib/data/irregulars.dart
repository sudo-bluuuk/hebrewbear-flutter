import 'package:hebrewbear/data/alphabet.dart';

/// Forms no rule produces, listed one slot at a time.
///
/// Every gzarah is a family; these are the verbs that are a family of one. The
/// keys are `root|binyan|tense|person`, with the root in bare consonants as
/// [normalizeRoot] leaves it.
///
/// Only the slots that actually deviate belong here. נתן is irregular in its
/// infinitive but perfectly regular in the present (נוֹתֵן), so only the
/// infinitive is listed and everything else still comes from the templates.
const Map<String, String> irregularForms = {
  // אמר Paal: takes a vav where the pe-alef rule gives לֶאֱמֹר.
  'אמר|Paal|Infinitive|inf': 'לוֹמַר',
  // נתן Paal: both nuns drop.
  'נתנ|Paal|Infinitive|inf': 'לָתֵת',
  // הלך Paal: conjugates as though it began with yod.
  'הלכ|Paal|Infinitive|inf': 'לָלֶכֶת',
  // נפל Paal: the nun becomes a yod rather than dropping.
  'נפל|Paal|Infinitive|inf': 'לִיפּוֹל',
};

/// Replaces any slot of [forms] this verb is known to do differently.
Map<String, String> applyIrregulars(
  String root,
  String binyan,
  String tense,
  Map<String, String> forms,
) {
  final bare = normalizeRoot(root);
  return forms.map((person, form) => MapEntry(
      person, irregularForms['$bare|$binyan|$tense|$person'] ?? form));
}
