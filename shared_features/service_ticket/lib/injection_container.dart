import 'package:core/services/di/injection_container.dart';
import 'package:service_ticket/features/data/datasource/service_request_datasource.dart';
import 'package:service_ticket/features/data/repositories/service_request_repository_impl.dart';
import 'package:service_ticket/features/domain/repositories/service_request_repository.dart';
import 'package:service_ticket/features/domain/usecasses/service_request_usecase.dart';
import 'package:service_ticket/features/presentation/cubit/open_service_request_cubit.dart';
import 'package:service_ticket/features/presentation/cubit/service_request_cubit.dart';

Future<void> initServiceRequestDi() async {
  di.registerFactory(() => ServiceRequestDatasource(dioClient: di(),dioClientUnc: di()));
  di.registerFactory<ServiceRequestRepository>(
      () => ServiceRequestRepositoryImpl(datasource: di()));
  di.registerFactory(
      () => ServiceRequestUseCase(serviceRequestRepository: di()));
  di.registerFactory(() => ServiceRequestCubit(serviceRequestUseCase: di(), productDetailsUseCase: di()));
  di.registerFactory(() => OpenServiceRequestCubit());
}
