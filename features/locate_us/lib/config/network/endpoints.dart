class ApiEndpoints {
  ApiEndpoints._();
  //? apis
  static const String getStates = "masters/v1/get-locateUs-state-list";
  static const String getCities = "masters/v1/get-locateUs-city-list";
  static const String getBranchesStateCity =
      "masters/v1/get-locateUs-branch-by-state-city-code";
  static const String getBranchesPincode =
      "masters/v1/get-locateUs-branch-by-pinCode";
  static const String getBranchesLatLong =
      "masters/v1/get-locateUs-branch-by-lat-lon";
  static const String getDealersStateCity =
      "masters/v1/get-locateUs-dealer-by-state-city-code";
  static const String getDealersPincode =
      "masters/v1/get-locateUs-dealer-by-pinCode";
  static const String saveBranch = "masters/v1/update-locateUs-bookmark";
  static const String getSavedBranches = "masters/v1/get-locateUs-bookmark";

  //? CPP links
  static const csc = "https://locator.csccloud.in/";
  static const ippb =
      "https://www.indiapost.gov.in/VAS/Pages/LocatePostOffices.aspx?Pin=pLIcI+wd8lo=";
  static const fino =
      "https://web4.finobank.com/contact-us#parentHorizontalTab";
}
