import 'package:auth/features/mobile_otp/data/datasources/phone_validate_datasource.dart';
import 'package:auth/features/mobile_otp/data/models/reg_status_request.dart';
import 'package:auth/features/mobile_otp/data/models/reg_status_response.dart';
import 'package:auth/features/mobile_otp/data/models/save_device_request.dart';
import 'package:auth/features/mobile_otp/data/models/save_device_response.dart';
import 'package:auth/features/mobile_otp/data/models/send_email_otp_request.dart';
import 'package:auth/features/mobile_otp/data/models/send_email_otp_response.dart';
import 'package:auth/features/mobile_otp/data/models/send_otp_request.dart';
import 'package:auth/features/mobile_otp/data/models/send_otp_response.dart';
import 'package:auth/features/mobile_otp/data/models/validate_email_otp_request.dart';
import 'package:auth/features/mobile_otp/data/models/validate_email_otp_response.dart';
import 'package:auth/features/mobile_otp/data/models/validate_multiple_device_request.dart';
import 'package:auth/features/mobile_otp/data/models/validate_multiple_device_response.dart';
import 'package:auth/features/mobile_otp/data/models/validate_otp_request.dart';
import 'package:auth/features/mobile_otp/data/models/validate_otp_response.dart';
import 'package:core/config/error/failure.dart';
import 'package:dartz/dartz.dart';

import '../../domain/repositories/phone_validate_repository.dart';
import '../models/validate_aadhaar_otp_req.dart';
import '../models/validate_aadhaar_otp_res.dart';

class PhoneValidateRepositoryImpl extends PhoneValidateRepository {
  PhoneValidateRepositoryImpl({required this.datasource});
  final PhoneValidateDataSource datasource;

  @override
  Future<Either<Failure, SendOtpResponse>> sendOtp(SendOtpRequest sendOtpRequest) async{
    final result = await datasource.sendOtp(sendOtpRequest);
    return result.fold((left) => Left(left), (right) => Right(right));
  }

  @override
  Future<Either<Failure, ValidateOtpResponse>> validateOtp(ValidateOtpRequest validateOtpRequest) async {
    final result = await datasource.validateOtp(validateOtpRequest);
    return result.fold((left) => Left(left), (right) => Right(right));
  }

  @override
  Future<Either<Failure, RegisterStatusResponse>> getCustRegStatus(RegisterStatusRequest registerStatusRequest) async{
    final result = await datasource.getCustRegStatus(registerStatusRequest);
    return result.fold((left) => Left(left), (right) => Right(right));
  }

  @override
  Future<Either<Failure, SaveDeviceResponse>> saveDevice(SaveDeviceRequest saveDeviceRequest) async{
    final result = await datasource.saveDevice(saveDeviceRequest);
    return result.fold((left) => Left(left), (right) => Right(right));
  }

  @override
  Future<Either<Failure, ValidateMultipleDeviceResponse>> validateMultipleDevice(ValidateMultiPleDeviceRequest validateMultiPleDeviceRequest) async{
    final result = await datasource.validateMultipleDevice(validateMultiPleDeviceRequest);
    return result.fold((left) => Left(left), (right) => Right(right));
  }

  @override
  Future<Either<Failure, SendEmailOtpResponse>> sendEmailOtp(SendEmailOtpRequest sendOtpRequest) async {
    final result = await datasource.sendEmailOtp(sendOtpRequest);
    return result.fold((left) => Left(left), (right) => Right(right));
  }

  @override
  Future<Either<Failure, ValidateEmailOtpResponse>> validateEmailOtp(ValidateEmailOtpRequest validateOtpRequest) async {
    final result = await datasource.validateEmailOtp(validateOtpRequest);
    return result.fold((left) => Left(left), (right) => Right(right));
  }

  @override
  Future<Either<Failure, ValidateAadhaarOtpRes>> validateAadhaarOtp(ValidateAadhaarOtpReq req) async {
    final result = await datasource.validateAadhaarOtp(req);
    return result.fold((left) => Left(left), (right) => Right(right));
  }
}