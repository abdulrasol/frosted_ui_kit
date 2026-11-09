import 'package:flutter/material.dart';
import 'package:frosted_ui_kit/src/core/l10n/arb/app_localizations.dart';
import 'package:frosted_ui_kit/src/shared/widgets/adaptive_surface_layout.dart';
import 'package:frosted_ui_kit/src/shared/widgets/buttons.dart';
import 'package:frosted_ui_kit/src/shared/widgets/cards.dart';
import 'package:frosted_ui_kit/src/shared/widgets/inputs.dart';
import 'package:frosted_ui_kit/src/shared/widgets/loading.dart';
import 'package:frosted_ui_kit/src/utils/frosted_theme.dart';

/// A base glassmorphic dialog widget.
///
/// The content is constrained and scrollable so long descriptions and the
/// on-screen keyboard do not cause overflow on compact devices.
class AppDialog extends StatelessWidget with Cards {
  /// Creates a glassmorphic dialog shell.
  const AppDialog({
    super.key,
    required this.child,
    this.header,
    this.actions,
    this.padding = const EdgeInsets.all(24.0),
    this.maxWidth = 520,
    this.insetPadding = const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 24,
    ),
    this.surfaceOpacity,
    this.blurSigma,
  });

  /// Dialog content.
  final Widget child;

  /// Optional header kept visible above the scrolling body when space allows.
  final Widget? header;

  /// Optional footer kept visible when there is enough vertical space.
  /// On very short viewports it scrolls together with the body.
  final Widget? actions;

  /// Inner content padding.
  final EdgeInsetsGeometry padding;

  /// Maximum width used on tablets and desktop layouts.
  final double maxWidth;

  /// Minimum distance between the dialog and the viewport edges.
  final EdgeInsets insetPadding;

  /// Opacity of the dialog surface tint.
  final double? surfaceOpacity;

  /// Backdrop blur sigma used by the dialog glass layer.
  final double? blurSigma;

  @override
  Widget build(BuildContext context) {
    final viewInsets = MediaQuery.viewInsetsOf(context);
    final theme = Theme.of(context);
    final tokens = FrostedThemeData.of(context);
    final availableHeight =
        MediaQuery.sizeOf(context).height -
        viewInsets.bottom -
        insetPadding.vertical;
    return TweenAnimationBuilder<double>(
      duration: MediaQuery.disableAnimationsOf(context)
          ? Duration.zero
          : tokens.motionDuration,
      curve: Curves.easeOutCubic,
      tween: Tween(begin: 0.96, end: 1),
      builder: (context, scale, dialog) => Opacity(
        opacity: ((scale - 0.96) / 0.04).clamp(0, 1),
        child: Transform.scale(scale: scale, child: dialog),
      ),
      child: Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        insetPadding: insetPadding,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: maxWidth,
            maxHeight: availableHeight.clamp(
              0,
              MediaQuery.sizeOf(context).height * 0.84,
            ),
          ),
          child: blurredCard(
            context: context,
            radius: tokens.dialogRadius,
            padding: padding,
            sigmaX: blurSigma ?? tokens.dialogBlur,
            sigmaY: blurSigma ?? tokens.dialogBlur,
            color: (tokens.surfaceColor ?? theme.colorScheme.surface)
                .withValues(alpha: surfaceOpacity ?? tokens.dialogOpacity),
            child: FrostedAdaptiveSurfaceLayout(
              header: header,
              crossAxisAlignment: CrossAxisAlignment.center,
              body: child,
              actions: actions,
              spacing: tokens.spacing,
            ),
          ),
        ),
      ),
    );
  }
}

class _InputDialogContent extends StatefulWidget {
  const _InputDialogContent({
    super.key,
    this.title,
    this.description,
    required this.hintText,
    required this.confirmText,
    required this.cancelText,
    this.validator,
    this.titleColor,
    this.descriptionColor,
    this.confirmButtonColor,
    this.confirmTextColor,
    this.cancelButtonColor,
    this.cancelTextColor,
    this.autofocus = false,
  });

