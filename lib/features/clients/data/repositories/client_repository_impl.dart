import '../../domain/entities/client.dart';
import '../../domain/repositories/client_repository.dart';
import '../datasources/client_local_data_source.dart';
import '../models/client_model.dart';

class ClientRepositoryImpl implements ClientRepository {
  ClientRepositoryImpl({ClientLocalDataSource? localDataSource})
    : _localDataSource = localDataSource ?? ClientLocalDataSource();

  final ClientLocalDataSource _localDataSource;

  @override
  Future<int> deleteClient(int id) {
    return _localDataSource.deleteClient(id);
  }

  @override
  Future<Client?> getClientById(int id) {
    return _localDataSource.getClientById(id);
  }

  @override
  Future<List<Client>> getClients() {
    return _localDataSource.getClients();
  }

  @override
  Future<int> saveClient(Client client) {
    return _localDataSource.upsertClient(ClientModel.fromEntity(client));
  }
}
