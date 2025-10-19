import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_local_data_source.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  ProductRepositoryImpl({ProductLocalDataSource? localDataSource})
    : _localDataSource = localDataSource ?? ProductLocalDataSource();

  final ProductLocalDataSource _localDataSource;

  @override
  Future<int> deleteProduct(int id) {
    return _localDataSource.deleteProduct(id);
  }

  @override
  Future<Product?> getProductById(int id) {
    return _localDataSource.getProductById(id);
  }

  @override
  Future<List<Product>> getProducts() {
    return _localDataSource.getProducts();
  }

  @override
  Future<int> saveProduct(Product product) {
    return _localDataSource.upsertProduct(ProductModel.fromEntity(product));
  }
}
