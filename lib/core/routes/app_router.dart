import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shopping_app/features/cart/presentation/pages/cart_page.dart';
import 'package:shopping_app/features/catalogue/presentation/pages/catalogue_page.dart';
import 'package:shopping_app/features/catalogue/presentation/pages/product_details_page.dart';

class AppRoutes {
  static const String catalogue = '/';
  static const String productDetails = '/product/:id';
  static const String cart = '/cart';
}

final appRouter = GoRouter(
  initialLocation: AppRoutes.catalogue,
  routes: [
    GoRoute(
      path: AppRoutes.catalogue,
      builder: (context, state) => const CataloguePage(),
    ),
    GoRoute(
      path: AppRoutes.productDetails,
      builder: (context, state) {
        final productId = int.parse(state.pathParameters['id'] ?? '0');
        return ProductDetailsPage(productId: productId);
      },
    ),
    GoRoute(
      path: AppRoutes.cart,
      builder: (context, state) => const CartPage(),
    ),
  ],
);
