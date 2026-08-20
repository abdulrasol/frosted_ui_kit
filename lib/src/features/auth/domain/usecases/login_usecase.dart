import 'package:frosted_ui_kit/src/features/auth/domain/entities/auth_response_entity.dart';
import 'package:frosted_ui_kit/src/features/auth/domain/repositories/auth_repository.dart';

/// Use case for logging in a user with email and password.
class LoginUseCase {
  final AuthRepository repository;

  /// Creates a [LoginUseCase] instance.
  const LoginUseCase(this.repository);

  /// Executes login request.
  Future<AuthResponseEntity> call({
    required String email,
    required String password,
  }) {
    return repository.login(email: email, password: password);
  }
}
