enum CombinationType { single, superset, triset }

class WorkoutSet {
  const WorkoutSet({
    this.id,
    required this.sessionId,
    required this.exerciseName,
    required this.setNumber,
    required this.repetitions,
    this.weight,
    this.restSeconds,
    this.combination = CombinationType.single,
    this.notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  final int? id;
  final int sessionId;
  final String exerciseName;
  final int setNumber;
  final int repetitions;
  final double? weight;
  final int? restSeconds;
  final CombinationType combination;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  WorkoutSet copyWith({
    int? id,
    int? sessionId,
    String? exerciseName,
    int? setNumber,
    int? repetitions,
    double? weight,
    int? restSeconds,
    CombinationType? combination,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return WorkoutSet(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      exerciseName: exerciseName ?? this.exerciseName,
      setNumber: setNumber ?? this.setNumber,
      repetitions: repetitions ?? this.repetitions,
      weight: weight ?? this.weight,
      restSeconds: restSeconds ?? this.restSeconds,
      combination: combination ?? this.combination,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'sessionId': sessionId,
      'exerciseName': exerciseName,
      'setNumber': setNumber,
      'repetitions': repetitions,
      'weight': weight,
      'restSeconds': restSeconds,
      'combination': combination.name,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory WorkoutSet.fromJson(Map<String, dynamic> json) {
    return WorkoutSet(
      id: json['id'] as int?,
      sessionId: json['sessionId'] as int,
      exerciseName: json['exerciseName'] as String,
      setNumber: json['setNumber'] as int,
      repetitions: json['repetitions'] as int,
      weight: (json['weight'] as num?)?.toDouble(),
      restSeconds: json['restSeconds'] as int?,
      combination: CombinationType.values.byName(
        (json['combination'] as String?) ?? CombinationType.single.name,
      ),
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is WorkoutSet &&
            runtimeType == other.runtimeType &&
            id == other.id &&
            sessionId == other.sessionId &&
            exerciseName == other.exerciseName &&
            setNumber == other.setNumber &&
            repetitions == other.repetitions &&
            weight == other.weight &&
            restSeconds == other.restSeconds &&
            combination == other.combination &&
            notes == other.notes &&
            createdAt == other.createdAt &&
            updatedAt == other.updatedAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      sessionId,
      exerciseName,
      setNumber,
      repetitions,
      weight,
      restSeconds,
      combination,
      notes,
      createdAt,
      updatedAt,
    );
  }
}
