import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:frosted_ui_kit/frosted_ui_kit.dart';

/// A foundational screen wrapper widget providing a consistent layout structure.
///
/// Wraps the content in a [Scaffold] and automatically adds a [FrostedAppBar]
/// at the top unless a custom appbar is provided or [isHideAppbar] is true.
class BaseWidget extends StatefulWidget {
  /// Creates a [BaseWidget] screen wrapper.
  const BaseWidget({
    super.key,
    required this.child,
    this.appbar,
    this.floatingActionButton,
    this.isHideAppbar = false,
    this.hideAppBarOnScroll = false,
    this.appBarScrollBehavior = AppBarScrollBehavior.none,
    this.hideAfter = 16,
    this.showAfter = 8,
    this.showStatusBarGradient = true,
    this.title,
    this.titleWidget,
    this.actions,
    this.backAction,
    this.bottomNavigationBar,
  });

  /// The main body content widget displayed in the scaffold body.
  final Widget child;

  /// Optional custom app bar implementing [PreferredSizeWidget].
  /// If null and [isHideAppbar] is false, [FrostedAppBar] is used by default.
  final PreferredSizeWidget? appbar;

  /// When set to true, hides the app bar completely.
  final bool isHideAppbar;

  /// Whether the default floating app bar hides while the body scrolls down.
  ///
  /// When enabled, the app bar is hidden after a downward scroll notification
  /// of at least one logical pixel and is shown again after an upward scroll
  /// notification of at least one logical pixel. The option is disabled by
  /// default to preserve the normal [BaseWidget] behavior.
  ///
  /// This behavior applies to the default floating [FrostedAppBar]. A custom
  /// [appbar] continues to be provided through [Scaffold.appBar] unchanged.
  final bool hideAppBarOnScroll;

  /// Controls the scroll response of the default floating app bar.
  ///
  /// When this is not [AppBarScrollBehavior.none], it takes precedence over
  /// [hideAppBarOnScroll]. The legacy boolean remains available for source
  /// compatibility and maps to [AppBarScrollBehavior.hideAll].
  final AppBarScrollBehavior appBarScrollBehavior;

  /// Downward logical-pixel distance required before hiding the app bar.
  final double hideAfter;

  /// Upward logical-pixel distance required before showing the app bar.
  final double showAfter;

  /// Whether to draw a subtle top gradient behind the system status bar.
  ///
  /// The gradient uses the current scaffold background color and fades into
  /// transparency below the status-bar and app-bar area. It improves the
  /// contrast of system icons while content scrolls underneath the header.
  final bool showStatusBarGradient;

  /// Optional floating action button displayed on the scaffold.
  final Widget? floatingActionButton;

  /// Title text string displayed in the default [FrostedAppBar].
  final String? title;

  /// Optional custom title content for the default [FrostedAppBar].
  final Widget? titleWidget;

  /// List of action widgets aligned to the end (right) of the [FrostedAppBar].
  final List<Widget>? actions;

  /// Optional custom back action.
  final VoidCallback? backAction;

  /// Optional bottom navigation bar displayed at the bottom of the screen.
  final Widget? bottomNavigationBar;

  @override
  State<BaseWidget> createState() => _BaseWidgetState();
}

class _BaseWidgetState extends State<BaseWidget> {
  bool _isAppBarVisible = true;
  double _downwardDistance = 0;
  double _upwardDistance = 0;

