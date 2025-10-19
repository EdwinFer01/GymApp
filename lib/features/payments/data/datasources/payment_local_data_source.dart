import 'package:sqflite/sqflite.dart';

import '../../../../core/constants/table_names.dart';
import '../../../../core/database/app_database.dart';
import '../models/payment_model.dart';

class PaymentLocalDataSource {
  PaymentLocalDataSource({AppDatabase? database})
    : _database = database ?? AppDatabase.instance;

  final AppDatabase _database;

  Future<Database> get _db async => _database.database;

  Future<int> upsertPayment(PaymentModel payment) async {
    final db = await _db;
    return db.insert(
      TableNames.payments,
      payment.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<PaymentModel>> getPaymentsByMembership(int membershipId) async {
    final db = await _db;
    final result = await db.query(
      TableNames.payments,
      where: 'membership_id = ?',
      whereArgs: [membershipId],
      orderBy: 'paid_at DESC',
    );
    return result.map(PaymentModel.fromMap).toList();
  }

  Future<PaymentModel?> getPaymentById(int id) async {
    final db = await _db;
    final result = await db.query(
      TableNames.payments,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (result.isEmpty) {
      return null;
    }
    return PaymentModel.fromMap(result.first);
  }

  Future<int> deletePayment(int id) async {
    final db = await _db;
    return db.delete(TableNames.payments, where: 'id = ?', whereArgs: [id]);
  }
}
