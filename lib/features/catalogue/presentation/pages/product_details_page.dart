import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shopping_app/core/routes/app_router.dart';
import 'package:shopping_app/core/theme/app_colors.dart';
import 'package:shopping_app/core/utils/error_handler.dart';
import 'package:shopping_app/core/widgets/app_bar_widget.dart';
import 'package:shopping_app/core/widgets/cart_badge.dart';
import 'package:shopping_app/core/widgets/shimmer_loading.dart';
import 'package:shopping_app/features/cart/presentation/riverpod/cart_provider.dart';
import 'package:shopping_app/features/catalogue/domain/entities/product_entity.dart';
import 'package:shopping_app/features/catalogue/domain/usecases/get_product_by_id_usecase.dart';
import 'package:shopping_app/core/di/injection_container.dart';

final productDetailsProvider = FutureProvider.family<ProductEntity, int>((
  ref,
  id,
) async {
  final useCase = ref.watch(getProductByIdUseCaseProvider);
  final result = await useCase(id);
  return result.fold(
    (failure) => throw Exception(failure.message),
    (product) => product,
  );
});

class ProductDetailsPage extends ConsumerWidget {
  final int productId;

  const ProductDetailsPage({Key? key, required this.productId})
    : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productAsync = ref.watch(productDetailsProvider(productId));

    return Scaffold(
      appBar: _buildAppBar(context),
      body: productAsync.when(
        data: (product) => _buildProductDetails(context, product, ref),
        loading: () => ShimmerLoading(child: ProductDetailsShimmer()),
        error: (error, stack) {
          final errorMsg =
              error != null
                  ? ErrorHandler.getErrorMessage(error)
                  : 'Failed to load product details';

          return ErrorHandler.buildErrorWidget(
            context,
            message: errorMsg,
            onRetry: () => ref.refresh(productDetailsProvider(productId)),
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      title: 'Product Details',
      titleIcon: Icons.inventory_2,
      leadingIcon: Icons.arrow_back,
      onLeadingTap: () => context.pop(),
      actions: const [CartBadge()],
    );
  }

  Widget _buildProductDetails(
    BuildContext context,
    ProductEntity product,
    WidgetRef ref,
  ) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProductImages(product),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProductHeader(context, product),
                const SizedBox(height: 16),
                _buildPriceSection(context, product),
                const SizedBox(height: 24),
                _buildDescriptionSection(context, product),
                const SizedBox(height: 24),
                _buildStockInfo(context, product),
                const SizedBox(height: 32),
                _buildAddToCartButton(context, product, ref),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductImages(ProductEntity product) {
    if (product.images.isEmpty) {
      return Container(
        height: 300,
        color: AppColors.background,
        child: const Center(
          child: Icon(Icons.image_not_supported, size: 80, color: Colors.grey),
        ),
      );
    }

    return SizedBox(
      height: 300,
      child: PageView.builder(
        itemCount: product.images.length,
        itemBuilder: (context, index) {
          final imageUrl =
              product.images[index].isNotEmpty
                  ? product.images[index]
                  : product.safeThumbnail;

          return CachedNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.cover,
            placeholder:
                (context, url) => ShimmerLoading(
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Colors.white,
                  ),
                ),
            errorWidget:
                (context, url, error) => Container(
                  color: AppColors.background,
                  child: const Icon(Icons.error, size: 50),
                ),
          );
        },
      ),
    );
  }

  Widget _buildProductHeader(BuildContext context, ProductEntity product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Brand & Rating
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              product.safeBrand,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 20),
                const SizedBox(width: 4),
                Text(
                  product.rating.toString(),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Title
        Text(product.safeTitle, style: Theme.of(context).textTheme.titleLarge),
      ],
    );
  }

  Widget _buildPriceSection(BuildContext context, ProductEntity product) {
    return Row(
      children: [
        Text(
          '\$${product.discountedPrice.toStringAsFixed(2)}',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (product.discountPercentage > 0) ...[
          const SizedBox(width: 12),
          Text(
            '\$${product.price.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              decoration: TextDecoration.lineThrough,
              color: AppColors.textLight,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              '-${product.discountPercentage.toStringAsFixed(0)}%',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDescriptionSection(BuildContext context, ProductEntity product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Description', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Text(
          product.safeDescription,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }

  Widget _buildStockInfo(BuildContext context, ProductEntity product) {
    return Row(
      children: [
        const Icon(Icons.inventory, size: 20, color: AppColors.textLight),
        const SizedBox(width: 8),
        Text(
          'Available in stock: ${product.stock}',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildAddToCartButton(
    BuildContext context,
    ProductEntity product,
    WidgetRef ref,
  ) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => _addToCart(context, product, ref),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: const Text('Add to Cart'),
      ),
    );
  }

  void _addToCart(BuildContext context, ProductEntity product, WidgetRef ref) {
    ref.read(cartProvider.notifier).addItem(product);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.safeTitle} added to cart'),
        action: SnackBarAction(
          label: 'View Cart',
          onPressed: () => context.go(AppRoutes.cart),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
