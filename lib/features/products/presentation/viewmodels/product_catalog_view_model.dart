import '../../../../core/viewmodels/base_view_model.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../../data/repositories/product_repository_impl.dart';

class ProductCatalogViewModel extends BaseViewModel {
  ProductCatalogViewModel({ProductRepository? productRepository})
    : _productRepository = productRepository ?? ProductRepositoryImpl();

  final ProductRepository _productRepository;

  List<Product> _products = <Product>[];
  String? _lastError;

  List<Product> get products => List<Product>.unmodifiable(_products);
  String? get lastError => _lastError;
  bool get hasProducts => _products.isNotEmpty;

  Future<void> load() async {
    setBusy(true);
    _lastError = null;
    try {
      final result = await _productRepository.getProducts();
      _products = List<Product>.from(result)
        ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    } catch (error) {
      _lastError = 'No pudimos cargar los productos. Intenta nuevamente.';
      _products = <Product>[];
    } finally {
      setBusy(false);
    }
  }

  Future<void> refresh() => load();
}
