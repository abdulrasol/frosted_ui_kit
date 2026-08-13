import 'package:flutter/material.dart';
import 'package:starter/src/extensions/context.dart';
import 'package:starter/src/features/auth/presentation/controllers/auth_controller.dart';
import 'package:starter/src/shared/widgets/buttons.dart';
import 'package:starter/src/shared/widgets/inputs.dart';

/// Form sub-widget for confirming email verification using token with localized strings.
class VerifyEmailFormWidget extends StatefulWidget with Buttons, Inputs {
  /// Auth controller instance.
  final AuthController controller;

  /// Creates a [VerifyEmailFormWidget].
  VerifyEmailFormWidget({super.key, required this.controller});

  @override
  State<VerifyEmailFormWidget> createState() => _VerifyEmailFormWidgetState();
}

class _VerifyEmailFormWidgetState extends State<VerifyEmailFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _tokenController = TextEditingController();

  @override
  void dispose() {
    _tokenController.dispose();
    super.dispose();
  }

  void _onVerifyPressed() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    widget.controller.confirmEmailVerification(token: _tokenController.text.trim());
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
            l10n.verifyEmailSubtitle,
            style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          widget.textField(
            context: context,
            label: l10n.verificationTokenLabel,
            placeholder: l10n.verificationTokenPlaceholder,
            controller: _tokenController,
            prefix: const Icon(Icons.verified_user_outlined, size: 20),
            validator: (value) => (value == null || value.trim().isEmpty) ? l10n.pleaseEnterVerificationToken : null,
          ),
          const SizedBox(height: 20),
          widget.appButton(
            context: context,
            title: l10n.verifyEmail,
            icon: Icons.verified_rounded,
            isLoading: widget.controller.isLoading,
            height: 50,
            onPressed: _onVerifyPressed,
          ),
        ],
      ),
    );
  }
}
