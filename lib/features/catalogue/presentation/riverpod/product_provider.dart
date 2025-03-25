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

  ProductNotifier({required GetProductsUseCase getProductsUseCase})
    : _getProductsUseCase = getProductsUseCase,
      super(const ProductState());

  Future<void> fetchProducts() async {
    if (state.status == ProductStatus.loading) return;

    // If we've reached the maximum number of items, don't fetch more
    if (state.hasReachedMax) return;

    // If we're loading the first page, set status to loading
    // Otherwise, append loading indicator to the existing list
    state = state.copyWith(status: ProductStatus.loading);

    final result = await _getProductsUseCase(
      skip: state.currentPage * state.limit,
      limit: state.limit,
    );

    result.fold(
      (failure) =>
          state = state.copyWith(
            status: ProductStatus.error,
            errorMessage: failure.message,
          ),
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
        );
      },
    );
  }

  void resetProducts() {
    state = const ProductState();
  }
}
