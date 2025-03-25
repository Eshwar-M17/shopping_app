import 'package:dartz/dartz.dart';
import 'package:shopping_app/core/utils/failure.dart';
import 'package:shopping_app/features/catalogue/domain/entities/product_entity.dart';

abstract class ProductRepository {
  Future<Either<Failure, List<ProductEntity>>> getProducts({
    required int skip,
    required int limit,
  });

  Future<Either<Failure, ProductEntity>> getProductById(int id);
}
