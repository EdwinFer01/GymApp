class ProgressRecord {
  ProgressRecord({
    this.id,
    required this.clientId,
    required this.recordedAt,
    this.weightKg,
    this.bodyFatPercentage,
    this.chestCm,
    this.waistCm,
    this.hipCm,
    this.armCm,
    this.thighCm,
    this.exerciseName,
    this.exerciseWeight,
    this.exerciseReps,
    this.notes,
    this.photoPath,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  final int? id;
  final int clientId;
  final DateTime recordedAt;
  final double? weightKg;
  final double? bodyFatPercentage;
  final double? chestCm;
  final double? waistCm;
  final double? hipCm;
  final double? armCm;
  final double? thighCm;
  final String? exerciseName;
  final double? exerciseWeight;
  final int? exerciseReps;
  final String? notes;
  final String? photoPath;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProgressRecord copyWith({
    int? id,
    int? clientId,
    DateTime? recordedAt,
    double? weightKg,
    double? bodyFatPercentage,
    double? chestCm,
    double? waistCm,
    double? hipCm,
    double? armCm,
    double? thighCm,
    String? exerciseName,
    double? exerciseWeight,
    int? exerciseReps,
    String? notes,
    String? photoPath,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProgressRecord(
      id: id ?? this.id,
      clientId: clientId ?? this.clientId,
      recordedAt: recordedAt ?? this.recordedAt,
      weightKg: weightKg ?? this.weightKg,
      bodyFatPercentage: bodyFatPercentage ?? this.bodyFatPercentage,
      chestCm: chestCm ?? this.chestCm,
      waistCm: waistCm ?? this.waistCm,
      hipCm: hipCm ?? this.hipCm,
      armCm: armCm ?? this.armCm,
      thighCm: thighCm ?? this.thighCm,
      exerciseName: exerciseName ?? this.exerciseName,
      exerciseWeight: exerciseWeight ?? this.exerciseWeight,
      exerciseReps: exerciseReps ?? this.exerciseReps,
      notes: notes ?? this.notes,
      photoPath: photoPath ?? this.photoPath,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'clientId': clientId,
      'recordedAt': recordedAt.toIso8601String(),
      'weightKg': weightKg,
      'bodyFatPercentage': bodyFatPercentage,
      'chestCm': chestCm,
      'waistCm': waistCm,
      'hipCm': hipCm,
      'armCm': armCm,
      'thighCm': thighCm,
      'exerciseName': exerciseName,
      'exerciseWeight': exerciseWeight,
      'exerciseReps': exerciseReps,
      'notes': notes,
      'photoPath': photoPath,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory ProgressRecord.fromJson(Map<String, dynamic> json) {
    return ProgressRecord(
      id: json['id'] as int?,
      clientId: json['clientId'] as int,
      recordedAt: DateTime.parse(json['recordedAt'] as String),
      weightKg: (json['weightKg'] as num?)?.toDouble(),
      bodyFatPercentage: (json['bodyFatPercentage'] as num?)?.toDouble(),
      chestCm: (json['chestCm'] as num?)?.toDouble(),
      waistCm: (json['waistCm'] as num?)?.toDouble(),
      hipCm: (json['hipCm'] as num?)?.toDouble(),
      armCm: (json['armCm'] as num?)?.toDouble(),
      thighCm: (json['thighCm'] as num?)?.toDouble(),
      exerciseName: json['exerciseName'] as String?,
      exerciseWeight: (json['exerciseWeight'] as num?)?.toDouble(),
      exerciseReps: json['exerciseReps'] as int?,
      notes: json['notes'] as String?,
      photoPath: json['photoPath'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ProgressRecord &&
            runtimeType == other.runtimeType &&
            id == other.id &&
            clientId == other.clientId &&
            recordedAt == other.recordedAt &&
            weightKg == other.weightKg &&
            bodyFatPercentage == other.bodyFatPercentage &&
            chestCm == other.chestCm &&
            waistCm == other.waistCm &&
            hipCm == other.hipCm &&
            armCm == other.armCm &&
            thighCm == other.thighCm &&
            exerciseName == other.exerciseName &&
            exerciseWeight == other.exerciseWeight &&
            exerciseReps == other.exerciseReps &&
            notes == other.notes &&
            photoPath == other.photoPath &&
            createdAt == other.createdAt &&
            updatedAt == other.updatedAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      clientId,
      recordedAt,
      weightKg,
      bodyFatPercentage,
      chestCm,
      waistCm,
      hipCm,
      armCm,
      thighCm,
      exerciseName,
      exerciseWeight,
      exerciseReps,
      notes,
      photoPath,
      createdAt,
      updatedAt,
    );
  }
}
