import '../../domain/entities/payment.dart';
import '../../domain/repositories/payment_repository.dart';
import '../datasources/payment_local_data_source.dart';
import '../models/payment_model.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  PaymentRepositoryImpl({PaymentLocalDataSource? localDataSource})
    : _localDataSource = localDataSource ?? PaymentLocalDataSource();

  final PaymentLocalDataSource _localDataSource;

  @override
  Future<int> deletePayment(int id) {
    return _localDataSource.deletePayment(id);
  }

  @override
  Future<Payment?> getPaymentById(int id) {
    return _localDataSource.getPaymentById(id);
  }

  @override
  Future<List<Payment>> getPaymentsByMembership(int membershipId) {
    return _localDataSource.getPaymentsByMembership(membershipId);
  }

  @override
  Future<int> savePayment(Payment payment) {
    return _localDataSource.upsertPayment(PaymentModel.fromEntity(payment));
  }
}
