import 'package:appstatus/feature/data/datasources/application_status_datasource.dart';
import 'package:appstatus/feature/data/repositories/application_status_repository_impl.dart';
import 'package:appstatus/feature/domain/repositories/application_status_repository.dart';
import 'package:appstatus/feature/domain/usecases/application_status_usecase.dart';
import 'package:appstatus/feature/presentation/cubit/application_status_cubit.dart';
import 'package:core/services/di/injection_container.dart';


Future<void> initApplicationStatusDi() async {
  di.registerFactory(() => ApplicationStatusDataSource(dioClient: di()));
  di.registerFactory<ApplicationStatusRepository>(
      () => ApplicationStatusRepositoryImpl(datasource: di()));
  di.registerFactory(() => ApplicationStatusUseCase(applicationStatusRepository: di()));
  di.registerFactory(() => ApplicationStatusCubit(applicationStatusUseCase: di()));
}
