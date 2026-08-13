import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:starter/src/shared/widgets/cards.dart';
import 'package:starter/src/utils/app_themes.dart';

/// Defines visual style variants for [AppButton].
enum AppButtonStyle {
  /// Default glassmorphic button style (built on [BluredCard] with backdrop blur).
  glass,

  /// Solid colored filled button style using primary theme color or custom background color.
  colored,

  /// Outlined button style with solid border line and transparent background.
  outlined,

  /// Text-only button style without border or card background.
  text,
}

/// A circular glassmorphic button with backdrop blur and semi-transparent border styling.
class CricleButton extends StatelessWidget {
  /// Creates a [CricleButton] with specified tap callback and icon.
  const CricleButton({super.key, required this.onPressed, required this.icon, this.size});

  /// Callback function executed when the button is tapped.
  final VoidCallback? onPressed;

  /// Icon data displayed at the center of the button.
  final IconData icon;

  /// Custom size for the button.
  final double? size;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          height: size ?? 48,
          width: size ?? 48,
          decoration: BoxDecoration(border: AppThemes.border, shape: BoxShape.circle),
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(50),
            child: Center(child: Icon(icon, size: (size ?? 48) * 0.6)),
          ),
        ),
      ),
    );
  }
}

/// A versatile button widget supporting multiple style variants ([AppButtonStyle.glass],
/// [AppButtonStyle.colored], [AppButtonStyle.outlined], [AppButtonStyle.text]).
class AppButton extends StatelessWidget {
  /// Creates an [AppButton].
  const AppButton({
    super.key,
    this.title,
    this.icon,
    this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.height = 48,
    this.width,
    this.borderRadius,
    this.margin,
    this.padding,
    this.textStyle,
    this.iconColor,
    this.style = AppButtonStyle.glass,
    this.backgroundColor,
    this.borderColor,
  });

  /// Optional text string displayed on the button.
  final String? title;

  /// Optional icon displayed beside or inside the button.
  final IconData? icon;

  /// Callback function triggered on button tap.
  final VoidCallback? onPressed;

  /// Whether the button shows a progress loading indicator.
  final bool isLoading;

  /// Whether the button is disabled.
  final bool isDisabled;

  /// Fixed height for the button card (defaults to 48).
  final double? height;

  /// Optional fixed width for the button card.
  final double? width;

  /// Custom border radius geometry for the button card.
  final BorderRadiusGeometry? borderRadius;

  /// Outer margin surrounding the button container.
  final EdgeInsetsGeometry? margin;

  /// Inner padding inside the button container.
  final EdgeInsetsGeometry? padding;

  /// Text style for the title label.
  final TextStyle? textStyle;

  /// Icon color override.
  final Color? iconColor;

  /// Visual style variant (defaults to [AppButtonStyle.glass]).
  final AppButtonStyle style;

  /// Custom background color override.
  final Color? backgroundColor;

  /// Custom border color override.
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveOnPressed = (isLoading || isDisabled) ? null : onPressed;
    final effectiveRadius = borderRadius ?? BorderRadius.circular(16);

    // Determine content color based on style variant and disabled state
    final Color defaultContentColor;
    switch (style) {
      case AppButtonStyle.colored:
        defaultContentColor = theme.colorScheme.onPrimary;
        break;
      case AppButtonStyle.glass:
      case AppButtonStyle.outlined:
      case AppButtonStyle.text:
        defaultContentColor = theme.colorScheme.primary;
        break;
    }

    final Color contentColor = isDisabled ? theme.colorScheme.onSurface.withValues(alpha: 0.38) : (iconColor ?? defaultContentColor);

