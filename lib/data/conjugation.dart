// ignore_for_file: curly_braces_in_flow_control_structures

import 'alphabet.dart';

/// Every template below indexes root[0], root[1] and root[2] directly, so only
/// triliteral roots can be conjugated. Quadriliterals (תרגם, טלפן) are not
/// supported yet and fall back to the bare root instead of throwing.
const int rootLength = 3;

bool isSupportedRoot(String root) => normalizeRoot(root).length == rootLength;

Map<String, String> _finalize(Map<String, String> forms) =>
    forms.map((person, form) => MapEntry(person, finalizeWord(form)));

Map<String, String> createInfinitive(String root, String binyan) {
  if (!isSupportedRoot(root)) return {'inf': root};
  return _finalize(_createInfinitive(normalizeRoot(root), binyan));
}

Map<String, String> conjugatePresent(String root, String binyan) {
  if (!isSupportedRoot(root)) return {'root': root};
  return _finalize(_conjugatePresent(normalizeRoot(root), binyan));
}

Map<String, String> conjugatePast(String root, String binyan) {
  if (!isSupportedRoot(root)) return {'root': root};
  return _finalize(_conjugatePast(normalizeRoot(root), binyan));
}

Map<String, String> conjugateFuture(String root, String binyan) {
  if (!isSupportedRoot(root)) return {'root': root};
  return _finalize(_conjugateFuture(normalizeRoot(root), binyan));
}

Map<String, String> _createInfinitive(String root, String binyan) {

    switch(binyan) {
        case 'Paal':
            if(root[0] == letters['alef']) // leehov
                return <String, String> {
                    'inf': "ל${vowels['E']}${root[0]}${vowels['E']}${root[1]}וֹ${root[2]}"
                };
            else if(root[1] == letters['yod'] || root[1] == letters['vav']) // lakum
                return <String, String> {
                    'inf': "ל${vowels['A']}${root[0]}${root[1]}${root[2]}"
                };
            else
                return <String, String> {
                    'inf': "ל${vowels['i']}${root[0]}${root[1]}וֹ${root[2]}"
                };
        case 'Piel':
            return <String, String> {
                'inf': "ל${vowels['e']}${root[0]}${vowels['a']}${root[1]}${vowels['e']}${root[2]}"
            };
        case 'Hiphil':
            return <String, String> {
                'inf': "לה${vowels['a']}${root[0]}${vowels['a']}${root[1]}${vowels['i']}י${root[2]}"
            };
        case 'Hitpael': 
            return <String, String> {
                'inf': "לה${vowels['i']}ת${root[0]}${vowels['a']}${root[1]}${vowels['e']}${root[2]}"
            };
        case 'Nifal':
            return <String, String> {
                'inf': "לְהִ${root[0]}${vowels['A']}${root[1]}${vowels['e']}${root[2]}"
            };
        case 'Pual':
            return <String, String> {
                'inf': "מְ${root[0]}${vowels['u']}${root[1]}${vowels['A']}${root[2]}"
            };
        case 'Hufal':
            return <String, String> {
                'inf': "מוּ${root[0]}${vowels['_e']}${root[1]}${vowels['A']}${root[2]}"
            };
        default:
            return {
                'inf': root
            };
    }
}

