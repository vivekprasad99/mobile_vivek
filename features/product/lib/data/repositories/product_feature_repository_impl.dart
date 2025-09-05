import 'package:core/config/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:product/data/datasources/product_feature_data_source.dart';
import 'package:product/data/models/product_feature_detail_request.dart';
import 'package:product/data/models/product_feature_request.dart';
import 'package:product/data/models/product_feature_response.dart';
import 'package:product/domain/repositories/product_feature_repository.dart';

class ProductFeatureRepositoryImpl extends ProductFeatureRepository {
  ProductFeatureRepositoryImpl({required this.datasource});

  final ProductFeatureDatasource datasource;

  @override
  Future<Either<Failure, ProductFeatureResponse>> getProductFeature(
      ProductFeatureRequest productParams) async {
    final result = await datasource.getProductFeature(productParams);
    return result.fold((left) => Left(left), (right) => Right(right));
  }

  @override
  Future<Either<Failure, ProductFeatureResponse>> getProductFeatureDetail(
      ProductFeatureDetailRequest productParams) async {
    final result = await datasource.getProductFeatureDetail(productParams);
    return result.fold((left) => Left(left), (right) => Right(right));
  }
}
