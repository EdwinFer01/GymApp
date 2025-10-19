import '../entities/progress_record.dart';

abstract class ProgressRepository {
  const ProgressRepository();

  Future<int> saveRecord(ProgressRecord record);
  Future<List<ProgressRecord>> getRecordsByClient(int clientId);
  Future<int> deleteRecord(int id);
}
