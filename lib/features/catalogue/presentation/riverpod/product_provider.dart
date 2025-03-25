import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopping_app/core/di/injection_container.dart';
import 'package:shopping_app/features/catalogue/domain/usecases/get_products_usecase.dart';
import 'package:shopping_app/features/catalogue/presentation/riverpod/product_state.dart';

final productProvider = StateNotifierProvider<ProductNotifier, ProductState>(
  (ref) => ProductNotifier(
    getProductsUseCase: ref.watch(getProductsUseCaseProvider),
  ),
);

// NOTE: The actual providers are defined in the injection_container.dart file

class ProductNotifier extends StateNotifier<ProductState> {
  final GetProductsUseCase _getProductsUseCase;
  bool _isLoading = false;

  ProductNotifier({required GetProductsUseCase getProductsUseCase})
    : _getProductsUseCase = getProductsUseCase,
      super(const ProductState());

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

      final result = await _getProductsUseCase(
        skip: state.currentPage * state.limit,
        limit: state.limit,
      );

      if (!mounted) return;

      result.fold(
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

  void resetProducts() {
    _isLoading = false;
    state = const ProductState();
  }
}
