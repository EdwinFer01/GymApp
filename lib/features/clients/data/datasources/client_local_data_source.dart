import 'package:sqflite/sqflite.dart';

import '../../../../core/constants/table_names.dart';
import '../../../../core/database/app_database.dart';
import '../models/client_model.dart';

class ClientLocalDataSource {
  ClientLocalDataSource({AppDatabase? database})
    : _database = database ?? AppDatabase.instance;

  final AppDatabase _database;

  Future<Database> get _db async => _database.database;

  Future<int> upsertClient(ClientModel client) async {
    final db = await _db;
    return db.insert(
      TableNames.clients,
      client.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> deleteClient(int id) async {
    final db = await _db;
    return db.delete(TableNames.clients, where: 'id = ?', whereArgs: [id]);
  }

  Future<ClientModel?> getClientById(int id) async {
    final db = await _db;
    final result = await db.query(
      TableNames.clients,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (result.isEmpty) {
      return null;
    }
    return ClientModel.fromMap(result.first);
  }

  Future<List<ClientModel>> getClients() async {
    final db = await _db;
    final result = await db.query(TableNames.clients, orderBy: 'last_name ASC');
    return result.map(ClientModel.fromMap).toList();
  }
}
