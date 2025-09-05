import 'package:auth/features/mobile_otp/data/models/save_device_request.dart';
import 'package:auth/features/mobile_otp/data/models/save_device_response.dart';
import 'package:auth/features/mobile_otp/data/models/send_otp_response.dart';
import 'package:auth/features/mobile_otp/data/models/validate_multiple_device_response.dart';
import 'package:auth/features/mobile_otp/data/models/validate_otp_request.dart';
import 'package:auth/features/mobile_otp/data/models/validate_otp_response.dart';
import 'package:core/config/error/failure.dart';
import 'package:dartz/dartz.dart';

import '../../data/models/reg_status_request.dart';
import '../../data/models/reg_status_response.dart';
import '../../data/models/send_email_otp_request.dart';
import '../../data/models/send_email_otp_response.dart';
import '../../data/models/send_otp_request.dart';
import '../../data/models/validate_aadhaar_otp_req.dart';
import '../../data/models/validate_aadhaar_otp_res.dart';
import '../../data/models/validate_email_otp_request.dart';
import '../../data/models/validate_email_otp_response.dart';
import '../../data/models/validate_multiple_device_request.dart';

abstract class PhoneValidateRepository {
  Future<Either<Failure, SendOtpResponse>> sendOtp(SendOtpRequest sendOtpRequest);
  Future<Either<Failure, ValidateOtpResponse>> validateOtp(ValidateOtpRequest validateOtpRequest);
  Future<Either<Failure, RegisterStatusResponse>> getCustRegStatus(RegisterStatusRequest registerStatusRequest);
  Future<Either<Failure, ValidateMultipleDeviceResponse>> validateMultipleDevice(ValidateMultiPleDeviceRequest validateMultiPleDeviceRequest);
  Future<Either<Failure, SaveDeviceResponse>> saveDevice(SaveDeviceRequest saveDeviceRequest);

  Future<Either<Failure, SendEmailOtpResponse>> sendEmailOtp(
      SendEmailOtpRequest sendOtpRequest);
  Future<Either<Failure, ValidateEmailOtpResponse>> validateEmailOtp(
      ValidateEmailOtpRequest validateOtpRequest);
  Future<Either<Failure, ValidateAadhaarOtpRes>> validateAadhaarOtp(
      ValidateAadhaarOtpReq req);
}