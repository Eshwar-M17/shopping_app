import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shopping_app/core/utils/failure.dart';
import 'package:shopping_app/features/catalogue/data/datasources/product_api_client.dart';
import 'package:shopping_app/features/catalogue/domain/entities/product_entity.dart';
import 'package:shopping_app/features/catalogue/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductApiClient _apiClient;

  ProductRepositoryImpl(this._apiClient);

  @override
  Future<Either<Failure, List<ProductEntity>>> getProducts({
    required int skip,
    required int limit,
  }) async {
    try {
      final response = await _apiClient.getProducts(skip: skip, limit: limit);
      return Right(response.products);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to fetch products'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProductEntity>> getProductById(int id) async {
    try {
      final product = await _apiClient.getProductById(id);
      return Right(product);
    } on DioException catch (e) {
      return Left(
        ServerFailure(e.message ?? 'Failed to fetch product details'),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
