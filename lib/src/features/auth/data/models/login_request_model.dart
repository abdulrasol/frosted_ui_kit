/// Data transfer model for user login request payload.
class LoginRequestModel {
  /// User email or identity username string.
  final String identity;

  /// User password.
  final String password;

  /// Creates a [LoginRequestModel].
  const LoginRequestModel({
    required this.identity,
    required this.password,
  });

  /// Converts login credentials to JSON map.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'identity': identity,
      'password': password,
    };
  }

  /// Creates a [LoginRequestModel] from JSON map.
  factory LoginRequestModel.fromJson(Map<String, dynamic> json) {
    return LoginRequestModel(
      identity: (json['identity'] ?? json['email']) as String? ?? '',
      password: json['password'] as String? ?? '',
    );
  }
}
