/// Riverpod state management for the product catalogue.
///
/// This file contains the provider and notifier for managing product data,
/// including fetching, pagination, and error handling for the product catalogue.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopping_app/core/di/injection_container.dart';
import 'package:shopping_app/features/catalogue/domain/usecases/get_products_usecase.dart';
import 'package:shopping_app/features/catalogue/presentation/riverpod/product_state.dart';

/// The main provider for product state throughout the app.
///
/// This provider exposes the [ProductNotifier] which manages product data
/// and the current [ProductState]. It's consumed by UI components that
/// need to display or interact with product data.
final productProvider = StateNotifierProvider<ProductNotifier, ProductState>(
  (ref) => ProductNotifier(
    getProductsUseCase: ref.watch(getProductsUseCaseProvider),
  ),
);

// NOTE: The actual providers are defined in the injection_container.dart file

/// Notifier class that manages product state and operations.
///
/// This class is responsible for:
/// - Fetching products from the API
/// - Managing pagination (loading more products when scrolling)
/// - Handling loading, success, and error states
/// - Providing methods to reset or refresh product data
class ProductNotifier extends StateNotifier<ProductState> {
  final GetProductsUseCase _getProductsUseCase;

  /// Flag to prevent concurrent API calls
  bool _isLoading = false;

  /// Creates a ProductNotifier with the required use case.
  ///
  /// The [getProductsUseCase] is injected through the constructor and is used
  /// to fetch product data from the repository.
  ProductNotifier({required GetProductsUseCase getProductsUseCase})
    : _getProductsUseCase = getProductsUseCase,
      super(const ProductState());

  /// Fetches products with pagination support.
  ///
  /// This method:
  /// - Checks if a fetch is already in progress or max items reached
  /// - Updates state to indicate loading
  /// - Calls the use case to fetch products from the repository
  /// - Updates state based on the result (success or error)
  /// - Manages pagination by tracking current page and if max items reached
  Future<void> fetchProducts() async {
    // Prevent concurrent fetches with a local flag
    if (_isLoading || state.status == ProductStatus.loading) return;

    // If we've reached the maximum number of items, don't fetch more
    if (state.hasReachedMax) return;

    try {
      _isLoading = true;

      // If we're loading the first page, set status to loading
      // Otherwise, append loading indicator to the existing list
      state = state.copyWith(status: ProductStatus.loading);

      // Calculate skip based on current page and limit
      final result = await _getProductsUseCase(
        skip: state.currentPage * state.limit,
        limit: state.limit,
      );

      if (!mounted) return;

      // Handle the result using the Either pattern from dartz
      result.fold(
        // Error case - update state with error status and message
        (failure) {
          final safeErrorMessage =
              failure.message?.isNotEmpty == true
                  ? failure.message
                  : 'Failed to load products. Please try again.';

          state = state.copyWith(
            status: ProductStatus.error,
            errorMessage: safeErrorMessage,
          );
        },
        // Success case - update state with new products
        (products) {
          // If no new products were returned, we've reached the max
          if (products.isEmpty) {
            state = state.copyWith(
              hasReachedMax: true,
              status: ProductStatus.success,
            );
            return;
          }

          // Otherwise, append the new products to our list
          state = state.copyWith(
            status: ProductStatus.success,
            products: [...state.products, ...products],
            currentPage: state.currentPage + 1,
            hasReachedMax: products.length < state.limit,
            // Clear any previous error message when successful
            errorMessage: null,
          );
        },
      );
    } catch (e) {
      if (mounted) {
        state = state.copyWith(
          status: ProductStatus.error,
          errorMessage: 'An unexpected error occurred. Please try again.',
        );
      }
    } finally {
      _isLoading = false;
    }
  }

  /// Resets the product state to its initial values.
  ///
  /// This method is typically called when the user wants to refresh the
  /// product list from scratch or when navigating back to the catalogue page.
  void resetProducts() {
    _isLoading = false;
    state = const ProductState();
  }
}
