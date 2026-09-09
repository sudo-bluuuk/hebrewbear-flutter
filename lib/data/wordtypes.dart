/// The seven verb patterns. A verb is stored as a root plus one of these and
/// its forms are generated on demand.
const List<String> binyanim = [
  "Paal",
  "Piel",
  "Hiphil",
  "Hitpael",
  "Nifal",
  "Pual",
  "Hufal",
];

const String nounType = "Noun";
const String adjectiveType = "Adjective";

bool isVerb(String type) => binyanim.contains(type);

/// The kinds of word the sidebar offers to add, each with the types it covers.
///
/// Verbs need a binyan picked; nouns and adjectives have exactly one type, so
/// the picker is hidden for them.
enum WordCategory {
  verb("verb", binyanim),
  noun("noun", [nounType]),
  adjective("adjective", [adjectiveType]);

  const WordCategory(this.label, this.types);

  final String label;
  final List<String> types;

  /// [label] capitalised, for use where it starts a phrase.
  String get title => label[0].toUpperCase() + label.substring(1);

  bool get needsTypeChoice => types.length > 1;
}
