import 'package:sqflite/sqflite.dart';

import '../../../../core/constants/table_names.dart';
import '../../../../core/database/app_database.dart';
import '../models/training_goal_model.dart';

class TrainingGoalLocalDataSource {
  TrainingGoalLocalDataSource({AppDatabase? database})
    : _database = database ?? AppDatabase.instance;

  final AppDatabase _database;

  Future<Database> get _db async => _database.database;

  Future<int> upsertGoal(TrainingGoalModel goal) async {
    final db = await _db;
    return db.insert(
      TableNames.trainingGoals,
      goal.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<TrainingGoalModel>> getGoalsByUser(int userId) async {
    final db = await _db;
    final result = await db.query(
      TableNames.trainingGoals,
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'updated_at DESC, created_at DESC',
    );
    return result.map(TrainingGoalModel.fromMap).toList();
  }

  Future<TrainingGoalModel?> getGoalById(int id) async {
    final db = await _db;
    final result = await db.query(
      TableNames.trainingGoals,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (result.isEmpty) {
      return null;
    }
    return TrainingGoalModel.fromMap(result.first);
  }

  Future<int> deleteGoal(int id) async {
    final db = await _db;
    return db.delete(
      TableNames.trainingGoals,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
