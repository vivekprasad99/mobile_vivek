import 'dart:convert';

import 'package:auth/config/network/api_endpoints.dart';
import 'package:auth/features/mobile_otp/data/models/reg_status_request.dart';
import 'package:auth/features/mobile_otp/data/models/reg_status_response.dart';
import 'package:auth/features/mobile_otp/data/models/save_device_request.dart';
import 'package:auth/features/mobile_otp/data/models/save_device_response.dart';
import 'package:auth/features/mobile_otp/data/models/send_otp_request.dart';
import 'package:auth/features/mobile_otp/data/models/send_otp_response.dart';
import 'package:auth/features/mobile_otp/data/models/validate_multiple_device_request.dart';
import 'package:auth/features/mobile_otp/data/models/validate_multiple_device_response.dart';
import 'package:auth/features/mobile_otp/data/models/validate_otp_request.dart';
import 'package:auth/features/mobile_otp/data/models/validate_otp_response.dart';
import 'package:core/config/error/failure.dart';
import 'package:core/config/flavor/feature_flag/feature_flag.dart';
import 'package:core/config/flavor/feature_flag/feature_flag_keys.dart';
import 'package:core/config/network/dio_client.dart';
import 'package:core/config/network/network_utils.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';

import '../models/send_email_otp_request.dart';
import '../models/send_email_otp_response.dart';
import '../models/validate_aadhaar_otp_req.dart';
import '../models/validate_aadhaar_otp_res.dart';
import '../models/validate_email_otp_request.dart';
import '../models/validate_email_otp_response.dart';

class PhoneValidateDataSource {
  DioClient dioClient;
  PhoneValidateDataSource({required this.dioClient});

  Future<Either<Failure, SendOtpResponse>> sendOtp(
      SendOtpRequest sendOtpRequest) async {

    if (isFeatureEnabled(featureName: featureEnableStubData)) {
            final langStubResponse = await rootBundle.loadString(
          'assets/stubdata/send_otp.json');
      final body = json.decode(langStubResponse);
      Either<Failure, SendOtpResponse> response =
      Right(SendOtpResponse.fromJson(body as Map<String, dynamic>));
      return response;
    } else {
      final response = await dioClient.postRequest(getMsApiUrl(ApiEndpoints.sendOtp),
          converter: (response) => SendOtpResponse.fromJson(response as Map<String, dynamic>),data: sendOtpRequest.toJson());
      return response;
    }

  }

  Future<Either<Failure, ValidateOtpResponse>> validateOtp(
      ValidateOtpRequest validateOtpRequest) async {
    if (isFeatureEnabled(featureName: featureEnableStubData)) {
            final otpStubResponse = await rootBundle.loadString(
          'assets/stubdata/validate_otp.json');
      final body = json.decode(otpStubResponse);
      Either<Failure, ValidateOtpResponse> response =
      Right(ValidateOtpResponse.fromJson(body as Map<String, dynamic>));
      return response;
    } else {
      final response = await dioClient.postRequest(getMsApiUrl(ApiEndpoints.validateOtp),
          converter: (response) => ValidateOtpResponse.fromJson(response as Map<String, dynamic>),data: validateOtpRequest.toJson());
      return response;
    }

  }

  Future<Either<Failure, RegisterStatusResponse>> getCustRegStatus(
      RegisterStatusRequest registerStatusRequest) async {
    if (isFeatureEnabled(featureName: featureEnableStubData)) {
            final stubResponse = await rootBundle.loadString(
          'assets/stubdata/registration_status.json');
      final body = json.decode(stubResponse);
      Either<Failure, RegisterStatusResponse> response =
      Right(RegisterStatusResponse.fromJson(body as Map<String, dynamic>));
      return response;
    } else {
      final response = await dioClient.postRequest(getMsApiUrl(ApiEndpoints.getCustRegStatus),
          converter: (response) => RegisterStatusResponse.fromJson(response as Map<String, dynamic>),data: registerStatusRequest.toJson());
      return response;
    }
  }

