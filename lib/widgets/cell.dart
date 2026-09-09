import 'package:flutter/material.dart';

class HebrewBearCell extends StatelessWidget {
  const HebrewBearCell({super.key, required this.child, this.onTap});

  final Widget child;

  /// Makes the cell tappable. Both cells of a row share one callback, so the
  /// whole row behaves as a single target.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: const EdgeInsets.all(16.0),
      child: child,
    );

    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.middle,
      child: onTap == null ? content : InkWell(onTap: onTap, child: content),
    );
  }
}
