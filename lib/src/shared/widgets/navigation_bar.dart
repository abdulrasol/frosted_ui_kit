import 'package:flutter/material.dart';
import 'package:frosted_ui_kit/src/shared/widgets/cards.dart';

/// Controller for managing the active state of [FrostedNavigationButtomBar].
class FrostedNavbarController extends ValueNotifier<int> {
  /// Creates a controller with an optional initial index.
  FrostedNavbarController({int initialIndex = 0}) : super(initialIndex);

  /// Gets the currently selected index.
  int get selectedIndex => value;

  /// Sets the currently selected index.
  set selectedIndex(int newIndex) => value = newIndex;
}

/// A glassmorphic bottom navigation bar that wraps a row of [FrostedNavbarItem]s.
class FrostedNavigationButtomBar extends StatefulWidget {
  /// Creates a floating glassmorphic navigation bar.
  const FrostedNavigationButtomBar({
    super.key,
    required this.items,
    required this.controller,
    this.action,
  });

  /// The list of items to display in the navigation bar.
  final List<FrostedNavbarItem> items;

  /// Controller managing the active tab state.
  final FrostedNavbarController controller;

  /// Optional action widget (like a FAB) displayed at the end of the bar.
  final Widget? action;

  @override
  State<FrostedNavigationButtomBar> createState() => _FrostedNavigationButtomBarState();
}

class _FrostedNavigationButtomBarState extends State<FrostedNavigationButtomBar> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: BlurredCard(
                borderRadius: BorderRadius.circular(32),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5), width: 1),
                sigmaX: 20,
                sigmaY: 20,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(widget.items.length, (index) {
                    return _FrostedNavbarItemWidget(
                      item: widget.items[index],
                      index: index,
                      controller: widget.controller,
                    );
                  }),
                ),
              ),
            ),
            if (widget.action != null) ...[const SizedBox(width: 8), widget.action!],
          ],
        ),
      ),
    );
  }
}

/// A single interactive item data model for [FrostedNavigationButtomBar].
class FrostedNavbarItem {
  /// Creates an item to be displayed in a [FrostedNavigationButtomBar].
  const FrostedNavbarItem({
    required this.icon,
    this.title,
    this.activeIcon,
    this.onTap,
    this.color,
    this.badgeCount,
  });

  /// The default icon displayed when the item is not selected.
  final IconData icon;

  /// Icon Color
  final Color? color;

  /// Optional custom icon displayed when the item is selected.
  final IconData? activeIcon;

  /// The text label displayed below the icon.
  final String? title;

  /// Optional badge count to display.
  final int? badgeCount;

  /// Callback executed when this item is tapped.
  final VoidCallback? onTap;
}

class _FrostedNavbarItemWidget extends StatefulWidget {
  const _FrostedNavbarItemWidget({
    required this.item,
    required this.index,
    required this.controller,
  });

  final FrostedNavbarItem item;
  final int index;
  final FrostedNavbarController controller;

  @override
  State<_FrostedNavbarItemWidget> createState() => _FrostedNavbarItemWidgetState();
}

class _FrostedNavbarItemWidgetState extends State<_FrostedNavbarItemWidget> with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.85).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _scaleController.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _scaleController.reverse();
    widget.controller.selectedIndex = widget.index;
    widget.item.onTap?.call();
  }

  void _handleTapCancel() {
    _scaleController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeColor = theme.colorScheme.primary;
    final inactiveColor = widget.item.color ?? theme.colorScheme.onSurfaceVariant;

    return Expanded(
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        behavior: HitTestBehavior.opaque,
        child: ValueListenableBuilder<int>(
          valueListenable: widget.controller,
          builder: (context, currentIndex, _) {
            final isActive = widget.index == currentIndex;
            final currentColor = isActive ? activeColor : inactiveColor;

            return AnimatedBuilder(
              animation: _scaleAnimation,
              builder: (context, child) => Transform.scale(
                scale: _scaleAnimation.value,
                child: child,
              ),
              child: AnimatedContainer(
                width: double.infinity,
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutCubic,
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                decoration: BoxDecoration(
                  color: isActive ? activeColor.withValues(alpha: 0.15) : Colors.transparent,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TweenAnimationBuilder<Color?>(
                  duration: const Duration(milliseconds: 250),
                  tween: ColorTween(end: currentColor),
                  builder: (context, color, _) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.item.badgeCount != null && widget.item.badgeCount! > 0)
                          Badge(
                            label: Text(widget.item.badgeCount.toString()),
                            backgroundColor: theme.colorScheme.error,
                            child: Icon(
                              isActive ? (widget.item.activeIcon ?? widget.item.icon) : widget.item.icon,
                              color: color,
                              size: 24,
                            ),
                          )
                        else
                          Icon(
                            isActive ? (widget.item.activeIcon ?? widget.item.icon) : widget.item.icon,
                            color: color,
                            size: 24,
                          ),

                        if (widget.item.title != null) ...[
                          const SizedBox(height: 4),
                          Flexible(
                            child: Text(
                              widget.item.title!,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: color,
                                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ],
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
