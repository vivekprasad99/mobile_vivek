import 'package:auth/features/mobile_otp/data/models/reg_status_request.dart';
import 'package:auth/features/mobile_otp/data/models/reg_status_response.dart';
import 'package:auth/features/mobile_otp/data/models/save_device_request.dart';
import 'package:auth/features/mobile_otp/data/models/send_otp_request.dart';
import 'package:auth/features/mobile_otp/data/models/send_otp_response.dart';
import 'package:auth/features/mobile_otp/data/models/validate_multiple_device_request.dart';
import 'package:auth/features/mobile_otp/data/models/validate_otp_request.dart';
import 'package:auth/features/mobile_otp/data/models/validate_otp_response.dart';
import 'package:auth/features/mobile_otp/domain/usecases/phone_validate_usecase.dart';
import 'package:auth/features/mobile_otp/domain/usecases/validate_otp_usecase.dart';
import 'package:auth/features/mobile_otp/presentation/cubit/phone_validate_state.dart';
import 'package:core/config/config.dart';
import 'package:core/config/flavor/feature_flag/feature_flag.dart';
import 'package:core/config/flavor/feature_flag/feature_flag_keys.dart';
import 'package:core/utils/pref_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:core/utils/const.dart';

import '../../data/models/send_email_otp_request.dart';
import '../../data/models/validate_aadhaar_otp_req.dart';
import '../../data/models/validate_email_otp_request.dart';

class PhoneValidateCubit extends Cubit<MobileOtpState> with CodeAutoFill {
  final PhoneValidateUseCase sendOtpUsecase;
  final ValidateOtpUsecase validateOtpUsecase;

  PhoneValidateCubit(
      {required this.sendOtpUsecase,
      required this.validateOtpUsecase})
      : super(MobileOtpInitState(false, false, false));

  sendOtp(SendOtpRequest sendOtpRequest, {bool isFromResend = false}) async {
    // PrefUtils.saveString(
    //     PrefUtils.keyPhoneNumber, sendOtpRequest.mobileNumber!);
    emit(ApiLoadingState(isloading: true));
    if (!isFeatureEnabled(featureName: featureEnableStubData)) {
      await Future.delayed(const Duration(seconds: 2));
    }
    try {
      final result = await sendOtpUsecase.call(sendOtpRequest);
      emit(ApiLoadingState(isloading: false));
      result.fold((l) => handleSendOtpFailure(l),
          (r) => _handleSendOtpSuccess(r, isFromResend));
    } catch (e) {
      emit(ApiLoadingState(isloading: false));
      handleSendOtpFailure(NoDataFailure());
    }
  }

  validateOtp(ValidateOtpRequest validateOtpRequest) async {
    try {
      emit(ApiLoadingState(isloading: true));
      if (isFeatureEnabled(featureName: featureEnableStubData)) {
        await Future.delayed(const Duration(seconds: 2));
      }
      final result = await validateOtpUsecase.call(validateOtpRequest);
      emit(ApiLoadingState(isloading: false));
      result.fold(
          (l) => _handleValidateOtpFailure(l),
          (r) =>
              _handleValidateOtpSuccess(r, validateOtpRequest.mobileNumber!));
    } catch (e) {
      emit(ApiLoadingState(isloading: false));
      _handleValidateOtpFailure(NoDataFailure());
    }
  }

  getCustRegStatus(
      {required RegisterStatusRequest registerStatusRequest}) async {
    try {
      emit(ApiLoadingState(isloading: true));
      if (isFeatureEnabled(featureName: featureEnableStubData)) {
        await Future.delayed(const Duration(seconds: 2));
      }
      final result =
          await validateOtpUsecase.getCustRegStatus(registerStatusRequest);
      emit(ApiLoadingState(isloading: false));
      result.fold((l) => _handleCustRegStatusFailure(l),
          (r) => _handleCustRegStatusSuccess(r));
    } catch (e) {
      emit(ApiLoadingState(isloading: false));
      _handleCustRegStatusFailure(NoDataFailure());
    }
  }

  validateMultipleDevice(
      {required ValidateMultiPleDeviceRequest
          validateMultiPleDeviceRequest}) async {
    try {
      emit(ApiLoadingState(isloading: true));
      if (isFeatureEnabled(featureName: featureEnableStubData)) {
        await Future.delayed(const Duration(seconds: 2));
      }
      final result = await validateOtpUsecase
          .validateMultipleDevice(validateMultiPleDeviceRequest);
      emit(ApiLoadingState(isloading: false));
      result.fold((l) => emit(ValidateMultipleDeviceFailureState(error: l)),
          (r) => emit(ValidateMultipleDeviceSuccessState(response: r)));
    } catch (e) {
      emit(ApiLoadingState(isloading: false));
      emit(ValidateMultipleDeviceFailureState(error: NoDataFailure()));
    }
  }

  saveDevice({required SaveDeviceRequest saveDeviceRequest}) async {
    try {
      emit(ApiLoadingState(isloading: true));
      if (isFeatureEnabled(featureName: featureEnableStubData)) {
        await Future.delayed(const Duration(seconds: 2));
      }
      final result = await validateOtpUsecase.saveDevice(saveDeviceRequest);
      emit(ApiLoadingState(isloading: false));
      result.fold((l) => emit(SaveDeviceFailureState(error: l)),
          (r) => emit(SaveDeviceSuccessState(response: r, superAppId: saveDeviceRequest.superAppId ?? "")));
    } catch (e) {
      emit(ApiLoadingState(isloading: false));
      emit(SaveDeviceFailureState(error: NoDataFailure()));
    }
  }


