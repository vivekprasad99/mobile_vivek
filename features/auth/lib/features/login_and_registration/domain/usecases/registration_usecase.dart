import 'package:auth/features/login_and_registration/data/models/mpin_request.dart';
import 'package:auth/features/login_and_registration/data/models/mpin_response.dart';
import 'package:auth/features/login_and_registration/data/models/register_user_request.dart';
import 'package:auth/features/login_and_registration/data/models/register_user_response.dart';
import 'package:core/config/error/failure.dart';
import 'package:core/config/usecase/usecase.dart';
import 'package:dartz/dartz.dart';

import '../repositories/auth_repository.dart';

class RegistrationUseCase
    extends UseCase<RegisterUserResponse, RegisterUserRequest> {
  final AuthRepository authRepository;
  RegistrationUseCase({required this.authRepository});

  @override
  Future<Either<Failure, RegisterUserResponse>> call(
      RegisterUserRequest params) async {
    return await authRepository.registerUser(params);
  }

  // @override
  Future<Either<Failure, MPinResponse>> createMPin(MPinRequest params) async {
    return await authRepository.createMPin(params);
  }
}
