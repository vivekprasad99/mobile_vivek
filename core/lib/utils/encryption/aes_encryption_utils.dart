import 'dart:convert';
import 'dart:math';
import 'package:core/utils/encryption/rsa_encryption_utils.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import "package:crypto/crypto.dart" as crypto;
import 'package:encrypt/encrypt.dart';
import 'package:flutter/services.dart';
import 'package:hex/hex.dart';
import 'dart:typed_data';
import "dart:isolate";

class EncryptionUtilsAES {
  late String aesEncryptionKey;
  static late encrypt.Encrypter encrypter;
  static EncryptionUtilsAES? _instance;
  late String _nonce;
  late IV _iv;
  late String encryptedAesKey;

  EncryptionUtilsAES._() {
    aesEncryptionKey = _generateAESKey();
    EncryptionUtilsRSA.getInstance.setRSAPublicKey();
    encryptAesKey();
    _nonce = _getRandomString();
    _iv = _generateIV(_nonce);
    final crypto.Digest aesDigest =
        crypto.sha256.convert(utf8.encode(aesEncryptionKey));
    final res = convertAesToString(aesDigest.bytes as Uint8List);
    String newAesKey = "";
    for (int i = 0; i < 32; i++) {
      newAesKey = newAesKey + res[i];
    }
    encrypt.Key key = encrypt.Key.fromUtf8(newAesKey);
    encrypter = encrypt.Encrypter(AES(key, mode: AESMode.cbc));
  }

  IV _generateIV(String nonce) {
    final base64EncodedStr = base64Encode(nonce.codeUnits);
    return IV.fromBase64(base64EncodedStr);
  }

  String _getRandomString({int length = 16}) {
    Random rnd = Random();
    const chars =
        "AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890";
    return String.fromCharCodes(Iterable.generate(
        length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
  }

  String _generateAESKey({int length = 16}) {
    final Random generator = Random.secure();
    final Uint8List bytes = Uint8List.fromList(
        List.generate(length, (index) => generator.nextInt(256)));
    String hexString =
        bytes.map((e) => e.toRadixString(length).padLeft(2, "0")).join();
    return hexString;
  }

  String getAesKey() {
    return aesEncryptionKey;
  }

  String convertAesToString(Uint8List encodeHash) {
    BigInt number = BigInt.parse(HEX.encode(encodeHash), radix: 16);
    String hexString = number.toRadixString(16);
    return hexString;
  }

  static EncryptionUtilsAES get getInstance =>
      _instance ??= EncryptionUtilsAES._();

  // This is for encrypt the text using AES
  String _encryptPayload({required Map<dynamic, dynamic> payload}) {
    String jsonString = json.encode(payload);
    final encrypted = encrypter.encrypt(jsonString, iv: _iv);
    return encrypted.base64;
  }

  String encryptedPayload({required Map<dynamic, dynamic> payload}) {
    return "$_hexNonce.${_encryptPayload(payload: payload)}";
  }

  String get _hexNonce {
    return HEX.encode(_nonce.codeUnits);
  }

  String bytesToHex(List<int> bytes) {
    return bytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();
  }

  Map<dynamic, dynamic>? decryptPayload(
      {required String payload,
      Function(Map<dynamic, dynamic>)? completion,
      bool isAsync = false}) {
    final crypto.Digest aesDigest =
        crypto.sha256.convert(utf8.encode(aesEncryptionKey));
    final res = convertAesToString(aesDigest.bytes as Uint8List);

    String newAesKey = "";
    for (int i = 0; i < 32; i++) {
      newAesKey = newAesKey + res[i];
    }

    final decrypter = Encrypter(
      AES(Key.fromUtf8(newAesKey), mode: AESMode.cbc),
    );
    final nonce = payload.split(".")[0];
    final encryptedData = payload.split(".")[1];
    final nonceBytes = HEX.decode(nonce);
    final iv = IV(nonceBytes as Uint8List);
    Encrypted encrypted = Encrypted.fromBase64(encryptedData);

    if (isAsync) {
      _decryptUsingIsolate(encrypted, iv, decrypter, (decrypted) {
        if (decrypted == "::ERROR::") {
          // cupertino.debugPrint("payload decrypt error from library");
          completion?.call({});
        } else {
          completion?.call(json.decode(decrypted));
        }
      });

      return null;
    } else {
      final decrypted = decrypter.decrypt(encrypted, iv: iv);
      return json.decode(decrypted);
    }
  }

  void encryptAesKey() async {
    encryptedAesKey = await EncryptionUtilsRSA.getInstance
        .encryptRSA(payload: aesEncryptionKey);
  }

  String get encryptedAESKey {
    return encryptedAesKey;
  }

  String get unencryptedAESKey {
    return aesEncryptionKey;
  }

  // Reason for isolate: https://github.com/leocavalcante/encrypt/issues/64
  // `decrypter.decrypt(encrypted, iv: iv)` block main thread -> Issue is evident when downloading document.
  Future<void> _decryptUsingIsolate(Encrypted encrypted, IV iv,
      Encrypter decrypter, Function(String) completion) async {
    final receivePort = ReceivePort();

    final isolate = await Isolate.spawn(
      _decrypt,
      [encrypted, iv, decrypter, receivePort.sendPort],
    );

    receivePort.listen((message) {
      receivePort.close();
      isolate.kill();
      completion(message);
    });
  }

  void _decrypt(List<Object> arguments) {
    Encrypted encrypted = arguments[0] as Encrypted;
    IV iv = arguments[1] as IV;
    Encrypter decrypter = arguments[2] as Encrypter;
    SendPort sendPort = arguments[3] as SendPort;

    try {
      final decrypted = decrypter.decrypt(encrypted, iv: iv);
      sendPort.send(decrypted);
    } catch (e) {
      sendPort.send("::ERROR::");
    }
  }
}
