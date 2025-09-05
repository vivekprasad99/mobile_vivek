class ApiEndpoints {
  ApiEndpoints._();
  static const String getAppLanguages = "v1/languages";
  static const String staticContent = "v1/static-content";
  static const String getAppLabels = "v1/static-label";
  static const String updateThemeDetail = "mobile/v1/update-theme";
  static const String getRateUs = "rate-us/v1/retrieve-record";
  static const String updateRateUs = "rate-us/v1/save-record";
  static const String getLandingBanner = "v1/banners";
  static const String getLoanList = "common/v1/loan-list";
  static const String getLoanAmount = "landing-page/v1/landing-details";
  static const String getOffers = "v1/offers";
  static const String logout = "v2/revoke";
  static const String getLandingPreOfferDetails =
      "landing-page/v1/offer-details";
  static const String getSearchRoute = "v1/search";
  static const String getRecentList = "common/v1/getsearchhis";
  static const String updateRecentList = "common/v1/saveSearchHisDetails";
  static const String getRecommendedList = "v1/generic-response?category=recommended_search";
  static const String welcomeNotifyreq = "common/v1/notifications";
  static const String updateDeviceLang = "mobile/v1/updateDeviceLanguage";
}
