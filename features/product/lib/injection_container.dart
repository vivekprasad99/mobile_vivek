import 'package:core/services/di/injection_container.dart';
import 'package:product/data/datasources/product_feature_data_source.dart';
import 'package:product/data/repositories/product_feature_repository_impl.dart';
import 'package:product/domain/repositories/product_feature_repository.dart';
import 'package:product/domain/usecases/product_feature_usecase.dart';
import 'package:product/presentation/cubit/product_feature_cubit.dart';



Future<void> initPrdouctDI() async {
  di.registerFactory(() => ProductFeatureDatasource(dioClient: di()));
  di.registerFactory<ProductFeatureRepository>(
      () => ProductFeatureRepositoryImpl(datasource: di()));
  di.registerFactory(() => ProductFeatureUseCase(productFeatureRepository: di()));

  di.registerFactory(() => ProductFeatureCubit(
      productFeatureUseCase: di()));
}
