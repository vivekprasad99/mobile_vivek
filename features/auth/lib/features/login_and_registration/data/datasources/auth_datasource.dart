import 'dart:convert';

import 'package:auth/config/network/api_endpoints.dart';
import 'package:auth/features/login_and_registration/data/models/authentication_request.dart';
import 'package:auth/features/login_and_registration/data/models/authentication_response.dart';
import 'package:auth/features/login_and_registration/data/models/authentication_ucic_request.dart';
import 'package:auth/features/login_and_registration/data/models/authentication_ucic_response.dart';
import 'package:auth/features/login_and_registration/data/models/delete_profile_req.dart';
import 'package:auth/features/login_and_registration/data/models/delete_profile_resp.dart';
import 'package:auth/features/login_and_registration/data/models/login_request.dart';
import 'package:auth/features/login_and_registration/data/models/mpin_request.dart';
import 'package:auth/features/login_and_registration/data/models/mpin_response.dart';
import 'package:auth/features/login_and_registration/data/models/postlogin_token_response.dart';
import 'package:auth/features/login_and_registration/data/models/register_user_request.dart';
import 'package:auth/features/login_and_registration/data/models/validate_device_by_ucic_req.dart';
import 'package:core/config/error/failure.dart';
import 'package:core/config/flavor/app_config.dart';
import 'package:core/config/flavor/feature_flag/feature_flag.dart';
import 'package:core/config/flavor/feature_flag/feature_flag_keys.dart';
import 'package:core/config/network/dio_client.dart';
import 'package:core/config/network/network_utils.dart';
import 'package:core/utils/pref_utils.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';

import '../models/get_theme_request.dart';
import '../models/get_theme_response.dart';
import '../models/login_response.dart';
import '../models/register_user_response.dart';
import '../models/validate_device_by_ucic_res.dart';

class AuthDatasource {
  DioClient dioClient;
  AuthDatasource({required this.dioClient});

  Future<Either<Failure, LoginResponse>> login(
      LoginRequest loginRequest) async {
    if (isFeatureEnabled(featureName: featureEnableStubData)) {
            final loginStubData =
          await rootBundle.loadString('assets/stubdata/login_response.json');
      final body = json.decode(loginStubData);
      Either<Failure, LoginResponse> response =
          Right(LoginResponse.fromJson(body as Map<String, dynamic>));
      return response;
    } else {
      final response = await dioClient.postRequest(
          getMsApiUrl(ApiEndpoints.login),
          converter: (response) =>
              LoginResponse.fromJson(response as Map<String, dynamic>),
          data: loginRequest.toJson());
      return response;
    }
  }

  Future<Either<Failure, RegisterUserResponse>> registerUser(
      RegisterUserRequest registerRequest) async {
    if (isFeatureEnabled(featureName: featureEnableStubData)) {
            final authStubData =
          await rootBundle.loadString('assets/stubdata/register_user.json');
      final body = json.decode(authStubData);
      Either<Failure, RegisterUserResponse> response =
          Right(RegisterUserResponse.fromJson(body as Map<String, dynamic>));
      return response;
    } else {
      final response = await dioClient.postRequest(
          getMsApiUrl(ApiEndpoints.registerUser),
          converter: (response) =>
              RegisterUserResponse.fromJson(response as Map<String, dynamic>),
          data: registerRequest.toJson());
      return response;
    }
  }

  Future<Either<Failure, AuthenticationResponse>> authenticate(
      AuthenticateSingleUcicRequest authenticationRequest) async {
    if (isFeatureEnabled(featureName: featureEnableStubData)) {
            final authStubData =
          await rootBundle.loadString('assets/stubdata/autheticate.json');
      final body = json.decode(authStubData);
      Either<Failure, AuthenticationResponse> response =
          Right(AuthenticationResponse.fromJson(body as Map<String, dynamic>));
      return response;
    } else {
      final response = await dioClient.postRequest(
          getMsApiUrl(ApiEndpoints.authenticate),
          converter: (response) =>
              AuthenticationResponse.fromJson(response as Map<String, dynamic>),
          data: authenticationRequest.toJson());
      return response;
    }
  }

