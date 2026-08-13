import 'package:starter/src/features/auth/domain/entities/user_entity.dart';

/// Data model representing a user, inheriting from [UserEntity].
class UserModel extends UserEntity {
  /// Creates a [UserModel].
  const UserModel({
    required super.id,
    required super.email,
    required super.name,
    required super.emailVisibility,
    required super.meadd,
    required super.baytraq,
    required super.created,
    required super.updated,
  });

  /// Constructs a [UserModel] from a JSON map response.
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String? ?? '',
      email: json['email'] as String? ?? '',
      name: json['name'] as String? ?? '',
      emailVisibility: json['emailVisibility'] as bool? ?? true,
      meadd: json['meadd'] as bool? ?? false,
      baytraq: json['baytraq'] as bool? ?? false,
      created: json['created'] as String? ?? '',
      updated: json['updated'] as String? ?? '',
    );
  }

  /// Converts [UserModel] instance into JSON map.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'email': email,
      'name': name,
      'emailVisibility': emailVisibility,
      'meadd': meadd,
      'baytraq': baytraq,
      'created': created,
      'updated': updated,
    };
  }

  /// Converts this model to a pure [UserEntity].
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      email: email,
      name: name,
      emailVisibility: emailVisibility,
      meadd: meadd,
      baytraq: baytraq,
      created: created,
      updated: updated,
    );
  }
}
