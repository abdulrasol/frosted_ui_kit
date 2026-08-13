import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:starter/src/utils/app_themes.dart';

/// A reusable glassmorphic container card with backdrop blur and customizable dimensions.
class BluredCard extends StatelessWidget {
  /// Creates a [BluredCard] container with optional padding, margin, radius, and dimensions.
  const BluredCard({super.key, required this.child, this.borderRadius, this.height, this.width, this.radius, this.margin, this.padding, this.border});

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

  /// Optional border
  final BoxBorder? border;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(radius ?? 50),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          height: height,
          width: width,
          margin: margin,
          padding: padding,
          decoration: BoxDecoration(border: border ?? AppThemes.border, borderRadius: borderRadius ?? BorderRadius.circular(radius ?? 50)),
          child: child,
        ),
      ),
    );
  }
}

/// A mixin providing utility methods for constructing glassmorphic card widgets.
mixin Cards {
  /// Helper method returning a configured [BluredCard] instance.
  Widget bluredCard({
    required BuildContext context,
    required Widget child,
    BorderRadiusGeometry? borderRadius,
    double? height,
    double? width,
    double? radius,
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? padding,
    BoxBorder? border,
  }) {
    return BluredCard(borderRadius: borderRadius, height: height, width: width, radius: radius, margin: margin, padding: padding, border: border, child: child);
  }
}
