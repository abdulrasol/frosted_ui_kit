import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frosted_ui_kit/src/shared/widgets/buttons.dart';
import 'package:frosted_ui_kit/src/shared/widgets/loading_button.dart';

/// Callback invoked when a [FrostedAsyncButton] operation fails.
typedef FrostedAsyncErrorCallback =
    void Function(Object error, StackTrace stackTrace);

/// A button that owns the loading, success, and error lifecycle of a Future.
///
/// The callback runs at most once at a time. Errors are captured and forwarded
/// to [onError]; this widget never opens a dialog or throws UI automatically.
/// Use [FrostLoadingButton] when the application needs manual state control.
class FrostedAsyncButton extends StatefulWidget {
  /// Creates a self-managed asynchronous action button.
  const FrostedAsyncButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.onSuccess,
    this.onError,
    this.icon,
    this.style = AppButtonStyle.colored,
    this.role = FrostedActionRole.primary,
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
    this.collapseOnLoading = false,
    this.loadingColor,
    this.loadingLabel = 'Loading',
    this.successLabel = 'Completed',
    this.errorLabel = 'Action failed',
    this.feedbackDuration = const Duration(milliseconds: 1200),
  });

  /// Normal button label, supplied in the application's current language.
  final String title;

  /// Asynchronous action; null disables the button.
  final Future<void> Function()? onPressed;

  /// Called after [onPressed] completes successfully while mounted.
  final VoidCallback? onSuccess;

  /// Receives failures while mounted. No dialog is shown automatically.
  final FrostedAsyncErrorCallback? onError;

  /// Optional leading icon in the idle state.
  final IconData? icon;

  /// Visual appearance, independent from [role].
  final AppButtonStyle style;

  /// Semantic role used for action colors.
  final FrostedActionRole role;

  /// Optional idle-state surface override.
  final Color? backgroundColor;

  /// Optional success-state surface color.
  final Color? successColor;

  /// Optional error-state surface color.
  final Color? errorColor;

  /// Optional idle label style.
  final TextStyle? textStyle;

  /// Optional idle icon and label color.
  final Color? iconColor;

  /// Button height.
  final double? height;

  /// Optional fixed width.
  final double? width;

  /// Optional local corner radius.
  final BorderRadiusGeometry? borderRadius;

  /// Outer margin.
  final EdgeInsetsGeometry? margin;

  /// Inner padding outside the loading state.
  final EdgeInsetsGeometry? padding;

  /// Success-state icon.
  final IconData successIcon;

  /// Error-state icon.
  final IconData errorIcon;

  /// Whether the button fills finite horizontal constraints.
  final bool isFullWidth;

  /// Whether loading collapses to a square indicator.
  final bool collapseOnLoading;

  /// Optional loading indicator color.
  final Color? loadingColor;

  /// Accessible loading-state label.
  final String loadingLabel;

  /// Accessible success-state label.
  final String successLabel;

  /// Accessible error-state label.
  final String errorLabel;

  /// Time success/error feedback remains visible before returning to idle.
  ///
  /// Set to null to keep the terminal state until this widget is replaced.
  final Duration? feedbackDuration;

  @override
  State<FrostedAsyncButton> createState() => _FrostedAsyncButtonState();
}

class _FrostedAsyncButtonState extends State<FrostedAsyncButton> {
  final FrostLoadingButtonController _controller =
      FrostLoadingButtonController();
  Timer? _resetTimer;
  int _operation = 0;

  Future<void> _run() async {
    final callback = widget.onPressed;
    if (callback == null || _controller.value != FrostLoadingButtonState.idle) {
      return;
    }

    _resetTimer?.cancel();
    final operation = ++_operation;
    _controller.start();
    try {
      await callback();
      if (!mounted || operation != _operation) return;
      _controller.success();
      widget.onSuccess?.call();
      _scheduleReset(operation);
    } catch (error, stackTrace) {
      if (!mounted || operation != _operation) return;
      _controller.error();
      widget.onError?.call(error, stackTrace);
      _scheduleReset(operation);
    }
  }

  void _scheduleReset(int operation) {
    final duration = widget.feedbackDuration;
    if (duration == null) return;
    _resetTimer = Timer(duration, () {
      if (!mounted || operation != _operation) return;
      _controller.reset();
    });
  }

  @override
  void dispose() {
    _operation++;
    _resetTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FrostLoadingButton(
    controller: _controller,
    title: widget.title,
    onPressed: widget.onPressed == null ? null : _run,
    icon: widget.icon,
    style: widget.style,
    role: widget.role,
    backgroundColor: widget.backgroundColor,
    successColor: widget.successColor,
    errorColor: widget.errorColor,
    textStyle: widget.textStyle,
    iconColor: widget.iconColor,
    height: widget.height,
    width: widget.width,
    borderRadius: widget.borderRadius,
    margin: widget.margin,
    padding: widget.padding,
    successIcon: widget.successIcon,
    errorIcon: widget.errorIcon,
    isFullWidth: widget.isFullWidth,
    collapseOnLoading: widget.collapseOnLoading,
    loadingColor: widget.loadingColor,
    loadingLabel: widget.loadingLabel,
    successLabel: widget.successLabel,
    errorLabel: widget.errorLabel,
  );
}
