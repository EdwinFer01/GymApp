import 'package:sqflite/sqflite.dart';

import '../../../../core/constants/table_names.dart';
import '../../../../core/database/app_database.dart';
import '../models/progress_record_model.dart';

class ProgressLocalDataSource {
  ProgressLocalDataSource({AppDatabase? database})
    : _database = database ?? AppDatabase.instance;

  final AppDatabase _database;

  Future<Database> get _db async => _database.database;

  Future<int> upsertRecord(ProgressRecordModel record) async {
    final db = await _db;
    return db.insert(
      TableNames.progressRecords,
      record.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<ProgressRecordModel>> getRecordsByClient(int clientId) async {
    final db = await _db;
    final result = await db.query(
      TableNames.progressRecords,
      where: 'client_id = ?',
      whereArgs: [clientId],
      orderBy: 'recorded_at DESC',
    );
    return result.map(ProgressRecordModel.fromMap).toList();
  }

  Future<int> deleteRecord(int id) async {
    final db = await _db;
    return db.delete(
      TableNames.progressRecords,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
