import 'package:auth/features/login_and_registration/domain/usecases/get_theme_usecase.dart';
import 'package:auth/features/login_and_registration/presentation/cubit/biometric_cubit.dart';
import 'package:auth/features/login_and_registration/domain/usecases/second_factor_auth_usecase.dart';
import 'package:core/services/di/injection_container.dart';

import 'data/datasources/auth_datasource.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'domain/repositories/auth_repository.dart';
import 'domain/usecases/login_usecase.dart';
import 'domain/usecases/registration_usecase.dart';
import 'presentation/cubit/auth_cubit.dart';
import 'presentation/cubit/auth_result_cubit.dart';

Future<void> initAuthDI() async {
  di.registerFactory(() => AuthDatasource(dioClient: di()));
  di.registerFactory<AuthRepository>(
      () => AuthRepositoryImpl(datasource: di()));
  di.registerFactory(() => LoginUseCase(authRepository: di()));
  di.registerFactory(() => RegistrationUseCase(authRepository: di()));
  di.registerFactory(() => SecondFactorAuthUseCase(authRepository: di()));
  di.registerFactory(() => GetThemeUseCase(repository: di()));
  di.registerFactory(() => BiometricCubit());
  di.registerFactory(() => AuthCubit(
      loginUsecase: di(),
      registerUsecase: di(),
      secondFactorAuthUseCase: di(), getThemeUseCase: di()));
  di.registerSingleton<AuthResultCubit>(AuthResultCubit(AuthResultState.init));
}
