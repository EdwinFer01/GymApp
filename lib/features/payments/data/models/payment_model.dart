import '../../domain/entities/payment.dart';

class PaymentModel extends Payment {
  const PaymentModel({
    super.id,
    required super.membershipId,
    required super.amount,
    required super.paidAt,
    super.status,
    super.method,
    super.reference,
    super.notes,
    super.createdAt,
    super.updatedAt,
  });

  factory PaymentModel.fromEntity(Payment payment) {
    return PaymentModel(
      id: payment.id,
      membershipId: payment.membershipId,
      amount: payment.amount,
      paidAt: payment.paidAt,
      status: payment.status,
      method: payment.method,
      reference: payment.reference,
      notes: payment.notes,
      createdAt: payment.createdAt,
      updatedAt: payment.updatedAt,
    );
  }

  factory PaymentModel.fromMap(Map<String, Object?> map) {
    return PaymentModel(
      id: map['id'] as int?,
      membershipId: map['membership_id'] as int,
      amount: (map['amount'] as num).toDouble(),
      paidAt: DateTime.parse(map['paid_at'] as String),
      status: PaymentStatus.values.byName(
        (map['status'] as String?) ?? PaymentStatus.completed.name,
      ),
      method: PaymentMethod.values.byName(
        (map['method'] as String?) ?? PaymentMethod.cash.name,
      ),
      reference: map['reference'] as String?,
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
      'membership_id': membershipId,
      'amount': amount,
      'paid_at': paidAt.toIso8601String(),
      'status': status.name,
      'method': method.name,
      'reference': reference,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
