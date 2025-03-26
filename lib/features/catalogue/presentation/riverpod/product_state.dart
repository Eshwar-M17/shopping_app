/// State management definitions for the product catalogue.
///
/// This file defines the state structure and possible status values
/// for the product catalogue feature.
import 'package:equatable/equatable.dart';
import 'package:shopping_app/features/catalogue/domain/entities/product_entity.dart';

/// Possible status values for the product loading process.
///
/// - [initial]: The initial state before any product fetch is attempted
/// - [loading]: Products are currently being fetched from the API
/// - [success]: Products were successfully fetched
/// - [error]: An error occurred while fetching products
enum ProductStatus { initial, loading, success, error }

/// Immutable state class for the product catalogue.
///
/// This class holds all the state information needed for displaying
/// the product catalogue, including:
/// - The list of products
/// - Current loading status
/// - Error information
/// - Pagination details
class ProductState extends Equatable {
  /// The list of products currently loaded
  final List<ProductEntity> products;

  /// The current status of the product loading operation
  final ProductStatus status;

  /// Error message in case of failure, null otherwise
  final String? errorMessage;

  /// Flag indicating whether all available products have been loaded
  final bool hasReachedMax;

  /// Current page number for pagination (0-based)
  final int currentPage;

  /// Number of items to load per page
  final int limit;

  /// Creates a ProductState with the given values.
  ///
  /// All parameters have default values for the initial state.
  const ProductState({
    this.products = const [],
    this.status = ProductStatus.initial,
    this.errorMessage,
    this.hasReachedMax = false,
    this.currentPage = 0,
    this.limit = 10,
  });

  /// Creates a copy of this state with the given field values updated.
  ///
  /// This method is used to maintain immutability while updating state.
  /// Note that errorMessage is intentionally not using the ?? operator
  /// to allow explicitly setting it to null.
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

  /// Properties used for equality comparison by Equatable.
  ///
  /// Two ProductState instances are considered equal if all these
  /// properties are equal.
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
