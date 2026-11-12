import 'package:material_ui/material_ui.dart';
import 'package:frosted_ui_kit/src/utils/frosted_theme.dart';

/// Shared responsive layout for dialog and bottom-sheet surfaces.
///
/// On normal viewports the header and actions remain visible while only the
/// body scrolls. When the available height is very small, all regions share a
/// single scroll view so no content becomes unreachable.
class FrostedAdaptiveSurfaceLayout extends StatelessWidget {
  /// Creates a responsive header/body/actions surface layout.
  const FrostedAdaptiveSurfaceLayout({
    super.key,
    required this.body,
    this.header,
    this.actions,
    this.spacing,
    this.pinnedActionsMinHeight = 240,
    this.crossAxisAlignment = CrossAxisAlignment.stretch,
  });

  /// Optional non-scrolling header on regular-height viewports.
  final Widget? header;

  /// Main scrollable surface content.
  final Widget body;

  /// Optional action footer kept visible when height allows.
  final Widget? actions;

  /// Gap between regions; null uses [FrostedThemeData.spacing].
  final double? spacing;

  /// Minimum finite height required to pin [actions].
  final double pinnedActionsMinHeight;

  /// Cross-axis alignment for the shared surface regions.
  ///
  /// The default stretches modern action footers to the available width.
  /// Dialogs may use [CrossAxisAlignment.center] to retain the compact width
  /// behavior of their legacy child-only API.
  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    final gap = spacing ?? FrostedThemeData.of(context).spacing;
    return LayoutBuilder(
      builder: (context, constraints) {
        final textScale = MediaQuery.textScalerOf(context).scale(1);
        final requiredPinnedHeight =
            pinnedActionsMinHeight * textScale.clamp(1.0, 1.75);
        final canPinActions =
            actions != null &&
            constraints.maxHeight.isFinite &&
            constraints.maxHeight >= requiredPinnedHeight;

        if (!canPinActions) {
          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: crossAxisAlignment,
              children: [
                if (header != null) ...[header!, SizedBox(height: gap)],
                body,
                if (actions != null) ...[SizedBox(height: gap), actions!],
              ],
            ),
          );
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: crossAxisAlignment,
          children: [
            if (header != null) ...[header!, SizedBox(height: gap)],
            Flexible(child: SingleChildScrollView(child: body)),
            SizedBox(height: gap),
            actions!,
          ],
        );
      },
    );
  }
}

/// Responsive two-action footer shared by dialogs and bottom sheets.
///
/// Actions are displayed horizontally when they have enough room. Narrow
/// surfaces and large accessibility text stack them vertically with full-width
/// touch targets, preserving secondary-before-primary ordering.
class FrostedAdaptiveActions extends StatelessWidget {
  /// Creates an adaptive secondary/primary action group.
  const FrostedAdaptiveActions({
    super.key,
    required this.primary,
    this.secondary,
    this.spacing,
    this.stackBelow = 360,
    this.stackAtTextScale = 1.3,
  });

  /// Main or destructive action.
  final Widget primary;

  /// Optional safe or cancel action.
  final Widget? secondary;

  /// Gap between actions; null uses [FrostedThemeData.spacing].
  final double? spacing;

  /// Width below which actions stack vertically.
  final double stackBelow;

  /// Accessibility text scale at which actions stack vertically.
  final double stackAtTextScale;

  @override
  Widget build(BuildContext context) {
    final secondaryAction = secondary;
    if (secondaryAction == null) return primary;
    final gap = spacing ?? FrostedThemeData.of(context).spacing;
    return LayoutBuilder(
      builder: (context, constraints) {
        final textScale = MediaQuery.textScalerOf(context).scale(1);
        final stack =
            constraints.maxWidth < stackBelow || textScale >= stackAtTextScale;
        if (stack) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              secondaryAction,
              SizedBox(height: gap),
              primary,
            ],
          );
        }
        return Row(
          children: [
            Expanded(child: secondaryAction),
            SizedBox(width: gap),
            Expanded(child: primary),
          ],
        );
      },
    );
  }
}
