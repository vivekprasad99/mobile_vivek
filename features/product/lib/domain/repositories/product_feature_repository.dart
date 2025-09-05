import 'package:core/config/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:product/data/models/product_feature_detail_request.dart';
import 'package:product/data/models/product_feature_request.dart';
import 'package:product/data/models/product_feature_response.dart';

abstract class ProductFeatureRepository {
  Future<Either<Failure, ProductFeatureResponse>> getProductFeature(
      ProductFeatureRequest productParams);

  Future<Either<Failure, ProductFeatureResponse>> getProductFeatureDetail(
      ProductFeatureDetailRequest productParams);
}
