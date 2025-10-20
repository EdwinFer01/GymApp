class TrainingGoal {
  TrainingGoal({
    this.id,
    required this.userId,
    required this.exercise,
    required this.targetWeight,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  final int? id;
  final int userId;
  final String exercise;
  final double targetWeight;
  final DateTime createdAt;
  final DateTime updatedAt;

  String get targetWeightLabel {
    final rounded = targetWeight.roundToDouble();
    final isInt = targetWeight == rounded;
    return isInt
        ? '${rounded.toInt()} kg'
        : '${targetWeight.toStringAsFixed(1)} kg';
  }

  String get targetWeightString {
    final rounded = targetWeight.roundToDouble();
    final isInt = targetWeight == rounded;
    return isInt ? rounded.toInt().toString() : targetWeight.toString();
  }

  TrainingGoal copyWith({
    int? id,
    int? userId,
    String? exercise,
    double? targetWeight,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TrainingGoal(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      exercise: exercise ?? this.exercise,
      targetWeight: targetWeight ?? this.targetWeight,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'exercise': exercise,
      'targetWeight': targetWeight,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory TrainingGoal.fromJson(Map<String, dynamic> json) {
    return TrainingGoal(
      id: json['id'] as int?,
      userId: json['userId'] as int,
      exercise: json['exercise'] as String,
      targetWeight: (json['targetWeight'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is TrainingGoal &&
            runtimeType == other.runtimeType &&
            id == other.id &&
            userId == other.userId &&
            exercise == other.exercise &&
            targetWeight == other.targetWeight &&
            createdAt == other.createdAt &&
            updatedAt == other.updatedAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      userId,
      exercise,
      targetWeight,
      createdAt,
      updatedAt,
    );
  }
}
