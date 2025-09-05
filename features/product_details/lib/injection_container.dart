import 'package:product_details/data/datasource/product_detail_datasource.dart';
import 'package:product_details/data/repositories/product_details_repository_impl.dart';
import 'package:product_details/domain/reposittories/product_detail_repository.dart';
import 'package:product_details/domain/usecases/product_detail_usecases.dart';
import 'package:product_details/presentation/cubit/product_details_cubit.dart';
import 'package:core/services/di/injection_container.dart';

Future<void> initProductDetailDI() async {
  di.registerFactory(() => ProductDetailsDatasource(dioClient: di()));
  di.registerFactory<ProductDetailsRepository>(
      () => ProductDetailsRepositoryImpl(datasource: di()));
  di.registerFactory(
      () => ProductDetailsUseCase(productDetailsRepository: di()));

  di.registerFactory(() => ProductDetailsCubit(
      usecase: di(), foreclosureUseCase: di(), productFeatureUseCase: di()));
}
