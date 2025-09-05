class ApiEndpoints {
  ApiEndpoints._();
  static const String getLoanList = "common/v1/loan-list";
  static const String genericResponse = "v1/generic-response";
  static const String createLCSR = "servicerequest/v1/create-case";
  static const String getReasons = "reasons";
  static const String getOffers = "offers";
  static const String fetchSr = "loan-cancellation/v1/fetch-all-sr";
  static const String getCharges =
      "loan-cancellation/autofin/v1/charges-details";
  static const String getLoanDetails = "foreclosure/v1/loan-details";
  static const String staticResponse = "v1/static-response";
  static const String getForeClosureDetails =
      "foreclosure/v1/fore-close-details";
  static const String createFDLead = "createFDLead ";
  static const String createForeclosureSR = "servicerequest/v1/create-case";
}
