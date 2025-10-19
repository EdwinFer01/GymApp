import '../../domain/entities/training_session.dart';
import '../../domain/entities/workout_set.dart';
import '../../domain/repositories/training_repository.dart';
import '../datasources/training_local_data_source.dart';
import '../models/training_session_model.dart';
import '../models/workout_set_model.dart';

class TrainingRepositoryImpl implements TrainingRepository {
  TrainingRepositoryImpl({TrainingLocalDataSource? localDataSource})
    : _localDataSource = localDataSource ?? TrainingLocalDataSource();

  final TrainingLocalDataSource _localDataSource;

  @override
  Future<int> deleteSession(int id) {
    return _localDataSource.deleteSession(id);
  }

  @override
  Future<int> deleteWorkoutSet(int id) {
    return _localDataSource.deleteWorkoutSet(id);
  }

  @override
  Future<TrainingSession?> getSessionById(int id) {
    return _localDataSource.getSessionById(id);
  }

  @override
  Future<List<TrainingSession>> getSessionsByClient(int clientId) {
    return _localDataSource.getSessionsByClient(clientId);
  }

  @override
  Future<List<WorkoutSet>> getWorkoutSetsBySession(int sessionId) {
    return _localDataSource.getWorkoutSetsBySession(sessionId);
  }

  @override
  Future<int> saveSession(TrainingSession session) {
    return _localDataSource.upsertSession(
      TrainingSessionModel.fromEntity(session),
    );
  }

  @override
  Future<int> saveWorkoutSet(WorkoutSet set) {
    return _localDataSource.upsertWorkoutSet(WorkoutSetModel.fromEntity(set));
  }
}
