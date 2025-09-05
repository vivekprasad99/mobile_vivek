class ApiEndpoints {
  ApiEndpoints._();

  static const String updateEmail = "profile/v1/saveEmail";
  static const String getAadhaarConsent = "kyc/v1/consent-otp";
  static const String validateAadhaarOTP = "kyc/v1/validate-otp-data-retrieve";
  static const String validateNameMatch = "common/v1/name-matcher";
  static const String validateDobGenderMatch = "common/v1/dob-gender-matcher";
  static const String updatePhoneNumber = "profile/v1/updateMobile";
  static const String customerProfile = "profile/v1/getProfileByUcic";
  static const String ocrProfile = "kyc/v1/extract-document-data";
  static const String customerProfileImage = "profile/v1/getProfileImage";
  static const String validatePan = "common/v1/pan-dob-nsdl-call";
  static const String updatePan = "profile/v1/savePan";
  static const String updateProfile = "profile/v1/updateImage";
  static const String deleteProfile = "profile/v1/deleteProfile";
  static const String validateDrivingLicense = "kyc/v1/validateDrivingLicense";
  static const String updateAddress = "profile/v1/updateAddress";
  static const String updateAddressOffline = "profile/v1/update-address-offline";
  static const String getActiveLoanList = "common/v1/loan-list";
}
