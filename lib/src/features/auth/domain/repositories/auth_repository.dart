import 'package:frosted_ui_kit/src/features/auth/data/models/register_request_model.dart';
import 'package:frosted_ui_kit/src/features/auth/domain/entities/auth_response_entity.dart';
import 'package:frosted_ui_kit/src/features/auth/domain/entities/user_entity.dart';

/// Abstract domain repository interface contract for authentication operations.
abstract class AuthRepository {
  /// Authenticates user with email and password.
  Future<AuthResponseEntity> login({
    required String email,
    required String password,
  });

  /// Registers a new user account with provided registration payload model.
  Future<UserEntity> register(RegisterRequestModel request);

  /// Requests a password reset email for specified user email address.
  Future<void> requestPasswordReset({required String email});

  /// Confirms password reset using reset token and new password credentials.
  Future<void> confirmPasswordReset({
    required String token,
    required String password,
    required String passwordConfirm,
  });

  /// Confirms email address verification using verification token.
  Future<void> confirmEmailVerification({required String token});
}
