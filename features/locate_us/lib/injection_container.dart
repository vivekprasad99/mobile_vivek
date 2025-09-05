import 'package:core/services/di/injection_container.dart';

import 'data/datasource/locate_us_datasource.dart';
import 'data/repositories/locate_us_repository_impl.dart';
import 'domain/repositories/locate_us_repository.dart';
import 'domain/usecase/locate_us_usecase.dart';
import 'presentation/cubit/locate_us_cubit.dart';

Future<void> initLocateUsDi() async {
  di.registerFactory(() => LocateUsDataSource(dioClient: di()));
  di.registerFactory<LocateUsRepository>(
    () => LocateUsRepositoryImpl(datasource: di()),
  );
  di.registerFactory(() => LocateUsUseCase(locateUsRepository: di()));
  di.registerFactory(() => LocateUsCubit(locateUsUsecase: di()));
}
