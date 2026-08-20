import 'package:frosted_ui_kit/src/features/auth/data/models/auth_response_model.dart';
import 'package:frosted_ui_kit/src/features/auth/data/models/login_request_model.dart';
import 'package:frosted_ui_kit/src/features/auth/data/models/register_request_model.dart';
import 'package:frosted_ui_kit/src/features/auth/data/models/reset_password_request_model.dart';
import 'package:frosted_ui_kit/src/features/auth/data/models/user_model.dart';

/// Abstract contract for authentication remote data source endpoints.
///
/// Designed to be backend-agnostic for `frosted_ui_kit`.
abstract class AuthRemoteDataSource {
  /// Sends login credentials to authentication endpoint.
  Future<AuthResponseModel> login(LoginRequestModel request);

  /// Registers user payload with authentication endpoint.
  Future<UserModel> register(RegisterRequestModel request);

  /// Sends password reset request for specified email address.
  Future<void> requestPasswordReset(String email);

  /// Confirms password reset with token and new password payload model.
  Future<void> confirmPasswordReset(ResetPasswordRequestModel request);

  /// Confirms email verification with token.
  Future<void> confirmEmailVerification(String token);
}

/// In-memory mock implementation of [AuthRemoteDataSource] for UI testing and demonstration.
class MockAuthRemoteDataSource implements AuthRemoteDataSource {
  /// Creates a [MockAuthRemoteDataSource] instance.
  const MockAuthRemoteDataSource();

  @override
  Future<AuthResponseModel> login(LoginRequestModel request) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    final user = UserModel(
      id: 'mock_user_123',
      email: request.identity,
      name: 'Demo User',
      created: DateTime.now().toIso8601String(),
      updated: DateTime.now().toIso8601String(),
    );
    return AuthResponseModel(token: 'mock_jwt_token_12345', user: user);
  }

  @override
  Future<UserModel> register(RegisterRequestModel request) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    return UserModel(
      id: 'mock_user_${DateTime.now().millisecondsSinceEpoch}',
      email: request.email,
      name: request.name,
      customData: request.customData,
      created: DateTime.now().toIso8601String(),
      updated: DateTime.now().toIso8601String(),
    );
  }

  @override
  Future<void> requestPasswordReset(String email) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
  }

  @override
  Future<void> confirmPasswordReset(ResetPasswordRequestModel request) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
  }

  @override
  Future<void> confirmEmailVerification(String token) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
  }
}
