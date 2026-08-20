/// Data transfer model for user registration request payload.
///
/// Designed to be flexible, supporting clean registration attributes.
class RegisterRequestModel {
  /// Email address of the user.
  final String email;

  /// Full display name of the user.
  final String name;

  /// User account password.
  final String password;

  /// Password confirmation string matching [password].
  final String passwordConfirm;

  /// Optional custom JSON key-value map for any app-specific user fields.
  final Map<String, dynamic>? customData;

  /// Creates a [RegisterRequestModel] instance.
  const RegisterRequestModel({
    required this.email,
    required this.name,
    required this.password,
    required this.passwordConfirm,
    this.customData,
  });

  /// Converts registration payload model into exact JSON map.
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'email': email,
      'name': name,
      'password': password,
      'passwordConfirm': passwordConfirm,
    };
    if (customData != null) {
      map.addAll(customData!);
    }
    return map;
  }

  /// Creates a [RegisterRequestModel] from a JSON map.
  factory RegisterRequestModel.fromJson(Map<String, dynamic> json) {
    return RegisterRequestModel(
      email: json['email'] as String? ?? '',
      name: json['name'] as String? ?? '',
      password: json['password'] as String? ?? '',
      passwordConfirm: json['passwordConfirm'] as String? ?? '',
      customData: json['customData'] as Map<String, dynamic>?,
    );
  }
}
