import 'package:auth/features/mobile_otp/data/datasources/phone_validate_datasource.dart';
import 'package:auth/features/mobile_otp/data/repositories/phone_validate_repository_impl.dart';
import 'package:auth/features/mobile_otp/domain/repositories/phone_validate_repository.dart';
import 'package:auth/features/mobile_otp/domain/usecases/phone_validate_usecase.dart';
import 'package:auth/features/mobile_otp/domain/usecases/validate_otp_usecase.dart';
import 'package:auth/features/mobile_otp/presentation/cubit/phone_validate_cubit.dart';
import 'package:core/services/di/injection_container.dart';

Future<void> initMobileOtpDI() async {
  di.registerFactory(() => PhoneValidateDataSource(dioClient: di()));
  di.registerFactory<PhoneValidateRepository>(
      () => PhoneValidateRepositoryImpl(datasource: di()));
  di.registerFactory(() => PhoneValidateUseCase(repository: di()));
  di.registerFactory(() => ValidateOtpUsecase(repository: di()));
  di.registerFactory(() => PhoneValidateCubit(
      sendOtpUsecase: di(),
      validateOtpUsecase: di()));
}
