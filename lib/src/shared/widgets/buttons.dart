import 'package:flutter/material.dart';
import 'package:frosted_ui_kit/src/shared/widgets/cards.dart';

/// Defines visual style variants for [AppButton].
enum AppButtonStyle {
  /// Default glassmorphic button style (built on [BlurredCard] with backdrop blur).
  glass,

  /// Solid colored filled button style using primary theme color or custom background color.
  colored,

  /// Outlined button style with solid border line and transparent background.
  outlined,

  /// Text-only button style without border or card background.
  text,
}

/// A circular glassmorphic button built on [BlurredCard] with customizable blur, border, and color.
class CircleButton extends StatelessWidget {
  /// Creates a [CircleButton] with specified tap callback, icon, and optional glass parameters.
  const CircleButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.size = 48.0,
    this.sigmaX = 10.0,
    this.sigmaY = 10.0,
    this.glassColor,
    this.borderColor,
    this.borderWidth,
    this.border,
    this.margin,
    this.boxShadow,
    this.clipBehavior = Clip.antiAlias,
  });

  /// Callback function executed when the button is tapped.
  final VoidCallback? onPressed;

  /// Icon data displayed at the center of the button.
  final IconData icon;

  /// Custom diameter size for the circular button (defaults to 48.0).
  final double? size;

  /// Horizontal backdrop blur intensity (defaults to 10.0).
  final double sigmaX;

  /// Vertical backdrop blur intensity (defaults to 10.0).
  final double sigmaY;

  /// Optional custom glass background tint color.
  final Color? glassColor;

  /// Optional border color override.
  final Color? borderColor;

  /// Optional border width override.
  final double? borderWidth;

  /// Optional custom border override. If provided, overrides [borderColor] and [borderWidth].
  final BoxBorder? border;

  /// Outer margin surrounding the button container.
  final EdgeInsetsGeometry? margin;

  /// Optional list of box shadows applied to the circular button.
  final List<BoxShadow>? boxShadow;

  /// Content clipping behavior (defaults to [Clip.antiAlias]).
  final Clip clipBehavior;

  @override
  Widget build(BuildContext context) {
    final effectiveSize = size ?? 48.0;
    BoxBorder? customBorder;
    if (borderColor != null) {
      customBorder = Border.all(color: borderColor!, width: borderWidth ?? 1.0);
    }

    return BlurredCard(
      height: effectiveSize,
      width: effectiveSize,
      shape: BoxShape.circle,
      sigmaX: sigmaX,
      sigmaY: sigmaY,
      color: glassColor,
      border: border ?? customBorder,
      boxShadow: boxShadow,
      margin: margin,
      clipBehavior: clipBehavior,
      padding: EdgeInsets.zero,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          customBorder: const CircleBorder(),
          child: Center(child: Icon(icon, size: effectiveSize * 0.5)),
        ),
      ),
    );
  }
}

/// Legacy alias for [CircleButton] to maintain backwards compatibility.
typedef CricleButton = CircleButton;

/// A versatile button widget supporting multiple style variants ([AppButtonStyle.glass],
/// [AppButtonStyle.colored], [AppButtonStyle.outlined], [AppButtonStyle.text]).
class AppButton extends StatelessWidget {
  /// Creates an [AppButton] with customizable style, size, glass effects, and tap handler.
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
    this.border,
    this.sigmaX = 10.0,
    this.sigmaY = 10.0,
    this.boxShadow,
    this.clipBehavior = Clip.antiAlias,
    this.child,
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

  /// Custom child to override the default text/icon content.
  final Widget? child;

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

  /// Optional custom border override. If provided, overrides [borderColor].
  final BoxBorder? border;

  /// Horizontal backdrop blur intensity for glass style (defaults to 10.0).
  final double sigmaX;

  /// Vertical backdrop blur intensity for glass style (defaults to 10.0).
  final double sigmaY;

  /// Optional list of box shadows applied to the button container.
  final List<BoxShadow>? boxShadow;

  /// Content clipping behavior (defaults to [Clip.antiAlias]).
  final Clip clipBehavior;

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

    final Color contentColor = isDisabled
        ? theme.colorScheme.onSurface.withValues(alpha: 0.38)
        : (iconColor ?? defaultContentColor);

    final Widget innerContent = Center(
      child: isLoading
          ? SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: contentColor,
              ),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 8,
              children: [
                if (icon != null) Icon(icon, size: 20, color: contentColor),
                if (title != null)
                  Flexible(
                    child: Text(
                      title!,
                      style:
                          textStyle ??
                          theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: contentColor,
                          ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
              ],
            ),
    );

    final Widget content = child ?? innerContent;

