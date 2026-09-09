import 'package:flutter/material.dart';
import 'package:hebrewbear/data/conjugation.dart';
import 'package:hebrewbear/data/dbmanager.dart';
import 'package:hebrewbear/data/wordtypes.dart';
import 'package:hebrewbear/layouts/conjugation/conjugation.dart';
import 'package:hebrewbear/widgets/sidebar.dart';
import 'package:provider/provider.dart';

const TextStyle hebrewTextStyle = TextStyle(
  fontSize: 18,
  fontFamily: 'Noto Serif Hebrew',
);

class ConjugationButton extends StatelessWidget {
  const ConjugationButton({super.key, required this.time, required this.word});

  final String time;
  final WordsSchemaData word;

  Map<String, String> _getConjugation() {
    switch (time) {
      case "Past":
        return conjugatePast(word.root, word.type);
      case "Future":
        return conjugateFuture(word.root, word.type);
      case "Present":
      default:
        return conjugatePresent(word.root, word.type);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Conjugation(
              word: word,
              infinitive: createInfinitive(word.root, word.type),
              result: _getConjugation(),
              time: time,
            ),
          ));
        },
        child: Text(time),
      ),
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
  Stream<List<WordsSchemaData>>? _words;
  String _filter = '';

  @override
  void initState() {
    super.initState();
    _filterController.addListener(_onFilterChanged);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _words ??= context.read<WordsDB>().watchWords(_filter);
  }

  @override
  void dispose() {
    _filterController.dispose();
    super.dispose();
  }

  void _onFilterChanged() {
    if (_filterController.text == _filter) return;
    setState(() {
      _filter = _filterController.text;
      _words = context.read<WordsDB>().watchWords(_filter);
    });
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

  Widget _buildVerb(WordsSchemaData word) {
    return ExpansionTile(
      title: ListTile(
        title: Text(
          "${createInfinitive(word.root, word.type).values.first} (${word.root})",
          style: hebrewTextStyle,
        ),
        subtitle: Text(word.translate),
        trailing: Text(word.type),
      ),
      children: <Widget>[
        ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ConjugationButton(time: "Present", word: word),
              ConjugationButton(time: "Past", word: word),
              ConjugationButton(time: "Future", word: word),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildWord(WordsSchemaData word) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: ListTile(
        title: Text(word.root, style: hebrewTextStyle),
        subtitle: Text(word.translate),
        trailing: Text(word.type),
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
        child: TextField(
          controller: _filterController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Search...',
          ),
        ),
      ),
      drawer: const HebrewBearSidebar(),
      body: StreamBuilder<List<WordsSchemaData>>(
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
            return Center(
              child: Text(_filter.isEmpty
                  ? "No words yet — add one from the menu."
                  : "Nothing matches '$_filter'."),
            );
          }

          return ListView.builder(
            itemCount: words.length,
            itemBuilder: (context, index) {
              final word = words[index];
              return Dismissible(
                key: ValueKey(word.id),
                confirmDismiss: (direction) => _confirmDelete(context),
                onDismissed: (direction) =>
                    context.read<WordsDB>().deleteWord(word.id),
                background: Container(color: Theme.of(context).focusColor),
                child: isVerb(word.type) ? _buildVerb(word) : _buildWord(word),
              );
            },
          );
        },
      ),
    );
  }
}