    final Widget innerContent = Center(
      child: isLoading
          ? SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: contentColor))
          : Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 8,
              children: [
                if (icon != null) Icon(icon, size: 20, color: contentColor),
                if (title != null)
                  Text(
                    title!,
                    style: textStyle ?? theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold, color: contentColor),
                  ),
              ],
            ),
    );

    // 1. Text Button variant
    if (style == AppButtonStyle.text) {
      return Container(
        height: height,
        width: width,
        margin: margin,
        padding: padding,
        child: InkWell(onTap: effectiveOnPressed, borderRadius: effectiveRadius as BorderRadius?, child: innerContent),
      );
    }

    // 2. Colored Button variant
    if (style == AppButtonStyle.colored) {
      final fillBg = isDisabled ? theme.colorScheme.onSurface.withValues(alpha: 0.12) : (backgroundColor ?? theme.colorScheme.primary);

      return Container(
        height: height,
        width: width,
        margin: margin,
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: fillBg,
          borderRadius: effectiveRadius,
          border: borderColor != null ? Border.all(color: borderColor!) : null,
        ),
        child: InkWell(onTap: effectiveOnPressed, borderRadius: effectiveRadius as BorderRadius?, child: innerContent),
      );
    }

    // 3. Outlined Button variant
    if (style == AppButtonStyle.outlined) {
      final borderCol = isDisabled ? theme.colorScheme.onSurface.withValues(alpha: 0.12) : (borderColor ?? theme.colorScheme.primary);

      return Container(
        height: height,
        width: width,
        margin: margin,
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.transparent,
          borderRadius: effectiveRadius,
          border: Border.all(color: borderCol, width: 1.5),
        ),
        child: InkWell(onTap: effectiveOnPressed, borderRadius: effectiveRadius as BorderRadius?, child: innerContent),
      );
    }

    // 4. Default Glassmorphic Button variant
    return BluredCard(
      height: height,
      width: width,
      margin: margin,
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
      borderRadius: effectiveRadius,
      border: borderColor != null ? Border.all(color: borderColor!) : null,
      child: InkWell(onTap: effectiveOnPressed, borderRadius: effectiveRadius as BorderRadius?, child: innerContent),
    );
  }
}

/// A mixin providing utility methods for constructing standard navigation and action buttons.
mixin Buttons {
  /// Returns a custom [CricleButton] with specified icon and tap callback.
  Widget cricleButton({required BuildContext context, required IconData icon, VoidCallback? onPressed, double? size}) {
    return CricleButton(onPressed: onPressed, icon: icon, size: size);
  }

  /// Returns a configured [AppButton] with support for style variants ([AppButtonStyle]).
  Widget appButton({
    required BuildContext context,
    String? title,
    IconData? icon,
    VoidCallback? onPressed,
    bool isLoading = false,
    bool isDisabled = false,
    double? height = 48,
    double? width,
    BorderRadiusGeometry? borderRadius,
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? padding,
    TextStyle? textStyle,
    Color? iconColor,
    AppButtonStyle style = AppButtonStyle.glass,
    Color? backgroundColor,
    Color? borderColor,
  }) {
    return AppButton(
      title: title,
      icon: icon,
      onPressed: onPressed,
      isLoading: isLoading,
      isDisabled: isDisabled,
      height: height,
      width: width,
      borderRadius: borderRadius,
      margin: margin,
      padding: padding,
      textStyle: textStyle,
      iconColor: iconColor,
      style: style,
      backgroundColor: backgroundColor,
      borderColor: borderColor,
    );
  }

  /// Returns an RTL-aware back navigation button that pops the current route.
  Widget backButton(BuildContext context, {VoidCallback? onTap}) {
    return cricleButton(
      context: context,
      icon: Icons.chevron_left_rounded,
      onPressed:
          onTap ??
          () {
            if (Navigator.of(context).canPop()) {
              Navigator.pop(context);
            }
          },
    );
  }

  /// Returns a close icon navigation button that pops the current route.
  Widget closeButton(BuildContext context) {
    return cricleButton(
      context: context,
      icon: Icons.close,
      onPressed: () {
        if (Navigator.of(context).canPop()) {
          Navigator.pop(context);
        }
      },
    );
  }
}
