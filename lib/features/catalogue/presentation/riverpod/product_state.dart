import 'package:equatable/equatable.dart';
import 'package:shopping_app/features/catalogue/domain/entities/product_entity.dart';

enum ProductStatus { initial, loading, success, error }

class ProductState extends Equatable {
  final List<ProductEntity> products;
  final ProductStatus status;
  final String? errorMessage;
  final bool hasReachedMax;
  final int currentPage;
  final int limit;

  const ProductState({
    this.products = const [],
    this.status = ProductStatus.initial,
    this.errorMessage,
    this.hasReachedMax = false,
    this.currentPage = 0,
    this.limit = 10,
  });

  ProductState copyWith({
    List<ProductEntity>? products,
    ProductStatus? status,
    String? errorMessage,
    bool? hasReachedMax,
    int? currentPage,
    int? limit,
  }) {
    return ProductState(
      products: products ?? this.products,
      status: status ?? this.status,
      errorMessage: errorMessage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
      limit: limit ?? this.limit,
    );
  }

  @override
  List<Object?> get props => [
    products,
    status,
    errorMessage,
    hasReachedMax,
    currentPage,
    limit,
  ];
}
