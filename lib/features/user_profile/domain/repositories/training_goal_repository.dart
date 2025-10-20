import '../entities/training_goal.dart';

abstract class TrainingGoalRepository {
  Future<List<TrainingGoal>> getGoalsByUser(int userId);
  Future<TrainingGoal?> getGoalById(int id);
  Future<int> saveGoal(TrainingGoal goal);
  Future<int> deleteGoal(int id);
}
