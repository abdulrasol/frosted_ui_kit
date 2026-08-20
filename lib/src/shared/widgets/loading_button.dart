import 'package:flutter/material.dart';
import 'package:frosted_ui_kit/src/shared/widgets/buttons.dart';
import 'package:frosted_ui_kit/src/shared/widgets/loading.dart';

/// The possible states for the [FrostLoadingButton].
enum FrostLoadingButtonState {
  /// The default state where the normal button title and icon are shown.
  idle,

  /// The loading state where the text is hidden and the [AppLoadingIndicator] is shown.
  loading,

  /// The success state where a success icon is shown.
  success,

  /// The error state where an error icon is shown.
  error,
}

/// Controller to manage the state of an [FrostLoadingButton].
class FrostLoadingButtonController extends ValueNotifier<FrostLoadingButtonState> {
  /// Creates a controller with the initial state set to [FrostLoadingButtonState.idle].
  FrostLoadingButtonController() : super(FrostLoadingButtonState.idle);

  /// Changes the state to [FrostLoadingButtonState.loading].
  void start() => value = FrostLoadingButtonState.loading;

  /// Changes the state to [FrostLoadingButtonState.success].
  void success() => value = FrostLoadingButtonState.success;

  /// Changes the state to [FrostLoadingButtonState.error].
  void error() => value = FrostLoadingButtonState.error;

  /// Resets the state back to [FrostLoadingButtonState.idle].
  void reset() => value = FrostLoadingButtonState.idle;
}

/// An animated button that transitions between states managed by an [FrostLoadingButtonController].
///
/// It supports showing an [AppLoadingIndicator] when loading, and success/error icons
/// for feedback. It is built on top of [AppButton].
class FrostLoadingButton extends StatelessWidget with Buttons {
  /// Creates an [FrostLoadingButton].
  const FrostLoadingButton({
    super.key,
    required this.controller,
    required this.title,
    required this.onPressed,
    this.icon,
    this.style = AppButtonStyle.colored,
    this.backgroundColor,
    this.successColor,
    this.errorColor,
    this.textStyle,
    this.iconColor,
    this.height = 48,
    this.width,
    this.borderRadius,
    this.margin,
    this.padding,
    this.successIcon = Icons.check_circle_rounded,
    this.errorIcon = Icons.error_rounded,
    this.isFullWidth = true,
  });

  /// The controller that drives the state of the button.
  final FrostLoadingButtonController controller;

  /// The normal title of the button.
  final String title;

  /// The callback to trigger when the button is tapped in the idle state.
  final VoidCallback? onPressed;

  /// The optional icon shown in the idle state.
  final IconData? icon;

  /// The style variant of the button.
  final AppButtonStyle style;

  /// Custom background color for the idle state.
  final Color? backgroundColor;

  /// The background color to use for the success state. Defaults to green.
  final Color? successColor;

  /// The background color to use for the error state. Defaults to red.
  final Color? errorColor;

  /// Text style for the idle state.
  final TextStyle? textStyle;

  /// Icon color for the idle state.
  final Color? iconColor;

  /// Fixed height for the button. Defaults to 48.
  final double? height;

  /// Optional fixed width for the button.
  final double? width;

  /// Custom border radius.
  final BorderRadiusGeometry? borderRadius;

  /// Outer margin surrounding the button container.
  final EdgeInsetsGeometry? margin;

  /// Inner padding inside the button container.
  final EdgeInsetsGeometry? padding;

  /// Icon used for the success state.
  final IconData successIcon;

  /// Icon used for the error state.
  final IconData errorIcon;

  /// Whether the button should stretch to full width in idle/success/error states.
  /// If true, the loading state will still collapse to a circle for the spinner.
  final bool isFullWidth;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Default colors for feedback states
    final resolvedSuccessColor = successColor ?? Colors.green.shade600;
    final resolvedErrorColor = errorColor ?? theme.colorScheme.error;

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth.isFinite ? constraints.maxWidth : null;

        return ValueListenableBuilder<FrostLoadingButtonState>(
          valueListenable: controller,
          builder: (context, state, child) {
            // Determine the background color based on the current state.
            Color? currentBgColor = backgroundColor;
            if (state == FrostLoadingButtonState.success) {
              currentBgColor = resolvedSuccessColor;
            } else if (state == FrostLoadingButtonState.error) {
              currentBgColor = resolvedErrorColor;
            }

            // Determine if the button should be disabled (non-clickable).
            final isDisabled = state != FrostLoadingButtonState.idle || onPressed == null;

            // Build the inner content based on the state.
            Widget content;
            switch (state) {
              case FrostLoadingButtonState.idle:
                content = Row(
                  key: const ValueKey('idle'),
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 8,
                  children: [
                    if (icon != null) Icon(icon, size: 20),
                    Flexible(child: Text(title, overflow: TextOverflow.ellipsis, maxLines: 1)),
                  ],
                );
                break;
              case FrostLoadingButtonState.loading:
                content = const AppLoadingIndicator(key: ValueKey('loading'), size: 48);
                break;
              case FrostLoadingButtonState.success:
                content = Icon(successIcon, key: const ValueKey('success'), size: 24, color: Colors.white);
                break;
              case FrostLoadingButtonState.error:
                content = Icon(errorIcon, key: const ValueKey('error'), size: 24, color: Colors.white);
                break;
            }

            return AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: appButton(
                context: context,
                title: null, // Title handled in custom content
                icon: null, // Icon handled in custom content
                style: style,
                backgroundColor: currentBgColor,
                isDisabled: isDisabled,
                onPressed: onPressed,
                height: height,
                width: state == FrostLoadingButtonState.loading ? (height ?? 48) : (isFullWidth ? (maxWidth ?? width) : width),
                borderRadius: borderRadius,
                margin: margin,
                padding: state == FrostLoadingButtonState.loading ? EdgeInsets.zero : padding,
                textStyle: textStyle,
                iconColor: iconColor,
                // Override the standard button content with our AnimatedSwitcher
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  switchInCurve: Curves.easeIn,
                  switchOutCurve: Curves.easeOut,
                  transitionBuilder: (child, animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: ScaleTransition(scale: animation, child: child),
                    );
                  },
                  child: content,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
