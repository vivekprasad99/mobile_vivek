import 'package:core/utils/encryption/preference_helper.dart';
import 'package:fast_rsa/fast_rsa.dart' as fast_rsa;

class EncryptionUtilsRSA {
  static EncryptionUtilsRSA? _instance;
  String publicKey = '';

  Future<String> getEncryptedAESKey(String aesKey) {
    return encryptRSA(payload: aesKey);
  }

  EncryptionUtilsRSA._();

  Future<void> setRSAPublicKey() async {
    await PreferencesHelper.getRSAPublicKey()
        .then((value) => publicKey = value);
  }

  static EncryptionUtilsRSA get getInstance =>
      _instance ??= EncryptionUtilsRSA._();

  Future<String> encryptRSA({required payload}) async {
    publicKey = await PreferencesHelper.getRSAPublicKey();
    String encryptKey = await fast_rsa.RSA.encryptPKCS1v15(payload, publicKey);
    return encryptKey;
  }
}
