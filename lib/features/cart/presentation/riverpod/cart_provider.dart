import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopping_app/features/cart/domain/entities/cart_item_entity.dart';
import 'package:shopping_app/features/cart/presentation/riverpod/cart_state.dart';
import 'package:shopping_app/features/catalogue/domain/entities/product_entity.dart';

final cartProvider = StateNotifierProvider<CartNotifier, CartState>(
  (ref) => CartNotifier(),
);

class CartNotifier extends StateNotifier<CartState> {
  CartNotifier() : super(const CartState());

  void addItem(ProductEntity product) {
    final existingIndex = state.items.indexWhere(
      (item) => item.product.id == product.id,
    );

    // If the item already exists in the cart, increase its quantity
    if (existingIndex >= 0) {
      final updatedItems = List<CartItemEntity>.from(state.items);
      final existingItem = updatedItems[existingIndex];

      updatedItems[existingIndex] = existingItem.copyWith(
        quantity: existingItem.quantity + 1,
      );

      state = state.copyWith(items: updatedItems);
    } else {
      // Otherwise, add a new item with quantity 1
      state = state.copyWith(
        items: [...state.items, CartItemEntity(product: product, quantity: 1)],
      );
    }
  }

  void removeItem(int productId) {
    final updatedItems =
        state.items.where((item) => item.product.id != productId).toList();

    state = state.copyWith(items: updatedItems);
  }

  void updateQuantity(int productId, int quantity) {
    if (quantity <= 0) {
      removeItem(productId);
      return;
    }

    final updatedItems = List<CartItemEntity>.from(state.items);
    final index = updatedItems.indexWhere(
      (item) => item.product.id == productId,
    );

    if (index >= 0) {
      updatedItems[index] = updatedItems[index].copyWith(quantity: quantity);
      state = state.copyWith(items: updatedItems);
    }
  }

  void incrementQuantity(int productId) {
    final updatedItems = List<CartItemEntity>.from(state.items);
    final index = updatedItems.indexWhere(
      (item) => item.product.id == productId,
    );

    if (index >= 0) {
      updatedItems[index] = updatedItems[index].copyWith(
        quantity: updatedItems[index].quantity + 1,
      );
      state = state.copyWith(items: updatedItems);
    }
  }

  void decrementQuantity(int productId) {
    final updatedItems = List<CartItemEntity>.from(state.items);
    final index = updatedItems.indexWhere(
      (item) => item.product.id == productId,
    );

    if (index >= 0) {
      final currentQuantity = updatedItems[index].quantity;

      if (currentQuantity <= 1) {
        removeItem(productId);
      } else {
        updatedItems[index] = updatedItems[index].copyWith(
          quantity: currentQuantity - 1,
        );
        state = state.copyWith(items: updatedItems);
      }
    }
  }

  void clearCart() {
    state = const CartState();
  }
}
