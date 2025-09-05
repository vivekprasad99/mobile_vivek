import 'package:auth/features/mobile_otp/data/models/save_device_request.dart';
import 'package:auth/features/mobile_otp/data/models/save_device_response.dart';
import 'package:auth/features/mobile_otp/data/models/validate_multiple_device_request.dart';
import 'package:auth/features/mobile_otp/data/models/validate_multiple_device_response.dart';
import 'package:auth/features/mobile_otp/data/models/validate_otp_request.dart';
import 'package:auth/features/mobile_otp/data/models/validate_otp_response.dart';
import 'package:auth/features/mobile_otp/domain/repositories/phone_validate_repository.dart';
import 'package:core/config/error/failure.dart';
import 'package:core/config/usecase/usecase.dart';
import 'package:dartz/dartz.dart';

import '../../data/models/reg_status_request.dart';
import '../../data/models/reg_status_response.dart';
import '../../data/models/send_email_otp_request.dart';
import '../../data/models/send_email_otp_response.dart';
import '../../data/models/validate_aadhaar_otp_req.dart';
import '../../data/models/validate_aadhaar_otp_res.dart';
import '../../data/models/validate_email_otp_request.dart';
import '../../data/models/validate_email_otp_response.dart';

class ValidateOtpUsecase extends UseCase<ValidateOtpResponse, ValidateOtpRequest> {
  final PhoneValidateRepository repository;

  ValidateOtpUsecase({required this.repository});

  @override
  Future<Either<Failure, ValidateOtpResponse>> call(ValidateOtpRequest params) async {
    return await repository.validateOtp(params);
  }


  Future<Either<Failure, RegisterStatusResponse>> getCustRegStatus(RegisterStatusRequest params) async {
    return await repository.getCustRegStatus(params);
  }


  Future<Either<Failure, ValidateMultipleDeviceResponse>> validateMultipleDevice(ValidateMultiPleDeviceRequest params) async {
    return await repository.validateMultipleDevice(params);
  }


  Future<Either<Failure, SaveDeviceResponse>> saveDevice(SaveDeviceRequest params) async {
    return await repository.saveDevice(params);
  }

  Future<Either<Failure, SendEmailOtpResponse>> sendEmailOtpCall(
      SendEmailOtpRequest params) async {
    return await repository.sendEmailOtp(params);
  }


  Future<Either<Failure, ValidateEmailOtpResponse>> validateEmailOtpCall(
      ValidateEmailOtpRequest params) async {
    return await repository.validateEmailOtp(params);
  }

  Future<Either<Failure, ValidateAadhaarOtpRes>> validateAadhaarOtp(
      ValidateAadhaarOtpReq req) async {
    return await repository.validateAadhaarOtp(req);
  }
}