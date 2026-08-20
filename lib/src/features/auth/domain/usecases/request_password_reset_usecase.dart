import 'package:frosted_ui_kit/src/features/auth/domain/repositories/auth_repository.dart';

/// Use case for requesting a password reset email token.
class RequestPasswordResetUseCase {
  final AuthRepository repository;

  /// Creates a [RequestPasswordResetUseCase] instance.
  const RequestPasswordResetUseCase(this.repository);

  /// Executes password reset request.
  Future<void> call({required String email}) {
    return repository.requestPasswordReset(email: email);
  }
}
