import 'package:frosted_ui_kit/src/features/auth/domain/entities/user_entity.dart';

/// Data model representing a user, inheriting from [UserEntity].
///
/// Handles JSON serialization and deserialization for authentication operations.
class UserModel extends UserEntity {
  /// Creates a [UserModel] instance.
  const UserModel({
    required super.id,
    required super.email,
    required super.name,
    super.customData,
    super.created = '',
    super.updated = '',
  });

  /// Constructs a [UserModel] from a JSON map response.
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String? ?? '',
      email: json['email'] as String? ?? '',
      name: json['name'] as String? ?? '',
      customData: json,
      created: json['created'] as String? ?? '',
      updated: json['updated'] as String? ?? '',
    );
  }

  /// Converts [UserModel] instance into a JSON map.
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'id': id,
      'email': email,
      'name': name,
      'created': created,
      'updated': updated,
    };
    if (customData != null) {
      map.addAll(customData!);
    }
    return map;
  }

  /// Converts this model instance into a pure domain [UserEntity].
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      email: email,
      name: name,
      customData: customData,
      created: created,
      updated: updated,
    );
  }
}


