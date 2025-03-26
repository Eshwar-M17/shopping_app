import 'package:json_annotation/json_annotation.dart';
import 'package:shopping_app/features/catalogue/data/models/json_serializers/string_serializer.dart';
import 'package:shopping_app/features/catalogue/domain/entities/product_entity.dart';

part 'product_model.g.dart';

@JsonSerializable()
class ProductModel extends ProductEntity {
  const ProductModel({
    required super.id,
    required super.title,
    required super.description,
    required super.price,
    required super.discountPercentage,
    required super.rating,
    required super.stock,
    required super.brand,
    required super.category,
    required super.thumbnail,
    required super.images,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    // Handle potential null values in the JSON before passing to auto-generated fromJson
    final safeJson = Map<String, dynamic>.from(json);
    
    // Ensure images is a list of strings even if it's null or empty
    if (safeJson['images'] == null) {
      safeJson['images'] = <String>[];
    } else if (safeJson['images'] is List) {
      final imagesList = safeJson['images'] as List;
      safeJson['images'] = imagesList.map((img) => img?.toString() ?? '').toList();
    }
    
    return _$ProductModelFromJson(safeJson);
  }

  Map<String, dynamic> toJson() => _$ProductModelToJson(this);
}

@JsonSerializable()
class ProductResponse {
  final List<ProductModel> products;
  final int total;
  final int skip;
  final int limit;

  ProductResponse({
    required this.products,
    required this.total,
    required this.skip,
    required this.limit,
  });

  factory ProductResponse.fromJson(Map<String, dynamic> json) => _$ProductResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ProductResponseToJson(this);
}
