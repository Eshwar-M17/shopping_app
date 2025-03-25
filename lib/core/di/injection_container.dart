import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shopping_app/features/catalogue/data/datasources/product_api_client.dart';
import 'package:shopping_app/features/catalogue/data/repositories/product_repository_impl.dart';
import 'package:shopping_app/features/catalogue/domain/repositories/product_repository.dart';
import 'package:shopping_app/features/catalogue/domain/usecases/get_product_by_id_usecase.dart';
import 'package:shopping_app/features/catalogue/domain/usecases/get_products_usecase.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();
  dio.interceptors.add(
    PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      compact: false,
    ),
  );
  return dio;
});

final productApiClientProvider = Provider<ProductApiClient>((ref) {
  return ProductApiClient(ref.watch(dioProvider));
});

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepositoryImpl(ref.watch(productApiClientProvider));
});

final getProductsUseCaseProvider = Provider<GetProductsUseCase>((ref) {
  return GetProductsUseCase(ref.watch(productRepositoryProvider));
});

final getProductByIdUseCaseProvider = Provider<GetProductByIdUseCase>((ref) {
  return GetProductByIdUseCase(ref.watch(productRepositoryProvider));
});
