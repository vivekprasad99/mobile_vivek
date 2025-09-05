enum Routes {
  paymentSuccess("/paymentSuccess"),
  choosePaymentMode("/choosePaymentMode"),
  camspayScreen("/camspayScreen"),
  paymentReceipt("/paymentReceipt"),
  paymentWebview("/paymentWebview");

  const Routes(this.path);

  final String path;
}
