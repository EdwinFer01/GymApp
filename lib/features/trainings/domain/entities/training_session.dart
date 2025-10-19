enum TrainingType { standard, superset, triset, circuit, custom }

class TrainingSession {
  const TrainingSession({
    this.id,
    required this.clientId,
    required this.title,
    this.type = TrainingType.standard,
    required this.scheduledAt,
    this.durationMinutes,
    this.notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  final int? id;
  final int clientId;
  final String title;
  final TrainingType type;
  final DateTime scheduledAt;
  final int? durationMinutes;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  TrainingSession copyWith({
    int? id,
    int? clientId,
    String? title,
    TrainingType? type,
    DateTime? scheduledAt,
    int? durationMinutes,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TrainingSession(
      id: id ?? this.id,
      clientId: clientId ?? this.clientId,
      title: title ?? this.title,
      type: type ?? this.type,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'clientId': clientId,
      'title': title,
      'type': type.name,
      'scheduledAt': scheduledAt.toIso8601String(),
      'durationMinutes': durationMinutes,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory TrainingSession.fromJson(Map<String, dynamic> json) {
    return TrainingSession(
      id: json['id'] as int?,
      clientId: json['clientId'] as int,
      title: json['title'] as String,
      type: TrainingType.values.byName(
        (json['type'] as String?) ?? TrainingType.standard.name,
      ),
      scheduledAt: DateTime.parse(json['scheduledAt'] as String),
      durationMinutes: json['durationMinutes'] as int?,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is TrainingSession &&
            runtimeType == other.runtimeType &&
            id == other.id &&
            clientId == other.clientId &&
            title == other.title &&
            type == other.type &&
            scheduledAt == other.scheduledAt &&
            durationMinutes == other.durationMinutes &&
            notes == other.notes &&
            createdAt == other.createdAt &&
            updatedAt == other.updatedAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      clientId,
      title,
      type,
      scheduledAt,
      durationMinutes,
      notes,
      createdAt,
      updatedAt,
    );
  }
}
