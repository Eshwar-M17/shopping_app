/// ShopEase - A modern shopping application built with Flutter.
///
/// This application demonstrates clean architecture principles with
/// a clear separation between UI, business logic, and data layers.
/// It uses Riverpod for state management and GoRouter for navigation.
///
/// Main features include:
/// - Product catalog with pagination
/// - Product details page
/// - Shopping cart functionality
/// - Responsive layout across different device sizes
/// - Error handling with user-friendly messages
///
/// The app is organized using a feature-first architecture with
/// core components shared across features.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopping_app/core/routes/app_router.dart';
import 'package:shopping_app/core/theme/app_theme.dart';

/// Application entry point that initializes Flutter bindings
/// and wraps the app in a ProviderScope for Riverpod state management.
void main() async {
  // Ensure Flutter is initialized before running the app
  WidgetsFlutterBinding.ensureInitialized();

  // ProviderScope enables Riverpod state management throughout the app
  runApp(const ProviderScope(child: MyApp()));
}

/// Root widget of the application.
///
/// Sets up the MaterialApp with theming and routing configuration.
/// The app uses GoRouter for navigation, defined in app_router.dart.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Shopping App',
      theme: AppTheme.lightTheme, // Defined in core/theme/app_theme.dart
      routerConfig: appRouter, // Defined in core/routes/app_router.dart
      debugShowCheckedModeBanner: false,
    );
  }
}
