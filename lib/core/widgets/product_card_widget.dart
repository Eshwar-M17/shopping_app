/// A reusable product card widget for displaying products in a grid.
///
/// This widget displays product information in a card format, including:
/// - Product image with discount badge
/// - Brand and title
/// - Rating and price information
/// - Add to cart button
///
/// The card handles image loading with placeholders and error states,
/// and provides tap interactions for viewing details or adding to cart.
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shopping_app/core/theme/app_colors.dart';
import 'package:shopping_app/core/widgets/shimmer_loading.dart';
import 'package:shopping_app/features/catalogue/domain/entities/product_entity.dart';

/// A card widget displaying product information with interactive elements.
///
/// This widget is used primarily in the product catalogue grid to display
/// product information in a consistent, attractive format.
class ProductCardWidget extends StatelessWidget {
  /// The product entity containing all the product data to display
  final ProductEntity product;

  /// Callback function when the card is tapped (navigates to product details)
  final VoidCallback onTap;

  /// Callback function when the add to cart button is tapped
  final VoidCallback onAddToCart;

  /// Creates a product card widget.
  ///
  /// All parameters are required to ensure proper functionality.
  const ProductCardWidget({
    Key? key,
    required this.product,
    required this.onTap,
    required this.onAddToCart,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final discountPercentage = product.discountPercentage.round();
    final hasDiscount = discountPercentage > 0;

    return GestureDetector(
      onTap: onTap,
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
                // Product image with loading and error states
                AspectRatio(
                  aspectRatio: 1,
                  child: Hero(
                    // Hero animation tag for smooth transitions to details page
                    tag: 'product-${product.id}',
                    child: CachedNetworkImage(
                      imageUrl: product.safeThumbnail,
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

                // Discount badge - only shown if product has a discount
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

            // Product Details section
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Brand name
                  Text(
                    product.safeBrand,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: AppColors.textMuted),
                  ),
                  const SizedBox(height: 1),

                  // Product title with ellipsis for long titles
                  Text(
                    product.safeTitle,
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 1),

                  // Rating and Price row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Rating display with star icon
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

                      // Price display with original and discounted prices
                      Row(
                        children: [
                          // Original price (strikethrough) - only shown if discounted
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
                          // Discounted/final price
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
                  _buildAddToCartButton(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the Add to Cart button with appropriate styling.
  ///
  /// Uses Material and InkWell for proper touch feedback.
  Widget _buildAddToCartButton(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onAddToCart,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.add_shopping_cart, color: Colors.white, size: 14),
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
    );
  }
}
