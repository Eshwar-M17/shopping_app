/// Router configuration for the application using GoRouter.
///
/// This file defines all the routes available in the app and their corresponding
/// page builders. GoRouter is used for declarative routing instead of the
/// traditional Navigator.
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shopping_app/features/cart/presentation/pages/cart_page.dart';
import 'package:shopping_app/features/catalogue/presentation/pages/catalogue_page.dart';
import 'package:shopping_app/features/catalogue/presentation/pages/product_details_page.dart';

/// Defines all route paths used in the app as constants.
///
/// Using this class helps maintain consistency in navigation throughout
/// the app and makes route path changes easier to manage.
class AppRoutes {
  /// Home page / Catalogue page - the entry point of the app
  static const String catalogue = '/';

  /// Product details page - uses a path parameter for the product ID
  static const String productDetails = '/product/:id';

  /// Shopping cart page
  static const String cart = '/cart';
}

/// The main router configuration for the app.
///
/// This GoRouter instance defines all available routes and their corresponding
/// page builders. It's configured with the catalogue page as the initial location.
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
        // Extract the product ID from the URL parameters
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
