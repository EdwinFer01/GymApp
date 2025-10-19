import '../../domain/entities/auth_user.dart';

class AuthUserModel extends AuthUser {
  AuthUserModel({
    required super.id,
    required super.email,
    required super.displayName,
    required super.role,
    required this.passwordHash,
    super.createdAt,
    super.updatedAt,
  });

  final String passwordHash;

  factory AuthUserModel.fromEntity(
    AuthUser user, {
    required String passwordHash,
  }) {
    return AuthUserModel(
      id: user.id,
      email: user.email,
      displayName: user.displayName,
      role: user.role,
      passwordHash: passwordHash,
      createdAt: user.createdAt,
      updatedAt: user.updatedAt,
    );
  }

  factory AuthUserModel.fromMap(Map<String, Object?> map) {
    return AuthUserModel(
      id: map['id'] as int,
      email: map['email'] as String,
      displayName: map['display_name'] as String,
      role: AuthRole.values.byName(
        (map['role'] as String?) ?? AuthRole.client.name,
      ),
      passwordHash: map['password_hash'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  Map<String, Object?> toMap() {
    return <String, Object?>{
      'id': id,
      'email': email,
      'display_name': displayName,
      'role': role.name,
      'password_hash': passwordHash,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  AuthUser toEntity() {
    return AuthUser(
      id: id,
      email: email,
      displayName: displayName,
      role: role,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
