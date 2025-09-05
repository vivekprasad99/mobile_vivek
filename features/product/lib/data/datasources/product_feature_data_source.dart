import 'package:core/config/error/failure.dart';
import 'package:core/config/network/dio_client.dart';
import 'package:core/config/network/network_utils.dart';
import 'package:dartz/dartz.dart';
import 'package:product/config/network/api_endpoints.dart';
import 'package:product/data/models/product_feature_detail_request.dart';
import 'package:product/data/models/product_feature_request.dart';
import 'package:product/data/models/product_feature_response.dart';

class ProductFeatureDatasource {
  DioClient dioClient;
  ProductFeatureDatasource({required this.dioClient});
  Future<Either<Failure, ProductFeatureResponse>> getProductFeature(
      ProductFeatureRequest loginRequest) async {
      final response = await dioClient.getRequest(
        getCMSApiUrl(ApiEndpoints.products),
        converter: (response) => ProductFeatureResponse.fromJson(
            response['data'] as Map<String, dynamic>),
      );
      return response;
    }

  Future<Either<Failure, ProductFeatureResponse>> getProductFeatureDetail(
      ProductFeatureDetailRequest request) async {
      final response = await dioClient.getRequest(
        getCMSApiUrl(ApiEndpoints.productsFeatureDetail),
        converter: (response) => ProductFeatureResponse.fromJson(
            response['data'] as Map<String, dynamic>),
        queryParameters: request.toJson()
      );
      return response;
    }
}
