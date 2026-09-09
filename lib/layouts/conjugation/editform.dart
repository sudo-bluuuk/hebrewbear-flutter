import 'package:flutter/material.dart';

/// Outcome of [EditFormDialog]; null from the dialog means cancelled.
sealed class FormEdit {
  const FormEdit();
}

/// The user typed a replacement for the generated form.
class FormReplaced extends FormEdit {
  const FormReplaced(this.form);

  final String form;
}

/// The user dropped their correction, going back to the generated form.
class FormReset extends FormEdit {
  const FormReset();
}

/// Asks for a corrected form, for when the conjugation rules get one wrong.
class EditFormDialog extends StatefulWidget {
  const EditFormDialog({
    super.key,
    required this.label,
    required this.current,
    required this.isManual,
  });

  /// Which form is being corrected, e.g. 'S M' or 'Infinitive'.
  final String label;

  /// What is shown now — either generated or a previous correction.
  final String current;

  /// Whether [current] is already a correction, so it can be reset.
  final bool isManual;

  @override
  State<EditFormDialog> createState() => _EditFormDialogState();
}

class _EditFormDialogState extends State<EditFormDialog> {
  static final _hebrewOnly = RegExp(r'^[\u0590-\u05FF\u200e\u200f ]+$');

  final _formKey = GlobalKey<FormState>();
  late final _controller = TextEditingController(text: widget.current);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(context).pop(FormReplaced(_controller.text.trim()));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Correct ${widget.label}'),
      content: Form(
        key: _formKey,
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: TextFormField(
            controller: _controller,
            autofocus: true,
            style: const TextStyle(fontSize: 22, fontFamily: 'Noto Serif Hebrew'),
            decoration: const InputDecoration(border: OutlineInputBorder()),
            onFieldSubmitted: (_) => _save(),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter a form';
              }
              if (!_hebrewOnly.hasMatch(value.trim())) {
                return 'Only Hebrew allowed';
              }
              return null;
            },
          ),
        ),
      ),
      actions: [
        if (widget.isManual)
          TextButton(
            onPressed: () => Navigator.of(context).pop(const FormReset()),
            child: const Text('Reset'),
          ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(onPressed: _save, child: const Text('Save')),
      ],
    );
  }
}
