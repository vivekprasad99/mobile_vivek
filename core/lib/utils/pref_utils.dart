import 'package:core/utils/secure_token_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefUtils {
  static const keyPhoneNumber = "phone_number";
  static const keyMpin = "mpin";
  static const keyTermsCondition = "terms_condition";
  static const keyWAConsent = "wa_consent";
  static const keySelectedLanguage = "app_lang";
  static const keyDeviceId = "device_id";
  static const keyIsCustomer = "isCustomer";
  static const keyIsCustomerProfile = "isCustomerProfile";
  static const keyIsPAN = "isPan";
  static const keyIsMultipleUCIC = "isMultipleUCIC";
  static const keyAuthNavFlow = "authNavFlow";
  static const keyUserName = "userName";
  static const keySuperAppId = "superAppId";
  static const keyToken = "token";
  static const ucic = "ucic";
  static const keyEnableBioMetric = "enableBioMetric";
  static const keyActiveBioMetric = "activeBioMetric";
  static const tollFreeNum = "tollFreeNum";
  static const keyPanLanMaxAttempt = "panLanMaxAttempt";
  static const keyCreateMpinMaxAttempt = "createMpinMaxAttempt";
  static const keyIsTutorialShown = "tutorialShown";
  static const keyRecentSearchList = "recentSearchList";
  static const keyIsGetTollFreeApiCallAgain = "isGetTollFreeApiCallAgain";
  static const keySelectedAppLang = "selectedAppLang";
  static const keyTermsConditionForOffer = "terms_condition";
  static const isAddressSameAsCurrent = "address_same_as_current";
  static const keySelectedProfile = "selectedProfile";
  static const keyWelcomeNotify = "welcomenotify";
  static const keyProfileCount = "profileCount";
  static const keyTypeAheadSearchApiTimeStamp = "typeAheadSearchApiTimeStamp";

  static const emailID = "email_id";
  static const rcAttempts = "rcAttempts";
  static const paymentTat = "paymentTat";

  static SharedPreferences? _sharedPreferences;
  static Future<SharedPreferences> get _instance async =>
      _sharedPreferences ??= await SharedPreferences.getInstance();

  static Future<SharedPreferences?> init() async {
    _sharedPreferences = await _instance;
    return _sharedPreferences;
  }

  void clearPreferencesData() async {
    _sharedPreferences!.clear();
  }

  static saveBool(String key, bool value) {
    _sharedPreferences!.setBool(key, value);
  }

  static saveInt(String key, int value) {
    return _sharedPreferences!.setInt(key, value);
  }

  static saveDouble(String key, double value) {
    return _sharedPreferences!.setDouble(key, value);
  }

  static saveString(String key, String value) {
    if (key == PrefUtils.keyToken) {
      SecureTokenManager.save(value);
      return;
    }
    return _sharedPreferences!.setString(key, value);
  }

  static saveStringList(String key, List<String> value) {
    return _sharedPreferences!.setStringList(key, value);
  }

  static bool getBool(String key, bool defaultValue) {
    return _sharedPreferences?.getBool(key) ?? defaultValue;
  }

  static int getInt(String key, int defaultValue) {
    return _sharedPreferences?.getInt(key) ?? defaultValue;
  }

  static double getDouble(String key, double defaultValue) {
    return _sharedPreferences?.getDouble(key) ?? defaultValue;
  }

  static String getString(String key, String defaultValue) {
    if (key == PrefUtils.keyToken) {
      return SecureTokenManager.token;
    }
    return _sharedPreferences?.getString(key) ?? defaultValue;
  }

  static List<String> getStringList(
    String key,
  ) {
    return _sharedPreferences?.getStringList(key) ?? [];
  }

  static removeData(String key) {
    if (key == PrefUtils.keyToken) {
      SecureTokenManager.remove();
      return '';
    }
    _sharedPreferences?.remove(key);
  }

  static Future<void> setThemeData(String value) {
    return _sharedPreferences!.setString('themeData', value);
  }

  static String getThemeData() {
    try {
      return _sharedPreferences!.getString('themeData')??'primary';
    } catch (e) {
      return 'primary';
    }
  }

  static Future<bool> setDarkTheme(bool value) async =>
      await _sharedPreferences!.setBool("isDark", value);

  static bool isDarkTheme() => _sharedPreferences!.getBool("isDark") ?? false;
}
