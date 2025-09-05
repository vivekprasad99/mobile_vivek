class ApiEndpoints {
  ApiEndpoints._();
  static const String getLoanList = "common/v1/loan-list";
  static const String genericResponse = "v1/generic-response";
  static const String createLCSR = "servicerequest/v1/create-case";

  static const String getLoanDetails = "foreclosure/v1/loan-details";
  static const String staticResponse = "v1/static-response";

  static const String createFDLead = "createFDLead ";
  static const String getNocDetails = "noc/v1/get-noc-details";
  static const String gcvalidation = "noc/v1/get-gc-validations";
  static const String updateRc = "noc/v1/update-rc-details";
  static const String getVahanDetails = "noc/v1/get-vahan-details";
  static const String downloadNoc = "noc/v1/get-pl-noc-document";
  static const String saveDeliveryAddress = "noc/v1/update-delivery-address";
}
