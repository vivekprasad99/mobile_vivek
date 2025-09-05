import 'package:core/utils/pref_utils.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureTokenManager {
  SecureTokenManager._();

  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  static String _token = '';

  static String get token => _token;

  static Future<void> init() async {
    _token = await _storage.read(key: PrefUtils.keyToken) ?? '';
  }

  static void save(String value) {
    _token = value;
    _storage.write(key: PrefUtils.keyToken, value: value);
  }

  static void remove() {
    _token = '';
    _storage.delete(key: PrefUtils.keyToken);
  }
}