  final String? title;
  final String? description;
  final String hintText;
  final String confirmText;
  final String cancelText;
  final FormFieldValidator<String>? validator;
  final Color? titleColor;
  final Color? descriptionColor;
  final Color? confirmButtonColor;
  final Color? confirmTextColor;
  final Color? cancelButtonColor;
  final Color? cancelTextColor;
  final bool autofocus;

  @override
  State<_InputDialogContent> createState() => _InputDialogContentState();
}

class _InputDialogContentState extends State<_InputDialogContent>
    with Buttons, Inputs {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _submitted = false;

  void _submit() {
    if (_submitted || !(_formKey.currentState?.validate() ?? false)) return;
    _submitted = true;
    FocusScope.of(context).unfocus();
    Navigator.of(context).pop(_controller.text);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Form(
      key: _formKey,
      child: AppDialog(
        actions: FrostedAdaptiveActions(
          secondary: appButton(
            context: context,
            title: widget.cancelText,
            style: AppButtonStyle.outlined,
            role: FrostedActionRole.secondary,
            backgroundColor: widget.cancelButtonColor,
            textStyle: widget.cancelTextColor != null
                ? TextStyle(color: widget.cancelTextColor)
                : null,
            onPressed: () => Navigator.of(context).pop(),
          ),
          primary: appButton(
            context: context,
            title: widget.confirmText,
            style: AppButtonStyle.colored,
            role: FrostedActionRole.primary,
            backgroundColor: widget.confirmButtonColor,
            textStyle: widget.confirmTextColor != null
                ? TextStyle(color: widget.confirmTextColor)
                : null,
            onPressed: _submit,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.title != null) ...[
              Text(
                widget.title!,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: widget.titleColor,
                ),
                textAlign: TextAlign.center,
              ),
              if (widget.description != null) const SizedBox(height: 8),
            ],
            if (widget.description != null)
              Text(
                widget.description!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color:
                      widget.descriptionColor ??
                      theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            const SizedBox(height: 24),
            textField(
              context: context,
              controller: _controller,
              placeholder: widget.hintText,
              validator: widget.validator,
              type: AppTextFieldType.text,
              autofocus: widget.autofocus,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _submit(),
            ),
          ],
        ),
      ),
    );
  }
}

class _DialogUtils with Buttons, Cards {}

final _dialogUtils = _DialogUtils();

