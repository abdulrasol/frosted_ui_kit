import 'package:flutter/material.dart';
import 'package:frosted_ui_kit/src/shared/widgets/cards.dart';

/// A reusable glassmorphic sliding tabs widget with press and smooth animated slide indicators (RTL aware).
class AppSlidingTabs extends StatelessWidget with Cards {
  /// Creates an [AppSlidingTabs] widget.
  AppSlidingTabs({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onTabChanged,
    this.height = 46,
    this.padding,
    this.margin,
    this.borderRadius,
    this.activeTextStyle,
    this.inactiveTextStyle,
    this.sigmaX = 10.0,
    this.sigmaY = 10.0,
    this.glassColor,
    this.border,
    this.boxShadow,
    this.clipBehavior = Clip.antiAlias,
  });

  /// List of tab label titles.
  final List<String> tabs;

  /// Currently selected tab index.
  final int selectedIndex;

  /// Callback triggered when a tab is tapped or swiped.
  final ValueChanged<int> onTabChanged;

  /// Total height of the tabs container card.
  final double height;

  /// Inner padding around the tab container.
  final EdgeInsetsGeometry? padding;

  /// Outer margin surrounding the tabs widget.
  final EdgeInsetsGeometry? margin;

  /// Custom border radius geometry.
  final BorderRadiusGeometry? borderRadius;

  /// Text style for the active selected tab label.
  final TextStyle? activeTextStyle;

  /// Text style for inactive tab labels.
  final TextStyle? inactiveTextStyle;

  /// Horizontal backdrop blur intensity (defaults to 10.0).
  final double sigmaX;

  /// Vertical backdrop blur intensity (defaults to 10.0).
  final double sigmaY;

  /// Custom translucent background color tint.
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
    final effectiveRadius = borderRadius ?? BorderRadius.circular(16);
    final count = tabs.length;

    if (count == 0) return const SizedBox.shrink();

    // Check if current locale layout direction is Right-To-Left (RTL)
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    // Calculate x alignment for AnimatedAlign (-1.0 to 1.0) and invert for RTL
    final double rawAlignX = count > 1
        ? -1.0 + (2.0 * selectedIndex / (count - 1))
        : 0.0;
    final double alignX = isRtl ? -rawAlignX : rawAlignX;

    return bluredCard(
      context: context,
      height: height,
      margin: margin,
      padding: padding ?? const EdgeInsets.all(4),
      borderRadius: effectiveRadius,
      sigmaX: sigmaX,
      sigmaY: sigmaY,
      color: glassColor,
      border: border,
      boxShadow: boxShadow,
      clipBehavior: clipBehavior,
      child: Stack(
        children: [
          // Smooth Animated Sliding Indicator Pill
          AnimatedAlign(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            alignment: Alignment(alignX, 0.0),
            child: FractionallySizedBox(
              widthFactor: 1.0 / count,
              heightFactor: 1.0,
              child: Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.primary.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Interactive Tab Labels Layer
          Row(
            children: List.generate(count, (index) {
              final isSelected = index == selectedIndex;
              return Expanded(
                child: InkWell(
                  onTap: () => onTabChanged(index),
                  borderRadius: BorderRadius.circular(12),
                  child: Center(
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style:
                          (isSelected
                              ? (activeTextStyle ??
                                    theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: theme.colorScheme.onPrimary,
                                    ))
                              : (inactiveTextStyle ??
                                    theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ))) ??
                          const TextStyle(),
                      child: Text(
                        tabs[index],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

/// A mixin providing utility methods for constructing sliding segmented tabs.
mixin Tabs {
  /// Returns a configured [AppSlidingTabs] widget instance.
  Widget appSlidingTabs({
    Key? key,
    required BuildContext context,
    required List<String> tabs,
    required int selectedIndex,
    required ValueChanged<int> onTabChanged,
    double height = 46,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    BorderRadiusGeometry? borderRadius,
    TextStyle? activeTextStyle,
    TextStyle? inactiveTextStyle,
    double sigmaX = 10.0,
    double sigmaY = 10.0,
    Color? glassColor,
    BoxBorder? border,
    List<BoxShadow>? boxShadow,
    Clip clipBehavior = Clip.antiAlias,
  }) {
    return AppSlidingTabs(
      key: key,
      tabs: tabs,
      selectedIndex: selectedIndex,
      onTabChanged: onTabChanged,
      height: height,
      padding: padding,
      margin: margin,
      borderRadius: borderRadius,
      activeTextStyle: activeTextStyle,
      inactiveTextStyle: inactiveTextStyle,
      sigmaX: sigmaX,
      sigmaY: sigmaY,
      glassColor: glassColor,
      border: border,
      boxShadow: boxShadow,
      clipBehavior: clipBehavior,
    );
  }
}
