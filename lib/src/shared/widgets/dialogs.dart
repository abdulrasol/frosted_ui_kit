import 'package:flutter/material.dart';
import 'package:frosted_ui_kit/src/shared/widgets/buttons.dart';
import 'package:frosted_ui_kit/src/shared/widgets/cards.dart';
import 'package:frosted_ui_kit/src/shared/widgets/inputs.dart';
import 'package:frosted_ui_kit/src/shared/widgets/loading.dart';

/// A base glassmorphic dialog widget.
class AppDialog extends StatelessWidget with Cards {
  const AppDialog({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(24.0),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 24.0),
      child: blurredCard(
        context: context,
        radius: 24,
        padding: padding,
        child: child,
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

  @override
  State<_InputDialogContent> createState() => _InputDialogContentState();
}

class _InputDialogContentState extends State<_InputDialogContent>
    with Buttons, Inputs {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: appButton(
                  context: context,
                  title: widget.cancelText,
                  style: AppButtonStyle.text,
                  backgroundColor: widget.cancelButtonColor,
                  textStyle: widget.cancelTextColor != null
                      ? TextStyle(color: widget.cancelTextColor)
                      : null,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: appButton(
                  context: context,
                  title: widget.confirmText,
                  style: AppButtonStyle.colored,
                  backgroundColor: widget.confirmButtonColor,
                  textStyle: widget.confirmTextColor != null
                      ? TextStyle(color: widget.confirmTextColor)
                      : null,
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? true) {
                      Navigator.of(context).pop(_controller.text);
                    }
                  },
                ),
              ),
            ],
          ),
        ],
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
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    IconData? icon = Icons.warning_rounded,
    Color? iconColor,
    Color? titleColor,
    Color? descriptionColor,
    Color? confirmButtonColor,
    Color? confirmTextColor,
    Color? cancelButtonColor,
    Color? cancelTextColor,
  }) {
    final theme = Theme.of(context);
    final color = iconColor ?? theme.colorScheme.error;

    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AppDialog(
          key: key,
          child: Column(
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
              Text(
                title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: titleColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: descriptionColor ?? theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: Builder(
                      builder: (btnContext) {
                        return _dialogUtils.appButton(
                          context: btnContext,
                          title: cancelText,
                          style: AppButtonStyle.text,
                          backgroundColor: cancelButtonColor,
                          textStyle: cancelTextColor != null
                              ? TextStyle(color: cancelTextColor)
                              : null,
                          onPressed: () => Navigator.of(context).pop(false),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Builder(
                      builder: (btnContext) {
                        return _dialogUtils.appButton(
                          context: btnContext,
                          title: confirmText,
                          style: AppButtonStyle.colored,
                          backgroundColor: confirmButtonColor ?? color,
                          textStyle: confirmTextColor != null
                              ? TextStyle(color: confirmTextColor)
                              : null,
                          onPressed: () => Navigator.of(context).pop(true),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
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
    String confirmText = 'OK',
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
        return AppDialog(
          key: key,
          child: Column(
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
              if (title != null) ...[
                Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: titleColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (description != null) const SizedBox(height: 8),
              ],
              if (description != null)
                Text(
                  description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color:
                        descriptionColor ?? theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              const SizedBox(height: 24),
              Builder(
                builder: (btnContext) {
                  return _dialogUtils.appButton(
                    context: btnContext,
                    title: confirmText,
                    style: AppButtonStyle.colored,
                    backgroundColor: confirmButtonColor ?? color,
                    textStyle: confirmTextColor != null
                        ? TextStyle(color: confirmTextColor)
                        : null,
                    onPressed: () => Navigator.of(context).pop(),
                  );
                },
              ),
            ],
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
    String confirmText = 'Submit',
    String cancelText = 'Cancel',
    FormFieldValidator<String>? validator,
    Color? titleColor,
    Color? descriptionColor,
    Color? confirmButtonColor,
    Color? confirmTextColor,
    Color? cancelButtonColor,
    Color? cancelTextColor,
  }) {
    return showDialog<String>(
      context: context,
      builder: (context) {
        return AppDialog(
          key: key,
          child: _InputDialogContent(
            key: key,
            title: title,
            description: description,
            hintText: hintText,
            confirmText: confirmText,
            cancelText: cancelText,
            validator: validator,
            titleColor: titleColor,
            descriptionColor: descriptionColor,
            confirmButtonColor: confirmButtonColor,
            confirmTextColor: confirmTextColor,
            cancelButtonColor: cancelButtonColor,
            cancelTextColor: cancelTextColor,
          ),
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

        Widget dialogContent;
        if (message == null) {
          dialogContent = Center(
            child: Material(
              type: MaterialType.transparency,
              child: _dialogUtils.blurredCard(
                context: context,
                radius: 24,
                padding: const EdgeInsets.all(24),
                child: content,
              ),
            ),
          );
        } else {
          dialogContent = AppDialog(child: content);
        }

        return PopScope(canPop: barrierDismissible, child: dialogContent);
      },
    );
  }
}
