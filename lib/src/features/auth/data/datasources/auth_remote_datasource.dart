import 'package:pocketbase/pocketbase.dart';
import 'package:starter/src/features/auth/data/models/auth_response_model.dart';
import 'package:starter/src/features/auth/data/models/login_request_model.dart';
import 'package:starter/src/features/auth/data/models/register_request_model.dart';
import 'package:starter/src/features/auth/data/models/reset_password_request_model.dart';
import 'package:starter/src/features/auth/data/models/user_model.dart';
import 'package:starter/src/utils/logger.dart';

/// Abstract contract for authentication remote data source endpoints.
abstract class AuthRemoteDataSource {
  /// Sends login credentials to PocketBase authentication endpoint.
  Future<AuthResponseModel> login(LoginRequestModel request);

  /// Registers user payload with PocketBase collection endpoint.
  Future<UserModel> register(RegisterRequestModel request);

  /// Sends password reset request for specified email via PocketBase.
  Future<void> requestPasswordReset(String email);

  /// Confirms password reset with token and new password payload model via PocketBase.
  Future<void> confirmPasswordReset(ResetPasswordRequestModel request);

  /// Confirms email verification with token via PocketBase.
  Future<void> confirmEmailVerification(String token);
}

/// Production implementation of [AuthRemoteDataSource] powered by PocketBase SDK with request logging and error parsing.
///
/// Connects to PocketBase backend instance at `https://api.subultech.top` (or custom URL).
/// Uses official `PocketBase` client instance: `final pb = PocketBase('https://api.subultech.top');`.
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  /// Base API URL string for PocketBase backend (default: `https://api.subultech.top`).
  final String baseUrl;

  /// Active [PocketBase] client instance.
  final PocketBase pb;

  /// Default production PocketBase API endpoint URL.
  static const String defaultBaseUrl = 'https://api.subultech.top';

  /// Creates an [AuthRemoteDataSourceImpl] with configurable [baseUrl] or custom [client].
  ///
  /// Example initialization: `final pb = PocketBase('https://api.subultech.top');`
  AuthRemoteDataSourceImpl({
    this.baseUrl = defaultBaseUrl,
    PocketBase? client,
  }) : pb = client ?? PocketBase(baseUrl);

  /// Helper method to extract clean human-readable error messages from PocketBase [ClientException].
  String _parseClientException(ClientException e) {
    // 1. Check HTTP status codes for gateway or server failures
    if (e.statusCode == 502) {
      return 'Server gateway error (502 Bad Gateway). Please try again in a moment.';
    }
    if (e.statusCode == 503) {
      return 'Service temporarily unavailable (503). Please try again shortly.';
    }
    if (e.statusCode == 504) {
      return 'Server gateway timeout (504). Please try again.';
    }
    if (e.statusCode == 500) {
      return 'Internal server error (500). Please try again later.';
    }

    // 2. Check nested field validation error messages in response['data']
    final data = e.response['data'];
    if (data is Map<String, dynamic> && data.isNotEmpty) {
      for (final entry in data.entries) {
        if (entry.value is Map<String, dynamic>) {
          final fieldData = entry.value as Map<String, dynamic>;
          final fieldMsg = fieldData['message'] as String?;
          final fieldCode = fieldData['code'] as String?;
          if (fieldCode == 'validation_not_unique' || fieldMsg == 'Value must be unique.') {
            return 'An account with this ${entry.key} already exists.';
          }
          if (fieldMsg != null && fieldMsg.isNotEmpty) {
            return fieldMsg;
          }
        }
      }
    }

    // 3. Fallback to main response message if available
    final mainMsg = e.response['message'] as String?;
    if (mainMsg != null && mainMsg.isNotEmpty) {
      return mainMsg;
    }

    return 'Authentication request failed (Status ${e.statusCode}).';
  }

  @override
  Future<AuthResponseModel> login(LoginRequestModel request) async {
    final endpoint = '$baseUrl/api/collections/users/auth-with-password';
    AppLogger.info('[AUTH POST] Requesting -> $endpoint (Identity: ${request.identity})');

    try {
      // 1. Authenticate user identity (email) and password against PocketBase 'users' collection
      final authData = await pb.collection('users').authWithPassword(
            request.identity,
            request.password,
          );

      AppLogger.success('[AUTH POST] 200 OK -> $endpoint (User ID: ${authData.record.id})');

      // 2. Map PocketBase RecordAuth (token and RecordModel) into AuthResponseModel
      return AuthResponseModel.fromJson(<String, dynamic>{
        'token': authData.token,
        'record': authData.record.toJson(),
      });
    } on ClientException catch (e, stackTrace) {
      final parsedMsg = _parseClientException(e);
      AppLogger.error('[AUTH POST] Error ${e.statusCode} -> $endpoint: $parsedMsg', e, stackTrace);
      throw parsedMsg;
    } catch (e, stackTrace) {
      AppLogger.error('[AUTH POST] Unexpected error -> $endpoint: $e', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<UserModel> register(RegisterRequestModel request) async {
    final endpoint = '$baseUrl/api/collections/users/records';
    AppLogger.info('[POST] Requesting -> $endpoint (Email: ${request.email})');

    try {
      // 1. Create new record in PocketBase 'users' collection using user request model
      final recordModel = await pb.collection('users').create(
            body: request.toJson(),
          );

      AppLogger.success('[POST] 200 OK -> $endpoint (User ID: ${recordModel.id})');

      // 2. Map PocketBase RecordModel to UserModel entity DTO
      return UserModel.fromJson(recordModel.toJson());
    } on ClientException catch (e, stackTrace) {
      final parsedMsg = _parseClientException(e);
      AppLogger.error('[POST] Error ${e.statusCode} -> $endpoint: $parsedMsg', e, stackTrace);
      throw parsedMsg;
    } catch (e, stackTrace) {
      AppLogger.error('[POST] Unexpected error -> $endpoint: $e', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> requestPasswordReset(String email) async {
    final endpoint = '$baseUrl/api/collections/users/request-password-reset';
    AppLogger.info('[POST] Requesting -> $endpoint (Email: $email)');

    try {
      // Request password reset email from PocketBase backend for target email
      await pb.collection('users').requestPasswordReset(email);
      AppLogger.success('[POST] 200 OK -> $endpoint (Reset email sent to $email)');
    } on ClientException catch (e, stackTrace) {
      final parsedMsg = _parseClientException(e);
      AppLogger.error('[POST] Error ${e.statusCode} -> $endpoint: $parsedMsg', e, stackTrace);
      throw parsedMsg;
    } catch (e, stackTrace) {
      AppLogger.error('[POST] Unexpected error -> $endpoint: $e', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> confirmPasswordReset(ResetPasswordRequestModel request) async {
    final endpoint = '$baseUrl/api/collections/users/confirm-password-reset';
    AppLogger.info('[POST] Requesting -> $endpoint');

    try {
      // Confirm password reset token with new password and password confirmation
      await pb.collection('users').confirmPasswordReset(
            request.token,
            request.password,
            request.passwordConfirm,
          );
      AppLogger.success('[POST] 200 OK -> $endpoint (Password reset confirmed)');
    } on ClientException catch (e, stackTrace) {
      final parsedMsg = _parseClientException(e);
      AppLogger.error('[POST] Error ${e.statusCode} -> $endpoint: $parsedMsg', e, stackTrace);
      throw parsedMsg;
    } catch (e, stackTrace) {
      AppLogger.error('[POST] Unexpected error -> $endpoint: $e', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> confirmEmailVerification(String token) async {
    final endpoint = '$baseUrl/api/collections/users/confirm-verification';
    AppLogger.info('[POST] Requesting -> $endpoint');

    try {
      // Confirm email verification token with PocketBase 'users' collection
      await pb.collection('users').confirmVerification(token);
      AppLogger.success('[POST] 200 OK -> $endpoint (Email verified successfully)');
    } on ClientException catch (e, stackTrace) {
      final parsedMsg = _parseClientException(e);
      AppLogger.error('[POST] Error ${e.statusCode} -> $endpoint: $parsedMsg', e, stackTrace);
      throw parsedMsg;
    } catch (e, stackTrace) {
      AppLogger.error('[POST] Unexpected error -> $endpoint: $e', e, stackTrace);
      rethrow;
    }
  }
}
