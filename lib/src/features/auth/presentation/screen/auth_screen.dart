import 'package:material_ui/material_ui.dart';
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

  /// Called after a successful login flow.
  final VoidCallback? onLoginSuccess;

  /// Called after a successful registration flow.
  final VoidCallback? onRegisterSuccess;

  /// Feature flags to enable/disable specific auth flows.
  final bool showRegisterButton;
  final bool showForgotPasswordButton;
  final bool showResetTokenButton;
  final bool showVerifyTokenButton;

  /// Optional custom login button override.
  final Widget? customLoginButton;

  /// Optional custom registration button override.
  final Widget? customRegisterButton;

  /// Optional custom password-reset request button override.
  final Widget? customForgotPasswordButton;

  /// Optional custom password-reset confirmation button override.
  final Widget? customResetTokenButton;

  /// Optional custom email-verification button override.
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
    return BaseWidget(
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
    );
  }
}

/// The embeddable view containing the sliding tabs and auth forms.
class AuthView extends StatefulWidget with Tabs {
  /// Optional controller. When omitted, a disposable demo controller is used.
  final AuthController? controller;

  /// Called after a successful login flow.
  final VoidCallback? onLoginSuccess;

  /// Called after a successful registration flow.
  final VoidCallback? onRegisterSuccess;

  /// Whether the register tab and related action are visible.
  final bool showRegisterButton;

  /// Whether the forgot-password action is visible.
  final bool showForgotPasswordButton;

  /// Whether the reset-token action is visible.
  final bool showResetTokenButton;

  /// Whether the verification-token action is visible.
  final bool showVerifyTokenButton;

  /// Optional custom login button override.
  final Widget? customLoginButton;

  /// Optional custom registration button override.
  final Widget? customRegisterButton;

  /// Optional custom password-reset request button override.
  final Widget? customForgotPasswordButton;

  /// Optional custom password-reset confirmation button override.
  final Widget? customResetTokenButton;

  /// Optional custom email-verification button override.
  final Widget? customVerifyTokenButton;

  /// Creates an embeddable authentication view.
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

    final targetIndex = _controller.currentMode == AuthViewMode.register
        ? 1
        : 0;
    if (_selectedTabIndex != targetIndex) {
      setState(() {
        _selectedTabIndex = targetIndex;
      });
    }

    if (success != null) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(success), backgroundColor: Colors.green),
      );
    } else if (error != null) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: Colors.red),
      );
    }
  }

  void _onTabSelected(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
    _controller.switchMode(
      index == 0 ? AuthViewMode.login : AuthViewMode.register,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = FrostedAppLocalizations.of(context)!;
    final isLogin = _selectedTabIndex == 0;
    final authTabs = [l10n.signIn, l10n.register];

    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        return Padding(
          padding: EdgeInsets.only(
            top: context.topPadding + 4,
            right: context.horizontalPadding,
            left: context.horizontalPadding,
          ),
          child: Column(
            children: [
              if (widget.showRegisterButton)
                widget.appSlidingTabs(
                  context: context,
                  tabs: authTabs,
                  selectedIndex: _selectedTabIndex,
                  onTabChanged: _onTabSelected,
                ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: context.horizontalPadding + 4,
                      left: 16,
                      right: 16,
                      bottom: 40,
                    ),
                    child: AnimatedCrossFade(
                      duration: const Duration(milliseconds: 300),
                      crossFadeState: isLogin
                          ? CrossFadeState.showFirst
                          : CrossFadeState.showSecond,
                      firstChild: LoginFormWidget(
                        controller: _controller,
                        onLoginSuccess: widget.onLoginSuccess,
                        showRegisterButton: widget.showRegisterButton,
                        showForgotPasswordButton:
                            widget.showForgotPasswordButton,
                        showResetTokenButton: widget.showResetTokenButton,
                        showVerifyTokenButton: widget.showVerifyTokenButton,
                        customLoginButton: widget.customLoginButton,
                        customRegisterButton: widget.customRegisterButton,
                        customForgotPasswordButton:
                            widget.customForgotPasswordButton,
                        customResetTokenButton: widget.customResetTokenButton,
                        customVerifyTokenButton: widget.customVerifyTokenButton,
                      ),
                      secondChild: widget.showRegisterButton
                          ? RegisterFormWidget(
                              controller: _controller,
                              onRegisterSuccess: widget.onRegisterSuccess,
                            )
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
