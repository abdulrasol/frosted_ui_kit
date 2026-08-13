import 'package:flutter/material.dart';
import 'package:starter/src/extensions/context.dart';
import 'package:starter/src/features/auth/presentation/controllers/auth_controller.dart';
import 'package:starter/src/shared/widgets/buttons.dart';
import 'package:starter/src/shared/widgets/inputs.dart';

/// Form sub-widget for requesting password reset email using localized strings.
class ForgotPasswordFormWidget extends StatefulWidget with Buttons, Inputs {
  /// Auth controller instance.
  final AuthController controller;

  /// Creates a [ForgotPasswordFormWidget].
  ForgotPasswordFormWidget({super.key, required this.controller});

  @override
  State<ForgotPasswordFormWidget> createState() => _ForgotPasswordFormWidgetState();
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

  void _onRequestResetPressed() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    widget.controller.requestPasswordReset(email: _emailController.text.trim());
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
            l10n.enterEmailToReset,
            style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          widget.textField(
            context: context,
            label: l10n.emailLabel,
            placeholder: l10n.emailPlaceholder,
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            prefix: const Icon(Icons.email_outlined, size: 20),
            validator: (value) {
              if (value == null || value.trim().isEmpty) return l10n.pleaseEnterEmail;
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
