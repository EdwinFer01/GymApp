import '../entities/training_session.dart';
import '../entities/workout_set.dart';

abstract class TrainingRepository {
  const TrainingRepository();

  Future<int> saveSession(TrainingSession session);
  Future<TrainingSession?> getSessionById(int id);
  Future<List<TrainingSession>> getSessionsByClient(int clientId);
  Future<int> deleteSession(int id);

  Future<int> saveWorkoutSet(WorkoutSet set);
  Future<List<WorkoutSet>> getWorkoutSetsBySession(int sessionId);
  Future<int> deleteWorkoutSet(int id);
}
