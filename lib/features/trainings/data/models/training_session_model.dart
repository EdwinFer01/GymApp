import '../../domain/entities/training_session.dart';

class TrainingSessionModel extends TrainingSession {
  const TrainingSessionModel({
    super.id,
    required super.clientId,
    required super.title,
    super.type,
    required super.scheduledAt,
    super.durationMinutes,
    super.notes,
    super.createdAt,
    super.updatedAt,
  });

  factory TrainingSessionModel.fromEntity(TrainingSession session) {
    return TrainingSessionModel(
      id: session.id,
      clientId: session.clientId,
      title: session.title,
      type: session.type,
      scheduledAt: session.scheduledAt,
      durationMinutes: session.durationMinutes,
      notes: session.notes,
      createdAt: session.createdAt,
      updatedAt: session.updatedAt,
    );
  }

  factory TrainingSessionModel.fromMap(Map<String, Object?> map) {
    return TrainingSessionModel(
      id: map['id'] as int?,
      clientId: map['client_id'] as int,
      title: map['title'] as String,
      type: TrainingType.values.byName(
        (map['type'] as String?) ?? TrainingType.standard.name,
      ),
      scheduledAt: DateTime.parse(map['scheduled_at'] as String),
      durationMinutes: map['duration_minutes'] as int?,
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
      'title': title,
      'type': type.name,
      'scheduled_at': scheduledAt.toIso8601String(),
      'duration_minutes': durationMinutes,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
