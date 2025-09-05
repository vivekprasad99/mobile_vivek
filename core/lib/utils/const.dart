class AppConst {
  AppConst._();
  static AppConst get = AppConst._();

  static const int maxValidateOtpCount = 3;
  static const int maxAuthCount = 3;
  static const int maxAttempt = 3;
  static const int maxLoginAttempt = 3;
  static const int maxResendOtpAttempt = 3;
  static const String codeSuccess = "SUCCESS";
  static const String codeCaptured = "CAPTURED";
  static const String codeFailure = "FAILURE";
  static const String useCasePrelogin = "preLogin";
  static const int resendOtpTime = 180;
  static const String preConditionFailServerError = "PRECONDITION_FAILED";
  static const String badRequest = "BAD_REQUEST";
  static const List<String> supportedFileTypes = ['.pdf','.txt'];
  static const List<String> supportedImageTypes = ['.jpg', '.jpeg', '.png'];
  static const int maxFileSizeInMB = 5;
  static const String mobilePlatform = "Mobile";
  static const String defaultAppLang = "en";
  static const String source = "SUPERAPP";
  static const String registrationJourney = "REGISTRATION";
  static const String forgotPassJourney = "FORGOT_PASSWORD";
  static const String updateMobileJourney = "UPDATE_MOBILE";
  static const String mapMyLoanMobileJourney = "MAP_MY_LOAN_MOBILE";
  static const String updateEmailJourney = "UPDATE_EMAIL";
  static const String updateAddressJourney = "UPDATE_ADDRESS";
  static const String loginJourney = "LOGIN";
  static const int createMpinMaxAttempt = 3;
  static const int maxPanLanAttempts = 3;
  static const String android = "ANDROID";
  static const String ios = "IOS";
  static const int maxProfileSupport = 3;
  static const String statusRevoke = "revoked";
  static const String paymentTat = "6";
}