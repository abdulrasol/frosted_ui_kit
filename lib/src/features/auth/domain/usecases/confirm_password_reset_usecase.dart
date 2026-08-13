import 'package:starter/src/features/auth/domain/repositories/auth_repository.dart';

/// Use case for confirming password reset with token and new password.
class ConfirmPasswordResetUseCase {
  final AuthRepository repository;

  /// Creates a [ConfirmPasswordResetUseCase] instance.
  const ConfirmPasswordResetUseCase(this.repository);

  /// Executes password reset confirmation with token, password, and confirmation password.
  Future<void> call({
    required String token,
    required String password,
    required String passwordConfirm,
  }) {
    return repository.confirmPasswordReset(
      token: token,
      password: password,
      passwordConfirm: passwordConfirm,
    );
  }
}
