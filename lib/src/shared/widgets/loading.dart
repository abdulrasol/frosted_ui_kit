import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

/// A generic glassmorphic loading indicator built on a Lottie animation.
///
/// Use this widget as a replacement for standard [CircularProgressIndicator].
class AppLoadingIndicator extends StatelessWidget {
  /// Creates an [AppLoadingIndicator].
  const AppLoadingIndicator({super.key, this.size = 64.0, this.color});

  /// The size (width and height) of the animation.
  final double size;

  /// Optional color filter to apply to the lottie animation.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      'assets/lottie/loading.json',
      package: 'frosted_ui_kit',
      width: size,
      height: size,
      fit: BoxFit.contain,
      delegates: color != null
          ? LottieDelegates(
              values: [
                ValueDelegate.color(const ['**'], value: color!),
              ],
            )
          : null,
    );
  }
}
