/// Entity representing an authenticated user in the domain layer.
///
/// Clean, generic user domain entity for any application.
class UserEntity {
  /// Unique identifier of the user.
  final String id;

  /// Email address of the user.
  final String email;

  /// Display name of the user.
  final String name;

  /// Optional raw JSON map containing any custom user attributes returned by backend.
  final Map<String, dynamic>? customData;

  /// ISO 8601 creation timestamp string.
  final String created;

  /// ISO 8601 updated timestamp string.
  final String updated;

  /// Creates a generic [UserEntity] instance.
  const UserEntity({
    required this.id,
    required this.email,
    required this.name,
    this.customData,
    this.created = '',
    this.updated = '',
  });
}
