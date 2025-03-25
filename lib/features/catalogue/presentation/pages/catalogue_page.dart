import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shopping_app/core/routes/app_router.dart';
import 'package:shopping_app/core/theme/app_colors.dart';
import 'package:shopping_app/core/widgets/shimmer_loading.dart';
import 'package:shopping_app/features/cart/presentation/riverpod/cart_provider.dart';
import 'package:shopping_app/features/catalogue/domain/entities/product_entity.dart';
import 'package:shopping_app/features/catalogue/presentation/riverpod/product_provider.dart';
import 'package:shopping_app/features/catalogue/presentation/riverpod/product_state.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
        title: const Text('Discover'),
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined),
                onPressed: () => context.go(AppRoutes.cart),
              ),
              if (cartItemCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      cartItemCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Featured section title
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              'Featured Products',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),

          // Main product grid
          Expanded(
            child:
                productState.status == ProductStatus.initial
                    ? _buildShimmerGrid()
                    : _buildProductGrid(productState),
          ),
        ],
      ),
    );
  }

  // New method to build shimmer loading grid
  Widget _buildShimmerGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.57,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: 6, // Show 6 shimmer items
      itemBuilder: (context, index) {
        return ShimmerLoading(child: ProductCardShimmer());
      },
    );
  }

  Widget _buildProductGrid(ProductState state) {
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async {
        ref.read(productProvider.notifier).resetProducts();
        await Future.delayed(const Duration(milliseconds: 300));
        ref.read(productProvider.notifier).fetchProducts();
      },
      child:
          state.status == ProductStatus.loading && state.products.isEmpty
              ? _buildShimmerGrid()
              : state.products.isEmpty
              ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.search_off_rounded,
                      size: 64,
                      color: AppColors.textLight,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No products found',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppColors.textLight,
                      ),
                    ),
                  ],
                ),
              )
              : GridView.builder(
                controller: _scrollController,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.57,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                padding: const EdgeInsets.all(16),
                itemCount:
                    state.products.length + (state.hasReachedMax ? 0 : 1),
                itemBuilder: (context, index) {
                  if (index >= state.products.length) {
                    return ShimmerLoading(child: ProductCardShimmer());
                  }

                  final product = state.products[index];
                  return _buildProductCard(product);
                },
              ),
    );
  }

  Widget _buildProductCard(ProductEntity product) {
    final discountPercentage = product.discountPercentage.round();
    final hasDiscount = discountPercentage > 0;

    return GestureDetector(
      onTap: () => _navigateToProductDetails(product),
      child: Card(
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Product Image with discount badge
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: Hero(
                    tag: 'product-${product.id}',
                    child: CachedNetworkImage(
                      imageUrl: product.thumbnail,
                      fit: BoxFit.cover,
                      placeholder:
                          (context, url) => ShimmerLoading(
                            child: Container(color: Colors.white),
                          ),
                      errorWidget:
                          (context, url, error) => Container(
                            color: AppColors.background,
                            child: const Icon(Icons.broken_image, size: 50),
                          ),
                    ),
                  ),
                ),

                // Discount badge
                if (hasDiscount)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.discount,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '$discountPercentage% OFF',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            // Product Details
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Brand and Title in a more compact layout
                  Text(
                    product.brand,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: AppColors.textMuted),
                  ),
                  const SizedBox(height: 1),

                  // Title
                  Text(
                    product.title,
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 1),

                  // Rating and Price in a single row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Rating
                      Row(
                        children: [
                          Icon(Icons.star, size: 12, color: AppColors.warning),
                          const SizedBox(width: 2),
                          Text(
                            product.rating.toString(),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),

                      // Price
                      Row(
                        children: [
                          if (hasDiscount)
                            Text(
                              '₹${product.price.toStringAsFixed(0)}',
                              style: Theme.of(
                                context,
                              ).textTheme.bodySmall?.copyWith(
                                decoration: TextDecoration.lineThrough,
                                color: AppColors.textLight,
                              ),
                            ),
                          if (hasDiscount) const SizedBox(width: 4),
                          Text(
                            '₹${product.discountedPrice.toStringAsFixed(0)}',
                            style: Theme.of(
                              context,
                            ).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // Add to cart button
                  const SizedBox(height: 4),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => _addToCart(product),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(
                                Icons.add_shopping_cart,
                                color: Colors.white,
                                size: 14,
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Add to Cart',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToProductDetails(ProductEntity product) {
    context.go('/product/${product.id}');
  }

  void _addToCart(ProductEntity product) {
    ref.read(cartProvider.notifier).addItem(product);

    // Show a snackbar
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
