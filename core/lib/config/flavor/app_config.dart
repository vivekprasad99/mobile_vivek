
enum Flavor { prod, dev, sit, uat, light }

class AppConfig {
  String appName = "";
  String baseUrl = "";
  String msSuffix = "";
  String cmsSuffix = "";
  String postLoginTokenSuffix = "";
  String preLoginTokenUserName = "";
  String preLoginTokenPassword = "";
  String postLoginTokenUserName = "";
  String postLoginTokenPassword = "";
  Flavor flavor = Flavor.dev;
  bool isMockTest = false;
  Map<String, bool> featureFlag;
  String botId = "";

  static AppConfig shared = AppConfig.create();

  factory AppConfig.create(
      {String appName = "",
      String baseUrl = "",
      String apiSuffix = "",
      String msSuffix = "",
      String postLoginTokenSuffix = "",
      String preLoginTokenUserName = "",
      String preLoginTokenPassword = "",
      String postLoginTokenUserName = "",
      String postLoginTokenPassword = "",
      Flavor flavor = Flavor.dev,
      bool isMockTest = false,
      Map<String, bool> featureFlag = const {},
      String botId = "",
      }) {
    return shared = AppConfig(
        appName,
        baseUrl,
        apiSuffix,
        msSuffix,
        postLoginTokenSuffix,
        preLoginTokenUserName,
        preLoginTokenPassword,
        postLoginTokenUserName,
        postLoginTokenPassword,
        flavor,
        isMockTest,
        featureFlag,
        botId);
  }

  AppConfig(
      this.appName,
      this.baseUrl,
      this.msSuffix,
      this.cmsSuffix,
      this.postLoginTokenSuffix,
      this.preLoginTokenUserName,
      this.preLoginTokenPassword,
      this.postLoginTokenUserName,
      this.postLoginTokenPassword,
      this.flavor,
      this.isMockTest,
      this.featureFlag,
      this.botId);
}
