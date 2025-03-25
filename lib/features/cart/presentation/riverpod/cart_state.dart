import 'package:equatable/equatable.dart';
import 'package:shopping_app/features/cart/domain/entities/cart_item_entity.dart';

enum CartStatus { initial, loading, loaded, error }

class CartState extends Equatable {
  final List<CartItemEntity> items;
  final CartStatus status;
  final String? errorMessage;

  const CartState({
    this.items = const [],
    this.status = CartStatus.loaded,
    this.errorMessage,
  });

  double get totalPrice {
    return items.fold(0, (sum, item) => sum + item.totalPrice);
  }

  int get totalItems {
    return items.fold(0, (sum, item) => sum + item.quantity);
  }

  CartState copyWith({
    List<CartItemEntity>? items,
    CartStatus? status,
    String? errorMessage,
  }) {
    return CartState(
      items: items ?? this.items,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [items, status, errorMessage];
}
