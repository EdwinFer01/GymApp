import 'package:sqflite/sqflite.dart';

import '../../../../core/constants/table_names.dart';
import '../../../../core/database/app_database.dart';
import '../models/membership_model.dart';

class MembershipLocalDataSource {
  MembershipLocalDataSource({AppDatabase? database})
    : _database = database ?? AppDatabase.instance;

  final AppDatabase _database;

  Future<Database> get _db async => _database.database;

  Future<int> upsertMembership(MembershipModel membership) async {
    final db = await _db;
    return db.insert(
      TableNames.memberships,
      membership.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<MembershipModel>> getMembershipsByClient(int clientId) async {
    final db = await _db;
    final result = await db.query(
      TableNames.memberships,
      where: 'client_id = ?',
      whereArgs: [clientId],
      orderBy: 'start_date DESC',
    );
    return result.map(MembershipModel.fromMap).toList();
  }

  Future<MembershipModel?> getMembershipById(int id) async {
    final db = await _db;
    final result = await db.query(
      TableNames.memberships,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (result.isEmpty) {
      return null;
    }
    return MembershipModel.fromMap(result.first);
  }

  Future<int> deleteMembership(int id) async {
    final db = await _db;
    return db.delete(TableNames.memberships, where: 'id = ?', whereArgs: [id]);
  }
}
