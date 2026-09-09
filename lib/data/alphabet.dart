
const Map<String, String> vowels = {
  'e': 'ֵ',
  'a': 'ַ',
  'i': 'ִ',
  'A': 'ָ',
  '_e': 'ְ',
  'u': 'ֻ',
  'E': 'ֶ'};

const Map<String, String> letters = {
    "alef": "א",
    "bet": "ב",
    "gimel": "ג",
    "dalet": "ד",
    "he": "ה",
    "vav": "ו",
    "zayin": "ז",
    "het": "ח",
    "tet": "ט",
    "yod": "י",
    "kaf": "כ",
    "kafSofit": "ך",
    "lamed": "ל",
    "mem": "מ",
    "memSofit": "ם",
    "nun": "נ",
    "nunSofit": "ן",
    "samekh": "ס",
    "ayin": "ע",
    "pe": "פ",
    "peSofit": "ף",
    "tsadi": "צ",
    "tsadiSofit": "ץ",
    "qof": "ק",
    "resh": "ר",
    "shin": "ש",
    "tav": "ת"
};

/// Letters that take a different shape at the end of a word.
const Map<String, String> _finalForms = {
  "כ": "ך", // kaf   -> kaf sofit
  "מ": "ם", // mem   -> mem sofit
  "נ": "ן", // nun   -> nun sofit
  "פ": "ף", // pe    -> pe sofit
  "צ": "ץ", // tsadi -> tsadi sofit
};

const Map<String, String> _baseForms = {
  "ך": "כ",
  "ם": "מ",
  "ן": "נ",
  "ף": "פ",
  "ץ": "צ",
};

/// True for the 27 Hebrew consonants (including final forms), false for
/// niqqud, cantillation marks, punctuation and anything non-Hebrew.
bool isHebrewLetter(String character) {
  if (character.isEmpty) return false;
  final code = character.codeUnitAt(0);
  return code >= 0x05D0 && code <= 0x05EA;
}

/// Strips niqqud, spaces and punctuation and rewrites final letters back to
/// their base shape, so a root is always stored as bare consonants.
///
/// This is what makes `root[0]`/`root[1]`/`root[2]` in conjugation.dart safe to
/// index: without it, a root typed with vowel points carries combining marks
/// that count towards `length`.
String normalizeRoot(String root) {
  final buffer = StringBuffer();
  for (final character in root.split('')) {
    if (!isHebrewLetter(character)) continue;
    buffer.write(_baseForms[character] ?? character);
  }
  return buffer.toString();
}

/// Rewrites the last consonant of [word] to its final form where one exists,
/// skipping trailing niqqud. Needed whenever the third radical lands at the end
/// of a generated form, e.g. Paal present of שכנ.
String finalizeWord(String word) {
  for (var i = word.length - 1; i >= 0; i--) {
    final character = word[i];
    final finalForm = _finalForms[character];
    if (finalForm != null) return word.replaceRange(i, i + 1, finalForm);
    if (isHebrewLetter(character)) return word;
  }
  return word;
}