    // 1. Text Button variant
    if (style == AppButtonStyle.text) {
      return Container(
        height: height,
        width: width,
        margin: margin,
        padding: padding,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: effectiveOnPressed,
            borderRadius: effectiveRadius as BorderRadius?,
            child: content,
          ),
        ),
      );
    }

    // 2. Colored Button variant
    if (style == AppButtonStyle.colored) {
      final fillBg = isDisabled
          ? theme.colorScheme.onSurface.withValues(alpha: 0.12)
          : (backgroundColor ?? theme.colorScheme.primary);

      return Container(
        height: height,
        width: width,
        margin: margin,
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
          borderRadius: effectiveRadius,
          border:
              border ??
              (borderColor != null ? Border.all(color: borderColor!) : null),
          boxShadow: boxShadow,
        ),
        child: Material(
          color: fillBg,
          clipBehavior: clipBehavior,
          borderRadius: effectiveRadius as BorderRadius?,
          child: InkWell(
            onTap: effectiveOnPressed,
            borderRadius: effectiveRadius as BorderRadius?,
            child: Padding(
              padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
              child: content,
            ),
          ),
        ),
      );
    }

    // 3. Outlined Button variant
    if (style == AppButtonStyle.outlined) {
      final borderCol = isDisabled
          ? theme.colorScheme.onSurface.withValues(alpha: 0.12)
          : (borderColor ?? theme.colorScheme.primary);

      return Container(
        height: height,
        width: width,
        margin: margin,
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
          borderRadius: effectiveRadius,
          border: border ?? Border.all(color: borderCol, width: 1.5),
          boxShadow: boxShadow,
        ),
        child: Material(
          color: backgroundColor ?? Colors.transparent,
          clipBehavior: clipBehavior,
          borderRadius: effectiveRadius as BorderRadius?,
          child: InkWell(
            onTap: effectiveOnPressed,
            borderRadius: effectiveRadius as BorderRadius?,
            child: Padding(
              padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
              child: content,
            ),
          ),
        ),
      );
    }

    // 4. Default Glassmorphic Button variant built on BlurredCard
    return BlurredCard(
      height: height,
      width: width,
      margin: margin,
      padding: EdgeInsets.zero,
      borderRadius: effectiveRadius,
      border:
          border ??
          (borderColor != null ? Border.all(color: borderColor!) : null),
      color: backgroundColor,
      sigmaX: sigmaX,
      sigmaY: sigmaY,
      boxShadow: boxShadow,
      clipBehavior: clipBehavior,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: effectiveOnPressed,
          borderRadius: effectiveRadius as BorderRadius?,
          child: Padding(
            padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
            child: content,
          ),
        ),
      ),
    );
  }
}

