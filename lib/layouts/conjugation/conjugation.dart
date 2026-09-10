import 'package:flutter/material.dart';
import 'package:hebrewbear/data/conjugation.dart';
import 'package:hebrewbear/data/corrections.dart';
import 'package:hebrewbear/data/dbmanager.dart';
import 'package:hebrewbear/data/gizrah.dart';
import 'package:hebrewbear/layouts/conjugation/editform.dart';
import 'package:hebrewbear/widgets/cell.dart';
import 'package:hebrewbear/widgets/stripe.dart';
import 'package:hebrewbear/widgets/table.dart';
import 'package:provider/provider.dart';

/// One tense of a verb, with every form correctable by hand.
///
/// The rules do not get every verb right, so a tapped row can be replaced with
/// a typed form. Only corrected forms are stored; the rest stay generated.
class Conjugation extends StatefulWidget {
  const Conjugation({super.key, required this.word, required this.time});

  final WordsSchemaData word;
  final String time;

  @override
  State<Conjugation> createState() => _ConjugationState();
}

class _ConjugationState extends State<Conjugation> {
  /// Held in state, not built inline: creating the stream in build would drop
  /// and re-subscribe on every rebuild.
  Stream<List<ConjugationOverride>>? _overrides;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _overrides ??= context.read<WordsDB>().watchOverrides(widget.word.id);
  }

  WordsSchemaData get word => widget.word;
  String get time => widget.time;

  static const TextStyle _hebrewTextStyle = TextStyle(
    fontSize: 26,
    fontFamily: 'Noto Serif Hebrew',
  );

  static const TextStyle _textStyle = TextStyle(fontSize: 26);

  Gizrah get _gizrah => gizrahFromName(word.gizrah);

  Map<String, String> get _generated => switch (time) {
        'Past' => conjugatePast(word.root, word.type, gizrah: _gizrah),
        'Future' => conjugateFuture(word.root, word.type, gizrah: _gizrah),
        _ => conjugatePresent(word.root, word.type, gizrah: _gizrah),
      };

  Future<void> _edit(
    BuildContext context, {
    required String tense,
    required String person,
    required String label,
    required String current,
    required bool isManual,
  }) async {
    final db = context.read<WordsDB>();
    final edit = await showDialog<FormEdit>(
      context: context,
      builder: (context) => EditFormDialog(
        label: label,
        current: current,
        isManual: isManual,
      ),
    );

    switch (edit) {
      case FormReplaced(:final form):
        await db.setOverride(
            wordId: word.id, tense: tense, person: person, form: form);
      case FormReset():
        await db.clearOverride(wordId: word.id, tense: tense, person: person);
      case null:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ConjugationOverride>>(
      stream: _overrides,
      builder: (context, snapshot) {
        final corrections = CorrectedForms.from(
            snapshot.data ?? const <ConjugationOverride>[]);

        final generated = _generated;
        final generatedInfinitive =
            createInfinitive(word.root, word.type, gizrah: _gizrah).values.first;
        final infinitive = corrections.resolve(WordsDB.infinitiveTense,
            WordsDB.infinitiveKey, generatedInfinitive);

        // The infinitive leads the table so every correctable form is reached
        // the same way — by tapping its row.
        final rows = <({String tense, String person, String label})>[
          (
            tense: WordsDB.infinitiveTense,
            person: WordsDB.infinitiveKey,
            label: 'Infinitive'
          ),
          for (final person in generated.keys)
            (tense: time, person: person, label: person),
        ];

        return Scaffold(
          appBar: AppBar(
            title: Text(infinitive, style: _hebrewTextStyle),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(24.0),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text("$time · ${word.translate}"),
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    'Tap a row to correct a form.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                HebrewBearTable(
                  children: [
                    for (final (index, row) in rows.indexed)
                      _buildRow(
                        context,
                        index: index,
                        tense: row.tense,
                        person: row.person,
                        label: row.label,
                        generated: row.person == WordsDB.infinitiveKey
                            ? generatedInfinitive
                            : generated[row.person]!,
                        correction:
                            corrections.correctionFor(row.tense, row.person),
                      ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  TableRow _buildRow(
    BuildContext context, {
    required int index,
    required String tense,
    required String person,
    required String label,
    required String generated,
    required String? correction,
  }) {
    final form = correction ?? generated;
    final isManual = correction != null;
    onTap() => _edit(
          context,
          tense: tense,
          person: person,
          label: label,
          current: form,
          isManual: isManual,
        );

    return TableRow(
      decoration: BoxDecoration(color: stripeColor(context, index)),
      children: [
        HebrewBearCell(
          onTap: onTap,
          child: Text(label, style: _textStyle),
        ),
        HebrewBearCell(
          onTap: onTap,
          child: Row(
            children: [
              Expanded(child: Text(form, style: _hebrewTextStyle)),
              if (isManual)
                Tooltip(
                  message: 'Corrected by hand',
                  child: Icon(
                    Icons.edit_note,
                    size: 20.0,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
