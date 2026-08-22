import 'package:flutter/material.dart';
import 'package:frosted_ui_kit/src/core/l10n/arb/app_localizations.dart';
import 'package:frosted_ui_kit/src/features/auth/presentation/controllers/auth_controller.dart';
import 'package:frosted_ui_kit/src/features/auth/presentation/widgets/forgot_password_form_widget.dart';
import 'package:frosted_ui_kit/src/features/auth/presentation/widgets/reset_password_form_widget.dart';
import 'package:frosted_ui_kit/src/features/auth/presentation/widgets/verify_email_form_widget.dart';
import 'package:frosted_ui_kit/src/shared/widgets/bottom_sheet.dart';
import 'package:frosted_ui_kit/src/shared/widgets/buttons.dart';
import 'package:frosted_ui_kit/src/shared/widgets/inputs.dart';

/// Form sub-widget for user sign-in credentials using localized strings and glassmorphic inputs.
///
/// Designed to be completely reusable across apps. Supports optional callbacks for success
/// handling and custom navigation flows.
class LoginFormWidget extends StatefulWidget
    with BottomSheets, Buttons, Inputs {
  /// Auth controller instance.
  final AuthController controller;

  /// Optional callback executed when sign-in completes successfully.
  final VoidCallback? onLoginSuccess;

  /// Optional callback executed when user taps the "Register" button.
  final VoidCallback? onRegisterTap;

  final bool showRegisterButton;
  final bool showForgotPasswordButton;
  final bool showResetTokenButton;
  final bool showVerifyTokenButton;

  /// Optional custom button overrides
  final Widget? customLoginButton;
  final Widget? customRegisterButton;
  final Widget? customForgotPasswordButton;
  final Widget? customResetTokenButton;
  final Widget? customVerifyTokenButton;

  /// Creates a [LoginFormWidget] instance.
  LoginFormWidget({
    super.key,
    required this.controller,
    this.onLoginSuccess,
    this.onRegisterTap,
    this.showRegisterButton = true,
    this.showForgotPasswordButton = true,
    this.showResetTokenButton = true,
    this.showVerifyTokenButton = true,
    this.customLoginButton,
    this.customRegisterButton,
    this.customForgotPasswordButton,
    this.customResetTokenButton,
    this.customVerifyTokenButton,
  });

  @override
  State<LoginFormWidget> createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onLoginPressed() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final success = await widget.controller.login(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );
    if (success && widget.onLoginSuccess != null) {
      widget.onLoginSuccess!();
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
          const SizedBox(height: 16),
          Text(
            l10n.welcomeBack,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            l10n.signInSubtitle,
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
              return null;
            },
          ),
          const SizedBox(height: 8),
          if (widget.showForgotPasswordButton)
            Align(
              alignment: Alignment.centerRight,
              child: widget.customForgotPasswordButton ??
                  widget.appButton(
                    style: AppButtonStyle.text,
                    context: context,
                    title: l10n.forgotPassword,
                    height: 36,
                    onPressed: () {
                      widget.showAppBottomSheet(
                        context: context,
                        title: l10n.forgotPassword,
                        child: ForgotPasswordFormWidget(
                          controller: widget.controller,
                        ),
                      );
                    },
                  ),
            ),
          const SizedBox(height: 18),
          widget.customLoginButton ??
              widget.appButton(
                context: context,
                title: l10n.signIn,
                icon: Icons.login_rounded,
                isLoading: widget.controller.isLoading,
                height: 50,
                onPressed: _onLoginPressed,
              ),
          const SizedBox(height: 16),
          if (widget.showRegisterButton)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(l10n.dontHaveAccount),
                const SizedBox(width: 8),
                widget.customRegisterButton ??
                    widget.appButton(
                      style: AppButtonStyle.colored,
                      context: context,
                      title: l10n.register,
                      height: 36,
                      onPressed: () {
                        if (widget.onRegisterTap != null) {
                          widget.onRegisterTap!();
                        } else {
                          widget.controller.switchMode(AuthViewMode.register);
                        }
                      },
                    ),
              ],
            ),
          if (widget.showResetTokenButton || widget.showVerifyTokenButton)
            Row(
              spacing: 8,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                if (widget.showResetTokenButton)
                  widget.customResetTokenButton ??
                      widget.appButton(
                        context: context,
                        style: AppButtonStyle.text,
                        title: l10n.resetToken,
                        height: 38,
                        onPressed: () {
                          widget.showAppBottomSheet(
                            context: context,
                            title: l10n.resetPassword,
                            child: ResetPasswordFormWidget(
                              controller: widget.controller,
                            ),
                          );
                        },
                      ),
                if (widget.showVerifyTokenButton)
                  widget.customVerifyTokenButton ??
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
