import 'package:starter/src/features/auth/data/models/register_request_model.dart';
import 'package:starter/src/features/auth/domain/entities/user_entity.dart';
import 'package:starter/src/features/auth/domain/repositories/auth_repository.dart';

/// Use case for registering a new user account.
class RegisterUseCase {
  final AuthRepository repository;

  /// Creates a [RegisterUseCase] instance.
  const RegisterUseCase(this.repository);

  /// Executes user registration.
  Future<UserEntity> call(RegisterRequestModel request) {
    return repository.register(request);
  }
}
