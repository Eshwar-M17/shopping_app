/// Shimmer loading effect widgets for displaying placeholder UI during data loading.
///
/// This file contains the base shimmer widget along with specific implementations
/// for different UI components like product cards, cart items, and product details.
/// These are displayed during loading states to indicate content is being fetched.
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:shopping_app/core/theme/app_colors.dart';

/// A generic shimmer loading effect widget that applies the effect to any child widget.
///
/// This base widget uses the shimmer package to create a smooth loading animation
/// that can be applied to any placeholder UI component to indicate loading state.
class ShimmerLoading extends StatelessWidget {
  /// The child widget to apply the shimmer effect to
  final Widget child;

  /// The base color for the shimmer effect (darker tone)
  final Color baseColor;

  /// The highlight color for the shimmer effect (lighter tone)
  final Color highlightColor;

  /// Creates a shimmer loading effect widget.
  ///
  /// The [child] parameter is required and represents the placeholder UI to animate.
  /// [baseColor] and [highlightColor] have defaults but can be customized.
  const ShimmerLoading({
    Key? key,
    required this.child,
    this.baseColor = const Color(0xFFEBEBF4),
    this.highlightColor = const Color(0xFFF5F5F5),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      period: const Duration(
        milliseconds: 1500,
      ), // Slightly slower for less CPU usage
      child: child,
    );
  }
}

/// A shimmer placeholder for a product card in the catalogue grid.
///
/// This widget mimics the structure of a ProductCardWidget, creating
/// placeholders for the image, title, price, rating, and add to cart button.
class ProductCardShimmer extends StatelessWidget {
  const ProductCardShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Image placeholder
          AspectRatio(aspectRatio: 1, child: Container(color: Colors.white)),

          // Content placeholder
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Brand
                Container(width: 60, height: 10, color: Colors.white),
                const SizedBox(height: 8),

                // Title
                Container(
                  width: double.infinity,
                  height: 14,
                  color: Colors.white,
                ),
                const SizedBox(height: 8),

                // Rating and price
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(width: 40, height: 10, color: Colors.white),
                    Container(width: 50, height: 14, color: Colors.white),
                  ],
                ),
                const SizedBox(height: 12),

                // Button
                Container(
                  width: double.infinity,
                  height: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// A shimmer placeholder for a cart item in the shopping cart.
///
/// This widget mimics the structure of a CartItemWidget, creating
/// placeholders for the image, title, brand, price, and quantity controls.
class CartItemShimmer extends StatelessWidget {
  const CartItemShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 12),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Container(
                  width: double.infinity,
                  height: 16,
                  color: Colors.white,
                ),
                const SizedBox(height: 8),

                // Brand
                Container(width: 80, height: 12, color: Colors.white),
                const SizedBox(height: 16),

                // Price and quantity
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(width: 60, height: 16, color: Colors.white),
                    Row(
                      children: [
                        Container(
                          width: 80,
                          height: 24,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// A shimmer placeholder for the product details page.
///
/// This widget mimics the structure of the ProductDetailsPage, creating
/// placeholders for the image, title, brand, price, description, and add to cart button.
class ProductDetailsShimmer extends StatelessWidget {
  const ProductDetailsShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Image
        AspectRatio(aspectRatio: 1, child: Container(color: Colors.white)),

        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Brand
              Container(width: 80, height: 12, color: Colors.white),
              const SizedBox(height: 8),

              // Title
              Container(
                width: double.infinity,
                height: 20,
                color: Colors.white,
              ),
              const SizedBox(height: 16),

              // Price
              Row(
                children: [
                  Container(width: 100, height: 24, color: Colors.white),
                ],
              ),
              const SizedBox(height: 24),

              // Description title
              Container(width: 120, height: 16, color: Colors.white),
              const SizedBox(height: 8),

              // Description lines
              for (int i = 0; i < 4; i++) ...[
                Container(
                  width: double.infinity,
                  height: 12,
                  color: Colors.white,
                ),
                const SizedBox(height: 8),
              ],

              const SizedBox(height: 32),

              // Button
              Container(
                width: double.infinity,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
