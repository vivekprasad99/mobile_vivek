import 'package:common/features/terms_conditions/presentation/cubit/terms_conditions_cubit.dart';
import 'package:core/services/di/injection_container.dart';

import 'data/datasource/terms_conditions_datasource.dart';
import 'data/repositories/terms_conditions_repository_impl.dart';
import 'domain/respositories/terms_conditions_repository.dart';
import 'domain/usecases/terms_conditions_usecases.dart';

Future<void> initTermsConditionsDI() async {
  di.registerFactory(() => TermsConditionsDataSource(dioClient: di()));
  di.registerFactory<TermsConditionsRepository>(
          () => TermsConditionsRepositoryImpl(datasource: di()),);
  di.registerFactory(() => TermsConditionsUseCase(repository: di()));
  di.registerFactory(() => TermsConditionsCubit(termsConditionsUseCase: di()));
}
