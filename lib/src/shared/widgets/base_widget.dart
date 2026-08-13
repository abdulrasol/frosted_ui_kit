import 'package:flutter/material.dart';
import 'package:starter/src/shared/widgets/buttons.dart';
import 'package:starter/src/shared/widgets/cards.dart';

/// A foundational screen wrapper widget providing a consistent layout structure.
///
/// Wraps the content in a [Scaffold] and automatically adds a [PrimaryAppBar]
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
  });

  /// The main body content widget displayed in the scaffold body.
  final Widget child;

  /// Optional custom app bar implementing [PreferredSizeWidget].
  /// If null and [isHideAppbar] is false, [PrimaryAppBar] is used by default.
  final PreferredSizeWidget? appbar;

  /// When set to true, hides the app bar completely.
  final bool isHideAppbar;

  /// Optional floating action button displayed on the scaffold.
  final Widget? floatingActionButton;

  /// Title text string displayed in the default [PrimaryAppBar].
  final String? title;

  /// List of action widgets aligned to the end (right) of the [PrimaryAppBar].
  final List<Widget>? actions;

  /// Optional custom back action.
  final VoidCallback? backAction;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isHideAppbar ? null : appbar,
      body: Stack(
        children: [
          child,

          // Default floating primary appbar
          if (!isHideAppbar && appbar == null)
            Align(
              alignment: Alignment.topCenter,
              child: PrimaryAppBar(title: title, actions: actions, backAction: backAction),
            ),
        ],
      ),
    );
  }
}

/// A modern, glassmorphic primary application bar with auto-fitting title and end-aligned actions.
class PrimaryAppBar extends StatelessWidget with Buttons, Cards implements PreferredSizeWidget {
  /// Creates a [PrimaryAppBar] with optional title string, custom title widget, leading widget, and actions.
  const PrimaryAppBar({super.key, this.title, this.titleWidget, this.leading, this.actions, this.backAction});

  /// Text title displayed inside a blurred glass card.
  final String? title;

  /// Custom widget replacing the default title text card.
  final Widget? titleWidget;

  /// Optional custom leading widget displayed before the title.
  final Widget? leading;

  /// Optional custom back action.
  final VoidCallback? backAction;

  /// List of trailing action widgets positioned on the far right.
  final List<Widget>? actions;

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
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
                if (leading != null) leading! else if (canPop) backButton(context, onTap: backAction) else const SizedBox.shrink(),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    spacing: 8,
                    children: [
                      if (titleWidget != null)
                        Flexible(fit: FlexFit.loose, child: titleWidget!)
                      else if (title != null)
                        Flexible(
                          fit: FlexFit.loose,
                          child: bluredCard(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            height: 48,
                            context: context,
                            child: Center(widthFactor: 1.0, child: Text(title!, maxLines: 1, overflow: TextOverflow.ellipsis)),
                          ),
                        )
                      else
                        const SizedBox.shrink(),
                      if (actions != null && actions!.isNotEmpty) Row(mainAxisSize: MainAxisSize.min, spacing: 8, children: actions!),
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
