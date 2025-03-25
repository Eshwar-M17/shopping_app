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
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppColors.error.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.delete_outline, color: AppColors.error),
      ),
      onDismissed: (_) => onRemove(),
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
            _buildProductImage(context),
            const SizedBox(width: 16),

            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Brand
                  Text(
                    item.product.brand,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: AppColors.textMuted),
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
                  _buildPriceSection(context),

                  const SizedBox(height: 12),

                  // Quantity controls
                  _buildQuantityControls(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage(BuildContext context) {
    return ClipRRect(
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
                child: Container(width: 100, height: 100, color: Colors.white),
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
    );
  }

  Widget _buildPriceSection(BuildContext context) {
    final hasDiscount = item.product.discountPercentage > 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // Discounted price
            Text(
              '₹${item.product.discountedPrice.toStringAsFixed(0)}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),

            // Original price if discounted
            if (hasDiscount) ...[
              const SizedBox(width: 8),
              Text(
                '₹${item.product.price.toStringAsFixed(0)}',
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
              '${item.product.discountPercentage.round()}% OFF',
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
    return Row(
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
      child: InkWell(
        onTap: onPressed,
        child: SizedBox(height: 36, width: 36, child: Icon(icon, size: 18)),
      ),
    );
  }
}