/// A mixin providing utility methods for constructing standard navigation and action buttons.
mixin Buttons {
  /// Returns a custom [CircleButton] with specified icon, tap callback, and glass options.
  Widget circleButton({
    Key? key,
    required BuildContext context,
    required IconData icon,
    VoidCallback? onPressed,
    double? size,
    double sigmaX = 10.0,
    double sigmaY = 10.0,
    Color? glassColor,
    Color? borderColor,
    double? borderWidth,
    BoxBorder? border,
    EdgeInsetsGeometry? margin,
    List<BoxShadow>? boxShadow,
    Clip clipBehavior = Clip.antiAlias,
  }) {
    return CircleButton(
      key: key,
      onPressed: onPressed,
      icon: icon,
      size: size,
      sigmaX: sigmaX,
      sigmaY: sigmaY,
      glassColor: glassColor,
      borderColor: borderColor,
      borderWidth: borderWidth,
      border: border,
      margin: margin,
      boxShadow: boxShadow,
      clipBehavior: clipBehavior,
    );
  }

  /// Legacy alias for [circleButton].
  Widget cricleButton({
    Key? key,
    required BuildContext context,
    required IconData icon,
    VoidCallback? onPressed,
    double? size,
    double sigmaX = 10.0,
    double sigmaY = 10.0,
    Color? glassColor,
    Color? borderColor,
    double? borderWidth,
    BoxBorder? border,
    EdgeInsetsGeometry? margin,
    List<BoxShadow>? boxShadow,
    Clip clipBehavior = Clip.antiAlias,
  }) {
    return circleButton(
      context: context,
      icon: icon,
      onPressed: onPressed,
      size: size,
      sigmaX: sigmaX,
      sigmaY: sigmaY,
      glassColor: glassColor,
      borderColor: borderColor,
      borderWidth: borderWidth,
      border: border,
      margin: margin,
      boxShadow: boxShadow,
      clipBehavior: clipBehavior,
    );
  }

  /// Returns a configured [AppButton] with support for style variants ([AppButtonStyle]).
  Widget appButton({
    Key? key,
    required BuildContext context,
    String? title,
    IconData? icon,
    Widget? child,
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
    BoxBorder? border,
    double sigmaX = 10.0,
    double sigmaY = 10.0,
    List<BoxShadow>? boxShadow,
    Clip clipBehavior = Clip.antiAlias,
  }) {
    return AppButton(
      key: key,
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
      border: border,
      sigmaX: sigmaX,
      sigmaY: sigmaY,
      boxShadow: boxShadow,
      clipBehavior: clipBehavior,
      child: child,
    );
  }

  /// Returns a custom glassmorphic Floating Action Button.
  Widget appFab({
    Key? key,
    required BuildContext context,
    String? title,
    IconData? icon,
    VoidCallback? onPressed,
    AppButtonStyle style = AppButtonStyle.glass,
    double sigmaX = 10.0,
    double sigmaY = 10.0,
    Color? backgroundColor,
    Color? borderColor,
    double? borderWidth,
    BoxBorder? border,
    BorderRadiusGeometry? borderRadius,
    EdgeInsetsGeometry? margin,
    List<BoxShadow>? boxShadow,
  }) {
    return AppFloatingActionButton(
      key: key,
      title: title,
      icon: icon,
      onPressed: onPressed,
      style: style,
      sigmaX: sigmaX,
      sigmaY: sigmaY,
      backgroundColor: backgroundColor,
      borderColor: borderColor,
      borderWidth: borderWidth,
      border: border,
      borderRadius: borderRadius,
      margin: margin,
      boxShadow: boxShadow,
    );
  }

  /// Returns an RTL-aware back navigation button built on [CircleButton].
  Widget backButton(
    BuildContext context, {
    VoidCallback? onTap,
    double sigmaX = 10.0,
    double sigmaY = 10.0,
    Color? glassColor,
    BoxBorder? border,
    EdgeInsetsGeometry? margin,
    List<BoxShadow>? boxShadow,
    Clip clipBehavior = Clip.antiAlias,
  }) {
    return circleButton(
      context: context,
      icon: Icons.chevron_left_rounded,
      sigmaX: sigmaX,
      sigmaY: sigmaY,
      glassColor: glassColor,
      border: border,
      margin: margin,
      boxShadow: boxShadow,
      clipBehavior: clipBehavior,
      onPressed:
          onTap ??
          () {
            if (Navigator.of(context).canPop()) {
              Navigator.pop(context);
            }
          },
    );
  }

  /// Returns a close icon navigation button built on [CircleButton].
  Widget closeButton(
    BuildContext context, {
    double sigmaX = 10.0,
    double sigmaY = 10.0,
    Color? glassColor,
    BoxBorder? border,
    EdgeInsetsGeometry? margin,
    List<BoxShadow>? boxShadow,
    Clip clipBehavior = Clip.antiAlias,
  }) {
    return circleButton(
      context: context,
      icon: Icons.close,
      sigmaX: sigmaX,
      sigmaY: sigmaY,
      glassColor: glassColor,
      border: border,
      margin: margin,
      boxShadow: boxShadow,
      clipBehavior: clipBehavior,
      onPressed: () {
        if (Navigator.of(context).canPop()) {
          Navigator.pop(context);
        }
      },
    );
  }
}

/// A flexible glassmorphic floating action button that supports icon-only, text-only, or both (extended).
class AppFloatingActionButton extends StatelessWidget {
  const AppFloatingActionButton({
    super.key,
    this.title,
    this.icon,
    required this.onPressed,
    this.style = AppButtonStyle.glass,
    this.sigmaX = 10.0,
    this.sigmaY = 10.0,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth,
    this.border,
    this.borderRadius,
    this.margin,
    this.boxShadow,
  }) : assert(
         title != null || icon != null,
         'A FAB must have either a title or an icon.',
       );

  /// Optional text label (makes the FAB extended).
  final String? title;

  /// Optional icon.
  final IconData? icon;

  /// Tap callback.
  final VoidCallback? onPressed;

  /// The visual style of the FAB.
  final AppButtonStyle style;

  final double sigmaX;
  final double sigmaY;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? borderWidth;
  final BoxBorder? border;
  final BorderRadiusGeometry? borderRadius;
  final EdgeInsetsGeometry? margin;
  final List<BoxShadow>? boxShadow;

  @override
  Widget build(BuildContext context) {
    // If it has only an icon, it is circular. If it has text, it is rounded rect (extended).
    final isExtended = title != null;

    if (!isExtended) {
      return CircleButton(
        key: key,
        icon: icon!,
        onPressed: onPressed,
        size: 56.0, // Standard FAB size
        sigmaX: sigmaX,
        sigmaY: sigmaY,
        glassColor: style == AppButtonStyle.glass ? backgroundColor : null,
        borderColor:
            borderColor ??
            (style == AppButtonStyle.outlined
                ? Theme.of(context).primaryColor
                : null),
        borderWidth: borderWidth,
        border: border,
        margin: margin,
        boxShadow: boxShadow,
      );
    }

    return AppButton(
      key: key,
      title: title,
      icon: icon,
      style: style,
      onPressed: onPressed,
      height: 56.0,
      sigmaX: sigmaX,
      sigmaY: sigmaY,
      backgroundColor: backgroundColor,
      borderColor: borderColor,
      // borderWidth: borderWidth,
      border: border,
      borderRadius: borderRadius ?? BorderRadius.circular(16.0),
      margin: margin,
      boxShadow: boxShadow,
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
    );
  }
}
