// ignore_for_file: curly_braces_in_flow_control_structures

import 'alphabet.dart';
import 'gizrah.dart';
import 'irregulars.dart';

/// Every template below is written against three slots. Roots that do not fit
/// them fall back to the bare root rather than throwing.
const int triliteralLength = 3;
const int quadriliteralLength = 4;

/// The intensive binyanim, built on a doubled middle radical.
///
/// That doubling is also why these are the only binyanim taking a four-letter
/// root: the doubled slot holds two consonants instead of one doubled one.
const Set<String> intensiveBinyanim = {'Piel', 'Pual', 'Hitpael'};

/// The same three, named for the rule that cares about root length: טלפן in
/// Paal is a mistake rather than a gap in the rules.
const Set<String> quadriliteralBinyanim = intensiveBinyanim;

bool isSupportedRoot(String root, String binyan) {
  final length = normalizeRoot(root).length;
  if (length == triliteralLength) return true;
  return length == quadriliteralLength &&
      quadriliteralBinyanim.contains(binyan);
}

/// The three slots the templates are written against.
///
/// A four-letter root is not a separate pattern: it behaves like a triliteral
/// whose middle radical is a cluster of two consonants. תרגם therefore fills the
/// same Piel template as דבר, with ר + sheva + ג sitting in the middle slot —
/// which is why four-letter roots need no templates of their own.
List<String> rootSlots(String root) {
  final bare = normalizeRoot(root);
  if (bare.length == quadriliteralLength) {
    return [bare[0], '${bare[1]}${vowels['_e']}${bare[2]}', bare[3]];
  }
  return [bare[0], bare[1], bare[2]];
}

Map<String, String> _finalize(Map<String, String> forms) => forms.map(
    (person, form) => MapEntry(person, addDageshKal(finalizeWord(form))));

Map<String, String> createInfinitive(
  String root,
  String binyan, {
  Gizrah gizrah = Gizrah.automatic,
}) {
  if (!isSupportedRoot(root, binyan)) return {'inf': root};
  return applyIrregulars(root, binyan, 'Infinitive',
      _finalize(_createInfinitive(rootSlots(root), binyan, gizrah)));
}

Map<String, String> conjugatePresent(
  String root,
  String binyan, {
  Gizrah gizrah = Gizrah.automatic,
}) {
  if (!isSupportedRoot(root, binyan)) return {'root': root};
  return applyIrregulars(root, binyan, 'Present',
      _finalize(_conjugatePresent(rootSlots(root), binyan, gizrah)));
}

Map<String, String> conjugatePast(
  String root,
  String binyan, {
  Gizrah gizrah = Gizrah.automatic,
}) {
  if (!isSupportedRoot(root, binyan)) return {'root': root};
  return applyIrregulars(root, binyan, 'Past',
      _finalize(_conjugatePast(rootSlots(root), binyan, gizrah)));
}

Map<String, String> conjugateFuture(
  String root,
  String binyan, {
  Gizrah gizrah = Gizrah.automatic,
}) {
  if (!isSupportedRoot(root, binyan)) return {'root': root};
  return applyIrregulars(root, binyan, 'Future',
      _finalize(_conjugateFuture(rootSlots(root), binyan, gizrah)));
}

/// The Hitpael prefix consonant together with the first radical, written in the
/// order Hebrew actually uses, with [between] left in its own slot.
///
/// When the first radical is a sibilant the two consonants swap places
/// (metathesis), and two of them also change the prefix consonant:
///
///     ס ש   swap only            הִסְתַּדֵּר, הִשְׁתַּתֵּף
///     צ     swap, then ת -> ט    הִצְטַלֵּם
///     ז     swap, then ת -> ד    הִזְדַּקֵּן
///
/// Only the consonants move; the vowels keep their slots. Written against the
/// bare root, so it covers both שׁ and שׂ — normalizeRoot has already dropped the
/// dot that tells them apart.
///
/// Not handled: a first radical of ד, ט or ת, where the prefix assimilates into
/// the radical instead (תמם -> הִתַּמֵּם). Those verbs are rare and the rule was not
/// verified, so they still come out with both consonants written.
String hitpaelOnset(String firstRadical, [String between = '']) {
  if (!_swapsWithPrefix.contains(firstRadical)) {
    return '${letters['tav']}$between$firstRadical';
  }
  return '$firstRadical$between${_prefixBefore[firstRadical] ?? letters['tav']}';
}

/// First radicals that trade places with the prefix.
final Set<String> _swapsWithPrefix = {
  letters['samekh']!,
  letters['shin']!,
  letters['tsadi']!,
  letters['zayin']!,
};

/// What the prefix consonant becomes before a first radical that voices or
/// emphasises it.
final Map<String, String> _prefixBefore = {
  letters['tsadi']!: letters['tet']!,
  letters['zayin']!: letters['dalet']!,
};

