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
    this.notes,
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
  final String? notes;
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
    String? notes,
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
      notes: notes ?? this.notes,
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
      'notes': notes,
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
      notes: json['notes'] as String?,
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
            notes == other.notes &&
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
      notes,
      createdAt,
      updatedAt,
    );
  }
}