  Future<Either<Failure, ValidateMultipleDeviceResponse>> validateMultipleDevice(ValidateMultiPleDeviceRequest validateMultiPleDeviceRequest) async {
    if (isFeatureEnabled(featureName: featureEnableStubData)) {
            final authStubData = await rootBundle.loadString(
          'assets/stubdata/validate_multiple_device.json');
      final body = json.decode(authStubData);
      Either<Failure, ValidateMultipleDeviceResponse> response =
      Right(ValidateMultipleDeviceResponse.fromJson(
          body as Map<String, dynamic>));
      return response;
    } else {
      final response = await dioClient.postRequest(getMsApiUrl(ApiEndpoints.validateMultipleDevice),
          converter: (response) =>
              ValidateMultipleDeviceResponse.fromJson(response as Map<String, dynamic>),data: validateMultiPleDeviceRequest.toJson());
      return response;
    }
  }

  Future<Either<Failure, SaveDeviceResponse>> saveDevice(SaveDeviceRequest saveDeviceRequest) async {
    if (isFeatureEnabled(featureName: featureEnableStubData)) {
            final authStubData = await rootBundle.loadString(
          'assets/stubdata/save_device.json');
      final body = json.decode(authStubData);
      Either<Failure, SaveDeviceResponse> response =
      Right(SaveDeviceResponse.fromJson(body as Map<String, dynamic>));
      return response;
    } else {
      final response = await dioClient.postRequest(getMsApiUrl(ApiEndpoints.saveDevice),
          converter: (response) =>
              SaveDeviceResponse.fromJson(response as Map<String, dynamic>),data: saveDeviceRequest.toJson());
      return response;
    }

  }

  Future<Either<Failure, SendEmailOtpResponse>> sendEmailOtp(
      SendEmailOtpRequest sendOtpRequest) async {
    if (isFeatureEnabled(featureName: featureEnableStubData)) {
            final langStubResponse =
      await rootBundle.loadString('assets/stubdata/profile/send_email_otp.json');
      final body = json.decode(langStubResponse);
      Either<Failure, SendEmailOtpResponse> response =
      Right(SendEmailOtpResponse.fromJson(body as Map<String, dynamic>));
      return response;
    } else {
      final response = await dioClient.postRequest(getMsApiUrl(ApiEndpoints.sendEmailOtp),
          converter: (response) => SendEmailOtpResponse.fromJson(response as Map<String, dynamic>),data: sendOtpRequest.toJson());
      return response;
    }
  }

  Future<Either<Failure, ValidateEmailOtpResponse>> validateEmailOtp(
      ValidateEmailOtpRequest validateOtpRequest) async {
    if (isFeatureEnabled(featureName: featureEnableStubData)) {
            final langStubResponse =
      await rootBundle.loadString('assets/stubdata/profile/validate_email_otp.json');
      final body = json.decode(langStubResponse);
      Either<Failure, ValidateEmailOtpResponse> response =
      Right(ValidateEmailOtpResponse.fromJson(body as Map<String, dynamic>));
      return response;
    } else {
      final response = await dioClient.postRequest(getMsApiUrl(ApiEndpoints.validateEmailOtp),
          converter: (response) => ValidateEmailOtpResponse.fromJson(response as Map<String, dynamic>),data: validateOtpRequest.toJson());
      return response;
    }
  }

  Future<Either<Failure, ValidateAadhaarOtpRes>> validateAadhaarOtp(
      ValidateAadhaarOtpReq req) async {
    if (isFeatureEnabled(featureName: featureEnableStubData)) {
            final myProfileStubData = await rootBundle
          .loadString('assets/stubdata/profile/validateAadhaarOtp.json');
      final body = json.decode(myProfileStubData);
      Either<Failure, ValidateAadhaarOtpRes> response =
      Right(ValidateAadhaarOtpRes.fromJson(body as Map<String, dynamic>));
      return response;
    } else {
      final response = await dioClient.postRequest(getMsApiUrl(ApiEndpoints.validateAadhaarOtp),
          converter: (response) => ValidateAadhaarOtpRes.fromJson(response as Map<String, dynamic>),data: req.toJson());
      return response;
    }
  }

}
