import 'package:flutter/material.dart';
import 'package:frosted_ui_kit/src/shared/widgets/cards.dart';

/// A glassmorphic list section that groups multiple [FrostedListTile]s together.
class FrostedListSection extends StatelessWidget {
  const FrostedListSection({
    super.key,
    this.header,
    required this.children,
    this.margin = const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    this.separatorColor,
    this.sigmaX = 10.0,
    this.sigmaY = 10.0,
    this.backgroundColor,
  });

  /// Optional header widget displayed above the section (usually a Text widget).
  final Widget? header;

  /// The list of child tiles, typically [FrostedListTile].
  final List<Widget> children;

  /// Outer margin surrounding the section.
  final EdgeInsetsGeometry margin;

  /// The color of the separator line between tiles.
  final Color? separatorColor;

  /// Horizontal backdrop blur intensity.
  final double sigmaX;

  /// Vertical backdrop blur intensity.
  final double sigmaY;

  /// Background color for the glass container.
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveSeparatorColor = separatorColor ?? theme.dividerColor.withValues(alpha: 0.1);

    return Padding(
      padding: margin,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (header != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0, left: 16.0, right: 16.0),
              child: header,
            ),
          BlurredCard(
            sigmaX: sigmaX,
            sigmaY: sigmaY,
            color: backgroundColor,
            padding: EdgeInsets.zero,
            margin: EdgeInsets.zero,
            radius: 16.0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: Column(
                children: [
                  for (int i = 0; i < children.length; i++) ...[
                    children[i],
                    if (i < children.length - 1)
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: effectiveSeparatorColor,
                        indent: 16,
                        endIndent: 16,
                      ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A glassmorphic list tile to be used inside a [FrostedListSection].
class FrostedListTile extends StatelessWidget {
  const FrostedListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.additionalInfo,
    this.onTap,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    this.leadingSize = 40.0,
    this.backgroundColor,
  });

  /// The primary content of the list tile.
  final Widget title;

  /// Additional content displayed below the title.
  final Widget? subtitle;

  /// A widget to display before the title.
  final Widget? leading;

  /// A widget to display after the title.
  final Widget? trailing;

  /// Additional widget displayed before the trailing widget.
  final Widget? additionalInfo;

  /// Called when the user taps this list tile.
  final VoidCallback? onTap;

  /// Padding around the content of the tile.
  final EdgeInsetsGeometry padding;

  /// The constrained size of the leading widget.
  final double leadingSize;

  /// Background color of the tile (overrides section background if needed).
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget content = Padding(
      padding: padding,
      child: Row(
        children: [
          if (leading != null) ...[
            SizedBox(
              width: leadingSize,
              height: leadingSize,
              child: Center(child: leading),
            ),
            const SizedBox(width: 16),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DefaultTextStyle(
                  style: theme.textTheme.bodyLarge ?? const TextStyle(),
                  child: title,
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  DefaultTextStyle(
                    style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                        ) ??
                        const TextStyle(),
                    child: subtitle!,
                  ),
                ],
              ],
            ),
          ),
          if (additionalInfo != null) ...[
            const SizedBox(width: 8),
            DefaultTextStyle(
              style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                  ) ??
                  const TextStyle(),
              child: additionalInfo!,
            ),
          ],
          if (trailing != null) ...[
            const SizedBox(width: 8),
            trailing!,
          ],
        ],
      ),
    );

    if (backgroundColor != null) {
      content = ColoredBox(
        color: backgroundColor!,
        child: content,
      );
    }

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        splashColor: theme.primaryColor.withValues(alpha: 0.1),
        highlightColor: theme.primaryColor.withValues(alpha: 0.05),
        child: content,
      );
    }

    return content;
  }
}
