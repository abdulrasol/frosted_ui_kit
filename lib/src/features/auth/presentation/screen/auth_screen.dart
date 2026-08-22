import 'package:flutter/material.dart';
import 'package:frosted_ui_kit/src/core/l10n/arb/app_localizations.dart';
import 'package:frosted_ui_kit/src/extensions/context.dart';
import 'package:frosted_ui_kit/src/features/auth/presentation/controllers/auth_controller.dart';
import 'package:frosted_ui_kit/src/features/auth/presentation/widgets/login_form_widget.dart';
import 'package:frosted_ui_kit/src/features/auth/presentation/widgets/register_form_widget.dart';
import 'package:frosted_ui_kit/src/shared/widgets/base_widget.dart';
import 'package:frosted_ui_kit/src/shared/widgets/tabs.dart';

/// Clean Authentication Screen with top sliding glassmorphic tabs and localized strings.
///
/// Designed to be reusable across apps with customizable callbacks and controllers.
class AuthScreen extends StatelessWidget {
  /// Optional pre-configured [AuthController] instance.
  final AuthController? controller;
  final VoidCallback? onLoginSuccess;
  final VoidCallback? onRegisterSuccess;
  
  /// Feature flags to enable/disable specific auth flows.
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

  const AuthScreen({
    super.key,
    this.controller,
    this.onLoginSuccess,
    this.onRegisterSuccess,
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
  Widget build(BuildContext context) {
    // AuthView manages its own state and reads current mode from its controller,
    // but we can't easily sync the BaseWidget title without listening.
    // For simplicity, we just use a static title or wrap it in a listener.
    return ListenableBuilder(
      listenable: controller ?? AuthController.create(), // If we need to listen, but AuthView creates its own if null.
      // Actually, better to just let AuthView handle it. Let's just pass title 'Authentication'
      builder: (context, _) => BaseWidget(
        title: 'Authentication',
        child: AuthView(
          controller: controller,
          onLoginSuccess: onLoginSuccess,
          onRegisterSuccess: onRegisterSuccess,
          showRegisterButton: showRegisterButton,
          showForgotPasswordButton: showForgotPasswordButton,
          showResetTokenButton: showResetTokenButton,
          showVerifyTokenButton: showVerifyTokenButton,
          customLoginButton: customLoginButton,
          customRegisterButton: customRegisterButton,
          customForgotPasswordButton: customForgotPasswordButton,
          customResetTokenButton: customResetTokenButton,
          customVerifyTokenButton: customVerifyTokenButton,
        ),
      ),
    );
  }
}

/// The embeddable view containing the sliding tabs and auth forms.
class AuthView extends StatefulWidget with Tabs {
  final AuthController? controller;
  final VoidCallback? onLoginSuccess;
  final VoidCallback? onRegisterSuccess;
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

  AuthView({
    super.key,
    this.controller,
    this.onLoginSuccess,
    this.onRegisterSuccess,
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
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  late final AuthController _controller;
  bool _createdControllerLocally = false;
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      _controller = widget.controller!;
    } else {
      _controller = AuthController.create();
      _createdControllerLocally = true;
    }
    _controller.addListener(_onStateChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onStateChanged);
    if (_createdControllerLocally) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _onStateChanged() {
    if (!mounted) return;
    final success = _controller.successMessage;
    final error = _controller.errorMessage;

    final targetIndex = _controller.currentMode == AuthViewMode.register ? 1 : 0;
    if (_selectedTabIndex != targetIndex) {
      setState(() {
        _selectedTabIndex = targetIndex;
      });
    }

    if (success != null) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(success), backgroundColor: Colors.green));
    } else if (error != null) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error), backgroundColor: Colors.red));
    }
  }

  void _onTabSelected(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
    _controller.switchMode(index == 0 ? AuthViewMode.login : AuthViewMode.register);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isLogin = _selectedTabIndex == 0;
    final authTabs = [l10n.signIn, l10n.register];

    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        return Padding(
          padding: EdgeInsets.only(top: context.topPadding + 4, right: context.horizontalPadding, left: context.horizontalPadding),
          child: Column(
            children: [
              if (widget.showRegisterButton)
                widget.appSlidingTabs(context: context, tabs: authTabs, selectedIndex: _selectedTabIndex, onTabChanged: _onTabSelected),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(top: context.horizontalPadding + 4, left: 16, right: 16, bottom: 40),
                    child: AnimatedCrossFade(
                      duration: const Duration(milliseconds: 300),
                      crossFadeState: isLogin ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                      firstChild: LoginFormWidget(
                        controller: _controller,
                        onLoginSuccess: widget.onLoginSuccess,
                        showRegisterButton: widget.showRegisterButton,
                        showForgotPasswordButton: widget.showForgotPasswordButton,
                        showResetTokenButton: widget.showResetTokenButton,
                        showVerifyTokenButton: widget.showVerifyTokenButton,
                        customLoginButton: widget.customLoginButton,
                        customRegisterButton: widget.customRegisterButton,
                        customForgotPasswordButton: widget.customForgotPasswordButton,
                        customResetTokenButton: widget.customResetTokenButton,
                        customVerifyTokenButton: widget.customVerifyTokenButton,
                      ),
                      secondChild: widget.showRegisterButton
                          ? RegisterFormWidget(controller: _controller, onRegisterSuccess: widget.onRegisterSuccess)
                          : const SizedBox.shrink(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
