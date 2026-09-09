import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:hebrewbear/data/dbmanager.dart';
import 'package:hebrewbear/data/wordtypes.dart';
import 'package:hebrewbear/layouts/conjugation/conjugation.dart';
import 'package:hebrewbear/widgets/categoryfilter.dart';
import 'package:hebrewbear/widgets/sidebar.dart';
import 'package:hebrewbear/widgets/stripe.dart';
import 'package:hebrewbear/widgets/wordtypechip.dart';
import 'package:provider/provider.dart';

const TextStyle hebrewTextStyle = TextStyle(
  fontSize: 18,
  fontFamily: 'Noto Serif Hebrew',
);

class ConjugationButton extends StatelessWidget {
  const ConjugationButton({super.key, required this.time, required this.word});

  final String time;
  final WordsSchemaData word;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Conjugation(word: word, time: time),
          ));
        },
        child: Text(time),
      ),
    );
  }
}

/// The three tense buttons, side by side when they fit and stacked when they
/// do not.
///
/// Flutter has no CSS-style media queries. [LayoutBuilder] is the closer
/// analogue to a CSS *container* query: it reports the width actually offered
/// to this widget, so the choice reacts to the row's own box rather than to the
/// size of the window.
class ConjugationButtons extends StatelessWidget {
  const ConjugationButtons({super.key, required this.word});

  final WordsSchemaData word;

  static const List<String> tenses = ["Present", "Past", "Future"];

  /// Horizontal padding Material puts inside an [ElevatedButton], the padding
  /// [ConjugationButton] adds around each one, and Material's minimum button
  /// width. These are layout constants, independent of the font.
  static const double _buttonPadding = 48.0;
  static const double _buttonSpacing = 20.0;
  static const double _buttonMinWidth = 64.0;

  /// Width the three buttons need side by side, measured from the labels as
  /// they will actually be drawn.
  ///
  /// A hand-picked breakpoint would be wrong somewhere: the same three labels
  /// need ~330px in Roboto but ~440px under the fallback font used in widget
  /// tests, and more again when the user scales text up. Measuring adapts to
  /// all three.
  static double rowWidthFor(BuildContext context) {
    final style = Theme.of(context).textTheme.labelLarge;
    final scaler = MediaQuery.textScalerOf(context);

    var total = 0.0;
    for (final tense in tenses) {
      final painter = TextPainter(
        text: TextSpan(text: tense, style: style),
        textDirection: Directionality.of(context),
        textScaler: scaler,
      )..layout();
      total += math.max(_buttonMinWidth, painter.width + _buttonPadding) +
          _buttonSpacing;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final threshold = rowWidthFor(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final buttons = [
          for (final tense in tenses) ConjugationButton(time: tense, word: word)
        ];

        if (constraints.maxWidth >= threshold) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: buttons,
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: buttons,
        );
      },
    );
  }
}

class WordsList extends StatefulWidget {
  const WordsList({super.key});

  @override
  State<WordsList> createState() => _WordsListState();
}

class _WordsListState extends State<WordsList> {
  final _filterController = TextEditingController();

  /// Held in state rather than built inline: rebuilding the stream on every
  /// frame would re-run the query on each keystroke and drop the results.
  Stream<List<WordEntry>>? _words;
  String _filter = '';
  WordCategory? _category;

  @override
  void initState() {
    super.initState();
    _filterController.addListener(_onFilterChanged);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _words ??= _query();
  }

  Stream<List<WordEntry>> _query() =>
      context.read<WordsDB>().watchWords(_filter, category: _category);

  @override
  void dispose() {
    _filterController.dispose();
    super.dispose();
  }

  void _onFilterChanged() {
    if (_filterController.text == _filter) return;
    _filter = _filterController.text;
    setState(() => _words = _query());
  }

  void _onCategoryChanged(WordCategory? category) {
    if (category == _category) return;
    _category = category;
    setState(() => _words = _query());
  }

  String get _emptyMessage {
    if (_filter.isNotEmpty) return "Nothing matches '$_filter'.";
    if (_category != null) return "No ${_category!.label}s yet.";
    return "No words yet — add one from the menu.";
  }

  Future<bool?> _confirmDelete(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm"),
          content: const Text("Are you sure you wish to delete this item?"),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text("Delete"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildVerb(WordEntry entry) {
    final word = entry.word;
    return ExpansionTile(
      title: ListTile(
        title: Row(
          children: [
            Flexible(
              child: Text(
                "${entry.infinitive} (${word.root})",
                style: hebrewTextStyle,
              ),
            ),
            if (entry.isInfinitiveManual)
              Padding(
                padding: const EdgeInsets.only(left: 6.0),
                child: Icon(
                  Icons.edit_note,
                  size: 18.0,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
          ],
        ),
        subtitle: Text(word.translate),
        trailing: WordTypeChip(type: word.type),
      ),
      children: <Widget>[
        ListTile(title: ConjugationButtons(word: word)),
      ],
    );
  }

  Widget _buildWord(WordsSchemaData word) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: ListTile(
        title: Text(word.root, style: hebrewTextStyle),
        subtitle: Text(word.translate),
        trailing: WordTypeChip(type: word.type),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hebrew Bear"),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _filterController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Search...',
                ),
              ),
            ),
            const SizedBox(width: 10.0),
            SizedBox(
              width: 136.0,
              child: CategoryFilter(
                value: _category,
                onChanged: _onCategoryChanged,
              ),
            ),
          ],
        ),
      ),
      drawer: const HebrewBearSidebar(),
      body: StreamBuilder<List<WordEntry>>(
        stream: _words,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Could not load words: ${snapshot.error}"));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final words = snapshot.data!;
          if (words.isEmpty) {
            return Center(child: Text(_emptyMessage));
          }

          return ListView.builder(
            itemCount: words.length,
            itemBuilder: (context, index) {
              final entry = words[index];
              final word = entry.word;
              return Dismissible(
                key: ValueKey(word.id),
                confirmDismiss: (direction) => _confirmDelete(context),
                onDismissed: (direction) =>
                    context.read<WordsDB>().deleteWord(word.id),
                background: Container(color: Theme.of(context).focusColor),
                child: ColoredBox(
                  color: stripeColor(context, index),
                  child:
                      isVerb(word.type) ? _buildVerb(entry) : _buildWord(word),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
