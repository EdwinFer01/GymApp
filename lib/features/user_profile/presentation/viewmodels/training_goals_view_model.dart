import 'dart:collection';

import 'package:flutter/foundation.dart';

import '../../../../core/viewmodels/base_view_model.dart';
import '../../data/repositories/training_goal_repository_impl.dart';
import '../../domain/entities/training_goal.dart';
import '../../domain/repositories/training_goal_repository.dart';

class TrainingGoalsViewModel extends BaseViewModel {
  TrainingGoalsViewModel({
    required this.userId,
    TrainingGoalRepository? repository,
  }) : _repository = repository ?? TrainingGoalRepositoryImpl();

  final int userId;
  final TrainingGoalRepository _repository;

  List<TrainingGoal> _goals = <TrainingGoal>[];
  String? _lastError;

  UnmodifiableListView<TrainingGoal> get goals =>
      UnmodifiableListView<TrainingGoal>(_goals);
  String? get lastError => _lastError;

  Future<void> load() async {
    setBusy(true);
    _lastError = null;
    try {
      await _refreshGoals();
    } catch (error, stackTrace) {
      debugPrint('Error loading training goals: $error');
      debugPrintStack(stackTrace: stackTrace);
      _lastError = 'No pudimos cargar tus objetivos. Intenta nuevamente.';
      _goals = <TrainingGoal>[];
      safeNotifyListeners();
    } finally {
      setBusy(false);
    }
  }

  Future<bool> saveGoal({
    TrainingGoal? original,
    required String exercise,
    required double targetWeight,
  }) async {
    setBusy(true);
    _lastError = null;
    try {
      final base =
          original ??
          TrainingGoal(
            userId: userId,
            exercise: exercise,
            targetWeight: targetWeight,
          );
      final toSave = base.copyWith(
        exercise: exercise,
        targetWeight: targetWeight,
      );
      await _repository.saveGoal(toSave);
      await _refreshGoals();
      safeNotifyListeners();
      return true;
    } catch (error, stackTrace) {
      debugPrint('Error saving training goal: $error');
      debugPrintStack(stackTrace: stackTrace);
      _lastError = 'No pudimos guardar el objetivo. Intenta nuevamente.';
      safeNotifyListeners();
      return false;
    } finally {
      setBusy(false);
    }
  }

  Future<bool> deleteGoal(TrainingGoal goal) async {
    final id = goal.id;
    if (id == null) return false;
    setBusy(true);
    _lastError = null;
    try {
      await _repository.deleteGoal(id);
      await _refreshGoals();
      safeNotifyListeners();
      return true;
    } catch (error, stackTrace) {
      debugPrint('Error deleting training goal: $error');
      debugPrintStack(stackTrace: stackTrace);
      _lastError = 'No pudimos eliminar el objetivo. Intenta nuevamente.';
      safeNotifyListeners();
      return false;
    } finally {
      setBusy(false);
    }
  }

  Future<void> _refreshGoals() async {
    _goals = await _repository.getGoalsByUser(userId);
  }
}
