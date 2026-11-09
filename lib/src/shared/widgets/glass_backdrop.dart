import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:frosted_ui_kit/src/utils/frosted_performance.dart';

/// Internal backdrop primitive shared by all kit glass surfaces.
///
/// Bounds each filter to its shape, applies performance settings once, and
/// avoids adding another blur inside an already blurred ancestor surface.
/// Independent sibling surfaces retain independent filters: overlapping glass
/// must not share a backdrop key automatically.
class GlassBackdrop extends StatelessWidget {
  /// Creates a bounded backdrop without changing the child's decoration.
  const GlassBackdrop({
    super.key,
    required this.child,
    required this.sigmaX,
    required this.sigmaY,
    this.enabled = true,
    this.shape = BoxShape.rectangle,
    this.borderRadius = BorderRadius.zero,
    this.clipBehavior = Clip.hardEdge,
  });

  /// Decorated surface and its content.
  final Widget child;

  /// Unscaled horizontal blur sigma.
  final double sigmaX;

  /// Unscaled vertical blur sigma.
  final double sigmaY;

  /// Local blur opt-out; global performance settings still take precedence.
  final bool enabled;

  /// Bounds shape.
  final BoxShape shape;

  /// Bounds radius for rectangular surfaces.
  final BorderRadiusGeometry borderRadius;

  /// Clipping quality, retained from the calling component.
  final Clip clipBehavior;

  @override
  Widget build(BuildContext context) {
    final settings = FrostedPerformance.of(context);
    final ancestor = context.dependOnInheritedWidgetOfExactType<_GlassScope>();
    final x = sigmaX * settings.blurScale;
    final y = sigmaY * settings.blurScale;
    if (!enabled ||
        !settings.blurEnabled ||
        (x == 0 && y == 0) ||
        ancestor != null) {
      return child;
    }
    final filtered = BackdropFilter(
      filter: ImageFilter.blur(sigmaX: x, sigmaY: y),
      child: _GlassScope(child: child),
    );
    return shape == BoxShape.circle
        ? ClipOval(clipBehavior: clipBehavior, child: filtered)
        : ClipRRect(
            borderRadius: borderRadius,
            clipBehavior: clipBehavior,
            child: filtered,
          );
  }
}

class _GlassScope extends InheritedWidget {
  const _GlassScope({required super.child});
  @override
  bool updateShouldNotify(_GlassScope oldWidget) => false;
}
