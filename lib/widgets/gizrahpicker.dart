import 'package:flutter/material.dart';
import 'package:hebrewbear/data/gizrah.dart';

/// Asks which way a root conjugates, for the one case Hebrew spelling does not
/// answer on its own.
///
/// Shown only when [needsGizrah] is true — a Paal root starting with נ or י,
/// where נפל drops the letter and נסע keeps it with nothing in the spelling to
/// tell them apart.
class GizrahPicker extends StatelessWidget {
  const GizrahPicker({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final Gizrah value;
  final ValueChanged<Gizrah> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<Gizrah>(
      initialValue: value,
      // Labels are long and carry a Hebrew example; ellipsise rather than
      // overflow when the text is scaled up.
      isExpanded: true,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        helperText: 'Two roots can look alike and conjugate differently.',
        helperMaxLines: 2,
      ),
      items: [
        for (final gizrah in Gizrah.values)
          DropdownMenuItem<Gizrah>(
            value: gizrah,
            child: Text('${gizrah.label} — ${gizrah.example}'),
          ),
      ],
      onChanged: (picked) {
        if (picked != null) onChanged(picked);
      },
    );
  }
}
