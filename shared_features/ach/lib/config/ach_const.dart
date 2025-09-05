class AchConst {
  AchConst._();

  static AchConst get = AchConst._();
  static const uploadDocument = "upload";
  static const deleteDocument = "delete";
  static const srStatusHold = "hold";
  static const srStatusCreate = "create";

  static const srCreateMandate = "createMandate";
  static const srHoldMandate = "holdMandate";
  static const srUpdateMandate = "updateMandate";
  static const srUpdateOtherMandate = "updateOtherMandate";
  static const srCancelMandate = "cancelMandate";
  static const srCancelOtherMandate = "cancelOtherMandate";

  static const frequencydeduction = "ADHO";
  static const mandateFrequency = "Monthly";
  // static const acceptedMatchScore = 70.0;
  //TO DO temprorey make name match score to 0
  static const acceptedMatchScore = 0.0;

  static const srCategoryAchMandate = "Existing Loan";
  static const srSubCategoryAchMandate = "ACH Related";
  static const srChannelAchMandate = "App";
  static const srRequestTypeAchMandate = "REQUEST";
  static const srProductNameAchMandate = "Loan";
  static const srRequestTypeLaonRefuncd = "Complaint";
  static const createMandatePattern = "ASPRESENTED";
  static const achRevokeable = "Y";
  static const achAuthorize = "Y";
  static const achAuthorizeRevoke = "Y";
  // Mandate Detail
  static const activeMandateStatus = "ACTIVE";
  static const nullMandateStatus = "NULL";

  static const caseTypeCreateEMandate = 5;
  static const caseTypeUpdateEMandate = 6;
  static const caseTypeCancelEMandate = 7;
  static const caseTypeHoldEMandate = 8;

  static const activePennyDropAccount = "ACTIVE";
  static const maxPennyDropAttempt = 3;
}

