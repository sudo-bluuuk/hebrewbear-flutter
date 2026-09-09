import 'package:flutter/material.dart';
import 'package:hebrewbear/data/dbmanager.dart';
import 'package:hebrewbear/widgets/table.dart';
import 'package:hebrewbear/widgets/cell.dart';

class Conjugation extends StatelessWidget {
  const Conjugation({
    super.key,
    required this.word,
    required this.infinitive,
    required this.result,
    required this.time,
  });

  final String time;
  final WordsSchemaData word;
  final Map<String, String> infinitive;
  final Map<String, String> result;

  static const TextStyle _hebrewTextStyle = TextStyle(
    fontSize: 26,
    fontFamily: 'Noto Serif Hebrew',
  );

  static const TextStyle _textStyle = TextStyle(fontSize: 26);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(infinitive.values.first, style: _hebrewTextStyle),
        // Without this the three tenses render identically bar the forms.
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
            HebrewBearTable(
              children: [
                ...List.generate(
                  result.length,
                  (index) => TableRow(
                    decoration: BoxDecoration(
                      color: index % 2 == 0
                          ? const Color.fromARGB(42, 0, 0, 0)
                          : Colors.transparent,
                    ),
                    children: [
                      HebrewBearCell(
                        child: Text(result.keys.elementAt(index),
                            style: _textStyle),
                      ),
                      HebrewBearCell(
                        child: Text(result.values.elementAt(index),
                            style: _hebrewTextStyle),
                      ),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
