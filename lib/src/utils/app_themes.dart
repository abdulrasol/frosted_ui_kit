import 'package:material_ui/material_ui.dart';
import 'frosted_theme.dart';

/// Centralized application theme configuration class.
class AppThemes {
  /// Global [ThemeData] instance specifying color scheme and visual design properties.
  static ThemeData theme = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
  );

  /// Standard translucent border color used across glassmorphic cards and buttons.
  static Color borderColor(BuildContext context) =>
      FrostedThemeData.of(context).borderColor ??
      Theme.of(context).colorScheme.secondary.withValues(alpha: .2);

  /// Standard translucent border style used across glassmorphic cards and buttons.
  static Border border(BuildContext context) =>
      Border.all(color: borderColor(context));
}
