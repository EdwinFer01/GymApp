import '../entities/product.dart';

abstract class ProductRepository {
  const ProductRepository();

  Future<int> saveProduct(Product product);
  Future<Product?> getProductById(int id);
  Future<List<Product>> getProducts();
  Future<int> deleteProduct(int id);
}
