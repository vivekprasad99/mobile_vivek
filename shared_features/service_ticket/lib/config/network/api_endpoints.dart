class ApiEndpoints {
  ApiEndpoints._();
  static const String querySubQuery = "v1/query-subquery";
  static const String getPresetUri = 'servicerequest/v1/presetURL';
  static const String checkDedupe = 'servicerequest/v1/get-srnumber-forloan';
  static const String createCase = "servicerequest/v1/create-case";
  static const String viewServiceRequest = "servicerequest/v1/service-requests";
  static const String reopenReasons = 'v1/status';
  static const String reopenCase = 'servicerequest/v1/reopen-case';
  static const String srDetailsByNumber = 'servicerequest/v1/sr-details';
  static const String getDocuments = "product-details/v1/get-document";
}
