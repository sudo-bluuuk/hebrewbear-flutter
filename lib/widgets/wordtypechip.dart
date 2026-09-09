import 'package:flutter/material.dart';
import 'package:hebrewbear/data/wordtypes.dart';

/// The word's type as a coloured chip — one colour per category.
///
/// The colours come from the active [ColorScheme] rather than being hard-coded,
/// so they stay legible in both the light and dark themes.
class WordTypeChip extends StatelessWidget {
  const WordTypeChip({super.key, required this.type});

  final String type;

  (Color, Color) _colorsFor(ColorScheme colors) {
    if (isVerb(type)) {
      return (colors.primaryContainer, colors.onPrimaryContainer);
    }
    if (type == nounType) {
      return (colors.secondaryContainer, colors.onSecondaryContainer);
    }
    return (colors.tertiaryContainer, colors.onTertiaryContainer);
  }

  @override
  Widget build(BuildContext context) {
    final (background, foreground) = _colorsFor(Theme.of(context).colorScheme);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Text(
        type,
        style: TextStyle(
          color: foreground,
          fontSize: 12.0,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
