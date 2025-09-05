class ApiEndpoints {
  ApiEndpoints._();

  static const String login = "mobile/v1/authentication";
  static const String validateDevice = "mobile/v1/validate-device";
  static const String applaunchConfig = "mobile/v1/appLaunch";
  static const String preLoginToken = "token";
  static const String postLoginToken = "v2/token";
  static const String sendOtp = "mobile/v1/send-otp";
  static const String validateOtp = "mobile/v1/validate-otp";
  static const String authenticate = "mobile/v1/pan-account-user";
  static const String userConsent = "mobile/v1/consent";
  static const String getCustRegStatus = "mobile/v1/registration-status";
  static const String createMpin = "mobile/v1/create-mpin";
  static const String registerUser = "mobile/v1/register-user";
  static const String validateMultipleDevice =
      "mobile/v1/validateDevice-withMobile";
  static const String validateDeviceWithUcic =
      "mobile/v1/validateDevice-withUcic";
  static const String saveDevice = "mobile/v1/save-device-details";
  static const String getThemeDetail = "mobile/v1/getThemeDetails";
  static const String sendEmailOtp = "profile/v1/sendEmailOtp";
  static const String validateEmailOtp = "profile/v1/verifyEmailOtp";
  static const String validateAadhaarOtp = "kyc/v1/validate-otp-data-retrieve";
  static const String deleteProfile = "profile/v1/delete-profile";
}
