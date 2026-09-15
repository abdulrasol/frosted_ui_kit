import 'package:flutter/material.dart';
import 'package:frosted_ui_kit/src/core/l10n/arb/app_localizations.dart';
import 'package:frosted_ui_kit/src/features/auth/presentation/controllers/auth_controller.dart';
import 'package:frosted_ui_kit/src/shared/widgets/buttons.dart';
import 'package:frosted_ui_kit/src/shared/widgets/inputs.dart';

/// Form sub-widget for confirming email verification using token with localized strings and glassmorphic inputs.
///
/// Fully reusable across applications with support for custom callbacks.
class VerifyEmailFormWidget extends StatefulWidget with Buttons, Inputs {
  /// Auth controller instance.
  final AuthController controller;

  /// Optional callback executed when email verification completes successfully.
  final VoidCallback? onVerifySuccess;

  /// Creates a [VerifyEmailFormWidget] instance.
  VerifyEmailFormWidget({
    super.key,
    required this.controller,
    this.onVerifySuccess,
  });

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

  Future<void> _onVerifyPressed() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final success = await widget.controller.confirmEmailVerification(
      token: _tokenController.text.trim(),
    );
    if (success && widget.onVerifySuccess != null) {
      widget.onVerifySuccess!();
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
            l10n.verifyEmailSubtitle,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          widget.textField(
            context: context,
            label: l10n.verificationTokenLabel,
            placeholder: l10n.verificationTokenPlaceholder,
            controller: _tokenController,
            prefix: const Icon(Icons.verified_user_outlined, size: 20),
            validator: (value) => (value == null || value.trim().isEmpty)
                ? l10n.pleaseEnterVerificationToken
                : null,
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
