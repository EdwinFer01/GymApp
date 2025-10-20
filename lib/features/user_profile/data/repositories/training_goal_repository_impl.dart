import '../../domain/entities/training_goal.dart';
import '../../domain/repositories/training_goal_repository.dart';
import '../datasources/training_goal_local_data_source.dart';
import '../models/training_goal_model.dart';

class TrainingGoalRepositoryImpl implements TrainingGoalRepository {
  TrainingGoalRepositoryImpl({TrainingGoalLocalDataSource? localDataSource})
    : _localDataSource = localDataSource ?? TrainingGoalLocalDataSource();

  final TrainingGoalLocalDataSource _localDataSource;

  @override
  Future<List<TrainingGoal>> getGoalsByUser(int userId) {
    return _localDataSource.getGoalsByUser(userId);
  }

  @override
  Future<TrainingGoal?> getGoalById(int id) {
    return _localDataSource.getGoalById(id);
  }

  @override
  Future<int> saveGoal(TrainingGoal goal) {
    final now = DateTime.now();
    final normalized = goal.id == null
        ? goal.copyWith(createdAt: now, updatedAt: now)
        : goal.copyWith(updatedAt: now);
    final model = TrainingGoalModel.fromEntity(normalized);
    return _localDataSource.upsertGoal(model);
  }

  @override
  Future<int> deleteGoal(int id) {
    return _localDataSource.deleteGoal(id);
  }
}
