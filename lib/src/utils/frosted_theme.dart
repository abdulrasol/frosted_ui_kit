import 'dart:ui' show lerpDouble;
import 'package:flutter/material.dart';

/// Immutable design tokens shared by Frosted widgets.
///
/// Register in [ThemeData.extensions]. Explicit widget properties take
/// precedence. Null colors inherit the host Material color scheme.
@immutable
class FrostedThemeData extends ThemeExtension<FrostedThemeData> {
  /// Creates tokens with the kit's existing geometry and motion defaults.
  const FrostedThemeData({
    this.surfaceColor,
    this.contentColor,
    this.borderColor,
    this.primaryActionColor,
    this.onPrimaryActionColor,
    this.secondaryActionColor,
    this.onSecondaryActionColor,
    this.destructiveActionColor,
    this.onDestructiveActionColor,
    this.buttonRadius = 16,
    this.dialogRadius = 24,
    this.surfaceRadius = 50,
    this.dialogOpacity = .88,
    this.dialogBlur = 12,
    this.glassBlur = 5,
    this.appBarBlur = 6,
    this.inputBlur = 10,
    this.tabsBlur = 10,
    this.sheetBlur = 15,
    this.navigationBlur = 20,
    this.spacing = 16,
    this.motionDuration = const Duration(milliseconds: 200),
  }) : assert(buttonRadius >= 0),
       assert(dialogRadius >= 0),
       assert(surfaceRadius >= 0),
       assert(dialogOpacity >= 0 && dialogOpacity <= 1),
       assert(dialogBlur >= 0),
       assert(glassBlur >= 0),
       assert(appBarBlur >= 0),
       assert(spacing >= 0);

  /// Surface tint override; null inherits Material surface behavior.
  final Color? surfaceColor;

  /// Foreground override for glass button content.
  final Color? contentColor;

  /// Shared glass border override.
  final Color? borderColor;

  /// Fill/accent override for primary actions; null uses ColorScheme.primary.
  final Color? primaryActionColor;

  /// Content override for filled primary actions.
  final Color? onPrimaryActionColor;

  /// Fill/accent override for secondary actions; null uses ColorScheme.secondary.
  final Color? secondaryActionColor;

  /// Content override for filled secondary actions.
  final Color? onSecondaryActionColor;

  /// Fill/accent override for destructive actions; null uses ColorScheme.error.
  final Color? destructiveActionColor;

  /// Content override for filled destructive actions.
  final Color? onDestructiveActionColor;

  /// Default regular button corner radius.
  final double buttonRadius;

  /// Default dialog corner radius.
  final double dialogRadius;

  /// Default generic card radius.
  final double surfaceRadius;

  /// Dialog tint opacity, independent of blur.
  final double dialogOpacity;

  /// Default dialog blur sigma.
  final double dialogBlur;

  /// Default water-drop and generic card blur sigma.
  final double glassBlur;

  /// Default app-bar blur sigma.
  final double appBarBlur;

  /// Default text-field backdrop sigma.
  final double inputBlur;

  /// Default tabs backdrop sigma.
  final double tabsBlur;

  /// Default bottom-sheet backdrop sigma.
  final double sheetBlur;

  /// Default navigation-bar backdrop sigma.
  final double navigationBlur;

  /// Standard content spacing.
  final double spacing;

  /// Standard entrance and feedback transition duration.
  final Duration motionDuration;

  /// Allocation-free defaults when no extension is installed.
  static const defaults = FrostedThemeData();

  /// Light preset; nullable colors follow the application's ColorScheme.
  static const light = FrostedThemeData();

  /// Dark preset, following the application's dark ColorScheme.
  static const dark = FrostedThemeData();

  /// Resolves tokens from the nearest Material theme.
  static FrostedThemeData of(BuildContext context) =>
      Theme.of(context).extension<FrostedThemeData>() ?? defaults;

