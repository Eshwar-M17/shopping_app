import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:shopping_app/features/catalogue/data/models/product_model.dart';

part 'product_api_client.g.dart';

@RestApi(baseUrl: "https://dummyjson.com")
abstract class ProductApiClient {
  factory ProductApiClient(Dio dio, {String baseUrl}) = _ProductApiClient;

  @GET("/products")
  Future<ProductResponse> getProducts({
    @Query("skip") required int skip,
    @Query("limit") required int limit,
  });

  @GET("/products/{id}")
  Future<ProductModel> getProductById(@Path("id") int id);
}
