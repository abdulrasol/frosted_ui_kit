import 'package:flutter/material.dart';
import 'package:frosted_ui_kit/src/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:frosted_ui_kit/src/features/auth/data/models/register_request_model.dart';
import 'package:frosted_ui_kit/src/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:frosted_ui_kit/src/features/auth/domain/entities/user_entity.dart';
import 'package:frosted_ui_kit/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:frosted_ui_kit/src/utils/logger.dart';

/// Available view modes for the unified authentication page flow.
enum AuthViewMode {
  /// User sign-in mode.
  login,

  /// User account registration mode.
  register,

  /// Request password reset email mode.
  forgotPassword,

  /// Confirm password reset with token mode.
  resetPassword,

  /// Confirm email verification with token mode.
  verifyEmail,
}

/// Steps representing email verification progress during registration flow.
enum VerificationProgressStep {
  /// Initial idle state.
  idle,

  /// Verification email request submitted.
  emailSent,

  /// Verification token entered.
  tokenEntered,

  /// Email successfully verified.
  verified,
}

/// Native [ChangeNotifier] controller managing state for the unified Auth page.
class AuthController extends ChangeNotifier {
  /// Authentication repository contract instance.
  final AuthRepository repository;

  /// Creates an [AuthController] with explicit repository dependency.
  AuthController({
    required this.repository,
    AuthViewMode initialMode = AuthViewMode.login,
  }) : _currentMode = initialMode;

  /// Factory constructor creating an [AuthController] with mock repository fallback for demo/testing.
  factory AuthController.create({
    AuthViewMode initialMode = AuthViewMode.login,
  }) {
    const remoteDataSource = MockAuthRemoteDataSource();
    const repository = AuthRepositoryImpl(remoteDataSource: remoteDataSource);
    return AuthController(repository: repository, initialMode: initialMode);
  }

  AuthViewMode _currentMode;

  /// Gets the currently active authentication view mode.
  AuthViewMode get currentMode => _currentMode;

  VerificationProgressStep _verificationStep = VerificationProgressStep.idle;

  /// Gets the current email verification progress step.
  VerificationProgressStep get verificationStep => _verificationStep;

  bool _isLoading = false;

  /// Indicates whether an async operation is currently executing.
  bool get isLoading => _isLoading;

  String? _errorMessage;

  /// Holds current error message string, if any.
  String? get errorMessage => _errorMessage;

  String? _successMessage;

  /// Holds current success message string, if any.
  String? get successMessage => _successMessage;

  UserEntity? _currentUser;

  /// Holds currently authenticated user entity.
  UserEntity? get currentUser => _currentUser;

  String? _pendingEmail;

  /// Email address pending verification or password reset.
  String? get pendingEmail => _pendingEmail;

  /// Switches active authentication view mode and clears messages.
  void switchMode(AuthViewMode mode) {
    _currentMode = mode;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }

  /// Clears error and success feedback messages.
  void clearMessages() {
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }

  /// Performs user sign-in authentication.
  Future<bool> login({required String email, required String password}) async {
    _setLoading(true);
    AppLogger.info('AuthController.login called for email: $email');
    try {
      final response = await repository.login(email: email, password: password);
      _currentUser = response.user;
      _successMessage =
          'Welcome back, ${response.user.name.isNotEmpty ? response.user.name : response.user.email}!';
      AppLogger.success(
        'AuthController.login success for user ID: ${response.user.id}',
      );
      _setLoading(false);
      return true;
    } catch (e) {
      AppLogger.error('AuthController.login failed: $e');
      _setError(e.toString());
      return false;
    }
  }

  /// Performs new user registration and advances to verification progress step.
  Future<bool> register(RegisterRequestModel request) async {
    _setLoading(true);
    AppLogger.info(
      'AuthController.register called for email: ${request.email}',
    );
    try {
      final user = await repository.register(request);
      _currentUser = user;
      _pendingEmail = user.email;
      _verificationStep = VerificationProgressStep.emailSent;
      _successMessage =
          'Account created for ${user.email}! Please verify your email.';
      _currentMode = AuthViewMode.verifyEmail;
      AppLogger.success(
        'AuthController.register success for user ID: ${user.id}',
      );
      _setLoading(false);
      return true;
    } catch (e) {
      AppLogger.error('AuthController.register failed: $e');
      _setError(e.toString());
      return false;
    }
  }

  /// Requests a password reset email token.
  Future<bool> requestPasswordReset({required String email}) async {
    _setLoading(true);
    AppLogger.info(
      'AuthController.requestPasswordReset called for email: $email',
    );
    try {
      await repository.requestPasswordReset(email: email);
      _pendingEmail = email;
      _successMessage = 'Password reset token sent to $email!';
      _currentMode = AuthViewMode.resetPassword;
      AppLogger.success('AuthController.requestPasswordReset success');
      _setLoading(false);
      return true;
    } catch (e) {
      AppLogger.error('AuthController.requestPasswordReset failed: $e');
      _setError(e.toString());
      return false;
    }
  }

  /// Confirms password reset with reset token and new password credentials.
  Future<bool> confirmPasswordReset({
    required String token,
    required String password,
    required String passwordConfirm,
  }) async {
    _setLoading(true);
    AppLogger.info('AuthController.confirmPasswordReset called');
    try {
      await repository.confirmPasswordReset(
        token: token,
        password: password,
        passwordConfirm: passwordConfirm,
      );
      _successMessage = 'Password updated successfully! You can now sign in.';
      _currentMode = AuthViewMode.login;
      AppLogger.success('AuthController.confirmPasswordReset success');
      _setLoading(false);
      return true;
    } catch (e) {
      AppLogger.error('AuthController.confirmPasswordReset failed: $e');
      _setError(e.toString());
      return false;
    }
  }

  /// Confirms email verification with token.
  Future<bool> confirmEmailVerification({required String token}) async {
    _setLoading(true);
    AppLogger.info('AuthController.confirmEmailVerification called');
    try {
      await repository.confirmEmailVerification(token: token);
      _verificationStep = VerificationProgressStep.verified;
      _successMessage = 'Email verified successfully!';
      _currentMode = AuthViewMode.login;
      AppLogger.success('AuthController.confirmEmailVerification success');
      _setLoading(false);
      return true;
    } catch (e) {
      AppLogger.error('AuthController.confirmEmailVerification failed: $e');
      _setError(e.toString());
      return false;
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }

  void _setError(Object error) {
    _isLoading = false;
    final str = error.toString();
    _errorMessage = str.startsWith('Exception: ') ? str.substring(11) : str;
    notifyListeners();
  }
}
