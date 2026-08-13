/// Data transfer model for password reset confirmation payload with token.
class ResetPasswordRequestModel {
  /// Reset token received via email.
  final String token;

  /// New password string.
  final String password;

  /// New password confirmation string.
  final String passwordConfirm;

  /// Creates a [ResetPasswordRequestModel].
  const ResetPasswordRequestModel({
    required this.token,
    required this.password,
    required this.passwordConfirm,
  });

  /// Converts reset password payload model into exact JSON map.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'token': token,
      'password': password,
      'passwordConfirm': passwordConfirm,
    };
  }

  /// Creates a [ResetPasswordRequestModel] from a JSON map.
  factory ResetPasswordRequestModel.fromJson(Map<String, dynamic> json) {
    return ResetPasswordRequestModel(
      token: json['token'] as String? ?? '',
      password: json['password'] as String? ?? '',
      passwordConfirm: json['passwordConfirm'] as String? ?? '',
    );
  }
}