/// The middle radical carrying the doubling dagesh of the intensive binyanim.
///
/// Two cases get no dot. א ה ח ע ר cannot take one at all — ה ח ע are simply
/// written undoubled, while א and ר additionally lengthen the vowel before
/// them (לְבָרֵךְ, not לְבַרֵךְ), which is a verified rule this does not yet apply.
/// A four-letter root's middle slot is a two-consonant cluster and is not
/// doubled either; the dagesh seen in תִּרְגֵּם is a dagesh kal, a different rule.
///
/// Takes the following [vowel] so it can emit consonant + vowel + dagesh, which
/// is Unicode canonical order. Appending the dagesh straight after the letter
/// renders the same but does not compare equal to Hebrew text from anywhere
/// else, which would make every vocalised expectation untypable.
/// True for roots whose third radical is ה, which does not survive into most
/// forms: קנה gives לִקְנוֹת, not לִקְנוֹה.
///
/// Unlike pe-yod or pe-nun, this class is fully predictable from the letters —
/// every root ending in ה behaves this way — so it needs nothing stored
/// alongside the word.
bool isLamedHe(List<String> root) => root[2] == letters['he'];

/// Radicals that cannot be doubled and lengthen the vowel before them instead.
///
/// Only these two. ה ח ע also reject the dagesh but are simply written
/// undoubled with the vowel untouched — לְבָרֵךְ takes a qamats where לְנַחֵם keeps
/// its patach.
final Set<String> _compensates = {letters['alef']!, letters['resh']!};

final Map<String, String> _lengthened = {
  vowels['a']!: vowels['A']!, // patach -> qamats
  vowels['i']!: vowels['e']!, // hiriq  -> tsere
};

/// The vowel standing before a middle radical, lengthened when that radical
/// compensates for the doubling it cannot carry.
String lengthenBefore(String middleSlot, String vowel) {
  if (middleSlot.length != 1 || !_compensates.contains(middleSlot)) return vowel;
  return _lengthened[vowel] ?? vowel;
}

String geminate(String middleSlot, String vowel) {
  if (middleSlot.length != 1 || rejectsDagesh.contains(middleSlot)) {
    return '$middleSlot$vowel';
  }
  return '$middleSlot$vowel$dagesh';
}

Map<String, String> _createInfinitive(List<String> root, String binyan, Gizrah gizrah) {

    switch(binyan) {
        case 'Paal':
            if(gizrah == Gizrah.droppingFirst)
                return <String, String> {
                    'inf': "ל${vowels['A']}${root[1]}${vowels['E']}${root[2]}${vowels['E']}ת"
                };
            else if(isLamedHe(root))
                return <String, String> {
                    'inf': "ל${vowels['i']}${root[0]}${vowels['_e']}${root[1]}וֹת"
                };
            else if(root[1] == root[2]) // lasov
                return <String, String> {
                    'inf': "ל${vowels['A']}${root[0]}וֹ${root[1]}"
                };
            else if(root[0] == letters['alef']) // leehov
                return <String, String> {
                    'inf': "ל${vowels['E']}${root[0]}${vowels['E']}${root[1]}וֹ${root[2]}"
                };
            else if(root[1] == letters['yod'] || root[1] == letters['vav']) // lakum
                return <String, String> {
                    'inf': "ל${vowels['A']}${root[0]}${root[1]}${root[2]}"
                };
            else
                return <String, String> {
                    'inf': "ל${vowels['i']}${root[0]}${vowels['_e']}${root[1]}וֹ${root[2]}"
                };
        case 'Piel':
            if(isLamedHe(root))
                return <String, String> {
                    'inf': "ל${vowels['_e']}${root[0]}${lengthenBefore(root[1], vowels['a']!)}${geminate(root[1], '')}וֹת"
                };
            return <String, String> {
                'inf': "ל${vowels['_e']}${root[0]}${lengthenBefore(root[1], vowels['a']!)}${geminate(root[1], vowels['e']!)}${root[2]}"
            };
        case 'Hiphil':
            if(root[0] == letters['nun']) // lehagia
                return <String, String> {
                    'inf': "ל${vowels['_e']}ה${vowels['a']}${root[1]}${vowels['i']}י${root[2]}"
                };
            else if(root[1] == letters['vav'] || root[1] == letters['yod']) // lehavin
                return <String, String> {
                    'inf': "ל${vowels['_e']}ה${vowels['A']}${root[0]}${vowels['i']}י${root[2]}"
                };
            else if(isLamedHe(root))
                return <String, String> {
                    'inf': "ל${vowels['_e']}ה${vowels['a']}${root[0]}${vowels['_e']}${root[1]}וֹת"
                };
            return <String, String> {
                'inf': "ל${vowels['_e']}ה${vowels['a']}${root[0]}${vowels['_e']}${root[1]}${vowels['i']}י${root[2]}"
            };
        case 'Hitpael': 
            if(isLamedHe(root))
                return <String, String> {
                    'inf': "ל${vowels['_e']}ה${vowels['i']}${hitpaelOnset(root[0], vowels['_e']!)}${lengthenBefore(root[1], vowels['a']!)}${geminate(root[1], '')}וֹת"
                };
            return <String, String> {
                'inf': "ל${vowels['_e']}ה${vowels['i']}${hitpaelOnset(root[0], vowels['_e']!)}${lengthenBefore(root[1], vowels['a']!)}${geminate(root[1], vowels['e']!)}${root[2]}"
            };
        case 'Nifal':
            if(isLamedHe(root))
                return <String, String> {
                    'inf': "לְהִי${root[0]}${vowels['A']}${root[1]}וֹת"
                };
            return <String, String> {
                'inf': "לְהִי${root[0]}${vowels['A']}${root[1]}${vowels['e']}${root[2]}"
            };
        case 'Pual':
            return <String, String> {
                'inf': "מְ${root[0]}וּ${geminate(root[1], vowels['A']!)}${root[2]}"
            };
        case 'Hufal':
            return <String, String> {
                'inf': "מוּ${root[0]}${vowels['_e']}${root[1]}${vowels['A']}${root[2]}"
            };
        default:
            return {
                'inf': root.join()
            };
    }
}

