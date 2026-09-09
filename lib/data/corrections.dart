import 'package:hebrewbear/data/dbmanager.dart';

/// The user's hand-typed forms, indexed for lookup against generated ones.
///
/// Kept apart from the widget so the fallback rule — a correction wins over the
/// generated form, and only for its own tense — is testable on its own.
class CorrectedForms {
  const CorrectedForms(this._byKey);

  factory CorrectedForms.from(List<ConjugationOverride> overrides) {
    return CorrectedForms({
      for (final override in overrides)
        _key(override.tense, override.person): override.form
    });
  }

  static const CorrectedForms none = CorrectedForms({});

  final Map<String, String> _byKey;

  static String _key(String tense, String person) => '$tense|$person';

  String? correctionFor(String tense, String person) =>
      _byKey[_key(tense, person)];

  bool isCorrected(String tense, String person) =>
      _byKey.containsKey(_key(tense, person));

  /// The correction when there is one, otherwise [generated].
  String resolve(String tense, String person, String generated) =>
      correctionFor(tense, person) ?? generated;

  bool get isEmpty => _byKey.isEmpty;
}