Map<String, String> _conjugatePresent(String root, String binyan) {

    switch(binyan) {
        case 'Paal':
            if(root[1] == letters['yod'] || root[1] == letters['vav'])
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
                'S M': 'מְ${root[0]}${vowels['a']}${root[1]}${vowels['e']}${root[2]}', //ae
                'S F': 'מְ${root[0]}${vowels['a']}${root[1]}${vowels['E']}${root[2]}${vowels['E']}ת',
                'P M': 'מְ${root[0]}${vowels['a']}${root[1]}${vowels['_e']}${root[2]}${vowels['i']}ים',
                'P F': 'מְ${root[0]}${vowels['a']}${root[1]}${vowels['_e']}${root[2]}וֹת'
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
                'S M': 'מ${vowels['i']}ת${vowels['_e']}${root[0]}${vowels['a']}${root[1]}${vowels['e']}${root[2]}', //ae
                'S F': 'מ${vowels['i']}ת${vowels['_e']}${root[0]}${vowels['a']}${root[1]}${vowels['E']}${root[2]}${vowels['E']}ת',
                'P M': 'מ${vowels['i']}ת${vowels['_e']}${root[0]}${vowels['a']}${root[1]}${vowels['_e']}${root[2]}${vowels['i']}ים',
                'P F': 'מ${vowels['i']}ת${vowels['_e']}${root[0]}${vowels['a']}${root[1]}${vowels['_e']}${root[2]}וֹת'
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
                'S M': 'מְ${root[0]}${vowels['u']}${root[1]}${vowels['A']}${root[2]}', 
                'S F': 'מְ${root[0]}${vowels['u']}${root[1]}${vowels['E']}${root[2]}${vowels['E']}ת',
                'P M': 'מְ${root[0]}${vowels['u']}${root[1]}${vowels['A']}${root[2]}${vowels['i']}ים',
                'P F': 'מְ${root[0]}${vowels['u']}${root[1]}${vowels['A']}${root[2]}וֹת'
            };
        case 'Hufal':
            return <String, String> {
                'S M': 'מוּ${root[0]}${vowels['_e']}${root[1]}${vowels['A']}${root[2]}',
                'S F': 'מוּ${root[0]}${vowels['_e']}${root[1]}${vowels['A']}${root[2]}${vowels['E']}ת',
                'P M': 'מוּ${root[0]}${vowels['_e']}${root[1]}${vowels['A']}${root[2]}${vowels['i']}ים',
                'P F': 'מוּ${root[0]}${vowels['_e']}${root[1]}${vowels['A']}${root[2]}וֹת'
            };
        default:
          return <String, String> {'root': root};
      }
}

Map<String, String> _conjugatePast(String root, String binyan) {
    
    switch (binyan) {
        case 'Paal':
            if(root[1] == letters['yod'] || root[1] == letters['vav'])
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
                'I': '${root[0]}${vowels['i']}י${root[1]}${vowels['a']}${root[2]}${vowels['_e']}ת${vowels['i']}י',
                'You F': '${root[0]}${vowels['i']}י${root[1]}${vowels['a']}${root[2]}${vowels['_e']}ת${vowels['_e']}',
                'You M': '${root[0]}${vowels['i']}י${root[1]}${vowels['a']}${root[2]}${vowels['_e']}ת${vowels['A']}',
                'He': '${root[0]}${vowels['i']}י${root[1]}${vowels['e']}${root[2]}',
                'She': '${root[0]}${vowels['i']}י${root[1]}${vowels['_e']}${root[2]}${vowels['A']}ה',
                'We': '${root[0]}${vowels['i']}י${root[1]}${vowels['a']}${root[2]}${vowels['_e']}נוּ',
                'You M P': '${root[0]}${vowels['i']}י${root[1]}${vowels['a']}${root[2]}${vowels['_e']}ת${vowels['E']}ם',
                'You F P': '${root[0]}${vowels['i']}י${root[1]}${vowels['a']}${root[2]}${vowels['_e']}ת${vowels['E']}ן',
                'They': '${root[0]}${vowels['i']}י${root[1]}${vowels['_e']}${root[2]}וּ'
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
                'I': 'הִת${root[0]}${vowels['a']}${root[1]}${vowels['a']}${root[2]}${vowels['_e']}ת${vowels['i']}י',
                'You F': 'הִת${root[0]}${vowels['a']}${root[1]}${vowels['a']}${root[2]}${vowels['_e']}ת${vowels['_e']}',
                'You M': 'הִת${root[0]}${vowels['a']}${root[1]}${vowels['a']}${root[2]}${vowels['_e']}ת${vowels['A']}',
                'He': 'הִת${root[0]}${vowels['a']}${root[1]}${vowels['e']}${root[2]}',
                'She': 'הִת${root[0]}${vowels['_e']}${root[1]}${vowels['a']}${root[2]}${vowels['A']}ה',
                'We': 'הִת${root[0]}${vowels['a']}${root[1]}${vowels['a']}${root[2]}${vowels['_e']}נוּ',
                'You M P': 'הִת${root[0]}${vowels['a']}${root[1]}${vowels['a']}${root[2]}${vowels['_e']}ת${vowels['E']}ם',
                'You F P': 'הִת${root[0]}${vowels['a']}${root[1]}${vowels['a']}${root[2]}${vowels['_e']}ת${vowels['E']}ן',
                'They': 'הִת${root[0]}${vowels['a']}${root[1]}${vowels['_e']}${root[2]}וּ'
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
                'I': '${root[0]}${vowels['u']}${root[1]}${vowels['a']}${root[2]}${vowels['_e']}ת${vowels['i']}י',
                'You F': '${root[0]}${vowels['u']}${root[1]}${vowels['a']}${root[2]}${vowels['_e']}ת${vowels['_e']}',
                'You M': '${root[0]}${vowels['u']}${root[1]}${vowels['a']}${root[2]}${vowels['_e']}ת${vowels['A']}',
                'He': '${root[0]}${vowels['u']}${root[1]}${vowels['a']}${root[2]}',
                'She': '${root[0]}${vowels['u']}${root[1]}${root[2]}${vowels['A']}ה',
                'We': '${root[0]}${vowels['u']}${root[1]}${vowels['a']}${root[2]}${vowels['_e']}נוּ',
                'You M P': '${root[0]}${vowels['u']}${root[1]}${vowels['a']}${root[2]}${vowels['_e']}ת${vowels['E']}ם',
                'You F P': '${root[0]}${vowels['u']}${root[1]}${vowels['a']}${root[2]}${vowels['_e']}ת${vowels['E']}ן',
                'They': '${root[0]}${vowels['u']}${root[1]}${vowels['_e']}${root[2]}וּ'
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
            return {'root': root};
    }
}

