import 'package:flutter/material.dart';
import 'package:frosted_ui_kit/frosted_ui_kit.dart';

/// A standardized glassmorphic bottom sheet container widget built on [BlurredCard].
class AppBottomSheet extends StatelessWidget {
  /// Creates an [AppBottomSheet] with customizable glass effects, title, and content.
  const AppBottomSheet({
    super.key,
    required this.child,
    this.title,
    this.padding,
    this.margin,
    this.borderRadius,
    this.height,
    this.sigmaX = 15.0,
    this.sigmaY = 15.0,
    this.glassColor,
    this.border,
    this.boxShadow,
    this.clipBehavior = Clip.antiAlias,
  });

  /// The child content widget displayed inside the bottom sheet.
  final Widget child;

  /// Optional header title string.
  final String? title;

  /// Inner padding for the bottom sheet container.
  final EdgeInsetsGeometry? padding;

  /// Outer margin surrounding the bottom sheet container.
  final EdgeInsetsGeometry? margin;

  /// Custom border radius geometry.
  final BorderRadiusGeometry? borderRadius;

  /// Optional height for the bottom sheet.
  final double? height;

  /// Horizontal backdrop blur intensity (defaults to 15.0).
  final double sigmaX;

  /// Vertical backdrop blur intensity (defaults to 15.0).
  final double sigmaY;

  /// Optional translucent background color tint.
  final Color? glassColor;

  /// Optional custom border decoration override.
  final BoxBorder? border;

  /// Optional list of box shadows applied to the card container.
  final List<BoxShadow>? boxShadow;

  /// Content clipping behavior (defaults to [Clip.antiAlias]).
  final Clip clipBehavior;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveRadius = borderRadius ?? const BorderRadius.vertical(top: Radius.circular(28));
    final defaultColor = glassColor ?? theme.colorScheme.surface.withValues(alpha: 0.85);

    return BlurredCard(
      height: height,
      margin: margin,
      padding: padding ?? EdgeInsets.symmetric(vertical: 12, horizontal: context.horizontalPadding),
      borderRadius: effectiveRadius,
      sigmaX: sigmaX,
      sigmaY: sigmaY,
      color: defaultColor,
      border: border,
      boxShadow: boxShadow,
      clipBehavior: clipBehavior,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Top drag handle indicator
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4), borderRadius: BorderRadius.circular(2)),
            ),
          ),
          if (title != null) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title!, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                IconButton(icon: const Icon(Icons.close_rounded), onPressed: () => Navigator.pop(context)),
              ],
            ),
            const SizedBox(height: 12),
          ],
          Flexible(child: SingleChildScrollView(child: child)),
          SizedBox(height: MediaQuery.viewInsetsOf(context).bottom),
        ],
      ),
    );
  }
}

/// A mixin providing utility methods for displaying standardized bottom sheets.
mixin BottomSheets {
  /// Displays a standardized [AppBottomSheet] modal built on [BlurredCard].
  Future<T?> showAppBottomSheet<T>({
    required BuildContext context,
    required Widget child,
    String? title,
    bool isScrollControlled = true,
    bool enableDrag = true,
    bool isDismissible = true,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    BorderRadiusGeometry? borderRadius,
    double? height,
    double sigmaX = 15.0,
    double sigmaY = 15.0,
    Color? glassColor,
    BoxBorder? border,
    List<BoxShadow>? boxShadow,
    Clip clipBehavior = Clip.antiAlias,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      enableDrag: enableDrag,
      isDismissible: isDismissible,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return AppBottomSheet(
          title: title,
          padding: padding,
          margin: margin,
          borderRadius: borderRadius,
          height: height,
          sigmaX: sigmaX,
          sigmaY: sigmaY,
          glassColor: glassColor,
          border: border,
          boxShadow: boxShadow,
          clipBehavior: clipBehavior,
          child: child,
        );
      },
    );
  }
}
