import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shopping_app/core/routes/app_router.dart';
import 'package:shopping_app/features/cart/presentation/riverpod/cart_provider.dart';
import 'package:shopping_app/features/catalogue/domain/entities/product_entity.dart';
import 'package:shopping_app/features/catalogue/presentation/riverpod/product_provider.dart';
import 'package:shopping_app/features/catalogue/presentation/riverpod/product_state.dart';
import 'package:shopping_app/features/catalogue/presentation/widgets/product_card.dart';

class CataloguePage extends ConsumerStatefulWidget {
  const CataloguePage({Key? key}) : super(key: key);

  @override
  ConsumerState<CataloguePage> createState() => _CataloguePageState();
}

class _CataloguePageState extends ConsumerState<CataloguePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // Fetch initial products
    Future.microtask(() => ref.read(productProvider.notifier).fetchProducts());

    // Add scroll listener for pagination
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      ref.read(productProvider.notifier).fetchProducts();
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    // Load more when user scrolls more than 80% of the list
    return currentScroll >= (maxScroll * 0.8);
  }

  @override
  Widget build(BuildContext context) {
    final productState = ref.watch(productProvider);
    final cartItemCount = ref.watch(cartProvider).totalItems;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping App'),
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () => context.go(AppRoutes.cart),
              ),
              if (cartItemCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      cartItemCount.toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body:
          productState.status == ProductStatus.initial
              ? const Center(child: CircularProgressIndicator())
              : _buildProductList(productState),
    );
  }

  Widget _buildProductList(ProductState state) {
    return RefreshIndicator(
      onRefresh: () async {
        ref.read(productProvider.notifier).resetProducts();
        await Future.delayed(const Duration(milliseconds: 300));
        ref.read(productProvider.notifier).fetchProducts();
      },
      child:
          state.products.isEmpty
              ? const Center(child: Text('No products found'))
              : ListView.builder(
                controller: _scrollController,
                itemCount:
                    state.products.length + (state.hasReachedMax ? 0 : 1),
                padding: const EdgeInsets.all(16),
                itemBuilder: (context, index) {
                  if (index >= state.products.length) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  final product = state.products[index];
                  return ProductCard(
                    product: product,
                    onTap: () => _navigateToProductDetails(product),
                    onAddToCart: () => _addToCart(product),
                  );
                },
              ),
    );
  }

  void _navigateToProductDetails(ProductEntity product) {
    context.go('/product/${product.id}');
  }

  void _addToCart(ProductEntity product) {
    ref.read(cartProvider.notifier).addItem(product);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.title} added to cart'),
        action: SnackBarAction(
          label: 'View Cart',
          onPressed: () => context.go(AppRoutes.cart),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
