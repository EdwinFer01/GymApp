import '../../domain/entities/workout_set.dart';

class WorkoutSetModel extends WorkoutSet {
  const WorkoutSetModel({
    super.id,
    required super.sessionId,
    required super.exerciseName,
    required super.setNumber,
    required super.repetitions,
    super.weight,
    super.restSeconds,
    super.combination,
    super.notes,
    super.createdAt,
    super.updatedAt,
  });

  factory WorkoutSetModel.fromEntity(WorkoutSet set) {
    return WorkoutSetModel(
      id: set.id,
      sessionId: set.sessionId,
      exerciseName: set.exerciseName,
      setNumber: set.setNumber,
      repetitions: set.repetitions,
      weight: set.weight,
      restSeconds: set.restSeconds,
      combination: set.combination,
      notes: set.notes,
      createdAt: set.createdAt,
      updatedAt: set.updatedAt,
    );
  }

  factory WorkoutSetModel.fromMap(Map<String, Object?> map) {
    return WorkoutSetModel(
      id: map['id'] as int?,
      sessionId: map['session_id'] as int,
      exerciseName: map['exercise_name'] as String,
      setNumber: map['set_number'] as int,
      repetitions: map['repetitions'] as int,
      weight: (map['weight'] as num?)?.toDouble(),
      restSeconds: map['rest_seconds'] as int?,
      combination: CombinationType.values.byName(
        (map['combination'] as String?) ?? CombinationType.single.name,
      ),
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
      'session_id': sessionId,
      'exercise_name': exerciseName,
      'set_number': setNumber,
      'repetitions': repetitions,
      'weight': weight,
      'rest_seconds': restSeconds,
      'combination': combination.name,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