/// A mixin providing utility methods to show various glassmorphic dialogs.
mixin Dialogs {
  /// Shows a warning/confirmation dialog.
  /// Returns `true` if the user confirms, `false` otherwise.
  Future<bool?> showAppWarningDialog({
    Key? key,
    required BuildContext context,
    required String title,
    required String description,
    String? confirmText,
    String? cancelText,
    IconData? icon = Icons.warning_rounded,
    Color? iconColor,
    Color? titleColor,
    Color? descriptionColor,
    Color? confirmButtonColor,
    Color? confirmTextColor,
    Color? cancelButtonColor,
    Color? cancelTextColor,
    bool isDestructive = false,
  }) {
    final theme = Theme.of(context);
    final color = iconColor ?? theme.colorScheme.error;

    return showDialog<bool>(
      context: context,
      builder: (context) {
        final l10n = FrostedAppLocalizations.of(context);
        final resolvedConfirmText = confirmText ?? l10n?.confirm ?? 'Confirm';
        final resolvedCancelText = cancelText ?? l10n?.cancel ?? 'Cancel';
        return AppDialog(
          key: key,
          header: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 32),
                ),
                SizedBox(height: FrostedThemeData.of(context).spacing),
              ],
              Text(
                title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: titleColor,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: FrostedAdaptiveActions(
            secondary: _dialogUtils.appButton(
              context: context,
              title: resolvedCancelText,
              style: AppButtonStyle.outlined,
              role: FrostedActionRole.secondary,
              backgroundColor: cancelButtonColor,
              textStyle: cancelTextColor != null
                  ? TextStyle(color: cancelTextColor)
                  : null,
              onPressed: () => Navigator.of(context).pop(false),
            ),
            primary: _dialogUtils.appButton(
              context: context,
              title: resolvedConfirmText,
              style: AppButtonStyle.colored,
              role: isDestructive
                  ? FrostedActionRole.destructive
                  : FrostedActionRole.primary,
              backgroundColor: confirmButtonColor,
              textStyle: confirmTextColor != null
                  ? TextStyle(color: confirmTextColor)
                  : null,
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ),
          child: Text(
            description,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: descriptionColor ?? theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }

  /// Shows an error/rejection dialog.
  /// Only contains an acknowledgment button.
  Future<void> showAppErrorDialog({
    Key? key,
    required BuildContext context,
    String? title,
    String? description,
    String? confirmText,
    IconData? icon = Icons.error_outline_rounded,
    Color? iconColor,
    Color? titleColor,
    Color? descriptionColor,
    Color? confirmButtonColor,
    Color? confirmTextColor,
  }) {
    final theme = Theme.of(context);
    final color = iconColor ?? theme.colorScheme.error;

    return showDialog<void>(
      context: context,
      builder: (context) {
        final l10n = FrostedAppLocalizations.of(context);
        final resolvedConfirmText = confirmText ?? l10n?.ok ?? 'OK';
        return AppDialog(
          key: key,
          header: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 32),
                ),
                const SizedBox(height: 16),
              ],
              if (title != null)
                Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: titleColor,
                  ),
                  textAlign: TextAlign.center,
                ),
            ],
          ),
          actions: _dialogUtils.appButton(
            context: context,
            title: resolvedConfirmText,
            style: AppButtonStyle.colored,
            role: FrostedActionRole.destructive,
            backgroundColor: confirmButtonColor,
            textStyle: confirmTextColor != null
                ? TextStyle(color: confirmTextColor)
                : null,
            onPressed: () => Navigator.of(context).pop(),
          ),
          child: description == null
              ? const SizedBox.shrink()
              : Text(
                  description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color:
                        descriptionColor ?? theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
        );
      },
    );
  }

  /// Shows an input dialog that prompts the user to enter text.
  /// Returns the entered text or `null` if cancelled.
  Future<String?> showAppInputDialog({
    Key? key,
    required BuildContext context,
    String? title,
    String? description,
    String hintText = '',
    String? confirmText,
    String? cancelText,
    FormFieldValidator<String>? validator,
    Color? titleColor,
    Color? descriptionColor,
    Color? confirmButtonColor,
    Color? confirmTextColor,
    Color? cancelButtonColor,
    Color? cancelTextColor,
    bool autofocus = false,
  }) {
    final l10n = FrostedAppLocalizations.of(context);
    return showDialog<String>(
      context: context,
      builder: (context) {
        return _InputDialogContent(
          key: key,
          title: title,
          description: description,
          hintText: hintText,
          confirmText: confirmText ?? l10n?.submit ?? 'Submit',
          cancelText: cancelText ?? l10n?.cancel ?? 'Cancel',
          validator: validator,
          titleColor: titleColor,
          descriptionColor: descriptionColor,
          confirmButtonColor: confirmButtonColor,
          confirmTextColor: confirmTextColor,
          cancelButtonColor: cancelButtonColor,
          cancelTextColor: cancelTextColor,
          autofocus: autofocus,
        );
      },
    );
  }

  /// Shows a glassmorphic loading dialog that uses [AppLoadingIndicator].
  /// Returns a Future that completes when the dialog is dismissed.
  Future<void> showAppLoadingDialog({
    Key? key,
    double? size,
    required BuildContext context,
    String? message,
    bool barrierDismissible = false,
    Color? color,
  }) {
    final theme = Theme.of(context);

    return showDialog<void>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) {
        final content = Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppLoadingIndicator(size: size ?? 80, color: color),
            if (message != null) ...[
              const SizedBox(height: 16),
              Text(
                message,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: color ?? theme.colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        );

        return PopScope(
          canPop: barrierDismissible,
          child: AppDialog(
            maxWidth: message == null ? 160 : 520,
            child: content,
          ),
        );
      },
    );
  }
}
