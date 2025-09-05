import 'package:common/features/startup/data/models/applaunch_config_response.dart';
import 'package:common/features/startup/data/models/token_response.dart';
import 'package:common/features/startup/data/models/validate_device_request.dart';
import 'package:common/features/startup/data/models/validate_device_response.dart';
import 'package:core/config/error/failure.dart';
import 'package:dartz/dartz.dart';


abstract class StartUpRepository {
  Future<Either<Failure, ValidateDeviceResponse>> validateDevice(ValidateDeviceRequest validateDeviceRequest);
  Future<Either<Failure, AppLaunchConfigResponse>> getAppLaunchConfig();
  Future<Either<Failure, TokenResponse>> getPreLoginToken();
}