  Future<Either<Failure, AuthenticateMultiUcicResponse>> authenticateUCIC(
      AuthenticateMultiUcicRequest authenticateUCICRequest) async {
    if (isFeatureEnabled(featureName: featureEnableStubData)) {
            final authStubData =
          await rootBundle.loadString('assets/stubdata/autheticate_ucic.json');
      final body = json.decode(authStubData);
      Either<Failure, AuthenticateMultiUcicResponse> response = Right(
          AuthenticateMultiUcicResponse.fromJson(body as Map<String, dynamic>));
      return response;
    } else {
      final response = await dioClient.postRequest(
          getMsApiUrl(ApiEndpoints.authenticate),
          converter: (response) => AuthenticateMultiUcicResponse.fromJson(
              response as Map<String, dynamic>),
          data: authenticateUCICRequest.toJson());
      return response;
    }
  }

  Future<Either<Failure, ValidateDeviceByUcicRes>> validateDeviceWithUcic(
      ValidateDeviceByUcicReq validateDeviceByUcicReq) async {
    if (isFeatureEnabled(featureName: featureEnableStubData)) {
            final authStubData = await rootBundle
          .loadString('assets/stubdata/validate_device_with_ucic.json');
      final body = json.decode(authStubData);
      Either<Failure, ValidateDeviceByUcicRes> response =
          Right(ValidateDeviceByUcicRes.fromJson(body as Map<String, dynamic>));
      return response;
    } else {
      final response = await dioClient.postRequest(
          getMsApiUrl(ApiEndpoints.validateDeviceWithUcic),
          converter: (response) => ValidateDeviceByUcicRes.fromJson(
              response as Map<String, dynamic>),
          data: validateDeviceByUcicReq.toJson());
      return response;
    }
  }

  Future<Either<Failure, MPinResponse>> createMPin(
      MPinRequest mPinRequest) async {
    if (isFeatureEnabled(featureName: featureEnableStubData)) {
            final authStubData =
          await rootBundle.loadString('assets/stubdata/create_mpin.json');

      final body = json.decode(authStubData);
      Either<Failure, MPinResponse> response =
          Right(MPinResponse.fromJson(body as Map<String, dynamic>));
      return response;
    } else {
      final response = await dioClient.postRequest(
          getMsApiUrl(ApiEndpoints.createMpin),
          converter: (response) =>
              MPinResponse.fromJson(response as Map<String, dynamic>),
          data: mPinRequest.toJson());
      return response;
    }
  }

  Future<Either<Failure, PostLoginTokenResponse>> getPostLoginToken(
      String mobileNumber, String mPin) async {
    String username = AppConfig.shared.postLoginTokenUserName;
    String password = AppConfig.shared.postLoginTokenPassword;
    String basicAuth =
        'Basic ${base64.encode(utf8.encode('$username:$password'))}';
    var headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': basicAuth,
    };
    var data = {
      'grant_type': 'password',
      'username': mobileNumber,
      'password': mPin,
    };
    PrefUtils.removeData(PrefUtils.keyToken);
    final response = await dioClient.postRequest(
        getPostTokenUrl(ApiEndpoints.postLoginToken),
        converter: (response) =>
            PostLoginTokenResponse.fromJson(response as Map<String, dynamic>),
        header: headers,
        data: data);
    return response;
  }

  Future<Either<Failure, GetThemeResponse>> getUserTheme(
      GetThemeRequest getThemeRequest) async {
    if (isFeatureEnabled(featureName: featureEnableStubData)) {
      final langStubData =
          await rootBundle.loadString('assets/stubdata/language.json');
      final body = json.decode(langStubData);
      Either<Failure, GetThemeResponse> response =
          Right(GetThemeResponse.fromJson(body as Map<String, dynamic>));
      return response;
    } else {
      final response = await dioClient.postRequest(
          getMsApiUrl(ApiEndpoints.getThemeDetail),
          converter: (response) =>
              GetThemeResponse.fromJson(response as Map<String, dynamic>),
          data: getThemeRequest.toJson());
      return response;
    }
  }

  Future<Either<Failure, DeleteProfileResp>> deleteProfile(
      DeleteProfileReq req) async {
    final response = await dioClient.postRequest(
        getMsApiUrl(ApiEndpoints.deleteProfile),
        converter: (response) =>
            DeleteProfileResp.fromJson(response as Map<String, dynamic>),
        data: req.toJson());
    return response;
  }
}
