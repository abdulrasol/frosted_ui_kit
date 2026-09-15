import 'package:flutter/material.dart';
import 'package:frosted_ui_kit/src/core/l10n/arb/app_localizations.dart';
import 'package:frosted_ui_kit/src/features/auth/data/models/register_request_model.dart';
import 'package:frosted_ui_kit/src/features/auth/presentation/controllers/auth_controller.dart';
import 'package:frosted_ui_kit/src/shared/widgets/buttons.dart';
import 'package:frosted_ui_kit/src/shared/widgets/inputs.dart';

/// Form sub-widget for user account registration using localized strings and glassmorphic inputs.
///
/// Designed to be completely reusable across applications. Supports custom field inputs
/// and optional callbacks for integration with navigation flows.
class RegisterFormWidget extends StatefulWidget with Buttons, Inputs {
  /// Active authentication controller instance.
  final AuthController controller;

  /// Optional callback triggered when registration completes successfully.
  final VoidCallback? onRegisterSuccess;

  /// Optional callback triggered when user taps the "Sign In" button.
  final VoidCallback? onLoginTap;

  /// Creates a [RegisterFormWidget] instance.
  RegisterFormWidget({
    super.key,
    required this.controller,
    this.onRegisterSuccess,
    this.onLoginTap,
  });

  @override
  State<RegisterFormWidget> createState() => _RegisterFormWidgetState();
}

class _RegisterFormWidgetState extends State<RegisterFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    super.dispose();
  }

  Future<void> _onRegisterPressed() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final request = RegisterRequestModel(
      email: _emailController.text.trim().toLowerCase(),
      name: _nameController.text.trim(),
      password: _passwordController.text,
      passwordConfirm: _passwordConfirmController.text,
    );
    final success = await widget.controller.register(request);
    if (success && widget.onRegisterSuccess != null) {
      widget.onRegisterSuccess!();
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
          const SizedBox(height: 16),

          Text(
            l10n.createAccount,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 18),
          widget.nameField(
            context: context,
            label: l10n.nameLabel,
            placeholder: l10n.namePlaceholder,
            controller: _nameController,
            validator: (value) => (value == null || value.trim().isEmpty)
                ? l10n.pleaseEnterName
                : null,
          ),
          const SizedBox(height: 14),
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
          const SizedBox(height: 14),
          widget.passwordField(
            context: context,
            label: l10n.passwordLabel,
            placeholder: l10n.passwordPlaceholder,
            controller: _passwordController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return l10n.pleaseEnterPassword;
              }
              if (value.length < 8) return l10n.passwordMinLength;
              return null;
            },
          ),
          const SizedBox(height: 14),
          widget.passwordField(
            context: context,
            label: l10n.confirmPasswordLabel,
            placeholder: l10n.passwordPlaceholder,
            controller: _passwordConfirmController,
            validator: (value) => value != _passwordController.text
                ? l10n.passwordsDoNotMatch
                : null,
          ),

          const SizedBox(height: 16),
          widget.appButton(
            context: context,
            title: l10n.registerAccount,
            icon: Icons.person_add_rounded,
            isLoading: widget.controller.isLoading,
            height: 50,
            onPressed: _onRegisterPressed,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(l10n.alreadyHaveAccount),
              const SizedBox(width: 8),
              widget.appButton(
                style: AppButtonStyle.colored,
                context: context,
                title: l10n.signIn,
                height: 36,
                onPressed: () {
                  if (widget.onLoginTap != null) {
                    widget.onLoginTap!();
                  } else {
                    widget.controller.switchMode(AuthViewMode.login);
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}
