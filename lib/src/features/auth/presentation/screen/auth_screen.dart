import 'package:flutter/material.dart';
import 'package:frosted_ui_kit/src/core/l10n/arb/app_localizations.dart';
import 'package:frosted_ui_kit/src/extensions/context.dart';
import 'package:frosted_ui_kit/src/features/auth/presentation/controllers/auth_controller.dart';
import 'package:frosted_ui_kit/src/features/auth/presentation/widgets/login_form_widget.dart';
import 'package:frosted_ui_kit/src/features/auth/presentation/widgets/register_form_widget.dart';
import 'package:frosted_ui_kit/src/shared/widgets/base_widget.dart';
import 'package:frosted_ui_kit/src/shared/widgets/bottom_sheet.dart';
import 'package:frosted_ui_kit/src/shared/widgets/buttons.dart';
import 'package:frosted_ui_kit/src/shared/widgets/cards.dart';
import 'package:frosted_ui_kit/src/shared/widgets/tabs.dart';

/// Clean Authentication Screen with top sliding glassmorphic tabs and localized strings.
///
/// Designed to be reusable across apps with customizable callbacks and controllers.
class AuthScreen extends StatefulWidget
    with BottomSheets, Buttons, Cards, Tabs {
  /// Optional pre-configured [AuthController] instance. If null, created via [AuthController.create].
  final AuthController? controller;

  /// Optional callback invoked when sign-in completes successfully.
  final VoidCallback? onLoginSuccess;

  /// Optional callback invoked when registration completes successfully.
  final VoidCallback? onRegisterSuccess;

  /// Creates an [AuthScreen] instance.
  AuthScreen({
    super.key,
    this.controller,
    this.onLoginSuccess,
    this.onRegisterSuccess,
  });

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
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
    final l10n = AppLocalizations.of(context)!;
    final isLogin = _selectedTabIndex == 0;
    final authTabs = [l10n.signIn, l10n.register];

    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        return BaseWidget(
          title: isLogin ? l10n.signIn : l10n.register,
          child: Padding(
            padding: EdgeInsets.only(
              top: context.topPadding + 4,
              right: context.horizontalPadding,
              left: context.horizontalPadding,
            ),
            child: Column(
              children: [
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
                      ),
                      child: AnimatedCrossFade(
                        duration: const Duration(milliseconds: 300),
                        crossFadeState: isLogin
                            ? CrossFadeState.showFirst
                            : CrossFadeState.showSecond,
                        firstChild: LoginFormWidget(
                          controller: _controller,
                          onLoginSuccess: widget.onLoginSuccess,
                        ),
                        secondChild: RegisterFormWidget(
                          controller: _controller,
                          onRegisterSuccess: widget.onRegisterSuccess,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
