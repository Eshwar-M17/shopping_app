/// Shopping cart state management.
///
/// This file defines the provider and notifier for managing the shopping cart,
/// including adding items, updating quantities, and calculating totals.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopping_app/features/cart/domain/entities/cart_item_entity.dart';
import 'package:shopping_app/features/cart/presentation/riverpod/cart_state.dart';
import 'package:shopping_app/features/catalogue/domain/entities/product_entity.dart';

/// The main provider for cart state throughout the app.
///
/// This provider exposes the [CartNotifier] which manages the shopping cart state.
/// UI components that need to display or modify cart data should consume this provider.
final cartProvider = StateNotifierProvider<CartNotifier, CartState>(
  (ref) => CartNotifier(),
);

/// Notifier class that manages shopping cart state and operations.
///
/// This class handles all cart-related functionality including:
/// - Adding products to the cart
/// - Removing products from the cart
/// - Updating product quantities
/// - Calculating totals and subtotals
class CartNotifier extends StateNotifier<CartState> {
  /// Creates a CartNotifier and initializes the cart.
  ///
  /// When instantiated, it automatically simulates loading the cart data.
  /// In a real application, this would load saved cart data from local storage
  /// or a remote API.
  CartNotifier() : super(const CartState(status: CartStatus.initial)) {
    // Simulate initial loading
    loadCart();
  }

  /// Simulates loading cart data from a persistent storage.
  ///
  /// In a real application, this would fetch cart data from local storage
  /// or a remote API. Here it just simulates the loading process with a delay.
  Future<void> loadCart() async {
    state = state.copyWith(status: CartStatus.loading);

    // Simulate API call or loading from local storage
    await Future.delayed(const Duration(milliseconds: 800));

    state = state.copyWith(status: CartStatus.loaded);
  }

  /// Adds a product to the cart.
  ///
  /// If the product already exists in the cart, its quantity is increased.
  /// Otherwise, a new cart item is created with quantity 1.
  ///
  /// [product] The product to add to the cart
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

  /// Removes a product from the cart completely, regardless of quantity.
  ///
  /// [productId] The ID of the product to remove
  void removeItem(int productId) {
    final updatedItems =
        state.items.where((item) => item.product.id != productId).toList();

    state = state.copyWith(items: updatedItems);
  }

  /// Updates the quantity of a specific product in the cart.
  ///
  /// If the new quantity is less than or equal to 0, the item is removed entirely.
  ///
  /// [productId] The ID of the product to update
  /// [quantity] The new quantity to set
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

  /// Increases the quantity of a specific product in the cart by 1.
  ///
  /// [productId] The ID of the product to increment
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

  /// Decreases the quantity of a specific product in the cart by 1.
  ///
  /// If the current quantity is 1, the item is removed entirely.
  ///
  /// [productId] The ID of the product to decrement
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

  /// Removes all items from the cart.
  ///
  /// This resets the cart to its initial empty state.
  void clearCart() {
    state = const CartState();
  }
}
