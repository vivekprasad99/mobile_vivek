import 'package:core/services/di/injection_container.dart';

import 'package:loan/features/foreclosure/data/datasource/foreclosure_datasource.dart';
import 'package:loan/features/foreclosure/data/repositories/foreclosure_repository_impl.dart';
import 'package:loan/features/foreclosure/domain/repositories/foreclosure_repository.dart';
import 'package:loan/features/foreclosure/domain/usecases/foreclosure_usecase.dart';
import 'package:loan/features/foreclosure/presentation/cubit/foreclosure_cubit.dart';

Future<void> initForeclosureDI() async {
  di.registerFactory(() => ForeClosureDatasource(dioClient: di()));
  di.registerFactory<ForeclosureRepository>(
      () => ForeclosureRepositoryImpl(datasource: di()));
  di.registerFactory(() => ForeclosureUseCase(foreclosureRepository: di()));
  di.registerFactory(() => ForeclosureCubit(foreclosureUseCase: di()));
}
