import 'package:drift/drift.dart' as d;
import 'package:flutter/material.dart';
import 'package:hebrewbear/data/alphabet.dart';
import 'package:hebrewbear/data/conjugation.dart';
import 'package:hebrewbear/data/dbmanager.dart';
import 'package:hebrewbear/data/wordtypes.dart';
import 'package:hebrewbear/widgets/dropdown.dart';
import 'package:provider/provider.dart';

class AddWord extends StatefulWidget {
  const AddWord({super.key, required this.type});

  final String type;

  @override
  State<AddWord> createState() => _AddWordState();
}

class _AddWordState extends State<AddWord> {
  static final _hebrewOnly = RegExp(r'^[\u0590-\u05FF\u200e\u200f ]+$');

  final _formKey = GlobalKey<FormState>();
  final _rootController = TextEditingController();
  final _translateController = TextEditingController();

  String _type = wordTypes.keys.first;

  @override
  void dispose() {
    _rootController.dispose();
    _translateController.dispose();
    super.dispose();
  }

  String? _validateRoot(String? value) {
    if (value == null || value.isEmpty) return 'Please enter some text';
    if (!_hebrewOnly.hasMatch(value)) return 'Only Hebrew allowed';
    if (isVerb(_type) && !isSupportedRoot(value)) {
      return 'Verb roots must be exactly $rootLength letters';
    }
    return null;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    // Verb roots are stored as bare consonants so they can be indexed when
    // building forms; nouns and adjectives keep whatever was typed.
    final root = isVerb(_type)
        ? normalizeRoot(_rootController.text)
        : _rootController.text.trim();

    await context.read<WordsDB>().insertWord(WordsSchemaCompanion(
          root: d.Value(root),
          translate: d.Value(_translateController.text.trim()),
          type: d.Value(_type),
        ));

    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add new ${widget.type}")),
      body: Center(
        child: Form(
          key: _formKey,
          child: SizedBox(
            width: 300.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: TextFormField(
                      controller: _rootController,
                      validator: _validateRoot,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter root if verb or word otherwise',
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: TextFormField(
                    controller: _translateController,
                    validator: (value) => value == null || value.isEmpty
                        ? 'Please enter some text'
                        : null,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter translate',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: HebrewBearDropdown(
                    listItems: wordTypes.keys.toList(),
                    defaultItem: _type,
                    // Re-validates the root, whose rules depend on the type.
                    onChanged: (newValue) => setState(() => _type = newValue),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _submit,
                      child: const Text('Add'),
                    ),
                    const Padding(padding: EdgeInsets.all(10.0)),
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Back'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
