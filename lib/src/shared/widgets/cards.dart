import 'package:flutter/material.dart';
import 'glass_backdrop.dart';
import 'package:frosted_ui_kit/src/utils/frosted_performance.dart';
import 'package:frosted_ui_kit/src/utils/app_themes.dart';
import 'package:frosted_ui_kit/src/utils/frosted_theme.dart';

/// A reusable glassmorphic container card with backdrop blur, customizable dimensions,
/// border highlights, background tint, and shadow support.
///
/// Serves as the central glass foundation for all glassmorphic components in `frosted_ui_kit`.
class BlurredCard extends StatelessWidget {
  /// Creates a [BlurredCard] glassmorphic container with comprehensive customization options.
  const BlurredCard({
    super.key,
    required this.child,
    this.borderRadius,
    this.height,
    this.width,
    this.radius,
    this.margin,
    this.padding,
    this.border,
    this.sigmaX,
    this.sigmaY,
    this.color,
    this.boxShadow,
    this.shape = BoxShape.rectangle,
    this.clipBehavior =
        Clip.hardEdge, // Using hardEdge is significantly faster than antiAlias
    this.disableBlur, // Option to disable blur on low-end devices (defaults to Android auto-disable if left null)
  });

  /// The child widget displayed within the glassmorphic card.
  final Widget child;

  /// Optional border radius geometry overriding the default rounded corners.
  final BorderRadiusGeometry? borderRadius;

  /// Explicit height for the container card.
  final double? height;

  /// Explicit width for the container card.
  final double? width;

  /// Circular corner radius value used when [borderRadius] is omitted (defaults to 50).
  final double? radius;

  /// Outer margin surrounding the container card.
  final EdgeInsetsGeometry? margin;

  /// Inner padding surrounding the child widget inside the container.
  final EdgeInsetsGeometry? padding;

  /// Optional border decoration override (defaults to [AppThemes.border]).
  final BoxBorder? border;

  /// Horizontal backdrop blur intensity.
  final double? sigmaX;

  /// Vertical backdrop blur intensity.
  final double? sigmaY;

  /// Custom translucent background color tint (defaults to primary color with 0.1 alpha).
  final Color? color;

  /// Optional list of box shadows applied to the card container.
  final List<BoxShadow>? boxShadow;

  /// Shape of the container box (defaults to [BoxShape.rectangle]).
  final BoxShape shape;

  /// Content clipping behavior.
  final Clip clipBehavior;

  /// If true, completely disables the BackdropFilter and relies only on the background color's opacity.
  /// If null, follows the explicit performance scope, or disables blur on Android
  /// when no scope is provided. Global disabled settings always take precedence.
  final bool? disableBlur;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = FrostedThemeData.of(context);
    final performance = FrostedPerformance.of(context);
    final blurX = sigmaX ?? tokens.glassBlur;
    final blurY = sigmaY ?? tokens.glassBlur;

    final shouldDisableBlur = !FrostedPerformance.shouldBlur(
      context,
      disableBlur: disableBlur,
    );

    // If blur is disabled, we need a solid-like background to maintain readability and luxury feel (like Telegram/X)
    final defaultColor =
        color ??
        tokens.surfaceColor ??
        (shouldDisableBlur
            ? theme.colorScheme.surface.withValues(
                alpha: performance.blurEnabled
                    ? 0.85
                    : performance.fallbackOpacity,
              )
            : theme.primaryColor.withValues(alpha: 0.1));
    final effectiveBorderRadius = shape == BoxShape.circle
        ? null
        : (borderRadius ??
              BorderRadius.circular(radius ?? tokens.surfaceRadius));

    final containerWidget = Container(
      height: height,
      width: width,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: defaultColor,
        border: border ?? AppThemes.border(context),
        borderRadius: effectiveBorderRadius,
        shape: shape,
        boxShadow: boxShadow,
      ),
      child: child,
    );

    return GlassBackdrop(
      enabled: !shouldDisableBlur,
      sigmaX: blurX,
      sigmaY: blurY,
      shape: shape,
      borderRadius: effectiveBorderRadius ?? BorderRadius.zero,
      clipBehavior: clipBehavior,
      child: containerWidget,
    );
  }
}

/// Legacy alias for [BlurredCard] to maintain backwards compatibility.
@Deprecated('Use BlurredCard instead. This alias remains for compatibility.')
typedef BluredCard = BlurredCard;

/// A mixin providing utility methods for constructing glassmorphic card widgets.
mixin Cards {
  /// Helper method returning a configured [BlurredCard] instance.
  Widget blurredCard({
    Key? key,
    required BuildContext context,
    required Widget child,
    BorderRadiusGeometry? borderRadius,
    double? height,
    double? width,
    double? radius,
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? padding,
    BoxBorder? border,
    double? sigmaX,
    double? sigmaY,
    Color? color,
    List<BoxShadow>? boxShadow,
    BoxShape shape = BoxShape.rectangle,
    Clip clipBehavior = Clip.hardEdge,
    bool? disableBlur,
  }) {
    return BlurredCard(
      key: key,
      borderRadius: borderRadius,
      height: height,
      width: width,
      radius: radius,
      margin: margin,
      padding: padding,
      border: border,
      sigmaX: sigmaX,
      sigmaY: sigmaY,
      color: color,
      boxShadow: boxShadow,
      shape: shape,
      clipBehavior: clipBehavior,
      disableBlur: disableBlur,
      child: child,
    );
  }

  /// Legacy alias for [blurredCard].
  @Deprecated('Use blurredCard instead. This method remains for compatibility.')
  Widget bluredCard({
    Key? key,
    required BuildContext context,
    required Widget child,
    BorderRadiusGeometry? borderRadius,
    double? height,
    double? width,
    double? radius,
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? padding,
    BoxBorder? border,
    double? sigmaX,
    double? sigmaY,
    Color? color,
    List<BoxShadow>? boxShadow,
    BoxShape shape = BoxShape.rectangle,
    Clip clipBehavior = Clip.hardEdge,
    bool? disableBlur,
  }) {
    return blurredCard(
      context: context,
      borderRadius: borderRadius,
      height: height,
      width: width,
      radius: radius,
      margin: margin,
      padding: padding,
      border: border,
      sigmaX: sigmaX,
      sigmaY: sigmaY,
      color: color,
      boxShadow: boxShadow,
      shape: shape,
      clipBehavior: clipBehavior,
      disableBlur: disableBlur,
      child: child,
    );
  }
}
