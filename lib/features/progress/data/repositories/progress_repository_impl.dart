import '../../domain/entities/progress_record.dart';
import '../../domain/repositories/progress_repository.dart';
import '../datasources/progress_local_data_source.dart';
import '../models/progress_record_model.dart';

class ProgressRepositoryImpl implements ProgressRepository {
  ProgressRepositoryImpl({ProgressLocalDataSource? localDataSource})
    : _localDataSource = localDataSource ?? ProgressLocalDataSource();

  final ProgressLocalDataSource _localDataSource;

  @override
  Future<int> deleteRecord(int id) {
    return _localDataSource.deleteRecord(id);
  }

  @override
  Future<List<ProgressRecord>> getRecordsByClient(int clientId) {
    return _localDataSource.getRecordsByClient(clientId);
  }

  @override
  Future<int> saveRecord(ProgressRecord record) {
    return _localDataSource.upsertRecord(
      ProgressRecordModel.fromEntity(record),
    );
  }
}
