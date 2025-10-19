import 'package:flutter/foundation.dart';

import '../../../../core/viewmodels/base_view_model.dart';
import '../../../auth/domain/entities/auth_user.dart';
import '../../../clients/data/repositories/client_repository_impl.dart';
import '../../../clients/domain/entities/client.dart';
import '../../../clients/domain/repositories/client_repository.dart';
import '../../../progress/data/repositories/progress_repository_impl.dart';
import '../../../progress/domain/entities/progress_record.dart';
import '../../../progress/domain/repositories/progress_repository.dart';

class ClientProgressViewModel extends BaseViewModel {
  ClientProgressViewModel({
    required AuthUser user,
    ProgressRepository? progressRepository,
    ClientRepository? clientRepository,
  })  : clientId = user.id,
        _user = user,
        _progressRepository =
            progressRepository ?? ProgressRepositoryImpl(),
        _clientRepository = clientRepository ?? ClientRepositoryImpl();

  final AuthUser _user;
  final int clientId;
  final ProgressRepository _progressRepository;
  final ClientRepository _clientRepository;

  List<ProgressRecord> _records = <ProgressRecord>[];
  ProgressRecord? _latestMeasurements;
  ProgressRecord? _latestExercise;
  String? _lastError;

  List<ProgressRecord> get records => _records;
  ProgressRecord? get latestMeasurements => _latestMeasurements;
  ProgressRecord? get latestExercise => _latestExercise;
  String? get lastError => _lastError;

  ProgressRecord? _firstWhereOrNull(
    Iterable<ProgressRecord> source,
    bool Function(ProgressRecord) predicate,
  ) {
    for (final record in source) {
      if (predicate(record)) return record;
    }
    return null;
  }

  Future<void> _ensureClientProfileExists() async {
    try {
      final existing = await _clientRepository.getClientById(clientId);
      if (existing != null) return;

      final name = _user.displayName.trim();
      final parts = name.isEmpty
          ? <String>[]
          : name
              .split(RegExp(r'\s+'))
              .where((part) => part.isNotEmpty)
              .toList();
      final emailLocalPart = _user.email.split('@').first;
      final firstName = parts.isNotEmpty ? parts.first : emailLocalPart;
      final lastName = parts.length > 1
          ? parts.sublist(1).join(' ')
          : 'Cliente';

      final now = DateTime.now();
      final client = Client(
        id: clientId,
        userId: _user.id,
        firstName: firstName,
        lastName: lastName,
        email: _user.email,
        createdAt: now,
        updatedAt: now,
      );

      await _clientRepository.saveClient(client);
    } catch (error, stackTrace) {
      debugPrint('Error ensuring client profile: $error');
      debugPrintStack(stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<void> load() async {
    setBusy(true);
    _lastError = null;
    try {
      await _ensureClientProfileExists();
      final results = await _progressRepository.getRecordsByClient(clientId);
      _records = results;
      _latestMeasurements = _firstWhereOrNull(
        results,
        (record) =>
            record.weightKg != null ||
            record.bodyFatPercentage != null ||
            record.chestCm != null ||
            record.waistCm != null ||
            record.hipCm != null ||
            record.armCm != null ||
            record.thighCm != null,
      );
      _latestExercise = _firstWhereOrNull(
        results,
        (record) =>
            (record.exerciseName ?? '').trim().isNotEmpty &&
            (record.exerciseWeight != null || record.exerciseReps != null),
      );
    } catch (error, stackTrace) {
      debugPrint('Error loading progress records: $error');
      debugPrintStack(stackTrace: stackTrace);
      _records = <ProgressRecord>[];
      _latestMeasurements = null;
      _latestExercise = null;
      _lastError = 'Error cargando progreso: $error';
    } finally {
      setBusy(false);
    }
  }

  Future<bool> addRecord(ProgressRecord record) async {
    setBusy(true);
    _lastError = null;
    try {
      await _ensureClientProfileExists();
      await _progressRepository.saveRecord(record);
      await load();
      return true;
    } catch (error, stackTrace) {
      debugPrint('Error saving progress record: $error');
      debugPrintStack(stackTrace: stackTrace);
      _lastError = 'Error guardando progreso: $error';
      return false;
    } finally {
      setBusy(false);
    }
  }

  Future<bool> deleteRecord(int id) async {
    setBusy(true);
    _lastError = null;
    try {
      await _progressRepository.deleteRecord(id);
      await load();
      return true;
    } catch (error, stackTrace) {
      debugPrint('Error deleting progress record: $error');
      debugPrintStack(stackTrace: stackTrace);
      _lastError = 'Error eliminando progreso: $error';
      return false;
    } finally {
      setBusy(false);
    }
  }
}
