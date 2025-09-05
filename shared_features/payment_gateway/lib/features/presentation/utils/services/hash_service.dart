import 'package:payment_gateway/features/data/models/payment_cred_response_model.dart';
import 'package:payu_checkoutpro_flutter/PayUConstantKeys.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class HashService {
static String merchantSalt = "";
static void setSalt({required bool isPennant, required Payu payu}){
    if(isPennant){
        merchantSalt = payu.personalLoan.hashToken;
    }else{
        merchantSalt = payu.vehicleLoan.hashToken;
    }
}
static const merchantSecretKey = "";// Add Merchant Secrete Key - Optional

  static Map generateHash(Map response) {

    
    var hashName = response[PayUHashConstantsKeys.hashName];
    var hashStringWithoutSalt = response[PayUHashConstantsKeys.hashString];
    var hashType = response[PayUHashConstantsKeys.hashType];
    var postSalt = response[PayUHashConstantsKeys.postSalt];

    var hash = "";

    if (hashType == PayUHashConstantsKeys.hashVersionV2) {
      hash = getHmacSHA256Hash(hashStringWithoutSalt, merchantSalt);
    } else if (hashName == PayUHashConstantsKeys.mcpLookup) {
      hash = getHmacSHA1Hash(hashStringWithoutSalt, merchantSecretKey);
    } else {
      var hashDataWithSalt = hashStringWithoutSalt + merchantSalt;
      if (postSalt != null) {
        hashDataWithSalt = hashDataWithSalt + postSalt;
      }
      hash = getSHA512Hash(hashDataWithSalt);
    }
    //Don't use this method, get the hash from your backend.
    var finalHash = {hashName: hash};
    return finalHash;
  }

  //Don't use this method get the hash from your backend.
  static String getSHA512Hash(String hashData) {
    var bytes = utf8.encode(hashData); // data being hashed
    var hash = sha512.convert(bytes);
    return hash.toString();
  }

  //Don't use this method get the hash from your backend.
  static String getHmacSHA256Hash(String hashData, String salt) {
    var key = utf8.encode(salt);
    var bytes = utf8.encode(hashData);
    final hmacSha256 = Hmac(sha256, key)
      .convert(bytes)
      .bytes;
    final hmacBase64 = base64Encode(hmacSha256);
    return hmacBase64;
  }

  static String getHmacSHA1Hash(String hashData, String salt) {
    var key = utf8.encode(salt);
    var bytes = utf8.encode(hashData);
    var hmacSha1 = Hmac(sha1, key); // HMAC-SHA1
    var hash = hmacSha1.convert(bytes);
    return hash.toString();
  }
}