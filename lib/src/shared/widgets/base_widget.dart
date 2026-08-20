import 'package:flutter/material.dart';
import 'package:frosted_ui_kit/frosted_ui_kit.dart';

/// A foundational screen wrapper widget providing a consistent layout structure.
///
/// Wraps the content in a [Scaffold] and automatically adds a [FrostedAppBar]
/// at the top unless a custom appbar is provided or [isHideAppbar] is true.
class BaseWidget extends StatelessWidget {
  /// Creates a [BaseWidget] screen wrapper.
  const BaseWidget({
    super.key,
    required this.child,
    this.appbar,
    this.floatingActionButton,
    this.isHideAppbar = false,
    this.title,
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

  /// Optional floating action button displayed on the scaffold.
  final Widget? floatingActionButton;

  /// Title text string displayed in the default [FrostedAppBar].
  final String? title;

  /// List of action widgets aligned to the end (right) of the [FrostedAppBar].
  final List<Widget>? actions;

  /// Optional custom back action.
  final VoidCallback? backAction;

  /// Optional bottom navigation bar displayed at the bottom of the screen.
  final Widget? bottomNavigationBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: bottomNavigationBar != null,
      appBar: isHideAppbar ? null : appbar,
      floatingActionButton: floatingActionButton,
      // bottomNavigationBar: bottomNavigationBar,
      body: Stack(
        children: [
          child,

          if (bottomNavigationBar != null)
            Positioned(
              bottom: 0, //MediaQuery.of(context).viewInsets.bottom,
              right: context.horizontalPadding,
              left: context.horizontalPadding,
              child: bottomNavigationBar!,
            ),
          // Default floating primary appbar
          if (!isHideAppbar && appbar == null)
            Positioned(
              top: 0,
              right: 0,
              left: 0,
              child: FrostedAppBar(title: title, actions: actions, backAction: backAction),
            ),
        ],
      ),
    );
  }
}
