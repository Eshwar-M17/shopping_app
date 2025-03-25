import 'package:dartz/dartz.dart';
import 'package:shopping_app/core/utils/failure.dart';
import 'package:shopping_app/features/catalogue/domain/entities/product_entity.dart';
import 'package:shopping_app/features/catalogue/domain/repositories/product_repository.dart';

class GetProductByIdUseCase {
  final ProductRepository _repository;

  GetProductByIdUseCase(this._repository);

  Future<Either<Failure, ProductEntity>> call(int id) {
    return _repository.getProductById(id);
  }
}
