
const Map<String, String> vowels = {
  'e': 'ֵ',
  'a': 'ַ',
  'i': 'ִ',
  'A': 'ָ',
  '_e': 'ְ',
  'u': 'ֻ',
  'E': 'ֶ'};

/// The dot written inside a letter. Doubles the consonant in the intensive
/// binyanim (dagesh chazak); it also flips בגדכפת from v/kh/f to b/k/p
/// (dagesh kal), which is not handled here.
const String dagesh = 'ּ';

/// Letters that cannot take a dagesh. When one lands where a doubling dagesh
/// belongs, the dot is simply not written.
const Set<String> rejectsDagesh = {'א', 'ה', 'ח', 'ע', 'ר'};

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
    if (finalForm != null) {
      final rewritten = word.replaceRange(i, i + 1, finalForm);
      // A word-final kaf carries a sheva, alone among the final forms:
      // מֶלֶךְ and לְבָרֵךְ, but שָׁלוֹם and בֵּן.
      if (finalForm == 'ך' && !rewritten.substring(i).contains(vowels['_e']!)) {
        return '$rewritten${vowels['_e']}';
      }
      return rewritten;
    }
    if (isHebrewLetter(character)) return word;
  }
  return word;
}

/// Letters that take a dagesh kal, which changes them from v/gh/dh/kh/f/th to
/// b/g/d/k/p/t. Written in base form; a word-final letter is past the point
/// where the rule applies.
const Set<String> _takesDageshKal = {'ב', 'ג', 'ד', 'כ', 'פ', 'ת'};

/// Vowels short enough that a sheva after them closes the syllable.
///
/// Deliberately excludes qamats and tsere: a qamats may be long or short and
/// nothing in the text says which, so the ambiguous cases are left alone rather
/// than guessed at.
final Set<String> _shortVowels = {
  vowels['i']!,
  vowels['a']!,
  vowels['E']!,
  vowels['u']!,
};

/// Splits a pointed word into letters, each carrying its own marks.
List<String> _letterUnits(String word) {
  final units = <String>[];
  for (final character in word.split('')) {
    if (isHebrewLetter(character) || units.isEmpty) {
      units.add(character);
    } else {
      units[units.length - 1] += character;
    }
  }
  return units;
}

/// Adds the dagesh kal that בגדכפת take at the start of a word and after a
/// silent sheva: לִכְתּוֹב, but כּוֹתְבִים keeps its ב bare because the sheva there
/// follows a long vowel and so is mobile.
///
/// A sheva is treated as silent only when the letter before it carries an
/// unambiguously short vowel. Anything less certain is left alone, so the pass
/// under-applies rather than putting a dot where none belongs.
String addDageshKal(String word) {
  final units = _letterUnits(word);

  for (var i = 0; i < units.length; i++) {
    if (!_takesDageshKal.contains(units[i][0])) continue;
    if (units[i].contains(dagesh)) continue;

    final afterSilentSheva = i >= 2 &&
        units[i - 1].contains(vowels['_e']!) &&
        _shortVowels.any(units[i - 2].contains);

    if (i == 0 || afterSilentSheva) units[i] = '${units[i]}$dagesh';
  }

  return units.join();
}
