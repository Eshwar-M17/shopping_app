import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shopping_app/core/routes/app_router.dart';
import 'package:shopping_app/core/theme/app_colors.dart';
import 'package:shopping_app/features/cart/presentation/riverpod/cart_provider.dart';

class CartBadge extends ConsumerWidget {
  const CartBadge({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItemCount = ref.watch(cartProvider).totalItems;

    return Stack(
      alignment: Alignment.center,
      children: [
        IconButton(
          icon: const Icon(
            Icons.shopping_cart_outlined,
            color: AppColors.primary,
            size: 26,
          ),
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
