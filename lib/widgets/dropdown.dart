import 'package:flutter/material.dart';

/// A form dropdown that reports the selected item to [onChanged].
///
/// [DropdownButtonFormField] is itself a [FormField] and tracks the selection
/// internally, so there is nothing to hold in state here.
class HebrewBearDropdown extends StatelessWidget {
  const HebrewBearDropdown({
    super.key,
    required this.onChanged,
    required this.defaultItem,
    required this.listItems,
  });

  final ValueChanged<String> onChanged;
  final String defaultItem;
  final List<String> listItems;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: defaultItem,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      borderRadius: const BorderRadius.all(Radius.circular(4.0)),
      decoration: const InputDecoration(border: OutlineInputBorder()),
      focusColor: Colors.transparent,
      items: [
        for (final item in listItems)
          DropdownMenuItem<String>(value: item, child: Text(item))
      ],
      onChanged: (String? newValue) {
        if (newValue != null) onChanged(newValue);
      },
    );
  }
}
