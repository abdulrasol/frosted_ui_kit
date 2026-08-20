import 'package:frosted_ui_kit/src/features/auth/domain/entities/user_entity.dart';

/// Entity representing successful authentication response holding bearer token and user entity.
class AuthResponseEntity {
  /// Authentication access token string.
  final String token;

  /// Authenticated user details entity.
  final UserEntity user;

  /// Creates an [AuthResponseEntity].
  const AuthResponseEntity({required this.token, required this.user});
}
