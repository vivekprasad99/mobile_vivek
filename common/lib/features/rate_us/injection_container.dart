import 'package:common/features/rate_us/data/datasource/rate_us_datasource.dart';
import 'package:common/features/rate_us/data/repositories/rate_us_repository_impl.dart';
import 'package:common/features/rate_us/domain/repositories/rate_us_repository.dart';
import 'package:common/features/rate_us/domain/usecases/rate_us_usecase.dart';
import 'package:common/features/rate_us/presentation/cubit/rate_us_cubit.dart';
import 'package:core/services/di/injection_container.dart';

Future<void> initRateUsDI() async {
  di.registerFactory(() => RateUsDatasource(dioClient: di()));
  di.registerFactory<RateUsRepository>(() => RateUsRepositoryImpl(datasource: di()));
  di.registerFactory(() => RateUsUseCase(repository: di()));
  di.registerFactory(() => RateUsCubit(usecase: di()));
}