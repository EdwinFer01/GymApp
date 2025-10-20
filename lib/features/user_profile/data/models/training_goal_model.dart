import '../../domain/entities/training_goal.dart';

class TrainingGoalModel extends TrainingGoal {
  TrainingGoalModel({
    super.id,
    required super.userId,
    required super.exercise,
    required super.targetWeight,
    super.createdAt,
    super.updatedAt,
  });

  factory TrainingGoalModel.fromEntity(TrainingGoal goal) {
    return TrainingGoalModel(
      id: goal.id,
      userId: goal.userId,
      exercise: goal.exercise,
      targetWeight: goal.targetWeight,
      createdAt: goal.createdAt,
      updatedAt: goal.updatedAt,
    );
  }

  factory TrainingGoalModel.fromMap(Map<String, Object?> map) {
    return TrainingGoalModel(
      id: map['id'] as int?,
      userId: map['user_id'] as int,
      exercise: map['exercise_name'] as String,
      targetWeight: (map['target_weight'] as num).toDouble(),
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
      'exercise_name': exercise,
      'target_weight': targetWeight,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
