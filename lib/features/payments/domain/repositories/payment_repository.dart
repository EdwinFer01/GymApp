import '../entities/payment.dart';

abstract class PaymentRepository {
  const PaymentRepository();

  Future<int> savePayment(Payment payment);
  Future<Payment?> getPaymentById(int id);
  Future<List<Payment>> getPaymentsByMembership(int membershipId);
  Future<int> deletePayment(int id);
}
