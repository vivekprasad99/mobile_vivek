import 'package:core/services/di/injection_container.dart';
import 'package:noc/data/datasource/noc_datasource.dart';
import 'package:noc/data/repositories/noc_repository_impl.dart';
import 'package:noc/domain/repositories/noc_repository.dart';
import 'package:noc/domain/usecases/noc_usecase.dart';
import 'package:noc/presentation/cubit/noc_cubit.dart';

Future<void> initNocDI() async {
  di.registerFactory(() => NocDatasource(dioClient: di()));
  di.registerFactory<NocRepository>(() => NocRepositoryImpl(datasource: di()));
  di.registerFactory(() => NocUsecase(nocRepository: di()));
  di.registerFactory(() => NocCubit(nocUsecase: di()));
}