  AppBarScrollBehavior get _scrollBehavior =>
      widget.appBarScrollBehavior != AppBarScrollBehavior.none
      ? widget.appBarScrollBehavior
      : widget.hideAppBarOnScroll
      ? AppBarScrollBehavior.hideAll
      : AppBarScrollBehavior.none;

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification.metrics.pixels <= 0 && !_isAppBarVisible) {
      setState(() => _isAppBarVisible = true);
      _downwardDistance = 0;
      _upwardDistance = 0;
      return false;
    }

    // Some platforms emit user-direction notifications without a usable
    // scroll delta. Use the direction as a reliable fallback so the app bar
    // still responds to real finger/trackpad scrolling.
    if (_scrollBehavior != AppBarScrollBehavior.none &&
        notification is UserScrollNotification) {
      if (notification.direction == ScrollDirection.reverse &&
          _isAppBarVisible) {
        setState(() => _isAppBarVisible = false);
        _downwardDistance = widget.hideAfter;
        _upwardDistance = 0;
      } else if (notification.direction == ScrollDirection.forward &&
          !_isAppBarVisible) {
        setState(() => _isAppBarVisible = true);
        _upwardDistance = widget.showAfter;
        _downwardDistance = 0;
      }
      return false;
    }

    final scrollDelta = notification is ScrollUpdateNotification
        ? notification.scrollDelta
        : null;
    if (_scrollBehavior != AppBarScrollBehavior.none && scrollDelta != null) {
      if (scrollDelta > 0) {
        _downwardDistance += scrollDelta;
        _upwardDistance = 0;
      } else if (scrollDelta < 0) {
        _upwardDistance += scrollDelta.abs();
        _downwardDistance = 0;
      }

      if (_downwardDistance >= widget.hideAfter && _isAppBarVisible) {
        setState(() => _isAppBarVisible = false);
      } else if (_upwardDistance >= widget.showAfter && !_isAppBarVisible) {
        setState(() => _isAppBarVisible = true);
      }
    }
    return false;
  }

  @override
  void didUpdateWidget(covariant BaseWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.hideAppBarOnScroll && !_isAppBarVisible) {
      _isAppBarVisible = true;
    }
    if (oldWidget.appBarScrollBehavior != widget.appBarScrollBehavior) {
      _downwardDistance = 0;
      _upwardDistance = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: widget.bottomNavigationBar != null,
      appBar: widget.isHideAppbar ? null : widget.appbar,
      floatingActionButton: widget.floatingActionButton,
      // bottomNavigationBar: bottomNavigationBar,
      body: Stack(
        children: [
          NotificationListener<ScrollNotification>(
            onNotification: _handleScrollNotification,
            child: widget.child,
          ),

          if (widget.bottomNavigationBar != null)
            Positioned(
              bottom: 0,
              right: context.horizontalPadding,
              left: context.horizontalPadding,
              child: widget.bottomNavigationBar!,
            ),
          if (widget.showStatusBarGradient)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: MediaQuery.paddingOf(context).top + kToolbarHeight + 16,
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Theme.of(
                          context,
                        ).scaffoldBackgroundColor.withValues(alpha: 0.92),
                        Theme.of(
                          context,
                        ).scaffoldBackgroundColor.withValues(alpha: 0.52),
                        Colors.transparent,
                      ],
                      stops: const [0, 0.42, 1],
                    ),
                  ),
                ),
              ),
            ),
          // Default floating primary appbar
          if (!widget.isHideAppbar && widget.appbar == null)
            Positioned(
              top: 0,
              right: 0,
              left: 0,
              child: ExcludeSemantics(
                excluding:
                    _scrollBehavior == AppBarScrollBehavior.hideAll &&
                    !_isAppBarVisible,
                child: IgnorePointer(
                  ignoring:
                      _scrollBehavior == AppBarScrollBehavior.hideAll &&
                      !_isAppBarVisible,
                  child: AnimatedSlide(
                    offset:
                        _scrollBehavior == AppBarScrollBehavior.hideAll &&
                            !_isAppBarVisible
                        ? const Offset(0, -1.2)
                        : Offset.zero,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOut,
                    child: AnimatedOpacity(
                      opacity:
                          _scrollBehavior == AppBarScrollBehavior.hideAll &&
                              !_isAppBarVisible
                          ? 0
                          : 1,
                      duration: const Duration(milliseconds: 200),
                      child: RepaintBoundary(
                        child: FrostedAppBar(
                          title: widget.title,
                          titleWidget: widget.titleWidget,
                          actions: widget.actions,
                          backAction: widget.backAction,
                          titleCollapsed:
                              _scrollBehavior ==
                                  AppBarScrollBehavior.collapseTitle &&
                              !_isAppBarVisible,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
