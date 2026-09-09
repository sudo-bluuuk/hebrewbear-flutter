import 'package:flutter/material.dart';

/// Background for alternating rows, so long lists and tables stay scannable.
///
/// Taken from the active [ColorScheme] rather than a fixed overlay: a
/// hard-coded translucent black lightens nothing on a dark background, it just
/// muddies it.
Color stripeColor(BuildContext context, int index) => index.isEven
    ? Theme.of(context).colorScheme.surfaceContainerHigh
    : Colors.transparent;