Map<String, String> _conjugatePresent(List<String> root, String binyan, Gizrah gizrah) {

    switch(binyan) {
        case 'Paal':
            if(isLamedHe(root))
                return <String, String> {
                    'S M': '${root[0]}וֹ${root[1]}${vowels['E']}ה',
                    'S F': '${root[0]}וֹ${root[1]}${vowels['A']}ה',
                    'P M': '${root[0]}וֹ${root[1]}${vowels['i']}ים',
                    'P F': '${root[0]}וֹ${root[1]}וֹת'
                };
            else if(root[1] == letters['yod'] || root[1] == letters['vav'])
                return <String, String> {
                    'S M': "${root[0]}${vowels['A']}${root[2]}",
                    'S F': '${root[0]}${vowels['A']}${root[2]}${vowels['A']}ה',
                    'P M': '${root[0]}${vowels['A']}${root[2]}${vowels['i']}ים',
                    'P F': '${root[0]}${vowels['A']}${root[2]}וֹת'
                }; 
            else
                return <String, String> {
                    'S M': '${root[0]}וֹ${root[1]}${vowels['e']}${root[2]}', //e
                    'S F': '${root[0]}וֹ${root[1]}${vowels['E']}${root[2]}${vowels['E']}ת',
                    'P M': '${root[0]}וֹ${root[1]}${vowels['_e']}${root[2]}${vowels['i']}ים',
                    'P F': '${root[0]}וֹ${root[1]}${vowels['_e']}${root[2]}וֹת'
                }; // divide in 3, check root length maybe?
        case 'Piel':
            return <String, String> {
                'S M': 'מְ${root[0]}${lengthenBefore(root[1], vowels['a']!)}${geminate(root[1], vowels['e']!)}${root[2]}', //ae
                'S F': 'מְ${root[0]}${lengthenBefore(root[1], vowels['a']!)}${geminate(root[1], vowels['E']!)}${root[2]}${vowels['E']}ת',
                'P M': 'מְ${root[0]}${lengthenBefore(root[1], vowels['a']!)}${geminate(root[1], vowels['_e']!)}${root[2]}${vowels['i']}ים',
                'P F': 'מְ${root[0]}${lengthenBefore(root[1], vowels['a']!)}${geminate(root[1], vowels['_e']!)}${root[2]}וֹת'
            };
        case 'Hiphil':
            return <String, String> {
                'S M': 'מַ${root[0]}${vowels['_e']}${root[1]}${vowels['i']}י${root[2]}', // i
                'S F': 'מַ${root[0]}${vowels['_e']}${root[1]}${vowels['i']}י${root[2]}${vowels['A']}ה',
                'P M': 'מַ${root[0]}${vowels['_e']}${root[1]}${vowels['i']}י${root[2]}${vowels['i']}ים',
                'P F': 'מַ${root[0]}${vowels['_e']}${root[1]}${vowels['i']}י${root[2]}וֹת'
            };
        case 'Hitpael': 
            return <String, String> {
                'S M': 'מ${vowels['i']}${hitpaelOnset(root[0], vowels['_e']!)}${lengthenBefore(root[1], vowels['a']!)}${geminate(root[1], vowels['e']!)}${root[2]}', //ae
                'S F': 'מ${vowels['i']}${hitpaelOnset(root[0], vowels['_e']!)}${lengthenBefore(root[1], vowels['a']!)}${geminate(root[1], vowels['E']!)}${root[2]}${vowels['E']}ת',
                'P M': 'מ${vowels['i']}${hitpaelOnset(root[0], vowels['_e']!)}${lengthenBefore(root[1], vowels['a']!)}${geminate(root[1], vowels['_e']!)}${root[2]}${vowels['i']}ים',
                'P F': 'מ${vowels['i']}${hitpaelOnset(root[0], vowels['_e']!)}${lengthenBefore(root[1], vowels['a']!)}${geminate(root[1], vowels['_e']!)}${root[2]}וֹת'
            };
        case 'Nifal':
            return <String, String> {
                'S M': 'נִ${root[0]}${root[1]}${vowels['A']}${root[2]}',
                'S F': 'נִ${root[0]}${root[1]}${vowels['E']}${root[2]}${vowels['E']}ת',
                'P M': 'נִ${root[0]}${root[1]}${vowels['A']}${root[2]}${vowels['i']}ים',
                'P F': 'נִ${root[0]}${root[1]}${vowels['A']}${root[2]}וֹת'
            };
        case 'Pual':
            return <String, String> {
                'S M': 'מְ${root[0]}${vowels['u']}${geminate(root[1], vowels['A']!)}${root[2]}', 
                'S F': 'מְ${root[0]}${vowels['u']}${geminate(root[1], vowels['E']!)}${root[2]}${vowels['E']}ת',
                'P M': 'מְ${root[0]}${vowels['u']}${geminate(root[1], vowels['A']!)}${root[2]}${vowels['i']}ים',
                'P F': 'מְ${root[0]}${vowels['u']}${geminate(root[1], vowels['A']!)}${root[2]}וֹת'
            };
        case 'Hufal':
            return <String, String> {
                'S M': 'מוּ${root[0]}${vowels['_e']}${root[1]}${vowels['A']}${root[2]}',
                'S F': 'מוּ${root[0]}${vowels['_e']}${root[1]}${vowels['A']}${root[2]}${vowels['E']}ת',
                'P M': 'מוּ${root[0]}${vowels['_e']}${root[1]}${vowels['A']}${root[2]}${vowels['i']}ים',
                'P F': 'מוּ${root[0]}${vowels['_e']}${root[1]}${vowels['A']}${root[2]}וֹת'
            };
        default:
          return <String, String> {'root': root.join()};
      }
}

