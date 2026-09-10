/// The Hebrew label for each conjugation slot.
///
/// Keyed by the slot names the engine produces — which are also the `person`
/// values manual corrections are stored under. These are display names only:
/// renaming a key here would orphan every correction saved against the old one.
const Map<String, String> hebrewLabels = {
  // Past and future carry person, so each slot has a pronoun of its own.
  'I': 'אֲנִי',
  'You M': 'אַתָּה',
  'You F': 'אַתְּ',
  'He': 'הוּא',
  'She': 'הִיא',
  'We': 'אֲנַחְנוּ',
  'You M P': 'אַתֶּם',
  'You F P': 'אַתֶּן',
  'They': 'הֵם',

  // The future table has a single plural 'you' covering both genders.
  'You': 'אַתֶּם / אַתֶּן',

  // The present is a participle: it agrees in gender and number but belongs to
  // no particular person — אני כותב and הוא כותב are the same word — so it is
  // labelled the way verb tables label it rather than with a pronoun.
  'S M': 'יָחִיד',
  'S F': 'יְחִידָה',
  'P M': 'רַבִּים',
  'P F': 'רַבּוֹת',

  'inf': 'שֵׁם הַפֹּעַל',
};

/// The Hebrew label for a slot, falling back to the slot name itself so an
/// unmapped key shows something rather than nothing.
String hebrewLabelFor(String person) => hebrewLabels[person] ?? person;
