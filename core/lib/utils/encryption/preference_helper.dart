import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const publicKey = 'publicKey';
const biometricKey = 'biometricKey';


class PreferencesHelper {
  static const token = 'token';

  static const storage = FlutterSecureStorage(
      aOptions: AndroidOptions(
    encryptedSharedPreferences: true,
  ));

  static Future<void> setPreference(String key, dynamic value) async {
    await storage.write(key: key, value: value.toString());
  }

  static Future<void> removeKey(String key) async {
    await storage.delete(key: key);
  }

  static Future<String> getPreferenceAsString(String key,
      {dynamic defaultValue = ''}) async =>
      await storage.read(key: key).then((value) {
        if (value == null) return defaultValue;
        return value;
      });

  static Future<void> setRSAPublicKey(String value) async {
    await setPreference(
      publicKey,
      "-----BEGIN RSA PUBLIC KEY-----\n$value\n-----END RSA PUBLIC KEY-----",
    );
  }

  static Future<String> getBiometricKey() async =>
      await getPreferenceAsString(biometricKey);

  static Future<void> setBiometricKey(String value) async {
    await setPreference(
      biometricKey,
      value,
    );
  }

  static Future<String> getRSAPublicKey() async =>
      await getPreferenceAsString(publicKey);

  
}
