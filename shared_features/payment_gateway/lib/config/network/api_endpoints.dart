class ApiEndpoints {
  ApiEndpoints._();

  static const String getTransactionId = "payment/v1/initiate-payment";
  static const String updatePaymentDetail = "payment/v1/audit-response";
  static const String getPaymentCredentials = "payment/v1/sandbox-details";
  static const String getPaymentOptions = "v1/generic-response?category=payment_options";
  
}
