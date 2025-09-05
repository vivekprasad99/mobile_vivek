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
import 'package:auth/features/login_and_registration/data/models/validate_device_by_ucic_req.dart';
import 'package:auth/features/login_and_registration/data/models/validate_device_by_ucic_res.dart';
import 'package:core/config/error/failure.dart';
import 'package:dartz/dartz.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_datasource.dart';
import '../models/get_theme_request.dart';
import '../models/get_theme_response.dart';

class AuthRepositoryImpl extends AuthRepository {
  AuthRepositoryImpl({required this.datasource});
  final AuthDatasource datasource;

  @override
  Future<Either<Failure, RegisterUserResponse>> registerUser(
      RegisterUserRequest registerUserRequest) async {
    final result = await datasource.registerUser(registerUserRequest);
    return result.fold((left) => Left(left), (right) => Right(right));
  }

  @override
  Future<Either<Failure, MPinResponse>> createMPin(
      MPinRequest mPinRequest) async {
    final result = await datasource.createMPin(mPinRequest);
    return result.fold((left) => Left(left), (right) => Right(right));
  }

  @override
  Future<Either<Failure, AuthenticationResponse>> authenticate(
      AuthenticateSingleUcicRequest authenticationRequest) async {
    final result = await datasource.authenticate(authenticationRequest);
    return result.fold((left) => Left(left), (right) => Right(right));
  }

  @override
  Future<Either<Failure, LoginResponse>> login(LoginRequest loginParams) async {
    final result = await datasource.login(loginParams);
    return result.fold((left) => Left(left), (right) => Right(right));
  }

  @override
  Future<Either<Failure, AuthenticateMultiUcicResponse>> authenticateUCIC(
      AuthenticateMultiUcicRequest authenticateUCICRequest) async {
    final result = await datasource.authenticateUCIC(authenticateUCICRequest);
    return result.fold((left) => Left(left), (right) => Right(right));
  }

  @override
  Future<Either<Failure, PostLoginTokenResponse>> getPostLoginToken(
      String mobileNumber, String mPin) async {
    final result = await datasource.getPostLoginToken(mobileNumber, mPin);
    return result.fold((left) => Left(left), (right) => Right(right));
  }

  @override
  Future<Either<Failure, GetThemeResponse>> getUserTheme(
      GetThemeRequest getThemeRequest) async {
    final result = await datasource.getUserTheme(getThemeRequest);
    return result.fold((left) => Left(left), (right) => Right(right));
  }

  @override
  Future<Either<Failure, ValidateDeviceByUcicRes>> validateDeviceByUcic(
      ValidateDeviceByUcicReq validateDeviceByUcicReq) async {
    final result =
        await datasource.validateDeviceWithUcic(validateDeviceByUcicReq);
    return result.fold((left) => Left(left), (right) => Right(right));
  }

  @override
  Future<Either<Failure, DeleteProfileResp>> deleteProfile(
      DeleteProfileReq req) async {
    final result = await datasource.deleteProfile(req);
    return result.fold((left) => Left(left), (right) => Right(right));
  }
}
