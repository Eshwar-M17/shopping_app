import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shopping_app/core/routes/app_router.dart';
import 'package:shopping_app/core/theme/app_colors.dart';
import 'package:shopping_app/core/widgets/shimmer_loading.dart';
import 'package:shopping_app/features/cart/presentation/riverpod/cart_provider.dart';
import 'package:shopping_app/features/cart/presentation/riverpod/cart_state.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CartPage extends ConsumerWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartProvider);
    final isLoading = cartState.status == CartStatus.loading;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Cart (${isLoading ? "..." : cartState.totalItems})',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go(AppRoutes.catalogue),
        ),
        actions: [
          if (cartState.items.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () => _showClearCartDialog(context, ref),
              tooltip: 'Clear cart',
            ),
        ],
      ),
      body:
          isLoading
              ? _buildLoadingState()
              : cartState.items.isEmpty
              ? _buildEmptyCart(context)
              : _buildCartItems(context, ref),
      bottomNavigationBar:
          isLoading || cartState.items.isEmpty
              ? null
              : _buildCheckoutSection(context, cartState),
    );
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      itemCount: 3, // Show 3 shimmer items
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: ShimmerLoading(child: CartItemShimmer()),
        );
      },
    );
  }

  Widget _buildEmptyCart(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: AppColors.background,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.shopping_cart_outlined,
              size: 80,
              color: AppColors.primary.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Your cart is empty',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 12),
          Text(
            'Add items to get started',
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: AppColors.textLight),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () => context.go(AppRoutes.catalogue),
            icon: const Icon(Icons.shopping_bag_outlined),
            label: const Text('Continue Shopping'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItems(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider).items;

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      itemCount: cartItems.length,
      separatorBuilder: (context, index) => const Divider(height: 24),
      itemBuilder: (context, index) {
        final item = cartItems[index];
        return Dismissible(
          key: Key('cart-item-${item.product.id}'),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            decoration: BoxDecoration(
              color: AppColors.error.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.delete_outline, color: AppColors.error),
          ),
          onDismissed: (direction) {
            ref.read(cartProvider.notifier).removeItem(item.product.id);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${item.product.title} removed from cart'),
                action: SnackBarAction(
                  label: 'Undo',
                  onPressed:
                      () =>
                          ref.read(cartProvider.notifier).addItem(item.product),
                ),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.transparent),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 1,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Hero(
                    tag: 'cart-${item.product.id}',
                    child: CachedNetworkImage(
                      imageUrl: item.product.thumbnail,
                      fit: BoxFit.cover,
                      width: 100,
                      height: 100,
                      placeholder:
                          (context, url) => ShimmerLoading(
                            child: Container(
                              width: 100,
                              height: 100,
                              color: Colors.white,
                            ),
                          ),
                      errorWidget:
                          (context, url, error) => Container(
                            width: 100,
                            height: 100,
                            color: AppColors.background,
                            child: const Icon(Icons.broken_image),
                          ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Product Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Brand
                      Text(
                        item.product.brand,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                      const SizedBox(height: 2),

                      // Title
                      Text(
                        item.product.title,
                        style: Theme.of(context).textTheme.titleMedium,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),

                      // Price information
                      Row(
                        children: [
                          // Discounted price
                          Text(
                            '₹${item.product.discountedPrice.toStringAsFixed(0)}',
                            style: Theme.of(
                              context,
                            ).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),

                          // Original price if discounted
                          if (item.product.discountPercentage > 0) ...[
                            const SizedBox(width: 8),
                            Text(
                              '₹${item.product.price.toStringAsFixed(0)}',
                              style: Theme.of(
                                context,
                              ).textTheme.bodySmall?.copyWith(
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ],
                        ],
                      ),

                      // Discount percentage
                      if (item.product.discountPercentage > 0)
                        Padding(
                          padding: const EdgeInsets.only(top: 2.0),
                          child: Text(
                            '${item.product.discountPercentage.round()}% OFF',
                            style: Theme.of(
                              context,
                            ).textTheme.bodySmall?.copyWith(
                              color: AppColors.discount,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                      const SizedBox(height: 12),

                      // Quantity controls
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Total for this item
                          Text(
                            'Total: ₹${(item.quantity * item.product.discountedPrice).toStringAsFixed(0)}',
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),

                          // Quantity controls
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.divider),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                _buildQuantityButton(
                                  icon: Icons.remove,
                                  onPressed:
                                      () => ref
                                          .read(cartProvider.notifier)
                                          .decrementQuantity(item.product.id),
                                ),
                                SizedBox(
                                  width: 40,
                                  child: Text(
                                    '${item.quantity}',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                _buildQuantityButton(
                                  icon: Icons.add,
                                  onPressed:
                                      () => ref
                                          .read(cartProvider.notifier)
                                          .incrementQuantity(item.product.id),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Material(
      color: AppColors.background,
      child: InkWell(
        onTap: onPressed,
        child: SizedBox(height: 36, width: 36, child: Icon(icon, size: 18)),
      ),
    );
  }

  Widget _buildCheckoutSection(BuildContext context, CartState cartState) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Order summary
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Items (${cartState.totalItems})',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  '₹${cartState.totalPrice.toStringAsFixed(0)}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Delivery fee
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Delivery Fee',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const Text(
                  'FREE',
                  style: TextStyle(
                    color: AppColors.discount,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),

            // Total amount
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Amount',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  '₹${cartState.totalPrice.toStringAsFixed(0)}',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Checkout button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Checkout functionality will be implemented in future updates',
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Proceed to Checkout',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showClearCartDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Clear Cart'),
            content: const Text(
              'Are you sure you want to remove all items from your cart?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  ref.read(cartProvider.notifier).clearCart();
                  Navigator.of(ctx).pop();
                },
                style: TextButton.styleFrom(foregroundColor: AppColors.error),
                child: const Text('Clear'),
              ),
            ],
          ),
    );
  }
}
