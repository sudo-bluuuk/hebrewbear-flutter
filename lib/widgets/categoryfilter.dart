import 'package:flutter/material.dart';
import 'package:hebrewbear/data/wordtypes.dart';

/// Narrows the word list to one category. A null [value] means "All".
class CategoryFilter extends StatelessWidget {
  const CategoryFilter({super.key, required this.value, required this.onChanged});

  static const String allLabel = 'All';

  final WordCategory? value;
  final ValueChanged<WordCategory?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<WordCategory?>(
      initialValue: value,
      // Ellipsise a label too wide for the box instead of overflowing it; the
      // labels fit in Roboto but not at large text scales.
      isExpanded: true,
      isDense: true,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
      ),
      items: [
        const DropdownMenuItem<WordCategory?>(
          value: null,
          child: Text(allLabel),
        ),
        for (final category in WordCategory.values)
          DropdownMenuItem<WordCategory?>(
            value: category,
            child: Text(category.title),
          ),
      ],
      onChanged: onChanged,
    );
  }
}
