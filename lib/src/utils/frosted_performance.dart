import 'package:flutter/material.dart';

/// Immutable, resolved performance configuration for every glass surface in
/// `frosted_ui_kit`.
///
/// Obtained through [FrostedPerformance.of]. Widgets never construct this
/// directly; apps configure it by placing a [FrostedPerformance] above their
/// widget tree.
@immutable
class FrostedPerformanceData {
  /// Creates a resolved performance configuration.
  const FrostedPerformanceData({
    this.blurEnabled = true,
    this.blurScale = 1.0,
    this.fallbackOpacity = 0.88,
  }) : assert(blurScale >= 0.0 && blurScale <= 1.0),
       assert(fallbackOpacity >= 0.0 && fallbackOpacity <= 1.0);

  /// Whether backdrop blur is applied at all.
  ///
  /// When `false`, every glass surface skips its `BackdropFilter` entirely and
  /// falls back to a translucent fill of [fallbackOpacity]. Layout, size and
  /// geometry are unchanged, so turning this off never causes a layout shift.
  ///
  /// This is by far the cheapest configuration and is the recommended setting
  /// for low-end devices.
  final bool blurEnabled;

  /// Multiplier applied to every `sigmaX` / `sigmaY` value in the kit.
  ///
  /// Ranges from `0.0` (no blur) to `1.0` (full designed blur). Lowering the
  /// sigma reduces GPU work while keeping the glass look.
  final double blurScale;

  /// Opacity of the solid fill used when [blurEnabled] is `false` and the
  /// surface has no explicit color, so contrast is preserved without a blur.
  final double fallbackOpacity;

  /// Returns a copy of this configuration with the given fields replaced.
  FrostedPerformanceData copyWith({
    bool? blurEnabled,
    double? blurScale,
    double? fallbackOpacity,
  }) {
    return FrostedPerformanceData(
      blurEnabled: blurEnabled ?? this.blurEnabled,
      blurScale: blurScale ?? this.blurScale,
      fallbackOpacity: fallbackOpacity ?? this.fallbackOpacity,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FrostedPerformanceData &&
        other.blurEnabled == blurEnabled &&
        other.blurScale == blurScale &&
        other.fallbackOpacity == fallbackOpacity;
  }

  @override
  int get hashCode => Object.hash(blurEnabled, blurScale, fallbackOpacity);

  @override
  String toString() =>
      'FrostedPerformanceData(blurEnabled: $blurEnabled, '
      'blurScale: $blurScale, fallbackOpacity: $fallbackOpacity)';
}

/// A global switch controlling the cost of every glass surface in
/// `frosted_ui_kit`.
///
/// Backdrop blur is the single most expensive operation in this design system:
/// it forces the GPU to read back the already-rendered backdrop, which breaks
/// the tile-based rendering pipeline used by every mobile GPU. On high-end
/// hardware this is unnoticeable; on entry-level and mid-range devices it is
/// the difference between a smooth and a janky screen.
///
/// Place this above [MaterialApp] (or any subtree) to tune or disable the
/// effect at runtime — for a user-facing "lite mode", for the platform
/// accessibility settings, or for a device-tier check:
///
/// ```dart
/// FrostedPerformance(
///   blurEnabled: !MediaQuery.disableAnimationsOf(context) && !liteMode,
///   blurScale: isLowEndDevice ? 0.5 : 1.0,
///   child: MaterialApp(home: MyHomePage()),
/// )
/// ```
///
/// Presets are available as [full], [balanced] and [lite]:
///
/// ```dart
/// FrostedPerformance.fromData(
///   data: FrostedPerformance.lite,
///   child: MaterialApp(home: MyHomePage()),
/// )
/// ```
///
/// When no [FrostedPerformance] is present in the tree, [defaults] is used and
/// all components behave exactly as they did before this widget existed.
class FrostedPerformance extends InheritedWidget {
  /// Creates a performance scope from individual values.
  FrostedPerformance({
    super.key,
    bool blurEnabled = true,
    double blurScale = 1.0,
    double fallbackOpacity = 0.88,
    required super.child,
  }) : data = FrostedPerformanceData(
         blurEnabled: blurEnabled,
         blurScale: blurScale,
         fallbackOpacity: fallbackOpacity,
       );

  /// Creates a performance scope from an existing [FrostedPerformanceData],
  /// typically one of the [full] / [balanced] / [lite] presets.
  const FrostedPerformance.fromData({
    super.key,
    required this.data,
    required super.child,
  });

  /// The resolved configuration exposed to descendants.
  final FrostedPerformanceData data;

  /// Configuration used when no [FrostedPerformance] exists in the tree.
  ///
  /// Identical to [full], preserving the original look of the kit.
  static const FrostedPerformanceData defaults = FrostedPerformanceData();

  /// Full designed blur. Recommended for flagship devices and desktop.
  static const FrostedPerformanceData full = FrostedPerformanceData();

  /// Half-strength blur. Keeps the glass look at roughly half the GPU cost.
  /// Recommended default for mid-range Android hardware.
  static const FrostedPerformanceData balanced = FrostedPerformanceData(
    blurScale: 0.5,
  );

  /// No backdrop blur at all — translucent fills only.
  ///
  /// The cheapest configuration. Recommended for entry-level devices and when
  /// the platform requests reduced motion or reduced transparency.
  static const FrostedPerformanceData lite = FrostedPerformanceData(
    blurEnabled: false,
  );

  /// Returns the nearest [FrostedPerformanceData], or [defaults] when none is
  /// present. Establishes a dependency so descendants rebuild on change.
  static FrostedPerformanceData of(BuildContext context) {
    return context
            .dependOnInheritedWidgetOfExactType<FrostedPerformance>()
            ?.data ??
        defaults;
  }

  /// Returns the nearest [FrostedPerformanceData], or `null` when none is
  /// present in the tree.
  static FrostedPerformanceData? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<FrostedPerformance>()
        ?.data;
  }

  @override
  bool updateShouldNotify(FrostedPerformance oldWidget) =>
      data != oldWidget.data;
}
