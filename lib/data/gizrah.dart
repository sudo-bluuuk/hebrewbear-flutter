import 'package:hebrewbear/data/alphabet.dart';
import 'package:hebrewbear/data/conjugation.dart';

/// How a root behaves when it is conjugated, for the cases the letters do not
/// settle on their own.
///
/// Most classes are predictable — every root ending in ה is lamed-he, every
/// root with a middle ו or י is hollow — and those are worked out from the
/// letters. Two roots of the same shape can still behave differently, though:
/// ישב gives לָשֶׁבֶת but ישן gives לִישֹׁן, and נפל drops its nun where נסע keeps it.
/// Nothing in the letters distinguishes those, so the class is stored with the
/// word and the user is asked.
enum Gizrah {
  /// Work it out from the letters. For a root whose first letter *might* drop,
  /// this means keeping it — the conservative reading, and what the app did
  /// before the class was stored at all.
  automatic('Keeps its first letter', 'like לִנְסוֹעַ'),

  /// The first radical drops and the infinitive takes a ת ending: ישב → לָשֶׁבֶת,
  /// ידע → לָדַעַת. Groups pe-yod roots together with the pe-nun roots that
  /// assimilate, because they behave alike despite the different letter.
  droppingFirst('Drops its first letter', 'like לָשֶׁבֶת');

  const Gizrah(this.label, this.example);

  final String label;
  final String example;
}

/// True when the letters alone do not settle the class, so the user has to say.
///
/// Only ever true for a Paal verb whose first radical is נ or י — the one shape
/// where two roots that look alike conjugate differently.
bool needsGizrah(String root, String binyan) {
  if (binyan != 'Paal') return false;

  final slots = rootSlots(root);
  if (slots.length != 3 || isLamedHe(slots)) return false;

  return slots[0] == letters['nun'] || slots[0] == letters['yod'];
}

/// Reads a stored class name back, falling back to [Gizrah.automatic] for rows
/// written before the column existed or for a name that is no longer known.
Gizrah gizrahFromName(String? name) => Gizrah.values
    .firstWhere((g) => g.name == name, orElse: () => Gizrah.automatic);
