import 'package:core/services/di/injection_container.dart';
import 'package:lead_generation/presentation/cubit/lead_generation_cubit.dart';
import 'data/datasource/lead_generation_datasource.dart';
import 'data/repositories/lead_generation_repository_impl.dart';
import 'domain/repositories/lead_generation_repository.dart';
import 'domain/usecases/lead_generation_usecase.dart';

Future<void> initLeadGenerationDi() async {
  di.registerFactory(() => LeadGenerationDatasource(dioClient: di()));
  di.registerFactory<LeadGenerationRepository>(
      () => LeadGenerationRepositoryImpl(datasource: di()));
  di.registerFactory(
      () => LeadGenerationUseCase(leadGenerationRepository: di()));
  di.registerFactory(() => LeadGenerationCubit(leadGenerationUseCase: di()));
}
