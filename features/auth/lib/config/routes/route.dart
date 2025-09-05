enum Routes {
  mobileOtp("/auth/mobileOtp"),
  chooseSecondFactorAuth("/auth/choose_secondfactorauth"),
  secondfactorauth("/auth/secondfactorauth/:mobileNumber/:authType"),
  userInfo("/auth/userInfo"),
  mpin("/auth/mpin"),
  biometric("/auth/biometric"),
  mpinSuccess("/auth/mpinSuccess"),
  registerStatus("/auth/registerStatus/:registerStatus"),
  login("/auth/login"),
  home("/home"),
  changeLoginPin("/auth/changeLoginPin");
  const Routes(this.path);

  final String path;
}
