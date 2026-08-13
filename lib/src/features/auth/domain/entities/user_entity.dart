/// Entity representing an authenticated user in the domain layer.
class UserEntity {
  /// Unique identifier of the user.
  final String id;

  /// Email address of the user.
  final String email;

  /// Display name of the user.
  final String name;

  /// Whether the user's email is visible to other users.
  final bool emailVisibility;

  /// Custom boolean flag 'meadd'.
  final bool meadd;

  /// Custom boolean flag 'baytraq'.
  final bool baytraq;

  /// ISO 8601 creation timestamp string.
  final String created;

  /// ISO 8601 updated timestamp string.
  final String updated;

  /// Creates a [UserEntity].
  const UserEntity({
    required this.id,
    required this.email,
    required this.name,
    required this.emailVisibility,
    required this.meadd,
    required this.baytraq,
    required this.created,
    required this.updated,
  });
}
