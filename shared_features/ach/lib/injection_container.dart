import 'package:core/services/di/injection_container.dart';
import 'data/datasource/ach_datasource.dart';
import 'data/repositories/ach_repository_impl.dart';
import 'domain/repositories/ach_repository.dart';
import 'domain/usecases/ach_usecase.dart';
import 'presentation/cubit/ach_cubit.dart';

Future<void> initAchDI() async {
  di.registerFactory(() => AchDatasource(dioClient: di(),dioClientUnc: di()));
  di.registerFactory<AchRepository>(() => AchRepositoryImpl(datasource: di()));
  di.registerFactory(() => AchUsecase(achRepository: di()));
  di.registerFactory(() => AchCubit(usecase: di()));
}
