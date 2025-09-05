class ApiEndpoints {
  ApiEndpoints._();
  static const String getAchLoans = "common/v1/loan-list";
  static const String fetchBankAccount = 'common/v1/customer-banklist';
  static const String getBankList = 'ach/v1/get-banklist';
  static const String getCMSBankList = 'v1/bank-list';
  static const String getPopularBankList = 'v1/popular-bank-list';
  static const String getMandates = 'ach/v1/mandates';
  static const String pennyDrop = 'ach/v1/save-verify-bank-details';
  static const String validateName = 'common/v1/validate-custname';
  static const String generateEMandateRequest = 'ach/v1/create-mandate';
  static const String generateUpiEMandateRequest = 'ach/v1/create-upi-madate';
  static const String validvpa = 'ach/v1/valid-vpa';
  static const String updateEnachStatus = 'updateEnachStatus';
  static const String getPresetUri = 'servicerequest/v1/presetURL';
  static const String generateSR = 'servicerequest/v1/create-case';
  static const String getCancelMandateReason = 'v1/generic-response?category=cancel_mandate_reason';
  static const String getUpdateMandateReason = 'v1/generic-response?category=update_mandate_reason';
  static const String submitUpdateMandateReason =
      'submitUpdateMandateReason';
  static const String createSRHoldMandate = 'createSRHoldMandate';
  static const String createSRCancelMandate = 'createSRCancelMandate';
  static const String reactiveMandate = 'reactiveMandate';
  static const String fetchApplicantName = 'ach/v1/find-applicant-coaplicant';
  static const String checkVpaStatus = 'ach/v1/cams-upi-mandate-status';
  static const String decryptCamsResponse = 'ach/v1/decrypt-cams-response';
  static const String getNpayStatusById = 'ach/v1/nupay-mandate-status';
}
