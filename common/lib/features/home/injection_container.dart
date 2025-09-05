import 'package:common/features/home/data/datasources/home_datasource.dart';
import 'package:common/features/home/data/repositories/home_repository_impl.dart';
import 'package:common/features/home/domain/repositories/home_repository.dart';
import 'package:common/features/home/domain/usecases/landing_page_usecase.dart';
import 'package:common/features/home/domain/usecases/update_theme_usecase.dart';
import 'package:common/features/home/presentation/cubit/home_cubit.dart';
import 'package:common/features/home/presentation/cubit/landing_page_cubit.dart';
import 'package:core/services/di/injection_container.dart';

Future<void> initHomeDI() async {
  di.registerFactory(() => HomeDataSource(dioClient: di()));
  di.registerFactory<HomeRepository>(
      () => HomeRepositoryImpl(datasource: di()),);
  di.registerFactory(() => UpdateThemeUseCase(repository: di()));
  di.registerFactory(() => LandingPageUsecase(repository: di()));
  di.registerFactory(() => HomeCubit(updateThemeUseCase: di()));
  di.registerFactory(() => LandingPageCubit(landingPageUsecase: di()));
}
