import 'package:flutter/material.dart';

/// Centralized application theme configuration class.
class AppThemes {
  /// Global [ThemeData] instance specifying color scheme and visual design properties.
  static ThemeData theme = ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple));

  /// Standard translucent border style used across glassmorphic cards and buttons.
  static Border border = Border.all(color: theme.colorScheme.secondary.withValues(alpha: .2));
}
