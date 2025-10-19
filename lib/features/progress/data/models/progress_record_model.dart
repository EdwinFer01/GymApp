import '../../domain/entities/progress_record.dart';

class ProgressRecordModel extends ProgressRecord {
  ProgressRecordModel({
    super.id,
    required super.clientId,
    required super.recordedAt,
    super.weightKg,
    super.bodyFatPercentage,
    super.chestCm,
    super.waistCm,
    super.hipCm,
    super.armCm,
    super.thighCm,
    super.notes,
    super.createdAt,
    super.updatedAt,
  });

  factory ProgressRecordModel.fromEntity(ProgressRecord record) {
    return ProgressRecordModel(
      id: record.id,
      clientId: record.clientId,
      recordedAt: record.recordedAt,
      weightKg: record.weightKg,
      bodyFatPercentage: record.bodyFatPercentage,
      chestCm: record.chestCm,
      waistCm: record.waistCm,
      hipCm: record.hipCm,
      armCm: record.armCm,
      thighCm: record.thighCm,
      notes: record.notes,
      createdAt: record.createdAt,
      updatedAt: record.updatedAt,
    );
  }

  factory ProgressRecordModel.fromMap(Map<String, Object?> map) {
    return ProgressRecordModel(
      id: map['id'] as int?,
      clientId: map['client_id'] as int,
      recordedAt: DateTime.parse(map['recorded_at'] as String),
      weightKg: (map['weight_kg'] as num?)?.toDouble(),
      bodyFatPercentage: (map['body_fat_percentage'] as num?)?.toDouble(),
      chestCm: (map['chest_cm'] as num?)?.toDouble(),
      waistCm: (map['waist_cm'] as num?)?.toDouble(),
      hipCm: (map['hip_cm'] as num?)?.toDouble(),
      armCm: (map['arm_cm'] as num?)?.toDouble(),
      thighCm: (map['thigh_cm'] as num?)?.toDouble(),
      notes: map['notes'] as String?,
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
      'client_id': clientId,
      'recorded_at': recordedAt.toIso8601String(),
      'weight_kg': weightKg,
      'body_fat_percentage': bodyFatPercentage,
      'chest_cm': chestCm,
      'waist_cm': waistCm,
      'hip_cm': hipCm,
      'arm_cm': armCm,
      'thigh_cm': thighCm,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
