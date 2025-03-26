import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shopping_app/core/theme/app_colors.dart';
import 'package:shopping_app/core/widgets/shimmer_loading.dart';
import 'package:shopping_app/features/cart/domain/entities/cart_item_entity.dart';

class CartItemWidget extends StatelessWidget {
  final CartItemEntity item;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onRemove;

  const CartItemWidget({
    Key? key,
    required this.item,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key('cart-item-${item.product.id}'),
      direction: DismissDirection.endToStart,
      background: _buildDismissBackground(),
      onDismissed: (_) => onRemove(),
      child: _buildCartItemContent(context),
    );
  }

  // Extract dismiss background to a separate method for better readability
  Widget _buildDismissBackground() {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
        color: AppColors.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(Icons.delete_outline, color: AppColors.error),
    );
  }

  // Main card content
  Widget _buildCartItemContent(BuildContext context) {
    return Container(
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
          _buildProductImage(context),
          const SizedBox(width: 16),
          Expanded(child: _buildProductDetails(context)),
        ],
      ),
    );
  }

  // Product details column
  Widget _buildProductDetails(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Brand
        Text(
          item.product.safeBrand,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppColors.textMuted),
        ),
        const SizedBox(height: 2),

        // Title
        Text(
          item.product.safeTitle,
          style: Theme.of(context).textTheme.titleMedium,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 8),

        // Price information
        _buildPriceSection(context),

        const SizedBox(height: 12),

        // Quantity controls
        _buildQuantityControls(context),
      ],
    );
  }

  Widget _buildProductImage(BuildContext context) {
    const double imageSize = 100;

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Hero(
        tag: 'cart-${item.product.id}',
        child: CachedNetworkImage(
          imageUrl: item.product.safeThumbnail,
          fit: BoxFit.cover,
          width: imageSize,
          height: imageSize,
          placeholder: (context, url) => const _ImagePlaceholder(),
          errorWidget: (context, url, error) => const _ImageErrorWidget(),
        ),
      ),
    );
  }

  Widget _buildPriceSection(BuildContext context) {
    final hasDiscount = item.product.discountPercentage > 0;
    final discountedPrice =
        '₹${item.product.discountedPrice.toStringAsFixed(0)}';
    final originalPrice = '₹${item.product.price.toStringAsFixed(0)}';
    final discountPercent = '${item.product.discountPercentage.round()}% OFF';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // Discounted price
            Text(
              discountedPrice,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),

            // Original price if discounted
            if (hasDiscount) ...[
              const SizedBox(width: 8),
              Text(
                originalPrice,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  decoration: TextDecoration.lineThrough,
                ),
              ),
            ],
          ],
        ),

        // Discount percentage
        if (hasDiscount)
          Padding(
            padding: const EdgeInsets.only(top: 2.0),
            child: Text(
              discountPercent,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.discount,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildQuantityControls(BuildContext context) {
    final totalPrice =
        'Total: ₹${(item.quantity * item.product.discountedPrice).toStringAsFixed(0)}';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Total for this item
        Text(totalPrice, style: const TextStyle(fontWeight: FontWeight.w500)),

        // Quantity controls
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.divider),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              _buildQuantityButton(icon: Icons.remove, onPressed: onDecrement),
              SizedBox(
                width: 40,
                child: Text(
                  '${item.quantity}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              _buildQuantityButton(icon: Icons.add, onPressed: onIncrement),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Material(
      color: AppColors.background,
      borderRadius: BorderRadius.circular(4),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(4),
        child: SizedBox(height: 36, width: 36, child: Icon(icon, size: 18)),
      ),
    );
  }
}

// Extract reusable widgets
class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: Container(width: 100, height: 100, color: Colors.white),
    );
  }
}

class _ImageErrorWidget extends StatelessWidget {
  const _ImageErrorWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      color: AppColors.background,
      child: const Icon(Icons.broken_image),
    );
  }
}
