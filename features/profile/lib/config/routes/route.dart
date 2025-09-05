enum Routes {
  myProfileData('/myProfileData'),
  myProfileAddPanData('/myProfileAddPanCard'),
  myProfileUploadPhoto('/myProfileUploadPhoto'),
  myProfileUpdateEmailID('/myProfileUpdateEmailID'),
  myProfileUpdateMobileNumber('/myProfileUpdateMobileNumber/:updateOperationType'),
  myProfileUpdateAddress('/myProfileUpdateAddress'),
  myProfileServiceRequestGenerated('/myProfileServiceRequestGenerated'),
  myProfileUpdateAddressAuth('/myProfileUpdateAddressAuth'),
  myProfileConfirmDetails('/myProfileConfirmDetail'),
  myProfileNameMismatch('/myProfileNameMismatch'),
  myProfileOtpScreen('/myProfileOtpScreen'),
  myProfileUpdateMobileNumAadharAuth('/myProfileUpdateMobileAadharAuth'),
  myProfileAuthenticateMobileNumber('/myProfileAuthenticateMobileNumber'),
  profilechooseSecondFactor("/profile_choose_secondfactorauth"),
  profilesecondfactor("/profilesecondfactor/:mobileNumber/:authType");

  const Routes(this.path);

  final String path;
}
