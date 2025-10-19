enum MembershipStatus { active, pending, expired, cancelled }

class Membership {
  Membership({
    this.id,
    required this.clientId,
    required this.planName,
    this.status = MembershipStatus.pending,
    required this.price,
    required this.startDate,
    required this.endDate,
    this.billingCycleDays,
    this.notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  final int? id;
  final int clientId;
  final String planName;
  final MembershipStatus status;
  final double price;
  final DateTime startDate;
  final DateTime endDate;
  final int? billingCycleDays;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  bool get isActive => status == MembershipStatus.active;
  bool get isExpired =>
      status == MembershipStatus.expired || endDate.isBefore(DateTime.now());

  Membership copyWith({
    int? id,
    int? clientId,
    String? planName,
    MembershipStatus? status,
    double? price,
    DateTime? startDate,
    DateTime? endDate,
    int? billingCycleDays,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Membership(
      id: id ?? this.id,
      clientId: clientId ?? this.clientId,
      planName: planName ?? this.planName,
      status: status ?? this.status,
      price: price ?? this.price,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      billingCycleDays: billingCycleDays ?? this.billingCycleDays,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'clientId': clientId,
      'planName': planName,
      'status': status.name,
      'price': price,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'billingCycleDays': billingCycleDays,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory Membership.fromJson(Map<String, dynamic> json) {
    return Membership(
      id: json['id'] as int?,
      clientId: json['clientId'] as int,
      planName: json['planName'] as String,
      status: MembershipStatus.values.byName(
        (json['status'] as String?) ?? MembershipStatus.pending.name,
      ),
      price: (json['price'] as num).toDouble(),
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      billingCycleDays: json['billingCycleDays'] as int?,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Membership &&
            runtimeType == other.runtimeType &&
            id == other.id &&
            clientId == other.clientId &&
            planName == other.planName &&
            status == other.status &&
            price == other.price &&
            startDate == other.startDate &&
            endDate == other.endDate &&
            billingCycleDays == other.billingCycleDays &&
            notes == other.notes &&
            createdAt == other.createdAt &&
            updatedAt == other.updatedAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      clientId,
      planName,
      status,
      price,
      startDate,
      endDate,
      billingCycleDays,
      notes,
      createdAt,
      updatedAt,
    );
  }
}
