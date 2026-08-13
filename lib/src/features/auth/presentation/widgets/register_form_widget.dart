import 'package:flutter/material.dart';
import 'package:starter/src/extensions/context.dart';
import 'package:starter/src/features/auth/data/models/register_request_model.dart';
import 'package:starter/src/features/auth/presentation/controllers/auth_controller.dart';
import 'package:starter/src/shared/widgets/buttons.dart';
import 'package:starter/src/shared/widgets/inputs.dart';

/// Form sub-widget for user account registration using localized strings.
class RegisterFormWidget extends StatefulWidget with Buttons, Inputs {
  /// Auth controller instance.
  final AuthController controller;

  /// Creates a [RegisterFormWidget].
  RegisterFormWidget({super.key, required this.controller});

  @override
  State<RegisterFormWidget> createState() => _RegisterFormWidgetState();
}

class _RegisterFormWidgetState extends State<RegisterFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: 'test_815@example.com');
  final _nameController = TextEditingController(text: 'example text');
  final _passwordController = TextEditingController(text: '123456789');
  final _passwordConfirmController = TextEditingController(text: '123456789');

  bool _obscurePassword = true;
  bool _obscurePasswordConfirm = true;

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    super.dispose();
  }

  void _onRegisterPressed() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final request = RegisterRequestModel(
      email: _emailController.text.trim().toLowerCase(),
      name: _nameController.text.trim(),
      password: _passwordController.text,
      passwordConfirm: _passwordConfirmController.text,
    );
    widget.controller.register(request);
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
          const SizedBox(height: 16),

          Text(
            l10n.createAccount,
            style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 18),
          widget.textField(
            context: context,
            label: l10n.nameLabel,
            placeholder: l10n.namePlaceholder,
            controller: _nameController,
            prefix: const Icon(Icons.person_outline, size: 20),
            validator: (value) => (value == null || value.trim().isEmpty) ? l10n.pleaseEnterName : null,
          ),
          const SizedBox(height: 14),
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
          const SizedBox(height: 14),
          widget.textField(
            context: context,
            label: l10n.passwordLabel,
            placeholder: l10n.passwordPlaceholder,
            controller: _passwordController,
            obscureText: _obscurePassword,
            prefix: const Icon(Icons.lock_outline, size: 20),
            suffix: widget.cricleButton(
              size: 30,
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
            label: l10n.confirmPasswordLabel,
            placeholder: l10n.passwordPlaceholder,
            controller: _passwordConfirmController,
            obscureText: _obscurePasswordConfirm,
            prefix: const Icon(Icons.lock_outline, size: 20),
            suffix: widget.cricleButton(
              size: 30,
              context: context,
              icon: _obscurePasswordConfirm ? Icons.visibility_off_outlined : Icons.visibility_outlined,
              onPressed: () => setState(() => _obscurePasswordConfirm = !_obscurePasswordConfirm),
            ),
            validator: (value) => value != _passwordController.text ? l10n.passwordsDoNotMatch : null,
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
                onPressed: () => widget.controller.switchMode(AuthViewMode.login),
              ),
            ],
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}
