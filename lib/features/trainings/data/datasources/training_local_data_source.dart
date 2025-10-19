import 'package:sqflite/sqflite.dart';

import '../../../../core/constants/table_names.dart';
import '../../../../core/database/app_database.dart';
import '../models/training_session_model.dart';
import '../models/workout_set_model.dart';

class TrainingLocalDataSource {
  TrainingLocalDataSource({AppDatabase? database})
    : _database = database ?? AppDatabase.instance;

  final AppDatabase _database;

  Future<Database> get _db async => _database.database;

  Future<int> upsertSession(TrainingSessionModel session) async {
    final db = await _db;
    return db.insert(
      TableNames.trainingSessions,
      session.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<TrainingSessionModel>> getSessionsByClient(int clientId) async {
    final db = await _db;
    final result = await db.query(
      TableNames.trainingSessions,
      where: 'client_id = ?',
      whereArgs: [clientId],
      orderBy: 'scheduled_at DESC',
    );
    return result.map(TrainingSessionModel.fromMap).toList();
  }

  Future<TrainingSessionModel?> getSessionById(int id) async {
    final db = await _db;
    final result = await db.query(
      TableNames.trainingSessions,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (result.isEmpty) {
      return null;
    }
    return TrainingSessionModel.fromMap(result.first);
  }

  Future<int> deleteSession(int id) async {
    final db = await _db;
    return db.delete(
      TableNames.trainingSessions,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> upsertWorkoutSet(WorkoutSetModel set) async {
    final db = await _db;
    return db.insert(
      TableNames.workoutSets,
      set.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<WorkoutSetModel>> getWorkoutSetsBySession(int sessionId) async {
    final db = await _db;
    final result = await db.query(
      TableNames.workoutSets,
      where: 'session_id = ?',
      whereArgs: [sessionId],
      orderBy: 'set_number ASC',
    );
    return result.map(WorkoutSetModel.fromMap).toList();
  }

  Future<int> deleteWorkoutSet(int id) async {
    final db = await _db;
    return db.delete(TableNames.workoutSets, where: 'id = ?', whereArgs: [id]);
  }
}
