import 'package:common/features/startup/data/datasources/startup_datasource.dart';
import 'package:common/features/startup/data/models/applaunch_config_response.dart';
import 'package:common/features/startup/data/models/token_response.dart';
import 'package:common/features/startup/data/models/validate_device_request.dart';
import 'package:common/features/startup/data/models/validate_device_response.dart';
import 'package:common/features/startup/domain/repositories/start_up_repository.dart';
import 'package:core/config/error/failure.dart';
import 'package:dartz/dartz.dart';


class StartUpRepositoryImpl implements StartUpRepository {
  StartUpRepositoryImpl({required this.datasource});
  final StartUpDataSource datasource;

  @override
  Future<Either<Failure, ValidateDeviceResponse>> validateDevice(ValidateDeviceRequest validateDeviceRequest) async{
    final result = await datasource.validateDevice(validateDeviceRequest);
    return result.fold((left) => Left(left), (right) => Right(right));
  }

  @override
  Future<Either<Failure, AppLaunchConfigResponse>> getAppLaunchConfig() async{
    final result = await datasource.getAppLaunchConfig();
    return result.fold((left) => Left(left), (right) => Right(right));
  }

  @override
  Future<Either<Failure, TokenResponse>> getPreLoginToken() async{
    final result = await datasource.getPreLoginToken();
    return result.fold((left) => Left(left), (right) => Right(right));
  }
}