  _handleCustRegStatusFailure(Failure failure) {
    emit(CustRegStatusFailureState(error: failure));
  }

  _handleCustRegStatusSuccess(RegisterStatusResponse registerStatusResponse) {
    PrefUtils.saveBool(
        PrefUtils.keyIsCustomer, registerStatusResponse.isCustomer!);
    PrefUtils.saveBool(PrefUtils.keyIsPAN, registerStatusResponse.isPanAvailable!);
    PrefUtils.saveBool(
        PrefUtils.keyIsMultipleUCIC, registerStatusResponse.ucicCount!>1? true:false );
    emit(CustRegStatusSuccessState(response: registerStatusResponse));
    cancel();
  }


  _handleSendOtpSuccess(SendOtpResponse response, bool isFromResend) {
    // initAutoFillSMS();
    if (response.code == AppConst.codeSuccess) {
      if (!isFromResend) {
        emit(SendOtpSuccess(response: response));
        showOtpView();
      } else {
        showResendOtpButton(true, false, false);
      }
    } else {
      emit(SendOtpSuccess(response: response));
    }
  }

  showOtpView() {
    _showOptView();
    startResendOtpTimer(true);
  }

  handleSendOtpFailure(Failure failure) {
    emit(SendOtpFailure(error: failure));
  }

  _handleValidateOtpSuccess(
      ValidateOtpResponse validateOtpResponse, String mobileNumber) {
    emit(ValidateOtpSuccess(response: validateOtpResponse));
  }

  _handleValidateOtpFailure(Failure failure) {
    emit(ValidateOtpFailure(error: failure));
  }

  _showOptView() {
    emit(MobileOtpInitState(false, true, true));
  }

  changeWAConsent(bool isChecked) {
    emit(WAConsentState(isChecked));
  }

  setMobileNumber(String mobileNumber) {
    emit(SetMobileNumberState(mobileNumber));
  }

  changeCheckBox(bool enableOtpBtn, bool checkUserConsent) {
    emit(MobileOtpInitState(true, enableOtpBtn, checkUserConsent));
  }

  enableVerifyButton(bool value) {
    emit(VerifyButtonState(value));
  }

  startResendOtpTimer(bool value) {
    emit(ResendOtpState(value, false, false));
  }

  showResendOtpButton(bool showTimer, bool showResendOTP, bool showIvrOTP) {
    emit(ResendOtpState(showTimer, showResendOTP, showIvrOTP));
  }

  resetPhoneNumber() {
    changeCheckBox(true, true);
    showResendOtpButton(false, false, false);
  }

  sendEmailOtp(SendEmailOtpRequest sendEmailOtpRequest,
      {bool isFromResend = false}) async {
    // PrefUtils.saveString(PrefUtils.emailID, sendEmailOtpRequest.emailID!);
    emit(ApiLoadingState(isloading: true));
    if (isFeatureEnabled(featureName: featureEnableStubData)) {
      await Future.delayed(const Duration(seconds: 2));
    }
    try {
      final result = await validateOtpUsecase.sendEmailOtpCall(sendEmailOtpRequest);
      emit(ApiLoadingState(isloading: false));
      result.fold((l) => emit(SendEmailOtpFailure(error: l)),
              (r) => emit(SendEmailOtpSuccess(response: r)));
    } catch (e) {
      emit(ApiLoadingState(isloading: false));
      emit(SendEmailOtpFailure(error: NoDataFailure()));
    }
  }


  validateEmailOtp(ValidateEmailOtpRequest validateOtpRequest) async {
    try {
      emit(ApiLoadingState(isloading: true));
      if (isFeatureEnabled(featureName: featureEnableStubData)) {
        await Future.delayed(const Duration(seconds: 2));
      }
      final result = await validateOtpUsecase.validateEmailOtpCall(validateOtpRequest);
      emit(ApiLoadingState(isloading: false));
      result.fold((l) => emit(ValidateEmailOtpFailure(error: l)),
              (r) => emit(ValidateEmailOtpSuccess(response: r)));
    } catch (e) {
      emit(ApiLoadingState(isloading: false));
      ValidateEmailOtpFailure(error: NoDataFailure());
    }
  }

  void validateAadhaarOtp(ValidateAadhaarOtpReq request) async {
    try {
      emit(ApiLoadingState(isloading: true));
      if (isFeatureEnabled(featureName: featureEnableStubData)) {
        await Future.delayed(const Duration(seconds: 2));
      }
      final result = await validateOtpUsecase.validateAadhaarOtp(request);
      emit(ApiLoadingState(isloading: false));
      result.fold((l) => emit(ValidateAadhaarOtpFailureState(failure: l)),
              (r) => emit(ValidateAadhaarOtpSuccessState(response: r)));
    } catch (e) {
      emit(ApiLoadingState(isloading: false));
      emit(ValidateAadhaarOtpFailureState(failure: NoDataFailure()));
    }
  }

  @override
  void codeUpdated() {
    emit(OtpReceiveState(code!));
  }
}
