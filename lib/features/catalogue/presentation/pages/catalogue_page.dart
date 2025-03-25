import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shopping_app/core/constants/app_constants.dart';
import 'package:shopping_app/core/routes/app_router.dart';
import 'package:shopping_app/core/theme/app_colors.dart';
import 'package:shopping_app/core/utils/error_handler.dart';
import 'package:shopping_app/core/utils/responsive_helper.dart';
import 'package:shopping_app/core/widgets/app_bar_widget.dart';
import 'package:shopping_app/core/widgets/cart_badge.dart';
import 'package:shopping_app/core/widgets/product_card_widget.dart';
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
  final TextEditingController _searchController = TextEditingController();
  bool _didInitialFetch = false;

  @override
  void initState() {
    super.initState();

    // Add scroll listener for pagination
    _scrollController.addListener(_onScroll);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Safely fetch products only once or when returning to this page
    if (!_didInitialFetch) {
      // Add a small delay to ensure proper widget mounting
      Future.microtask(() {
        if (mounted) {
          ref.read(productProvider.notifier).resetProducts();
          ref.read(productProvider.notifier).fetchProducts();
          _didInitialFetch = true;
        }
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
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

    return Scaffold(
      appBar: _buildAppBar(),
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

  PreferredSizeWidget _buildAppBar() {
    return CustomAppBar(
      title: 'Discover',
      titleIcon: Icons.shopping_bag,
      actions: const [CartBadge()],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Container(
          height: 50,
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search products',
              hintStyle: TextStyle(color: AppColors.textMuted),
              prefixIcon: Icon(Icons.search, color: AppColors.textMuted),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 15),
            ),
            onSubmitted: (value) {
              // Will be implemented later
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Search will be implemented in future updates'),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // New method to build shimmer loading grid
  Widget _buildShimmerGrid() {
    final columns = ResponsiveHelper.getGridColumns(context);

    return GridView.builder(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        childAspectRatio: 0.57,
        crossAxisSpacing: AppConstants.smallPadding,
        mainAxisSpacing: AppConstants.smallPadding,
      ),
      itemCount: 6, // Show 6 shimmer items
      itemBuilder: (context, index) {
        return ShimmerLoading(child: ProductCardShimmer());
      },
    );
  }

  Widget _buildProductGrid(ProductState state) {
    final columns = ResponsiveHelper.getGridColumns(context);

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
              : state.status == ProductStatus.error
              ? ErrorHandler.buildErrorWidget(
                context,
                message:
                    state.errorMessage ??
                    'Failed to load products. Please try again.',
                onRetry: () {
                  ref.read(productProvider.notifier).resetProducts();
                  ref.read(productProvider.notifier).fetchProducts();
                },
              )
              : state.products.isEmpty
              ? _buildEmptyState()
              : GridView.builder(
                controller: _scrollController,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  childAspectRatio: 0.57,
                  crossAxisSpacing: AppConstants.smallPadding,
                  mainAxisSpacing: AppConstants.smallPadding,
                ),
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
                itemCount:
                    state.products.length + (state.hasReachedMax ? 0 : 1),
                itemBuilder: (context, index) {
                  if (index >= state.products.length) {
                    return ShimmerLoading(child: ProductCardShimmer());
                  }

                  final product = state.products[index];
                  return ProductCardWidget(
                    product: product,
                    onTap: () => _navigateToProductDetails(product),
                    onAddToCart: () => _addToCart(product),
                  );
                },
              ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off_rounded, size: 64, color: AppColors.textLight),
          const SizedBox(height: 16),
          Text(
            'No products found',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: AppColors.textLight),
          ),
        ],
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
