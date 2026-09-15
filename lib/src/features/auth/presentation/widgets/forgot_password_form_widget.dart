import 'package:flutter/material.dart';
import 'package:frosted_ui_kit/src/core/l10n/arb/app_localizations.dart';
import 'package:frosted_ui_kit/src/features/auth/presentation/controllers/auth_controller.dart';
import 'package:frosted_ui_kit/src/shared/widgets/buttons.dart';
import 'package:frosted_ui_kit/src/shared/widgets/inputs.dart';

/// Form sub-widget for requesting password reset email using localized strings and glassmorphic inputs.
///
/// Fully reusable across applications with support for custom callbacks.
class ForgotPasswordFormWidget extends StatefulWidget with Buttons, Inputs {
  /// Auth controller instance.
  final AuthController controller;

  /// Optional callback invoked when the password reset link is requested.
  final VoidCallback? onRequestSent;

  /// Creates a [ForgotPasswordFormWidget] instance.
  ForgotPasswordFormWidget({
    super.key,
    required this.controller,
    this.onRequestSent,
  });

  @override
  State<ForgotPasswordFormWidget> createState() =>
      _ForgotPasswordFormWidgetState();
}

class _ForgotPasswordFormWidgetState extends State<ForgotPasswordFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.controller.pendingEmail != null) {
      _emailController.text = widget.controller.pendingEmail!;
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _onRequestResetPressed() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final success = await widget.controller.requestPasswordReset(
      email: _emailController.text.trim(),
    );
    if (success && widget.onRequestSent != null) {
      widget.onRequestSent!();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = FrostedAppLocalizations.of(context)!;

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.enterEmailToReset,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          widget.emailField(
            context: context,
            label: l10n.emailLabel,
            placeholder: l10n.emailPlaceholder,
            controller: _emailController,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return l10n.pleaseEnterEmail;
              }
              if (!value.contains('@')) return l10n.pleaseEnterValidEmail;
              return null;
            },
          ),
          const SizedBox(height: 20),
          widget.appButton(
            context: context,
            title: l10n.sendResetLink,
            icon: Icons.send_rounded,
            isLoading: widget.controller.isLoading,
            height: 50,
            onPressed: _onRequestResetPressed,
          ),
        ],
      ),
    );
  }
}
