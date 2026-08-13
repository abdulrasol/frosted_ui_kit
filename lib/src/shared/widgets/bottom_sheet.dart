import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:starter/src/utils/app_themes.dart';

/// A standardized glassmorphic bottom sheet widget container.
class AppBottomSheet extends StatelessWidget {
  /// Creates an [AppBottomSheet].
  const AppBottomSheet({super.key, required this.child, this.title, this.padding, this.margin, this.borderRadius, this.height});

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveRadius = borderRadius ?? const BorderRadius.vertical(top: Radius.circular(28));

    return ClipRRect(
      borderRadius: effectiveRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          height: height,
          margin: margin,
          padding: padding ?? const EdgeInsets.fromLTRB(24, 12, 24, 24),
          decoration: BoxDecoration(color: theme.colorScheme.surface.withValues(alpha: 0.85), border: AppThemes.border, borderRadius: effectiveRadius),
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
        ),
      ),
    );
  }
}

/// A mixin providing utility methods for displaying standardized bottom sheets.
mixin BottomSheets {
  /// Displays a standardized [AppBottomSheet] modal.
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
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      enableDrag: enableDrag,
      isDismissible: isDismissible,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return AppBottomSheet(title: title, padding: padding, margin: margin, borderRadius: borderRadius, height: height, child: child);
      },
    );
  }
}
