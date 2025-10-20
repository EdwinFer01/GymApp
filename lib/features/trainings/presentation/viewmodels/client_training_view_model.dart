import '../../../../core/viewmodels/base_view_model.dart';
import '../../data/repositories/training_repository_impl.dart';
import '../../domain/entities/training_session.dart';
import '../../domain/repositories/training_repository.dart';

class ClientTrainingViewModel extends BaseViewModel {
  ClientTrainingViewModel({
    required this.clientId,
    TrainingRepository? trainingRepository,
  }) : _trainingRepository = trainingRepository ?? TrainingRepositoryImpl();

  final int clientId;
  final TrainingRepository _trainingRepository;

  List<TrainingSession> _sessions = <TrainingSession>[];
  String? _lastError;

  List<TrainingSession> get sessions =>
      List<TrainingSession>.unmodifiable(_sessions);
  String? get lastError => _lastError;

  Future<void> load() async {
    setBusy(true);
    _lastError = null;
    try {
      final result = await _trainingRepository.getSessionsByClient(clientId);
      final now = DateTime.now();
      final upcoming =
          result
              .where((session) => !session.scheduledAt.isBefore(now))
              .toList(growable: false)
            ..sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
      _sessions = upcoming;
    } catch (error) {
      _lastError = 'No pudimos cargar tus entrenamientos. Intenta nuevamente.';
      _sessions = <TrainingSession>[];
    } finally {
      setBusy(false);
    }
  }

  Future<bool> scheduleTraining({
    TrainingSession? original,
    required String title,
    required TrainingType type,
    required DateTime scheduledAt,
    required String trainer,
  }) async {
    try {
      final base =
          original ??
          TrainingSession(
            clientId: clientId,
            title: title,
            type: type,
            scheduledAt: scheduledAt,
            notes: trainer,
          );
      final session = base.copyWith(
        title: title,
        type: type,
        scheduledAt: scheduledAt,
        notes: trainer,
        updatedAt: DateTime.now(),
      );
      await _trainingRepository.saveSession(session);
      await load();
      return true;
    } catch (error) {
      _lastError = 'No pudimos guardar tu entrenamiento. Intenta nuevamente.';
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteTraining(TrainingSession session) async {
    final id = session.id;
    if (id == null) return false;
    try {
      await _trainingRepository.deleteSession(id);
      await load();
      return true;
    } catch (error) {
      _lastError = 'No pudimos eliminar el entrenamiento. Intenta nuevamente.';
      notifyListeners();
      return false;
    }
  }
}
