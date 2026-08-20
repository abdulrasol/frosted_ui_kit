import 'package:frosted_ui_kit/src/features/auth/domain/repositories/auth_repository.dart';

/// Use case for verifying email address with verification token.
class ConfirmEmailVerificationUseCase {
  final AuthRepository repository;

  /// Creates a [ConfirmEmailVerificationUseCase] instance.
  const ConfirmEmailVerificationUseCase(this.repository);

  /// Executes email verification token confirmation.
  Future<void> call({required String token}) {
    return repository.confirmEmailVerification(token: token);
  }
}
