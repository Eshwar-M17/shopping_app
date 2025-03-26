/// A shopping cart icon with a badge showing the number of items.
///
/// This widget displays a cart icon in the app bar or other locations,
/// along with a small badge indicating the number of items currently in the cart.
/// It automatically navigates to the cart page when tapped.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shopping_app/core/routes/app_router.dart';
import 'package:shopping_app/core/theme/app_colors.dart';
import 'package:shopping_app/features/cart/presentation/riverpod/cart_provider.dart';

/// A cart icon with item count badge that reacts to cart state changes.
///
/// This widget consumes the [cartProvider] to display the current number of items
/// in the cart, and updates automatically when items are added or removed.
/// The badge is only shown when there are items in the cart.
class CartBadge extends ConsumerWidget {
  /// Creates a cart badge widget.
  ///
  /// The widget doesn't require any parameters as it gets all necessary
  /// data from the cart provider.
  const CartBadge({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get the current cart item count from the cart provider
    final cartItemCount = ref.watch(cartProvider).totalItems;

    return Stack(
      alignment: Alignment.center,
      children: [
        // Cart icon button
        IconButton(
          icon: const Icon(
            Icons.shopping_cart_outlined,
            color: AppColors.primary,
            size: 26,
          ),
          onPressed: () => context.go(AppRoutes.cart),
        ),

        // Badge showing item count (only visible when cart has items)
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
              constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
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
    );
  }
}
