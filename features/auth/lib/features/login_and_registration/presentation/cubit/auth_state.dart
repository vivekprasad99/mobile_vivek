import 'package:auth/features/login_and_registration/data/models/authentication_response.dart';
import 'package:auth/features/login_and_registration/data/models/authentication_ucic_response.dart';
import 'package:auth/features/login_and_registration/data/models/delete_profile_resp.dart';
import 'package:auth/features/login_and_registration/data/models/login_response.dart';
import 'package:auth/features/login_and_registration/data/models/mpin_response.dart';
import 'package:auth/features/login_and_registration/data/models/postlogin_token_response.dart';
import 'package:auth/features/login_and_registration/data/models/validate_device_by_ucic_res.dart';
import 'package:core/config/config.dart';
import 'package:equatable/equatable.dart';
import 'package:local_auth/local_auth.dart';

import '../../data/models/get_theme_response.dart';
import '../../data/models/register_user_response.dart';

abstract class AuthState extends Equatable {}

class AuthInitialState extends AuthState {
  @override
  List<Object?> get props => [];
}

class LoadingState extends AuthState {
  final bool isloading;
  LoadingState({required this.isloading});

  @override
  List<Object?> get props => [isloading];
}

class SecondFactorAuthValidateState extends AuthState {
  final bool isValid;
  SecondFactorAuthValidateState({required this.isValid});

  @override
  List<Object?> get props => [isValid];
}

class SecondFactorAuthTypeState extends AuthState {
  final int authType;
  SecondFactorAuthTypeState({required this.authType});

  @override
  List<Object?> get props => [authType];
}

class AuthenticationSuccessState extends AuthState {
  final AuthenticationResponse response;
  AuthenticationSuccessState({required this.response});

  @override
  List<Object?> get props => [response];
}

class AuthenticateMultiUcicFailureState extends AuthState {
  final Failure error;
  AuthenticateMultiUcicFailureState({required this.error});

  @override
  List<Object?> get props => [error];
}

class ValidateDeviceByUcicSuccessState extends AuthState {
  final ValidateDeviceByUcicRes response;
  final String userFullName;
  final String ucic;
  ValidateDeviceByUcicSuccessState(
      {required this.response, required this.userFullName, required this.ucic});

  @override
  List<Object?> get props => [response, userFullName, ucic];
}

class ValidateDeviceByUcicFailureState extends AuthState {
  final Failure error;
  ValidateDeviceByUcicFailureState({required this.error});

  @override
  List<Object?> get props => [error];
}

class AuthenticateMultiUcicSuccessState extends AuthState {
  final AuthenticateMultiUcicResponse response;
  AuthenticateMultiUcicSuccessState({required this.response});

  @override
  List<Object?> get props => [response];
}

class AuthenticationFailureState extends AuthState {
  final Failure error;
  AuthenticationFailureState({required this.error});

  @override
  List<Object?> get props => [error];
}

class UserInfoValidateState extends AuthState {
  final bool isValid;
  UserInfoValidateState({required this.isValid});

  @override
  List<Object?> get props => [isValid];
}

class UserInfoSuccessState extends AuthState {
  final RegisterUserResponse response;
  final String userFullName;
  final String ucic;
  UserInfoSuccessState(
      {required this.response, required this.userFullName, required this.ucic});

  @override
  List<Object?> get props => [response, userFullName, ucic];
}

class UserInfoFailureState extends AuthState {
  final Failure failure;
  UserInfoFailureState({required this.failure});

  @override
  List<Object?> get props => [failure];
}

class MPINValidateState extends AuthState {
  final bool isValid;
  MPINValidateState({required this.isValid});

  @override
  List<Object?> get props => [isValid];
}

class MPINValidateTextState extends AuthState {
  final bool isValidFirstThreeDigit;
  final bool isValidLastThreeDigit;
  final bool isValidSequential;
  final bool isMPinInitialState;
  MPINValidateTextState({
    required this.isValidFirstThreeDigit,
    required this.isValidLastThreeDigit,
    required this.isValidSequential,
    required this.isMPinInitialState,
  });

  @override
  List<Object?> get props => [
        isValidFirstThreeDigit,
        isValidLastThreeDigit,
        isValidSequential,
        isMPinInitialState
      ];
}

class MPinSuccessState extends AuthState {
  final MPinResponse response;
  MPinSuccessState({required this.response});

  @override
  List<Object?> get props => [response];
}

class MPinFailureState extends AuthState {
  final Failure error;
  MPinFailureState({required this.error});

  @override
  List<Object?> get props => [error];
}
// ignore_for_file: must_be_immutable
class PanConsentState extends AuthState {
  bool isPanConsent;
  PanConsentState(this.isPanConsent);

  @override
  List<Object?> get props => [isPanConsent];
}

class LoginSuccessState extends AuthState {
  final LoginResponse response;
  final bool isFromDeleteProfile;
  LoginSuccessState({required this.response, required this.isFromDeleteProfile});
  @override
  List<Object?> get props => [response, isFromDeleteProfile];
}

class LoginFailureState extends AuthState {
  final Failure error;
  LoginFailureState({required this.error});

  @override
  List<Object?> get props => [error];
}

class BiometricRegistrationState extends AuthState {
  final bool isFacedId;
  final List<BiometricType> availableBiometrics;
  final bool isDeviceHasBiometric;
  BiometricRegistrationState(
      {required this.isFacedId,
      required this.availableBiometrics,
      required this.isDeviceHasBiometric});
  @override
  List<Object?> get props =>
      [isFacedId, availableBiometrics, isDeviceHasBiometric];
}

class BiometricLoginState extends AuthState {
  final int remainingAttempt;
  final bool isBiometricLoginSuccess;
  BiometricLoginState(
      {required this.remainingAttempt, required this.isBiometricLoginSuccess});
  @override

  List<Object?> get props => [remainingAttempt, isBiometricLoginSuccess];
}

class PostLoginTokenSuccessState extends AuthState {
  final PostLoginTokenResponse response;
  final bool isFromDeleteProfile;
  PostLoginTokenSuccessState({required this.response, required this.isFromDeleteProfile});
  @override
  List<Object?> get props => [response, isFromDeleteProfile];
}

class PostLoginTokenFailureState extends AuthState {
  final Failure error;
  PostLoginTokenFailureState({required this.error});

  @override
  List<Object?> get props => [error];
}

class GetThemeSuccess extends AuthState {
  final GetThemeResponse response;

  GetThemeSuccess({required this.response});

  @override
  List<Object?> get props => [response];
}

class GetThemeFailure extends AuthState {
  final Failure error;

  GetThemeFailure({required this.error});

  @override
  List<Object?> get props => [error];
}

class DeleteProfileSuccessState extends AuthState {
  final DeleteProfileResp resp;

  DeleteProfileSuccessState({required this.resp});
  @override
  List<Object?> get props => [resp];
}

class DeleteProfileFailureState extends AuthState {
  final Failure error;

  DeleteProfileFailureState({required this.error});
  @override
  List<Object?> get props => [error];
}
