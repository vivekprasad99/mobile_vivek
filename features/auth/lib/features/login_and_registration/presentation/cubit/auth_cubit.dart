import 'package:auth/features/login_and_registration/data/models/authentication_request.dart';
import 'package:auth/features/login_and_registration/data/models/authentication_ucic_request.dart';
import 'package:auth/features/login_and_registration/data/models/delete_profile_req.dart';
import 'package:auth/features/login_and_registration/data/models/login_request.dart';
import 'package:auth/features/login_and_registration/data/models/mpin_request.dart';
import 'package:auth/features/login_and_registration/data/models/register_user_request.dart';
import 'package:auth/features/login_and_registration/data/models/validate_device_by_ucic_req.dart';
import 'package:auth/features/login_and_registration/domain/usecases/get_theme_usecase.dart';
import 'package:auth/features/login_and_registration/domain/usecases/second_factor_auth_usecase.dart';
import 'package:core/config/error/failure.dart';
import 'package:core/config/flavor/feature_flag/feature_flag.dart';
import 'package:core/config/flavor/feature_flag/feature_flag_keys.dart';
import 'package:core/utils/encryption/preference_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';

import '../../data/models/get_theme_request.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/registration_usecase.dart';
import '../login_wireframe/utils/biometric/app_enum.dart';
import '../login_wireframe/utils/biometric/biometric_authentication_util.dart';
import 'auth_state.dart';
import 'package:permission_handler/permission_handler.dart' as permission;

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(
      {required this.loginUsecase,
      required this.registerUsecase,
      required this.secondFactorAuthUseCase,
      required this.getThemeUseCase})
      : super(AuthInitialState()) {
    validateAuthInput(false);
    emit(BiometricRegistrationState(
        isFacedId: false,
        isDeviceHasBiometric: false,
        availableBiometrics: const <BiometricType>[]));
    emit(BiometricLoginState(
        remainingAttempt: 3, isBiometricLoginSuccess: false));
  }

  final LoginUseCase loginUsecase;
  final RegistrationUseCase registerUsecase;
  final SecondFactorAuthUseCase secondFactorAuthUseCase;
  final GetThemeUseCase getThemeUseCase;

  validateAuthInput(bool isValid) {
    emit(SecondFactorAuthValidateState(isValid: isValid));
  }

  changeAuthType(int changeAuthType) {
    emit(SecondFactorAuthTypeState(authType: changeAuthType));
  }

  authenticateSingleUcicCustomer(
      {required AuthenticateSingleUcicRequest authenticationRequest}) async {
    try {
      emit(LoadingState(isloading: true));
      if (isFeatureEnabled(featureName: featureEnableStubData)) {
        await Future.delayed(const Duration(seconds: 2));
      }
      final result = await secondFactorAuthUseCase.call(authenticationRequest);
      emit(LoadingState(isloading: false));
      result.fold((l) => emit(AuthenticationFailureState(error: l)),
          (r) => emit(AuthenticationSuccessState(response: r)));
    } catch (e) {
      emit(LoadingState(isloading: false));
      emit(AuthenticationFailureState(error: NoDataFailure()));
    }
  }

  authenticateMultiUcicCustomer(
      {required AuthenticateMultiUcicRequest authenticateUCICRequest}) async {
    try {
      emit(LoadingState(isloading: true));
      if (isFeatureEnabled(featureName: featureEnableStubData)) {
        await Future.delayed(const Duration(seconds: 2));
      }
      final result = await secondFactorAuthUseCase
          .authenticateUCIC(authenticateUCICRequest);
      emit(LoadingState(isloading: false));
      result.fold((l) => emit(AuthenticateMultiUcicFailureState(error: l)),
          (r) => emit(AuthenticateMultiUcicSuccessState(response: r)));
    } catch (e) {
      emit(LoadingState(isloading: false));
      emit(AuthenticateMultiUcicFailureState(error: NoDataFailure()));
    }
  }

  validateDeviceByUcic(
      {required ValidateDeviceByUcicReq validateDeviceByUcicReq,
      required String userFullName,
      required String ucic}) async {
    try {
      emit(LoadingState(isloading: true));
      if (isFeatureEnabled(featureName: featureEnableStubData)) {
        await Future.delayed(const Duration(seconds: 2));
      }
      final result = await secondFactorAuthUseCase
          .validateDeviceByUcic(validateDeviceByUcicReq);
      emit(LoadingState(isloading: false));
      result.fold(
          (l) => emit(ValidateDeviceByUcicFailureState(error: l)),
          (r) => emit(ValidateDeviceByUcicSuccessState(
              response: r, userFullName: userFullName, ucic: ucic)));
    } catch (e) {
      emit(LoadingState(isloading: false));
      emit(ValidateDeviceByUcicFailureState(error: NoDataFailure()));
    }
  }

  registerUser(RegisterUserRequest registerUserRequest, String userFullName,
      String ucic) async {
    try {
      emit(LoadingState(isloading: true));
      if (isFeatureEnabled(featureName: featureEnableStubData)) {
        await Future.delayed(const Duration(seconds: 2));
      }
      final result = await registerUsecase.call(registerUserRequest);
      emit(LoadingState(isloading: false));
      result.fold(
          (l) => emit(UserInfoFailureState(failure: l)),
          (r) => emit(UserInfoSuccessState(
              response: r, userFullName: userFullName, ucic: ucic)));
    } catch (e) {
      emit(LoadingState(isloading: false));
      emit(UserInfoFailureState(failure: NoDataFailure()));
    }
  }

  createMPin(MPinRequest mPinRequest) async {
    try {
      emit(LoadingState(isloading: true));
      if (isFeatureEnabled(featureName: featureEnableStubData)) {
        await Future.delayed(const Duration(seconds: 2));
      }
      final result = await registerUsecase.createMPin(mPinRequest);
      emit(LoadingState(isloading: false));
      result.fold((l) => emit(MPinFailureState(error: l)),
          (r) => emit(MPinSuccessState(response: r)));
    } catch (e) {
      emit(LoadingState(isloading: false));
      emit(MPinFailureState(error: NoDataFailure()));
    }
  }

  void validateMPINButton(bool isValid) {
    emit(MPINValidateState(isValid: isValid));
  }

  void validateMPINText(bool isValidFirstThreeDigit, bool isValidLastThreeDigit,
      bool isValidSequential, bool isMPinInitialState) {
    emit(MPINValidateTextState(
        isValidFirstThreeDigit: isValidFirstThreeDigit,
        isValidLastThreeDigit: isValidLastThreeDigit,
        isValidSequential: isValidSequential,
        isMPinInitialState: isMPinInitialState));
  }

  void validateUserInfo(bool isValid) {
    emit(UserInfoValidateState(isValid: isValid));
  }

  login({required LoginRequest loginRequest, required isFromDeleteProfile}) async {
    try {
      emit(LoadingState(isloading: true));
      if (isFeatureEnabled(featureName: featureEnableStubData)) {
        await Future.delayed(const Duration(seconds: 2));
      }
      final result = await loginUsecase.call(loginRequest);
      emit(LoadingState(isloading: false));
      result.fold((l) => emit(LoginFailureState(error: l)),
          (r) => emit(LoginSuccessState(response: r, isFromDeleteProfile: isFromDeleteProfile)));
    } catch (e) {
      emit(LoadingState(isloading: false));
      emit(LoginFailureState(error: NoDataFailure()));
    }
  }

  getPostLoginToken(
      {required String mobileNumber, required String mPin, required bool isFromDeleteProfile}) async {
    try {
      emit(LoadingState(isloading: true));
      if (isFeatureEnabled(featureName: featureEnableStubData)) {
        await Future.delayed(const Duration(seconds: 2));
      }
      final result = await loginUsecase.getPostLoginToken(mobileNumber, mPin);
      emit(LoadingState(isloading: false));
      result.fold((l) => emit(PostLoginTokenFailureState(error: l)),
          (r) => emit(PostLoginTokenSuccessState(response: r, isFromDeleteProfile: isFromDeleteProfile)));
    } catch (e) {
      emit(LoadingState(isloading: false));
      emit(PostLoginTokenFailureState(error: NoDataFailure()));
    }
  }

  void biometricAuthentication(int countValue) {
    emit(BiometricLoginState(
        remainingAttempt: countValue - 1, isBiometricLoginSuccess: false));
  }

  void getAvailableBiometric() async {
    if (await BiometricAuth.getInstance.checkBiometrics()) {
      List<BiometricType> availableBiometrics =
          await BiometricAuth.getInstance.getAvailableBiometrics();

      if (availableBiometrics.contains(BiometricType.face) ||
          availableBiometrics.contains(BiometricType.weak)) {
        emit(BiometricRegistrationState(
            isFacedId: true,
            availableBiometrics: availableBiometrics,
            isDeviceHasBiometric: true));
      } else {
        emit(BiometricRegistrationState(
            isFacedId: false,
            availableBiometrics: availableBiometrics,
            isDeviceHasBiometric: true));
      }
    }
  }

  void registerWithBiometric() async {
    var result = await BiometricAuth.getInstance.authenticateWithBiometrics();
    if (result == BiometricAuthResult.success) {
      String biometricKey = BiometricAuth.getInstance.generateBiometricKey();
      await PreferencesHelper.setBiometricKey(biometricKey);
    }
  }

  void loginWithBiometric(int countValue) async {
    var result = await BiometricAuth.getInstance.authenticateWithBiometrics();
    if (result == BiometricAuthResult.success) {
       await PreferencesHelper.getBiometricKey();
      loginWithBiometricCallback(countValue, true);
      // emit(BiometricLoginState(
      //     remainingAttempt: countValue, isBiometricLoginSuccess: true));
    } else {
      loginWithBiometricCallback(countValue - 1, false);
      // emit(BiometricLoginState(
      //     remainingAttempt: countValue - 1, isBiometricLoginSuccess: false));
    }
  }

  void loginWithBiometricCallback(int count, bool isBioSuccess) {
    emit(BiometricLoginState(
        remainingAttempt: count, isBiometricLoginSuccess: isBioSuccess));
  }

  void getSettings() async {
    await permission.openAppSettings();
  }

  void onLoginCompleted() {
    emit(state);
  }

  changePanConsent(bool isChecked) {
    emit(PanConsentState(isChecked));
  }

  getThemeDetail(GetThemeRequest getThemeRequest) async {
    try {
      emit(LoadingState(isloading: true));
      if (isFeatureEnabled(featureName: featureEnableStubData)) {
        await Future.delayed(const Duration(seconds: 2));
      }
      final result = await getThemeUseCase.call(getThemeRequest);
      emit(LoadingState(isloading: false));
      result.fold((l) => emit(GetThemeFailure(error: l)),
          (r) => emit(GetThemeSuccess(response: r)));
    } catch (e) {
      emit(LoadingState(isloading: false));
      emit(GetThemeFailure(error: NoDataFailure()));
    }
  }

  deleteProfile(DeleteProfileReq request) async {
    try {
      emit(LoadingState(isloading: true));
      if (isFeatureEnabled(featureName: featureEnableStubData)) {
        await Future.delayed(const Duration(seconds: 2));
      }
      final result = await loginUsecase.deleteProfile(request);
      emit(LoadingState(isloading: false));
      result.fold((l) => emit(DeleteProfileFailureState(error: l)),
          (r) => emit(DeleteProfileSuccessState(resp: r)));
    } catch (e) {
      emit(LoadingState(isloading: false));
      emit(DeleteProfileFailureState(error: NoDataFailure()));
    }
  }
}
