import 'package:core/config/error/failure.dart';
import 'package:core/config/usecase/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:product/data/models/product_feature_detail_request.dart';
import 'package:product/data/models/product_feature_request.dart';
import 'package:product/data/models/product_feature_response.dart';
import 'package:product/domain/repositories/product_feature_repository.dart';

class ProductFeatureUseCase
    extends UseCase<ProductFeatureResponse, ProductFeatureRequest> {
  final ProductFeatureRepository productFeatureRepository;

  ProductFeatureUseCase({required this.productFeatureRepository});

  @override
  Future<Either<Failure, ProductFeatureResponse>> call(
      ProductFeatureRequest params) async {
    return await productFeatureRepository.getProductFeature(params);
  }

  Future<Either<Failure, ProductFeatureResponse>> productFeatureDetail(
      ProductFeatureDetailRequest params) async {
    return await productFeatureRepository.getProductFeatureDetail(params);
  }
}