Map<String, String> _conjugatePast(List<String> root, String binyan, Gizrah gizrah) {
    
    switch (binyan) {
        case 'Paal':
            if(isLamedHe(root))
                return <String, String> {
                    'I': '${root[0]}${vowels['A']}${root[1]}${vowels['i']}ית${vowels['i']}י',
                    'You F': '${root[0]}${vowels['A']}${root[1]}${vowels['i']}ית',
                    'You M': '${root[0]}${vowels['A']}${root[1]}${vowels['i']}ית${vowels['A']}',
                    'He': '${root[0]}${vowels['A']}${root[1]}${vowels['A']}ה',
                    'She': '${root[0]}${vowels['A']}${root[1]}${vowels['_e']}ת${vowels['A']}ה',
                    'We': '${root[0]}${vowels['A']}${root[1]}${vowels['i']}ינוּ',
                    'You M P': '${root[0]}${vowels['_e']}${root[1]}${vowels['i']}ית${vowels['E']}ם',
                    'You F P': '${root[0]}${vowels['_e']}${root[1]}${vowels['i']}ית${vowels['E']}ן',
                    'They': '${root[0]}${vowels['A']}${root[1]}וּ'
                };
            else if(root[1] == letters['yod'] || root[1] == letters['vav'])
                return <String, String> {
                    'I': '${root[0]}${vowels['A']}${root[2]}${vowels['_e']}ת${vowels['i']}י',
                    'You F': '${root[0]}${vowels['A']}${root[2]}${vowels['_e']}ת',
                    'You M': '${root[0]}${vowels['A']}${root[2]}${vowels['_e']}ת${vowels['A']}',
                    'He': '${root[0]}${vowels['A']}${root[2]}',
                    'She': '${root[0]}${vowels['A']}${root[2]}${vowels['A']}ה',
                    'We': '${root[0]}${vowels['A']}${root[2]}${vowels['_e']}נוּ',
                    'You M P': '${root[0]}${vowels['A']}${root[2]}${vowels['_e']}ת${vowels['E']}ם',
                    'You F P': '${root[0]}${vowels['A']}${root[2]}${vowels['_e']}ת${vowels['E']}ן',
                    'They': '${root[0]}${vowels['A']}${root[2]}וּ'
                };
            else
                return <String, String> {
                    'I': '${root[0]}${vowels['A']}${root[1]}${vowels['a']}${root[2]}${vowels['_e']}ת${vowels['i']}י',
                    'You F': '${root[0]}${vowels['A']}${root[1]}${vowels['a']}${root[2]}${vowels['_e']}ת',
                    'You M': '${root[0]}${vowels['A']}${root[1]}${vowels['a']}${root[2]}${vowels['_e']}ת${vowels['A']}',
                    'He': '${root[0]}${vowels['A']}${root[1]}${vowels['a']}${root[2]}',
                    'She': '${root[0]}${vowels['A']}${root[1]}${vowels['_e']}${root[2]}${vowels['A']}ה',
                    'We': '${root[0]}${vowels['A']}${root[1]}${vowels['a']}${root[2]}${vowels['_e']}נוּ',
                    'You M P': '${root[0]}${vowels['_e']}${root[1]}${vowels['a']}${root[2]}${vowels['_e']}ת${vowels['E']}ם',
                    'You F P': '${root[0]}${vowels['_e']}${root[1]}${vowels['a']}${root[2]}${vowels['_e']}ת${vowels['E']}ן',
                    'They': '${root[0]}${vowels['A']}${root[1]}${vowels['_e']}${root[2]}וּ'
                };
        case 'Piel':
            return <String, String> {
                'I': '${root[0]}${vowels['i']}י${geminate(root[1], vowels['a']!)}${root[2]}${vowels['_e']}ת${vowels['i']}י',
                'You F': '${root[0]}${vowels['i']}י${geminate(root[1], vowels['a']!)}${root[2]}${vowels['_e']}ת${vowels['_e']}',
                'You M': '${root[0]}${vowels['i']}י${geminate(root[1], vowels['a']!)}${root[2]}${vowels['_e']}ת${vowels['A']}',
                'He': '${root[0]}${vowels['i']}י${geminate(root[1], vowels['e']!)}${root[2]}',
                'She': '${root[0]}${vowels['i']}י${geminate(root[1], vowels['_e']!)}${root[2]}${vowels['A']}ה',
                'We': '${root[0]}${vowels['i']}י${geminate(root[1], vowels['a']!)}${root[2]}${vowels['_e']}נוּ',
                'You M P': '${root[0]}${vowels['i']}י${geminate(root[1], vowels['a']!)}${root[2]}${vowels['_e']}ת${vowels['E']}ם',
                'You F P': '${root[0]}${vowels['i']}י${geminate(root[1], vowels['a']!)}${root[2]}${vowels['_e']}ת${vowels['E']}ן',
                'They': '${root[0]}${vowels['i']}י${geminate(root[1], vowels['_e']!)}${root[2]}וּ'
            };
        case 'Hiphil':
            return <String, String> {
                'I': 'הִ${root[0]}${vowels['_e']}${root[1]}${vowels['e']}${root[2]}ת${vowels['i']}י',
                'You F': 'הִ${root[0]}${vowels['_e']}${root[1]}${vowels['e']}${root[2]}ת',
                'You M': 'הִ${root[0]}${vowels['_e']}${root[1]}${vowels['e']}${root[2]}ת${vowels['A']}ה',
                'He': 'הִ${root[0]}${vowels['_e']}${root[1]}${vowels['i']}י${root[2]}',
                'She': 'הִ${root[0]}${vowels['_e']}${root[1]}${vowels['i']}י${root[2]}${vowels['A']}ה',
                'We': 'הִ${root[0]}${vowels['_e']}${root[1]}${vowels['e']}${root[2]}נוּ',
                'You M P': 'הִ${root[0]}${vowels['_e']}${root[1]}${vowels['e']}${root[2]}ת${vowels['E']}ם',
                'You F P': 'הִ${root[0]}${vowels['_e']}${root[1]}${vowels['e']}${root[2]}ת${vowels['E']}ן',
                'They': 'הִ${root[0]}${vowels['_e']}${root[1]}${vowels['i']}י${root[2]}וּ' 

            };
        case 'Hitpael':
            return <String, String> {
                'I': 'הִ${hitpaelOnset(root[0], vowels['_e']!)}${lengthenBefore(root[1], vowels['a']!)}${geminate(root[1], vowels['a']!)}${root[2]}${vowels['_e']}ת${vowels['i']}י',
                'You F': 'הִ${hitpaelOnset(root[0], vowels['_e']!)}${lengthenBefore(root[1], vowels['a']!)}${geminate(root[1], vowels['a']!)}${root[2]}${vowels['_e']}ת${vowels['_e']}',
                'You M': 'הִ${hitpaelOnset(root[0], vowels['_e']!)}${lengthenBefore(root[1], vowels['a']!)}${geminate(root[1], vowels['a']!)}${root[2]}${vowels['_e']}ת${vowels['A']}',
                'He': 'הִ${hitpaelOnset(root[0], vowels['_e']!)}${lengthenBefore(root[1], vowels['a']!)}${geminate(root[1], vowels['e']!)}${root[2]}',
                'She': 'הִ${hitpaelOnset(root[0], vowels['_e']!)}${vowels['_e']}${geminate(root[1], vowels['a']!)}${root[2]}${vowels['A']}ה',
                'We': 'הִ${hitpaelOnset(root[0], vowels['_e']!)}${lengthenBefore(root[1], vowels['a']!)}${geminate(root[1], vowels['a']!)}${root[2]}${vowels['_e']}נוּ',
                'You M P': 'הִ${hitpaelOnset(root[0], vowels['_e']!)}${lengthenBefore(root[1], vowels['a']!)}${geminate(root[1], vowels['a']!)}${root[2]}${vowels['_e']}ת${vowels['E']}ם',
                'You F P': 'הִ${hitpaelOnset(root[0], vowels['_e']!)}${lengthenBefore(root[1], vowels['a']!)}${geminate(root[1], vowels['a']!)}${root[2]}${vowels['_e']}ת${vowels['E']}ן',
                'They': 'הִ${hitpaelOnset(root[0], vowels['_e']!)}${lengthenBefore(root[1], vowels['a']!)}${geminate(root[1], vowels['_e']!)}${root[2]}וּ'
            };
        case 'Nifal':
            return <String, String> {
                'I': 'נִ${root[0]}${vowels['_e']}${root[1]}${vowels['a']}${root[2]}${vowels['_e']}ת${vowels['i']}י',
                'You F': 'נִ${root[0]}${vowels['_e']}${root[1]}${vowels['a']}${root[2]}${vowels['_e']}ת${vowels['_e']}',
                'You M': 'נִ${root[0]}${vowels['_e']}${root[1]}${vowels['a']}${root[2]}${vowels['_e']}ת${vowels['A']}',
                'He': 'נִ${root[0]}${vowels['_e']}${root[1]}${vowels['a']}${root[2]}',
                'She': 'נִ${root[0]}${vowels['_e']}${root[1]}${vowels['_e']}${root[2]}${vowels['A']}ה',
                'We': 'נִ${root[0]}${vowels['_e']}${root[1]}${vowels['a']}${root[2]}${vowels['_e']}נוּ',
                'You M P': 'נִ${root[0]}${vowels['_e']}${root[1]}${vowels['a']}${root[2]}${vowels['_e']}ת${vowels['E']}ם',
                'You F P': 'נִ${root[0]}${vowels['_e']}${root[1]}${vowels['a']}${root[2]}${vowels['_e']}ת${vowels['E']}ן',
                'They': 'נִ${root[0]}${vowels['_e']}${root[1]}${vowels['_e']}${root[2]}וּ'
            };
        case 'Pual':
            return <String, String> {
                'I': '${root[0]}${vowels['u']}${geminate(root[1], vowels['a']!)}${root[2]}${vowels['_e']}ת${vowels['i']}י',
                'You F': '${root[0]}${vowels['u']}${geminate(root[1], vowels['a']!)}${root[2]}${vowels['_e']}ת${vowels['_e']}',
                'You M': '${root[0]}${vowels['u']}${geminate(root[1], vowels['a']!)}${root[2]}${vowels['_e']}ת${vowels['A']}',
                'He': '${root[0]}${vowels['u']}${geminate(root[1], vowels['a']!)}${root[2]}',
                'She': '${root[0]}${vowels['u']}${geminate(root[1], '')}${root[2]}${vowels['A']}ה',
                'We': '${root[0]}${vowels['u']}${geminate(root[1], vowels['a']!)}${root[2]}${vowels['_e']}נוּ',
                'You M P': '${root[0]}${vowels['u']}${geminate(root[1], vowels['a']!)}${root[2]}${vowels['_e']}ת${vowels['E']}ם',
                'You F P': '${root[0]}${vowels['u']}${geminate(root[1], vowels['a']!)}${root[2]}${vowels['_e']}ת${vowels['E']}ן',
                'They': '${root[0]}${vowels['u']}${geminate(root[1], vowels['_e']!)}${root[2]}וּ'
            };
        case 'Hufal':
            return <String, String> {
                'I': 'הֻ${root[0]}${vowels['_e']}${root[1]}${vowels['a']}${root[2]}ת${vowels['i']}י',
                'You F': 'הֻ${root[0]}${vowels['_e']}${root[1]}${vowels['a']}${root[2]}${vowels['_e']}ת${vowels['_e']}',
                'You M': 'הֻ${root[0]}${vowels['_e']}${root[1]}${vowels['a']}${root[2]}${vowels['_e']}ת${vowels['A']}',
                'He': 'הֻ${root[0]}${vowels['_e']}${root[1]}${vowels['a']}${root[2]}',
                'She': 'הֻ${root[0]}${vowels['_e']}${root[1]}${vowels['a']}${root[2]}${vowels['A']}ה',
                'We': 'הֻ${root[0]}${vowels['_e']}${root[1]}${vowels['a']}${root[2]}${vowels['_e']}נוּ',
                'You M P': 'הֻ${root[0]}${vowels['_e']}${root[1]}${vowels['a']}${root[2]}${vowels['_e']}ת${vowels['E']}ם',
                'You F P': 'הֻ${root[0]}${vowels['_e']}${root[1]}${vowels['a']}${root[2]}${vowels['_e']}ת${vowels['E']}ן',
                'They': 'הֻ${root[0]}${vowels['_e']}${root[1]}${vowels['a']}${root[2]}וּ'
            };
        default:
            return {'root': root.join()};
    }
}

