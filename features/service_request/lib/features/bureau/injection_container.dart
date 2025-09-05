import 'package:core/services/di/injection_container.dart';
import 'package:service_request/features/bureau/data/repositories/bureau_repository_impl.dart';
import 'package:service_request/features/bureau/presentation/cubit/bureau_cubit.dart';
import 'data/datasource/bureau_datasource.dart';
import 'domain/repositories/bureau_repository.dart';
import 'domain/usecases/bureau_usecases.dart';

Future<void> initBureauDI() async {
  di.registerFactory(() => BureauDataSource(dioClient: di(),dioClientUnc: di()));

  di.registerFactory<BureauRepository>(
      () => BureauRepositoryImpl(datasource: di()));
  di.registerFactory(() => BureauUseCase(repository: di()));
  di.registerFactory(() => BureauCubit(bureauUseCase: di()));

}