Map<String, String> _conjugateFuture(String root, String binyan) {

    switch(binyan) {
        case 'Paal':
            if(root[1] == letters['vav'])
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
                'I': 'אֲ${root[0]}${vowels['a']}${root[1]}${vowels['e']}${root[2]}',
                'We': 'נְ${root[0]}${vowels['a']}${root[1]}${vowels['e']}${root[2]}',
                'You M': 'תְּ${root[0]}${vowels['a']}${root[1]}${vowels['e']}${root[2]}',
                'You F': 'תְּ${root[0]}${vowels['a']}${root[1]}${root[2]}י',
                'You': 'תְּ${root[0]}${vowels['a']}${root[1]}${root[2]}וּ',
                'He': 'יְ${root[0]}${vowels['a']}${root[1]}${vowels['e']}${root[2]}',
                'She': 'תְּ${root[0]}${vowels['a']}${root[1]}${vowels['e']}${root[2]}',
                'They': 'יְ${root[0]}${vowels['a']}${root[1]}${root[2]}וּ'
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
                'I': 'אֶתְ${root[0]}${vowels['a']}${root[1]}${vowels['e']}${root[2]}',
                'We': 'נִתְ${root[0]}${vowels['a']}${root[1]}${vowels['e']}${root[2]}',
                'You M': 'תִּתְ${root[0]}${vowels['a']}${root[1]}${vowels['e']}${root[2]}',
                'You F': 'תִּתְ${root[0]}${vowels['a']}${root[1]}${root[2]}${vowels['i']}י',
                'You': 'תִּתְ${root[0]}${vowels['a']}${root[1]}${root[2]}וּ',
                'He': 'יִתְ${root[0]}${vowels['a']}${root[1]}${vowels['e']}${root[2]}',
                'She': 'תִּתְ${root[0]}${vowels['a']}${root[1]}${vowels['e']}${root[2]}',
                'They': 'יִתְ${root[0]}${vowels['a']}${root[1]}${root[2]}וּ'
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
                'I': 'אֲ${root[0]}${vowels['u']}${root[1]}${vowels['A']}${root[2]}',
                'We': 'נְ${root[0]}${vowels['u']}${root[1]}${vowels['A']}${root[2]}',
                'You F': 'תְּ${root[0]}${vowels['u']}${root[1]}${vowels['_e']}${root[2]}${vowels['i']}י',
                'You M': 'תְּ${root[0]}${vowels['u']}${root[1]}${vowels['A']}${root[2]}',
                'You': 'תְּ${root[0]}${vowels['u']}${root[1]}${vowels['_e']}${root[2]}וּ',
                'He': 'יְ${root[0]}${vowels['u']}${root[1]}${vowels['A']}${root[2]}',
                'She': 'תְּ${root[0]}${vowels['u']}${root[1]}${vowels['A']}${root[2]}',
                'They': 'יְ${root[0]}${vowels['u']}${root[1]}${vowels['_e']}${root[2]}וּ'
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
            return {'root': root};
    }
}