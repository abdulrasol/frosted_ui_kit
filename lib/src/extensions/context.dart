import 'package:flutter/material.dart';
import 'package:starter/src/core/l10n/arb/app_localizations.dart';

/// Extension methods on [BuildContext] for screen dimensions, padding, and localization.
extension ContextExtension on BuildContext {
  /// Convenient getter for accessing [AppLocalizations] instance.
  AppLocalizations get l10n => AppLocalizations.of(this)!;

  /// Returns total screen width.
  double get screenWidth => MediaQuery.sizeOf(this).width;

  /// Returns total screen height.
  double get screenHeight => MediaQuery.sizeOf(this).height;

  /// Returns media query padding.
  EdgeInsets get padding => MediaQuery.paddingOf(this);

  /// Returns keyboard view insets padding.
  EdgeInsets get viewInsets => MediaQuery.viewInsetsOf(this);

  /// Preferred app bar height size.
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  /// Total top padding including safe area and app bar height.
  double get topPadding => kToolbarHeight + padding.top;

  /// Standard horizontal padding value.
  double get horizontalPadding => 8;
}
