import '../../domain/entities/membership.dart';

class MembershipModel extends Membership {
  MembershipModel({
    super.id,
    required super.clientId,
    required super.planName,
    super.status,
    required super.price,
    required super.startDate,
    required super.endDate,
    super.billingCycleDays,
    super.notes,
    super.createdAt,
    super.updatedAt,
  });

  factory MembershipModel.fromEntity(Membership membership) {
    return MembershipModel(
      id: membership.id,
      clientId: membership.clientId,
      planName: membership.planName,
      status: membership.status,
      price: membership.price,
      startDate: membership.startDate,
      endDate: membership.endDate,
      billingCycleDays: membership.billingCycleDays,
      notes: membership.notes,
      createdAt: membership.createdAt,
      updatedAt: membership.updatedAt,
    );
  }

  factory MembershipModel.fromMap(Map<String, Object?> map) {
    return MembershipModel(
      id: map['id'] as int?,
      clientId: map['client_id'] as int,
      planName: map['plan_name'] as String,
      status: MembershipStatus.values.byName(
        (map['status'] as String?) ?? MembershipStatus.pending.name,
      ),
      price: (map['price'] as num).toDouble(),
      startDate: DateTime.parse(map['start_date'] as String),
      endDate: DateTime.parse(map['end_date'] as String),
      billingCycleDays: map['billing_cycle_days'] as int?,
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
      'plan_name': planName,
      'status': status.name,
      'price': price,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'billing_cycle_days': billingCycleDays,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
