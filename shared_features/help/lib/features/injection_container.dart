
import 'package:core/services/di/injection_container.dart';
import 'package:help/features/data/datasource/help_datasource.dart';
import 'package:help/features/data/repositories/help_repository_impl.dart';
import 'package:help/features/domain/respositories/help_repository.dart';
import 'package:help/features/presentation/cubit/help_cubit.dart';
import 'domain/usecases/help_usecases.dart';

Future<void> initHelpDI() async {
  di.registerFactory(() => HelpDataSource(dioClient: di()));
  di.registerFactory<HelpRepository>(
          () => HelpRepositoryImpl(datasource: di()));
  di.registerFactory(() => HelpUseCase(repository: di()));
  di.registerFactory(() => HelpCubit(helpUseCase: di()));
}
