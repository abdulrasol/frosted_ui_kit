import 'package:frosted_ui_kit/src/features/auth/data/models/user_model.dart';
import 'package:frosted_ui_kit/src/features/auth/domain/entities/auth_response_entity.dart';

/// Data model representing authentication response from server holding token and user data.
class AuthResponseModel extends AuthResponseEntity {
  /// Creates an [AuthResponseModel].
  const AuthResponseModel({
    required super.token,
    required UserModel super.user,
  });

  /// Constructs an [AuthResponseModel] from server JSON response.
  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    final userJson =
        (json['record'] ?? json['user'] ?? <String, dynamic>{})
            as Map<String, dynamic>;
    return AuthResponseModel(
      token: json['token'] as String? ?? '',
      user: UserModel.fromJson(userJson),
    );
  }

  /// Converts model to pure [AuthResponseEntity].
  AuthResponseEntity toEntity() {
    return AuthResponseEntity(token: token, user: user);
  }
}
