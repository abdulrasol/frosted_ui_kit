import 'package:material_ui/material_ui.dart';
import 'package:frosted_ui_kit/src/shared/widgets/buttons.dart';
import 'package:frosted_ui_kit/src/shared/widgets/cards.dart';
import 'package:frosted_ui_kit/src/utils/frosted_theme.dart';

/// Controls how the default app bar reacts to body scrolling.
enum AppBarScrollBehavior {
  /// Keeps the app bar visible.
  none,

  /// Hides the complete floating app bar while scrolling down.
  hideAll,

  /// Keeps the app bar controls visible and collapses its title.
  collapseTitle,
}

/// A modern, glassmorphic primary application bar with auto-fitting title and end-aligned actions.
class FrostedAppBar extends StatelessWidget
    with Buttons, Cards
    implements PreferredSizeWidget {
  /// Creates a [FrostedAppBar] with optional title string, custom title widget, leading widget, and actions.
  const FrostedAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.leading,
    this.actions,
    this.backAction,
    this.titleCollapsed = false,
    this.sigmaX,
    this.sigmaY,
    this.glassColor,
    this.border,
    this.borderRadius,
    this.padding,
    this.margin,
    this.boxShadow,
  });

  /// Text title displayed inside a blurred glass card.
  final String? title;

  /// Custom widget replacing the default title text card.
  final Widget? titleWidget;

  /// Optional custom leading widget displayed before the title.
  final Widget? leading;

  /// Optional custom back action.
  final VoidCallback? backAction;

  /// Whether the title content should be visually collapsed.
  ///
  /// Leading and action widgets remain available when this is true.
  final bool titleCollapsed;

  /// List of trailing action widgets positioned on the far right.
  final List<Widget>? actions;

  /// Horizontal backdrop blur intensity (defaults to 6.0).
  final double? sigmaX;

  /// Vertical backdrop blur intensity (defaults to 6.0).
  final double? sigmaY;

  /// Custom translucent background color tint.
  final Color? glassColor;

  /// Optional custom border decoration override.
  final BoxBorder? border;

  /// Custom border radius geometry.
  final BorderRadiusGeometry? borderRadius;

  /// Inner padding surrounding the title text inside the container.
  final EdgeInsetsGeometry? padding;

  /// Outer margin surrounding the title container card.
  final EdgeInsetsGeometry? margin;

  /// Optional list of box shadows applied to the card container.
  final List<BoxShadow>? boxShadow;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultTitleColor = theme.brightness == Brightness.dark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.white.withValues(alpha: 0.20);
    final canPop = Navigator.of(context).canPop();
    return SafeArea(
      top: true,
      bottom: false,
      child: Container(
        margin: const EdgeInsets.all(5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              spacing: 8,
              children: [
                if (leading != null)
                  leading!
                else if (canPop)
                  backButton(context, onTap: backAction)
                else
                  const SizedBox.shrink(),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    spacing: 8,
                    children: [
                      if (titleWidget != null)
                        Flexible(
                          fit: FlexFit.loose,
                          child: AnimatedOpacity(
                            opacity: titleCollapsed ? 0 : 1,
                            duration: const Duration(milliseconds: 180),
                            child: ExcludeSemantics(
                              excluding: titleCollapsed,
                              child: titleWidget!,
                            ),
                          ),
                        )
                      else if (title != null)
                        Flexible(
                          fit: FlexFit.loose,
                          child: AnimatedOpacity(
                            opacity: titleCollapsed ? 0 : 1,
                            duration: const Duration(milliseconds: 180),
                            child: ExcludeSemantics(
                              excluding: titleCollapsed,
                              child: blurredCard(
                                padding:
                                    padding ??
                                    const EdgeInsets.symmetric(horizontal: 16),
                                margin: margin,
                                borderRadius: borderRadius,
                                border: border,
                                sigmaX:
                                    sigmaX ??
                                    FrostedThemeData.of(context).appBarBlur,
                                sigmaY:
                                    sigmaY ??
                                    FrostedThemeData.of(context).appBarBlur,
                                // Keep the title surface visually aligned with
                                // water-drop controls on Android, where the
                                // card fallback intentionally skips blur.
                                color: glassColor ?? defaultTitleColor,
                                boxShadow: boxShadow,
                                height: 48,
                                context: context,
                                child: Center(
                                  widthFactor: 1.0,
                                  child: Text(
                                    title!,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      else
                        const SizedBox.shrink(),
                      if (actions != null && actions!.isNotEmpty)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          spacing: 8,
                          children: actions!,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
