import 'package:sqflite/sqflite.dart';

import '../../../../core/constants/table_names.dart';
import '../../../../core/database/app_database.dart';
import '../models/product_model.dart';

class ProductLocalDataSource {
  ProductLocalDataSource({AppDatabase? database})
    : _database = database ?? AppDatabase.instance;

  final AppDatabase _database;

  Future<Database> get _db async => _database.database;

  Future<int> upsertProduct(ProductModel product) async {
    final db = await _db;
    return db.insert(
      TableNames.products,
      product.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<ProductModel>> getProducts() async {
    final db = await _db;
    final result = await db.query(TableNames.products, orderBy: 'name ASC');
    return result.map(ProductModel.fromMap).toList();
  }

  Future<ProductModel?> getProductById(int id) async {
    final db = await _db;
    final result = await db.query(
      TableNames.products,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (result.isEmpty) {
      return null;
    }
    return ProductModel.fromMap(result.first);
  }

  Future<int> deleteProduct(int id) async {
    final db = await _db;
    return db.delete(TableNames.products, where: 'id = ?', whereArgs: [id]);
  }
}
