import 'package:common/features/language_selection/domain/usecases/app_labels_usecase.dart';
import 'package:core/services/di/injection_container.dart';
import 'data/datasources/select_language_datasource.dart';
import 'data/repositories/select_language_repository_impl.dart';
import 'domain/repositories/select_language_repository.dart';
import 'domain/usecases/select_language_usecase.dart';
import 'presentation/cubit/select_language_cubit.dart';

Future<void> initSelectLanguagesDI() async {
  di.registerFactory(() => SelectLanguageDataSource(dioClient: di()));
  di.registerFactory<SelectLanguagesRepository>(
          () => SelectLanguageRepositoryImpl(datasource: di()),);
  di.registerFactory(() => SelectLanguageUseCase(repository: di()));
  di.registerFactory(() => AppLabelsUseCase(repository: di()));
  di.registerFactory(() =>
      SelectLanguageCubit(appLanguagesUseCase: di(), appLabelsUseCase: di()),);
}
