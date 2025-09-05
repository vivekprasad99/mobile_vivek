import 'package:auth/features/login_and_registration/data/models/authentication_request.dart';
import 'package:auth/features/login_and_registration/data/models/authentication_response.dart';
import 'package:auth/features/login_and_registration/data/models/authentication_ucic_request.dart';
import 'package:auth/features/login_and_registration/data/models/authentication_ucic_response.dart';
import 'package:auth/features/login_and_registration/data/models/delete_profile_req.dart';
import 'package:auth/features/login_and_registration/data/models/delete_profile_resp.dart';
import 'package:auth/features/login_and_registration/data/models/login_request.dart';
import 'package:auth/features/login_and_registration/data/models/login_response.dart';
import 'package:auth/features/login_and_registration/data/models/mpin_request.dart';
import 'package:auth/features/login_and_registration/data/models/mpin_response.dart';
import 'package:auth/features/login_and_registration/data/models/postlogin_token_response.dart';
import 'package:auth/features/login_and_registration/data/models/register_user_request.dart';
import 'package:auth/features/login_and_registration/data/models/register_user_response.dart';
import 'package:core/config/error/failure.dart';
import 'package:dartz/dartz.dart';

import '../../data/models/get_theme_request.dart';
import '../../data/models/get_theme_response.dart';
import '../../data/models/validate_device_by_ucic_req.dart';
import '../../data/models/validate_device_by_ucic_res.dart';

abstract class AuthRepository {
  Future<Either<Failure, LoginResponse>> login(LoginRequest loginParams);

  Future<Either<Failure, RegisterUserResponse>> registerUser(
      RegisterUserRequest registerUserRequest);

  Future<Either<Failure, AuthenticationResponse>> authenticate(
      AuthenticateSingleUcicRequest authenticationRequest);

  Future<Either<Failure, AuthenticateMultiUcicResponse>> authenticateUCIC(
      AuthenticateMultiUcicRequest authenticateUCICRequest);

  Future<Either<Failure, ValidateDeviceByUcicRes>> validateDeviceByUcic(
      ValidateDeviceByUcicReq validateDeviceByUcicReq);

  Future<Either<Failure, MPinResponse>> createMPin(MPinRequest mPinRequest);

  Future<Either<Failure, PostLoginTokenResponse>> getPostLoginToken(
      String mobileNumber, String mPin);

  Future<Either<Failure, GetThemeResponse>> getUserTheme(
      GetThemeRequest getThemeRequest);
  Future<Either<Failure, DeleteProfileResp>> deleteProfile(
      DeleteProfileReq req);
}
