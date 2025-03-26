/// Dependency Injection container using Riverpod.
///
/// This file sets up all the dependencies and their relationships for the application,
/// including networking clients, repositories, and use cases. It leverages Riverpod's
/// provider system to manage dependencies with proper scoping and lazy initialization.
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shopping_app/features/catalogue/data/datasources/product_api_client.dart';
import 'package:shopping_app/features/catalogue/data/repositories/product_repository_impl.dart';
import 'package:shopping_app/features/catalogue/domain/repositories/product_repository.dart';
import 'package:shopping_app/features/catalogue/domain/usecases/get_product_by_id_usecase.dart';
import 'package:shopping_app/features/catalogue/domain/usecases/get_products_usecase.dart';

/// Provider for the Dio HTTP client with logging configuration.
///
/// This provider creates and configures a Dio instance with PrettyDioLogger
/// for detailed request and response logging during development.
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();
  dio.interceptors.add(
    PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      compact: false,
    ),
  );
  return dio;
});

/// Provider for the ProductApiClient that handles API calls.
///
/// This provider creates a ProductApiClient instance with the Dio client
/// injected from the dioProvider. It's responsible for making HTTP requests
/// to the product-related endpoints.
final productApiClientProvider = Provider<ProductApiClient>((ref) {
  return ProductApiClient(ref.watch(dioProvider));
});

/// Provider for the ProductRepository that implements the domain repository interface.
///
/// This provider creates a ProductRepositoryImpl that depends on the ProductApiClient.
/// It bridges the data layer with the domain layer by transforming API responses
/// into domain entities.
final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepositoryImpl(ref.watch(productApiClientProvider));
});

/// Provider for the GetProductsUseCase.
///
/// This use case is responsible for fetching a list of products from the repository.
/// It's used by the UI layer to get product data for the catalogue page.
final getProductsUseCaseProvider = Provider<GetProductsUseCase>((ref) {
  return GetProductsUseCase(ref.watch(productRepositoryProvider));
});

/// Provider for the GetProductByIdUseCase.
///
/// This use case is responsible for fetching a single product by its ID.
/// It's used by the UI layer to get product details for the product details page.
final getProductByIdUseCaseProvider = Provider<GetProductByIdUseCase>((ref) {
  return GetProductByIdUseCase(ref.watch(productRepositoryProvider));
});
