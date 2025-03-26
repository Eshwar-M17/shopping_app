/// Domain entity representing a product in the catalogue.
///
/// This entity contains all the core product information needed by the UI layer.
/// It uses nullable fields for properties that might be missing from the API response,
/// along with "safe" getters that provide fallback values when accessing these fields.
import 'package:equatable/equatable.dart';

/// Represents a product with its core attributes.
///
/// The entity uses Equatable to enable value-based equality comparisons,
/// which is useful for state management and widget rebuilding optimization.
class ProductEntity extends Equatable {
  /// Unique identifier for the product
  final int id;

  /// Name/title of the product (nullable)
  final String? title;

  /// Detailed description of the product (nullable)
  final String? description;

  /// Original price of the product
  final double price;

  /// Discount percentage applied to the product
  final double discountPercentage;

  /// Average user rating of the product
  final double rating;

  /// Number of items available in stock
  final int stock;

  /// Brand name of the product (nullable)
  final String? brand;

  /// Category the product belongs to (nullable)
  final String? category;

  /// URL to the product's thumbnail image (nullable)
  final String? thumbnail;

  /// List of additional product image URLs
  final List<String> images;

  /// Creates a product entity with the required attributes.
  ///
  /// While some fields are nullable, all fields must be provided when creating
  /// an instance, even if some are null. This is to maintain a consistent structure.
  const ProductEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.discountPercentage,
    required this.rating,
    required this.stock,
    required this.brand,
    required this.category,
    required this.thumbnail,
    required this.images,
  });

  /// Calculates the discounted price based on the original price and discount percentage.
  ///
  /// This computed property avoids redundant calculations throughout the UI.
  double get discountedPrice {
    return price - (price * discountPercentage / 100);
  }

  /// Safe accessor for title, returning a default value if null
  String get safeTitle => title ?? 'Unknown Product';

  /// Safe accessor for description, returning a default value if null
  String get safeDescription => description ?? 'No description available';

  /// Safe accessor for brand, returning a default value if null
  String get safeBrand => brand ?? 'Unknown Brand';

  /// Safe accessor for category, returning a default value if null
  String get safeCategory => category ?? 'Uncategorized';

  /// Safe accessor for thumbnail, returning an empty string if null
  String get safeThumbnail => thumbnail ?? '';

  /// List of properties used for equality comparisons by Equatable
  @override
  List<Object?> get props => [
    id,
    title,
    description,
    price,
    discountPercentage,
    rating,
    stock,
    brand,
    category,
    thumbnail,
    images,
  ];
}
