import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/product.dart';
import '../viewmodels/product_catalog_view_model.dart';

class ProductCatalogView extends StatelessWidget {
  const ProductCatalogView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProductCatalogViewModel>(
      create: (_) => ProductCatalogViewModel()..load(),
      child: const _ProductCatalogContent(),
    );
  }
}

class _ProductCatalogContent extends StatelessWidget {
  const _ProductCatalogContent();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final viewModel = context.watch<ProductCatalogViewModel>();
    final products = viewModel.products;
    final isLoading = viewModel.isBusy;
    final error = viewModel.lastError;

    return RefreshIndicator(
      onRefresh: viewModel.refresh,
      child: ListView(
        key: const ValueKey('product-catalog'),
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          Text(
            'Tienda del gimnasio',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Encuentra suplementos, accesorios y merchandising listo para ti.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          if (isLoading && products.isEmpty)
            const _LoadingState()
          else if (error != null && products.isEmpty)
            _ErrorState(message: error, onRetry: viewModel.refresh)
          else if (products.isEmpty)
            const _EmptyState()
          else
            ...products.map(
              (product) => _ProductCard(
                product: product,
                onAddToCart: () => _showComingSoon(context, product.name),
              ),
            ),
          if (isLoading && products.isNotEmpty) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                const SizedBox(width: 12),
                Text(
                  'Actualizando catalogo...',
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  static void _showComingSoon(BuildContext context, String productName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$productName estara disponible para compra pronto.'),
      ),
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 80),
      child: Center(child: CircularProgressIndicator()),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Column(
        children: [
          Icon(
            Icons.wifi_off_rounded,
            size: 48,
            color: theme.colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.error,
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.tonalIcon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 80),
      child: Column(
        children: [
          Icon(
            Icons.shopping_bag_outlined,
            size: 48,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            'Aun no tenemos productos cargados.',
            style: theme.textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Vuelve mas tarde para descubrir nuevos suplementos y accesorios.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.product, required this.onAddToCart});

  final Product product;
  final VoidCallback onAddToCart;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isOutOfStock = product.isOutOfStock;
    final category = product.category?.trim();

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: theme.colorScheme.primaryContainer,
                  foregroundColor: theme.colorScheme.primary,
                  child: const Icon(Icons.local_mall_outlined, size: 26),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatPrice(product.price),
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (category != null && category.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Chip(
                            label: Text(category),
                            avatar: const Icon(
                              Icons.category_outlined,
                              size: 18,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            if (product.description != null &&
                product.description!.trim().isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                product.description!.trim(),
                style: theme.textTheme.bodyMedium,
              ),
            ],
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(
                  isOutOfStock
                      ? Icons.cancel_outlined
                      : Icons.inventory_2_outlined,
                  size: 20,
                  color: isOutOfStock
                      ? theme.colorScheme.error
                      : theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  isOutOfStock
                      ? 'Sin stock disponible'
                      : 'Stock disponible: ${product.stock}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isOutOfStock
                        ? theme.colorScheme.error
                        : theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const Spacer(),
                FilledButton.icon(
                  onPressed: isOutOfStock ? null : onAddToCart,
                  icon: const Icon(Icons.shopping_cart_outlined),
                  label: const Text('Agregar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static String _formatPrice(double price) {
    final isWhole = price == price.roundToDouble();
    final formatted = isWhole
        ? price.toStringAsFixed(0)
        : price.toStringAsFixed(2);
    return '\$$formatted';
  }
}
