/// Every word type the app knows about, mapped to whether it conjugates.
///
/// Verbs are stored as a root plus a binyan and their forms are generated on
/// demand; nouns and adjectives are stored as written.
const Map<String, bool> wordTypes = {
  "Paal": true,
  "Piel": true,
  "Hiphil": true,
  "Hitpael": true,
  "Nifal": true,
  "Pual": true,
  "Hufal": true,
  "Noun": false,
  "Adjective": false,
};

bool isVerb(String type) => wordTypes[type] ?? false;
