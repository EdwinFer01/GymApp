import 'package:my_gym_app/features/clients/domain/entities/client.dart';

class ClientModel extends Client {
  ClientModel({
    super.id,
    super.userId,
    required super.firstName,
    required super.lastName,
    required super.email,
    super.phone,
    super.birthDate,
    super.gender,
    super.heightCm,
    super.weightKg,
    super.createdAt,
    super.updatedAt,
  });

  factory ClientModel.fromEntity(Client entity) {
    return ClientModel(
      id: entity.id,
      userId: entity.userId,
      firstName: entity.firstName,
      lastName: entity.lastName,
      email: entity.email,
      phone: entity.phone,
      birthDate: entity.birthDate,
      gender: entity.gender,
      heightCm: entity.heightCm,
      weightKg: entity.weightKg,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  factory ClientModel.fromMap(Map<String, Object?> map) {
    return ClientModel(
      id: map['id'] as int?,
      userId: map['user_id'] as int?,
      firstName: map['first_name'] as String,
      lastName: map['last_name'] as String,
      email: map['email'] as String,
      phone: map['phone'] as String?,
      birthDate: map['birth_date'] != null
          ? DateTime.parse(map['birth_date'] as String)
          : null,
      gender: Gender.values.byName(
        (map['gender'] as String?) ?? Gender.undisclosed.name,
      ),
      heightCm: (map['height_cm'] as num?)?.toDouble(),
      weightKg: (map['weight_kg'] as num?)?.toDouble(),
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'] as String)
          : DateTime.now(),
      updatedAt: map['updated_at'] != null
          ? DateTime.parse(map['updated_at'] as String)
          : DateTime.now(),
    );
  }

  Map<String, Object?> toMap() {
    return <String, Object?>{
      'id': id,
      'user_id': userId,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone': phone,
      'birth_date': birthDate?.toIso8601String(),
      'gender': gender.name,
      'height_cm': heightCm,
      'weight_kg': weightKg,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Map<String, Object?> toConflictUpdateMap() {
    return <String, Object?>{
      'phone': phone,
      'birth_date': birthDate?.toIso8601String(),
      'gender': gender.name,
      'height_cm': heightCm,
      'weight_kg': weightKg,
      'updated_at': DateTime.now().toIso8601String(),
    };
  }
}
