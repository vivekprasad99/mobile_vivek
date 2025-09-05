import 'package:auth/features/login_and_registration/data/models/delete_profile_req.dart';
import 'package:auth/features/login_and_registration/data/models/delete_profile_resp.dart';
import 'package:auth/features/login_and_registration/data/models/login_request.dart';
import 'package:auth/features/login_and_registration/data/models/login_response.dart';
import 'package:auth/features/login_and_registration/data/models/postlogin_token_response.dart';
import 'package:core/config/error/failure.dart';
import 'package:core/config/usecase/usecase.dart';
import 'package:dartz/dartz.dart';

import '../repositories/auth_repository.dart';

class LoginUseCase extends UseCase<LoginResponse, LoginRequest> {
  final AuthRepository authRepository;
  LoginUseCase({required this.authRepository});

  @override
  Future<Either<Failure, LoginResponse>> call(LoginRequest params) async {
    return await authRepository.login(params);
  }

  Future<Either<Failure, PostLoginTokenResponse>> getPostLoginToken(
      String mobileNumber, String mPin) async {
    return await authRepository.getPostLoginToken(mobileNumber, mPin);
  }

  Future<Either<Failure, DeleteProfileResp>> deleteProfile(
      DeleteProfileReq req) async {
    return await authRepository.deleteProfile(req);
  }
}
