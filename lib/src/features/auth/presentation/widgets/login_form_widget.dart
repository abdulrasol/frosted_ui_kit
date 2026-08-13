import 'package:flutter/material.dart';
import 'package:starter/src/extensions/context.dart';
import 'package:starter/src/features/auth/presentation/controllers/auth_controller.dart';
import 'package:starter/src/features/auth/presentation/widgets/forgot_password_form_widget.dart';
import 'package:starter/src/features/auth/presentation/widgets/reset_password_form_widget.dart';
import 'package:starter/src/features/auth/presentation/widgets/verify_email_form_widget.dart';
import 'package:starter/src/shared/widgets/bottom_sheet.dart';
import 'package:starter/src/shared/widgets/buttons.dart';
import 'package:starter/src/shared/widgets/inputs.dart';

/// Form sub-widget for user sign-in credentials using localized strings.
class LoginFormWidget extends StatefulWidget with BottomSheets, Buttons, Inputs {
  /// Auth controller instance.
  final AuthController controller;

  /// Creates a [LoginFormWidget].
  LoginFormWidget({super.key, required this.controller});

  @override
  State<LoginFormWidget> createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginPressed() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    widget.controller.login(email: _emailController.text.trim(), password: _passwordController.text);
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
            l10n.welcomeBack,
            style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            l10n.signInSubtitle,
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
              return null;
            },
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: widget.appButton(
              style: AppButtonStyle.text,
              context: context,
              title: l10n.forgotPassword,
              height: 36,
              onPressed: () {
                widget.showAppBottomSheet(
                  context: context,
                  title: l10n.forgotPassword,
                  child: ForgotPasswordFormWidget(controller: widget.controller),
                );
              },
            ),
          ),
          const SizedBox(height: 18),
          widget.appButton(
            context: context,
            title: l10n.signIn,
            icon: Icons.login_rounded,
            isLoading: widget.controller.isLoading,
            height: 50,
            onPressed: _onLoginPressed,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(l10n.dontHaveAccount),
              const SizedBox(width: 8),
              widget.appButton(
                style: AppButtonStyle.colored,
                context: context,
                title: l10n.register,
                height: 36,
                onPressed: () => widget.controller.switchMode(AuthViewMode.register),
              ),
            ],
          ),

          // const Divider(height: 32),
          Row(
            spacing: 8,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              widget.appButton(
                context: context,
                style: AppButtonStyle.text,
                title: l10n.resetToken,
                height: 38,
                onPressed: () {
                  widget.showAppBottomSheet(
                    context: context,
                    title: l10n.resetPassword,
                    child: ResetPasswordFormWidget(controller: widget.controller),
                  );
                },
              ),
              widget.appButton(
                style: AppButtonStyle.text,
                context: context,
                title: l10n.verifyToken,
                height: 38,
                onPressed: () {
                  widget.showAppBottomSheet(
                    context: context,
                    title: l10n.verifyEmail,
                    child: VerifyEmailFormWidget(controller: widget.controller),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
