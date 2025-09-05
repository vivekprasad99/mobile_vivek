import 'package:auth/features/mobile_otp/data/models/save_device_response.dart';
import 'package:auth/features/mobile_otp/data/models/send_otp_response.dart';
import 'package:auth/features/mobile_otp/data/models/reg_status_response.dart';
import 'package:auth/features/mobile_otp/data/models/validate_multiple_device_response.dart';
import 'package:auth/features/mobile_otp/data/models/validate_otp_response.dart';
import 'package:core/config/error/failure.dart';
import 'package:equatable/equatable.dart';

import '../../data/models/send_email_otp_response.dart';
import '../../data/models/validate_aadhaar_otp_res.dart';
import '../../data/models/validate_email_otp_response.dart';

/// Represents the state of MobileNumber in the application.
abstract class MobileOtpState extends Equatable {}
// ignore_for_file: must_be_immutable
class MobileOtpInitState extends MobileOtpState {
  bool showPhoneView;
  bool enableButton;
  bool isUserConsent;
  MobileOtpInitState(this.showPhoneView,this.enableButton, this.isUserConsent);

  @override
  List<Object?> get props => [showPhoneView,enableButton,isUserConsent];
}

class WAConsentState extends MobileOtpState{
  bool isWAConsent;
  WAConsentState(this.isWAConsent);

  @override
  List<Object?> get props => [isWAConsent];
}

class OtpReceiveState extends MobileOtpState {
  String otp;
  OtpReceiveState(this.otp);

  @override
  List<Object?> get props => [otp];
}

class VerifyButtonState extends MobileOtpState {
  bool isEnable;
  VerifyButtonState(this.isEnable);

  @override
  List<Object?> get props => [isEnable];
}

class CheckBoxState extends MobileOtpState {
  bool ischecked;
  CheckBoxState(this.ischecked);

  @override
  List<Object?> get props => [ischecked];
}

class ApiLoadingState extends MobileOtpState {
  final bool isloading;
  ApiLoadingState({required this.isloading});

  @override
  List<Object?> get props => [isloading];
}

class ResendOtpState extends MobileOtpState {
  bool showTimer;
  bool showResendOtp;
  bool showIvrOtp;
  ResendOtpState(this.showTimer, this.showResendOtp, this.showIvrOtp);
  @override
  List<Object?> get props => [showTimer, showResendOtp, showIvrOtp];
}

class SendOtpSuccess extends MobileOtpState {
  final SendOtpResponse response;
  SendOtpSuccess({required this.response});
  @override
  List<Object?> get props => [response];
}

class SendOtpFailure extends MobileOtpState {
  final Failure error;
  SendOtpFailure({required this.error});
  @override
  List<Object?> get props => [error];
}

class ValidateOtpSuccess extends MobileOtpState {
  final ValidateOtpResponse response;
  ValidateOtpSuccess({required this.response});
  @override
  List<Object?> get props => [response];
}

class ValidateOtpFailure extends MobileOtpState {
  final Failure error;
  ValidateOtpFailure({required this.error});
  @override
  List<Object?> get props => [error];
}

class CustRegStatusFailureState extends MobileOtpState {
  final Failure error;
  CustRegStatusFailureState({required this.error});
  @override
  List<Object?> get props => [error];
}

class CustRegStatusSuccessState extends MobileOtpState {
  final RegisterStatusResponse response;
  CustRegStatusSuccessState({required this.response});
  @override
  List<Object?> get props => [response];
}

class SetMobileNumberState extends MobileOtpState {
  String mobileNumber;

  SetMobileNumberState(this.mobileNumber);

  @override
  List<Object?> get props => [mobileNumber];
}

class ValidateMultipleDeviceFailureState extends MobileOtpState {
  final Failure error;
  ValidateMultipleDeviceFailureState({required this.error});
  @override
  List<Object?> get props => [error];
}

class ValidateMultipleDeviceSuccessState extends MobileOtpState {
  final ValidateMultipleDeviceResponse response;
  ValidateMultipleDeviceSuccessState({required this.response});
  @override
  List<Object?> get props => [response];
}

class SaveDeviceFailureState extends MobileOtpState {
  final Failure error;
  SaveDeviceFailureState({required this.error});
  @override
  List<Object?> get props => [error];
}

class SaveDeviceSuccessState extends MobileOtpState {
  final SaveDeviceResponse response;
  final String superAppId;
  SaveDeviceSuccessState({required this.response, required this.superAppId});
  @override
  List<Object?> get props => [response, superAppId];
}

class SendEmailOtpSuccess extends MobileOtpState {
  final SendEmailOtpResponse response;
  SendEmailOtpSuccess({required this.response});
  @override
  List<Object?> get props => [response];
}

class SendEmailOtpFailure extends MobileOtpState {
  final Failure error;
  SendEmailOtpFailure({required this.error});
  @override
  List<Object?> get props => [error];
}

class ValidateEmailOtpSuccess extends MobileOtpState {
  final ValidateEmailOtpResponse response;
  ValidateEmailOtpSuccess({required this.response});
  @override
  List<Object?> get props => [response];
}

class ValidateEmailOtpFailure extends MobileOtpState {
  final Failure error;
  ValidateEmailOtpFailure({required this.error});
  @override
  List<Object?> get props => [error];
}

class ValidateAadhaarOtpSuccessState extends MobileOtpState {
  final ValidateAadhaarOtpRes response;

  ValidateAadhaarOtpSuccessState(
      {required this.response});

  @override
  List<Object?> get props => [response];
}

class ValidateAadhaarOtpFailureState extends MobileOtpState {
  final Failure failure;

  ValidateAadhaarOtpFailureState({required this.failure});

  @override
  List<Object?> get props => [failure];
}
