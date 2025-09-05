import 'package:auth/features/login_and_registration/data/models/authentication_request.dart';
import 'package:auth/features/login_and_registration/data/models/authentication_response.dart';
import 'package:auth/features/login_and_registration/data/models/authentication_ucic_request.dart';
import 'package:auth/features/login_and_registration/data/models/authentication_ucic_response.dart';
import 'package:auth/features/login_and_registration/data/models/validate_device_by_ucic_req.dart';
import 'package:auth/features/login_and_registration/domain/repositories/auth_repository.dart';
import 'package:core/config/error/failure.dart';
import 'package:core/config/usecase/usecase.dart';
import 'package:dartz/dartz.dart';

import '../../data/models/validate_device_by_ucic_res.dart';

class SecondFactorAuthUseCase
    extends UseCase<AuthenticationResponse, AuthenticateSingleUcicRequest> {
  final AuthRepository authRepository;
  SecondFactorAuthUseCase({required this.authRepository});

  @override
  Future<Either<Failure, AuthenticationResponse>> call(
      AuthenticateSingleUcicRequest params) async {
    return await authRepository.authenticate(params);
  }

  // @override
  Future<Either<Failure, AuthenticateMultiUcicResponse>> authenticateUCIC(
      AuthenticateMultiUcicRequest params) async {
    return await authRepository.authenticateUCIC(params);
  }

  Future<Either<Failure, ValidateDeviceByUcicRes>> validateDeviceByUcic(
      ValidateDeviceByUcicReq params) async {
    return await authRepository.validateDeviceByUcic(params);
  }
}
