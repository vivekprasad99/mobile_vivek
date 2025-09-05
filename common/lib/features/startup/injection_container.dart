import 'package:common/features/startup/data/datasources/startup_datasource.dart';
import 'package:common/features/startup/data/repositories/startup_repository_impl.dart';
import 'package:common/features/startup/domain/usecases/validate_device_usecase.dart';
import 'package:common/features/startup/presentation/cubit/validate_device_cubit.dart';
import 'package:core/features/presentation/bloc/theme/theme_bloc.dart';
import 'package:core/services/di/injection_container.dart';
import 'domain/repositories/start_up_repository.dart';
import 'presentation/cubit/app_launch_cubit.dart';

Future<void> initMainAppDI() async {
  di.registerSingleton<AppLaunchCubit>(AppLaunchCubit(
    connectivityManager: di(),
    deviceManager: di(),
  ),);
  di.registerSingleton<ThemeBloc>(ThemeBloc());
  di.registerFactory(() => StartUpDataSource(dioClient: di()));
  di.registerFactory<StartUpRepository>(
          () => StartUpRepositoryImpl(datasource: di()),);
  di.registerFactory(() => ValidateDeviceUseCase(repository: di()));
  di.registerFactory(() => ValidateDeviceCubit(validateDeviceUseCase: di()));

}
