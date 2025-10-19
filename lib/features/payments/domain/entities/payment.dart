enum PaymentStatus { pending, completed, failed, refunded }

enum PaymentMethod { cash, card, bankTransfer, digitalWallet, other }

class Payment {
  Payment({
    this.id,
    required this.membershipId,
    required this.amount,
    required this.paidAt,
    this.status = PaymentStatus.completed,
    this.method = PaymentMethod.cash,
    this.reference,
    this.notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  final int? id;
  final int membershipId;
  final double amount;
  final DateTime paidAt;
  final PaymentStatus status;
  final PaymentMethod method;
  final String? reference;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  Payment copyWith({
    int? id,
    int? membershipId,
    double? amount,
    DateTime? paidAt,
    PaymentStatus? status,
    PaymentMethod? method,
    String? reference,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Payment(
      id: id ?? this.id,
      membershipId: membershipId ?? this.membershipId,
      amount: amount ?? this.amount,
      paidAt: paidAt ?? this.paidAt,
      status: status ?? this.status,
      method: method ?? this.method,
      reference: reference ?? this.reference,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'membershipId': membershipId,
      'amount': amount,
      'paidAt': paidAt.toIso8601String(),
      'status': status.name,
      'method': method.name,
      'reference': reference,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'] as int?,
      membershipId: json['membershipId'] as int,
      amount: (json['amount'] as num).toDouble(),
      paidAt: DateTime.parse(json['paidAt'] as String),
      status: PaymentStatus.values.byName(
        (json['status'] as String?) ?? PaymentStatus.completed.name,
      ),
      method: PaymentMethod.values.byName(
        (json['method'] as String?) ?? PaymentMethod.cash.name,
      ),
      reference: json['reference'] as String?,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Payment &&
            runtimeType == other.runtimeType &&
            id == other.id &&
            membershipId == other.membershipId &&
            amount == other.amount &&
            paidAt == other.paidAt &&
            status == other.status &&
            method == other.method &&
            reference == other.reference &&
            notes == other.notes &&
            createdAt == other.createdAt &&
            updatedAt == other.updatedAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      membershipId,
      amount,
      paidAt,
      status,
      method,
      reference,
      notes,
      createdAt,
      updatedAt,
    );
  }
}
