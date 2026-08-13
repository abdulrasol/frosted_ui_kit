import 'package:flutter/material.dart';
import 'package:starter/src/extensions/context.dart';
import 'package:starter/src/features/auth/presentation/controllers/auth_controller.dart';
import 'package:starter/src/shared/widgets/buttons.dart';
import 'package:starter/src/shared/widgets/inputs.dart';

/// Form sub-widget for resetting password using reset token with localized strings.
class ResetPasswordFormWidget extends StatefulWidget with Buttons, Inputs {
  /// Auth controller instance.
  final AuthController controller;

  /// Creates a [ResetPasswordFormWidget].
  ResetPasswordFormWidget({super.key, required this.controller});

  @override
  State<ResetPasswordFormWidget> createState() => _ResetPasswordFormWidgetState();
}

class _ResetPasswordFormWidgetState extends State<ResetPasswordFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _tokenController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscurePasswordConfirm = true;

  @override
  void dispose() {
    _tokenController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    super.dispose();
  }

  void _onResetPasswordPressed() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    widget.controller.confirmPasswordReset(
      token: _tokenController.text.trim(),
      password: _passwordController.text,
      passwordConfirm: _passwordConfirmController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

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
          widget.textField(
            context: context,
            label: l10n.newPasswordLabel,
            placeholder: l10n.newPasswordPlaceholder,
            controller: _passwordController,
            obscureText: _obscurePassword,
            prefix: const Icon(Icons.lock_outline, size: 20),
            suffix: widget.cricleButton(
              context: context,
              icon: _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) return l10n.pleaseEnterPassword;
              if (value.length < 8) return l10n.passwordMinLength;
              return null;
            },
          ),
          const SizedBox(height: 14),
          widget.textField(
            context: context,
            label: l10n.confirmNewPasswordLabel,
            placeholder: l10n.confirmNewPasswordPlaceholder,
            controller: _passwordConfirmController,
            obscureText: _obscurePasswordConfirm,
            prefix: const Icon(Icons.lock_outline, size: 20),
            suffix: widget.cricleButton(
              context: context,
              icon: _obscurePasswordConfirm ? Icons.visibility_off_outlined : Icons.visibility_outlined,
              onPressed: () => setState(() => _obscurePasswordConfirm = !_obscurePasswordConfirm),
            ),
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