Map<String, String> _conjugateFuture(List<String> root, String binyan, Gizrah gizrah) {

    switch(binyan) {
        case 'Paal':
            if(isLamedHe(root))
                return <String, String> {
                    'I': 'אֶ${root[0]}${vowels['_e']}${root[1]}${vowels['E']}ה',
                    'We': 'נִ${root[0]}${vowels['_e']}${root[1]}${vowels['E']}ה',
                    'You M': 'תִּ${root[0]}${vowels['_e']}${root[1]}${vowels['E']}ה',
                    'You F': 'תִּ${root[0]}${vowels['_e']}${root[1]}${vowels['i']}י',
                    'You': 'תִּ${root[0]}${vowels['_e']}${root[1]}וּ',
                    'He': 'יִ${root[0]}${vowels['_e']}${root[1]}${vowels['E']}ה',
                    'She': 'תִּ${root[0]}${vowels['_e']}${root[1]}${vowels['E']}ה',
                    'They': 'יִ${root[0]}${vowels['_e']}${root[1]}וּ'
                };
            else if(root[1] == letters['vav'])
                return <String, String> {
                    'I': 'אָ${root[0]}וּ${root[2]}',
                    'We': 'נָ${root[0]}וּ${root[2]}',
                    'You M': 'תָּ${root[0]}וּ${root[2]}',
                    'You F': 'תָּ${root[0]}וּ${root[2]}י',
                    'You': 'תָּ${root[0]}וּ${root[2]}וּ',
                    'He': 'יָ${root[0]}וּ${root[2]}',
                    'She': 'תָּ${root[0]}וּ${root[2]}',
                    'They': 'יָ${root[0]}וּ${root[2]}וּ'
                };
            else if(root[1] == letters['yod'])
                return <String, String> {
                    'I': 'אָ${root[0]}${vowels['i']}${root[1]}${root[2]}',
                    'We': 'נָ${root[0]}${vowels['i']}${root[1]}${root[2]}',
                    'You M': 'תָּ${root[0]}${vowels['i']}${root[1]}${root[2]}',
                    'You F': 'תָּ${root[0]}${vowels['i']}${root[1]}${root[2]}י',
                    'You': 'תָּ${root[0]}${vowels['i']}${root[1]}${root[2]}וּ',
                    'He': 'יָ${root[0]}${vowels['i']}${root[1]}${root[2]}',
                    'She': 'תָּ${root[0]}${vowels['i']}${root[1]}${root[2]}',
                    'They': 'יָ${root[0]}${vowels['i']}${root[1]}${root[2]}וּ'
                };
            else
                return <String, String> {
                    'I': 'אֶ${root[0]}${vowels['_e']}${root[1]}וֹ${root[2]}',
                    'We': 'נִ${root[0]}${vowels['_e']}${root[1]}וֹ${root[2]}',
                    'You M': 'תִּ${root[0]}${vowels['_e']}${root[1]}וֹ${root[2]}',
                    'You F': 'תִּ${root[0]}${vowels['_e']}${root[1]}וֹ${root[2]}י',
                    'You': 'תִּ${root[0]}${vowels['_e']}${root[1]}וֹ${root[2]}וּ',
                    'He': 'יִ${root[0]}${vowels['_e']}${root[1]}וֹ${root[2]}',
                    'She': 'תִּ${root[0]}${vowels['_e']}${root[1]}וֹ${root[2]}',
                    'They': 'יִ${root[0]}${vowels['_e']}${root[1]}${vowels['_e']}${root[2]}וּ'
                };
        case 'Piel':
            return <String, String> {
                'I': 'אֲ${root[0]}${lengthenBefore(root[1], vowels['a']!)}${geminate(root[1], vowels['e']!)}${root[2]}',
                'We': 'נְ${root[0]}${lengthenBefore(root[1], vowels['a']!)}${geminate(root[1], vowels['e']!)}${root[2]}',
                'You M': 'תְּ${root[0]}${lengthenBefore(root[1], vowels['a']!)}${geminate(root[1], vowels['e']!)}${root[2]}',
                'You F': 'תְּ${root[0]}${lengthenBefore(root[1], vowels['a']!)}${geminate(root[1], '')}${root[2]}י',
                'You': 'תְּ${root[0]}${lengthenBefore(root[1], vowels['a']!)}${geminate(root[1], '')}${root[2]}וּ',
                'He': 'יְ${root[0]}${lengthenBefore(root[1], vowels['a']!)}${geminate(root[1], vowels['e']!)}${root[2]}',
                'She': 'תְּ${root[0]}${lengthenBefore(root[1], vowels['a']!)}${geminate(root[1], vowels['e']!)}${root[2]}',
                'They': 'יְ${root[0]}${lengthenBefore(root[1], vowels['a']!)}${geminate(root[1], '')}${root[2]}וּ'
            };
        case 'Hiphil':
            return <String, String> {
                'I': 'אַ${root[0]}${root[1]}${vowels['i']}י${root[2]}',
                'We': 'נַ${root[0]}${root[1]}${vowels['i']}י${root[2]}',
                'You M': 'תַּ${root[0]}${root[1]}${vowels['i']}י${root[2]}',
                'You F': 'תַּ${root[0]}${root[1]}${vowels['i']}י${root[2]}${vowels['i']}י',
                'You': 'תַּ${root[0]}${root[1]}${vowels['i']}י${root[2]}וּ',
                'He': 'יַ${root[0]}${root[1]}${vowels['i']}י${root[2]}',
                'She': 'תַּ${root[0]}${root[1]}${vowels['i']}י${root[2]}',
                'They': 'יַ${root[0]}${root[1]}${vowels['i']}י${root[2]}וּ'
            };
        case 'Hitpael':
            return <String, String> {
                'I': 'אֶ${hitpaelOnset(root[0], vowels['_e']!)}${lengthenBefore(root[1], vowels['a']!)}${geminate(root[1], vowels['e']!)}${root[2]}',
                'We': 'נִ${hitpaelOnset(root[0], vowels['_e']!)}${lengthenBefore(root[1], vowels['a']!)}${geminate(root[1], vowels['e']!)}${root[2]}',
                'You M': 'תִּ${hitpaelOnset(root[0], vowels['_e']!)}${lengthenBefore(root[1], vowels['a']!)}${geminate(root[1], vowels['e']!)}${root[2]}',
                'You F': 'תִּ${hitpaelOnset(root[0], vowels['_e']!)}${lengthenBefore(root[1], vowels['a']!)}${geminate(root[1], '')}${root[2]}${vowels['i']}י',
                'You': 'תִּ${hitpaelOnset(root[0], vowels['_e']!)}${lengthenBefore(root[1], vowels['a']!)}${geminate(root[1], '')}${root[2]}וּ',
                'He': 'יִ${hitpaelOnset(root[0], vowels['_e']!)}${lengthenBefore(root[1], vowels['a']!)}${geminate(root[1], vowels['e']!)}${root[2]}',
                'She': 'תִּ${hitpaelOnset(root[0], vowels['_e']!)}${lengthenBefore(root[1], vowels['a']!)}${geminate(root[1], vowels['e']!)}${root[2]}',
                'They': 'יִ${hitpaelOnset(root[0], vowels['_e']!)}${lengthenBefore(root[1], vowels['a']!)}${geminate(root[1], '')}${root[2]}וּ'
            };
        case 'Nifal':
            return <String, String> {
                'I': 'אֶ${root[0]}${vowels['A']}${root[1]}${vowels['e']}${root[2]}',
                'We': 'נִ${root[0]}${vowels['A']}${root[1]}${vowels['e']}${root[2]}',
                'You F': 'תִּ${root[0]}${vowels['A']}${root[1]}${vowels['_e']}${root[2]}${vowels['i']}י',
                'You M': 'תִּ${root[0]}${vowels['A']}${root[1]}${vowels['e']}${root[2]}',
                'You': 'תִּ${root[0]}${vowels['A']}${root[1]}${vowels['_e']}${root[2]}וּ',
                'He': 'יִ${root[0]}${vowels['A']}${root[1]}${vowels['e']}${root[2]}',
                'She': 'תִּ${root[0]}${vowels['A']}${root[1]}${vowels['e']}${root[2]}',
                'They': 'יִ${root[0]}${vowels['A']}${root[1]}${vowels['e']}${root[2]}וּ'
            };
        case 'Pual':
            return <String, String> {
                'I': 'אֲ${root[0]}${vowels['u']}${geminate(root[1], vowels['A']!)}${root[2]}',
                'We': 'נְ${root[0]}${vowels['u']}${geminate(root[1], vowels['A']!)}${root[2]}',
                'You F': 'תְּ${root[0]}${vowels['u']}${geminate(root[1], vowels['_e']!)}${root[2]}${vowels['i']}י',
                'You M': 'תְּ${root[0]}${vowels['u']}${geminate(root[1], vowels['A']!)}${root[2]}',
                'You': 'תְּ${root[0]}${vowels['u']}${geminate(root[1], vowels['_e']!)}${root[2]}וּ',
                'He': 'יְ${root[0]}${vowels['u']}${geminate(root[1], vowels['A']!)}${root[2]}',
                'She': 'תְּ${root[0]}${vowels['u']}${geminate(root[1], vowels['A']!)}${root[2]}',
                'They': 'יְ${root[0]}${vowels['u']}${geminate(root[1], vowels['_e']!)}${root[2]}וּ'
            };
        case 'Hufal':
            return <String, String> {
                'I': 'אֻ${root[0]}${vowels['_e']}${root[1]}${vowels['A']}${root[2]}',
                'We': 'נֻ${root[0]}${vowels['_e']}${root[1]}${vowels['A']}${root[2]}',
                'You F': 'תֻּ${root[0]}${vowels['_e']}${root[1]}${vowels['_e']}${root[2]}${vowels['i']}י',
                'You M': 'תֻּ${root[0]}${vowels['_e']}${root[1]}${vowels['A']}${root[2]}',
                'You': 'תֻּ${root[0]}${vowels['_e']}${root[1]}${vowels['_e']}${root[2]}וּ',
                'He': 'יֻ${root[0]}${vowels['_e']}${root[1]}${vowels['A']}${root[2]}',
                'She': 'תֻּ${root[0]}${vowels['_e']}${root[1]}${vowels['A']}${root[2]}',
                'They': 'יֻ${root[0]}${vowels['_e']}${root[1]}${vowels['_e']}${root[2]}וּ'
            };
        default:
            return {'root': root.join()};
    }
}