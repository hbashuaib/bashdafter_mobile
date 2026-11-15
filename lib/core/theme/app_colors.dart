import 'package:flutter/material.dart';

class AppColors {
  static Color cardTint(
    BuildContext context,
    Color lightColor,
  ) {
    final isDark =
        Theme.of(context).brightness ==
        Brightness.dark;

    return isDark
        ? Theme.of(context)
            .colorScheme
            .surfaceContainerHighest
        : lightColor;
  }
}