  @override
  FrostedThemeData copyWith({
    Color? surfaceColor,
    Color? contentColor,
    Color? borderColor,
    Color? primaryActionColor,
    Color? onPrimaryActionColor,
    Color? secondaryActionColor,
    Color? onSecondaryActionColor,
    Color? destructiveActionColor,
    Color? onDestructiveActionColor,
    double? buttonRadius,
    double? dialogRadius,
    double? surfaceRadius,
    double? dialogOpacity,
    double? dialogBlur,
    double? glassBlur,
    double? appBarBlur,
    double? inputBlur,
    double? tabsBlur,
    double? sheetBlur,
    double? navigationBlur,
    double? spacing,
    Duration? motionDuration,
  }) => FrostedThemeData(
    surfaceColor: surfaceColor ?? this.surfaceColor,
    contentColor: contentColor ?? this.contentColor,
    borderColor: borderColor ?? this.borderColor,
    primaryActionColor: primaryActionColor ?? this.primaryActionColor,
    onPrimaryActionColor: onPrimaryActionColor ?? this.onPrimaryActionColor,
    secondaryActionColor: secondaryActionColor ?? this.secondaryActionColor,
    onSecondaryActionColor:
        onSecondaryActionColor ?? this.onSecondaryActionColor,
    destructiveActionColor:
        destructiveActionColor ?? this.destructiveActionColor,
    onDestructiveActionColor:
        onDestructiveActionColor ?? this.onDestructiveActionColor,
    buttonRadius: buttonRadius ?? this.buttonRadius,
    dialogRadius: dialogRadius ?? this.dialogRadius,
    surfaceRadius: surfaceRadius ?? this.surfaceRadius,
    dialogOpacity: dialogOpacity ?? this.dialogOpacity,
    dialogBlur: dialogBlur ?? this.dialogBlur,
    glassBlur: glassBlur ?? this.glassBlur,
    appBarBlur: appBarBlur ?? this.appBarBlur,
    inputBlur: inputBlur ?? this.inputBlur,
    tabsBlur: tabsBlur ?? this.tabsBlur,
    sheetBlur: sheetBlur ?? this.sheetBlur,
    navigationBlur: navigationBlur ?? this.navigationBlur,
    spacing: spacing ?? this.spacing,
    motionDuration: motionDuration ?? this.motionDuration,
  );

  @override
  FrostedThemeData lerp(covariant FrostedThemeData? other, double t) {
    if (other == null || identical(this, other)) return this;
    if (t == 0) return this;
    if (t == 1) return other;
    return FrostedThemeData(
      surfaceColor: Color.lerp(surfaceColor, other.surfaceColor, t),
      contentColor: Color.lerp(contentColor, other.contentColor, t),
      borderColor: Color.lerp(borderColor, other.borderColor, t),
      primaryActionColor: Color.lerp(
        primaryActionColor,
        other.primaryActionColor,
        t,
      ),
      onPrimaryActionColor: Color.lerp(
        onPrimaryActionColor,
        other.onPrimaryActionColor,
        t,
      ),
      secondaryActionColor: Color.lerp(
        secondaryActionColor,
        other.secondaryActionColor,
        t,
      ),
      onSecondaryActionColor: Color.lerp(
        onSecondaryActionColor,
        other.onSecondaryActionColor,
        t,
      ),
      destructiveActionColor: Color.lerp(
        destructiveActionColor,
        other.destructiveActionColor,
        t,
      ),
      onDestructiveActionColor: Color.lerp(
        onDestructiveActionColor,
        other.onDestructiveActionColor,
        t,
      ),
      buttonRadius: lerpDouble(buttonRadius, other.buttonRadius, t)!,
      dialogRadius: lerpDouble(dialogRadius, other.dialogRadius, t)!,
      surfaceRadius: lerpDouble(surfaceRadius, other.surfaceRadius, t)!,
      dialogOpacity: lerpDouble(dialogOpacity, other.dialogOpacity, t)!,
      dialogBlur: lerpDouble(dialogBlur, other.dialogBlur, t)!,
      glassBlur: lerpDouble(glassBlur, other.glassBlur, t)!,
      appBarBlur: lerpDouble(appBarBlur, other.appBarBlur, t)!,
      inputBlur: lerpDouble(inputBlur, other.inputBlur, t)!,
      tabsBlur: lerpDouble(tabsBlur, other.tabsBlur, t)!,
      sheetBlur: lerpDouble(sheetBlur, other.sheetBlur, t)!,
      navigationBlur: lerpDouble(navigationBlur, other.navigationBlur, t)!,
      spacing: lerpDouble(spacing, other.spacing, t)!,
      motionDuration: Duration(
        microseconds: lerpDouble(
          motionDuration.inMicroseconds,
          other.motionDuration.inMicroseconds,
          t,
        )!.round(),
      ),
    );
  }
}
