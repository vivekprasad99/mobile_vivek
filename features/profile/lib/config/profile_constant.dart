class ProfileConst {
  ProfileConst._();

  static ProfileConst get = ProfileConst._();
  static const uploadDocument = "uploadDocument";
  static const deleteDocument = "deleteDocument";

  static const int maxOtpAttempt = 3;
  static const int maxEmailAttempt = 3;
  static const int maxAadhaarAttempt = 3;
  static const int maxDLValidationAttempt = 3;
  static const int profileMaxFileSize = 2;
  // static const int nameMatchScore = 80;
  // static const int dobMatchScore = 100;
  // static const int genderMatchScore = 100;

  static const int nameMatchScore = 0;
  static const int dobMatchScore = 0;
  static const int genderMatchScore = 0;

}

