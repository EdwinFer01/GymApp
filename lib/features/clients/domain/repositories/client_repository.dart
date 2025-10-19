import '../entities/client.dart';

abstract class ClientRepository {
  const ClientRepository();

  Future<List<Client>> getClients();
  Future<Client?> getClientById(int id);
  Future<int> saveClient(Client client);
  Future<int> deleteClient(int id);
}
