enum Routes {
  paymentDetails("/paymentDetails"),
  billPayments("/billpayments");

  const Routes(this.path);

  final String path;
}
