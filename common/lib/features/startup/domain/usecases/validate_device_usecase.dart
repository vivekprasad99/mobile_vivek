import 'package:common/features/startup/data/models/applaunch_config_response.dart';
import 'package:common/features/startup/data/models/token_response.dart';
import 'package:common/features/startup/domain/repositories/start_up_repository.dart';
import 'package:common/features/startup/data/models/validate_device_request.dart';
import 'package:common/features/startup/data/models/validate_device_response.dart';
import 'package:core/config/error/failure.dart';
import 'package:core/config/usecase/usecase.dart';
import 'package:dartz/dartz.dart';

class ValidateDeviceUseCase extends UseCase<ValidateDeviceResponse, ValidateDeviceRequest> {
  final StartUpRepository repository;

  ValidateDeviceUseCase({required this.repository});

  @override
  Future<Either<Failure, ValidateDeviceResponse>> call(ValidateDeviceRequest params) async{
    return await repository.validateDevice(params);
  }

  Future<Either<Failure, AppLaunchConfigResponse>> getAppLaunchConfig() async{
    return await repository.getAppLaunchConfig();
  }

  Future<Either<Failure, TokenResponse>> getPreLoginToken() async{
    return await repository.getPreLoginToken();
  }
}
