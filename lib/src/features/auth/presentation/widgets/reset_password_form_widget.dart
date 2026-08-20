import 'package:flutter/material.dart';
import 'package:frosted_ui_kit/src/core/l10n/arb/app_localizations.dart';
import 'package:frosted_ui_kit/src/features/auth/presentation/controllers/auth_controller.dart';
import 'package:frosted_ui_kit/src/shared/widgets/buttons.dart';
import 'package:frosted_ui_kit/src/shared/widgets/inputs.dart';

/// Form sub-widget for resetting password using reset token with localized strings and glassmorphic inputs.
///
/// Fully reusable across applications with support for custom callbacks.
class ResetPasswordFormWidget extends StatefulWidget with Buttons, Inputs {
  /// Auth controller instance.
  final AuthController controller;

  /// Optional callback executed when password reset completes successfully.
  final VoidCallback? onResetSuccess;

  /// Creates a [ResetPasswordFormWidget] instance.
  ResetPasswordFormWidget({
    super.key,
    required this.controller,
    this.onResetSuccess,
  });

  @override
  State<ResetPasswordFormWidget> createState() => _ResetPasswordFormWidgetState();
}

class _ResetPasswordFormWidgetState extends State<ResetPasswordFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _tokenController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();

  @override
  void dispose() {
    _tokenController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    super.dispose();
  }

  Future<void> _onResetPasswordPressed() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final success = await widget.controller.confirmPasswordReset(
      token: _tokenController.text.trim(),
      password: _passwordController.text,
      passwordConfirm: _passwordConfirmController.text,
    );
    if (success && widget.onResetSuccess != null) {
      widget.onResetSuccess!();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.resetPasswordSubtitle,
            style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          widget.textField(
            context: context,
            label: l10n.resetTokenLabel,
            placeholder: l10n.resetTokenPlaceholder,
            controller: _tokenController,
            prefix: const Icon(Icons.vpn_key_outlined, size: 20),
            validator: (value) => (value == null || value.trim().isEmpty) ? l10n.pleaseEnterResetToken : null,
          ),
          const SizedBox(height: 14),
          widget.passwordField(
            context: context,
            label: l10n.newPasswordLabel,
            placeholder: l10n.newPasswordPlaceholder,
            controller: _passwordController,
            validator: (value) {
              if (value == null || value.isEmpty) return l10n.pleaseEnterPassword;
              if (value.length < 8) return l10n.passwordMinLength;
              return null;
            },
          ),
          const SizedBox(height: 14),
          widget.passwordField(
            context: context,
            label: l10n.confirmNewPasswordLabel,
            placeholder: l10n.confirmNewPasswordPlaceholder,
            controller: _passwordConfirmController,
            validator: (value) => value != _passwordController.text ? l10n.passwordsDoNotMatch : null,
          ),
          const SizedBox(height: 20),
          widget.appButton(
            context: context,
            title: l10n.submit,
            icon: Icons.check_circle_rounded,
            isLoading: widget.controller.isLoading,
            height: 50,
            onPressed: _onResetPasswordPressed,
          ),
        ],
      ),
    );
  }
}

