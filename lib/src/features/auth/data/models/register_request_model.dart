/// Data transfer model for user registration request payload.
class RegisterRequestModel {
  /// Email address of the user.
  final String email;

  /// Visibility flag for email address.
  final bool emailVisibility;

  /// Full name of the user.
  final String name;

  /// Custom boolean flag 'meadd'.
  final bool meadd;

  /// Custom boolean flag 'baytraq'.
  final bool baytraq;

  /// User password.
  final String password;

  /// Password confirmation string matching [password].
  final String passwordConfirm;

  /// Creates a [RegisterRequestModel].
  const RegisterRequestModel({
    required this.email,
    this.emailVisibility = true,
    required this.name,
    this.meadd = false,
    this.baytraq = false,
    required this.password,
    required this.passwordConfirm,
  });

  /// Converts registration payload model into exact JSON map.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'email': email,
      'emailVisibility': emailVisibility,
      'name': name,
      'meadd': meadd,
      'baytraq': baytraq,
      'password': password,
      'passwordConfirm': passwordConfirm,
    };
  }

  /// Creates a [RegisterRequestModel] from a JSON map.
  factory RegisterRequestModel.fromJson(Map<String, dynamic> json) {
    return RegisterRequestModel(
      email: json['email'] as String? ?? '',
      emailVisibility: json['emailVisibility'] as bool? ?? true,
      name: json['name'] as String? ?? '',
      meadd: json['meadd'] as bool? ?? false,
      baytraq: json['baytraq'] as bool? ?? false,
      password: json['password'] as String? ?? '',
      passwordConfirm: json['passwordConfirm'] as String? ?? '',
    );
  }
}
