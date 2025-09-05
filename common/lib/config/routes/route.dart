enum Routes {
  // general
  route("/"),
  startup("/startup"),

  // Auth Page
  login("/auth/login"),
  register("/auth/register"),
  languageSelection("/auth/languageSelection"),

  // privacy policy page
  privacyPolicy("/privacyPolicy"),

  termsConditions("/termsConditions"),
  // registerStatus("/auth/registerStatus/:registerStatus"),
  // home page
  home("/home"),
  preapprovedOffer("/preapprovedOffer"),
  preapprovedOfferDetails("/preapprovedOfferDetails"),

  services("/services"),
  //product page
  productFeatures("/product_features"),
  productDetails("/product_details"),

  settings("/setting"),
  notificationPref("/notification_pref"),

  othersFeat("/othersFeat"),

  // Payment page
  billPayments("/billpayments"),

  searchScreen("/searchScreen");

  const Routes(this.path);

  final String path;
}
