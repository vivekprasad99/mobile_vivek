import "package:core/config/network/network_utils.dart";
import "package:core/utils/helper/log.dart";
import "package:dio/dio.dart";
import "package:flutter/foundation.dart";
import "aes_encryption_utils.dart";

class EncryptionInterceptor extends Interceptor {
  EncryptionInterceptor();

  bool cryptoEnabled({required String endpoint}) {
    return !isCMSApi(endpoint);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    var payload = options.data;
    if (cryptoEnabled(endpoint: options.path)) {
      options.headers['x-encryption-key'] =
          EncryptionUtilsAES.getInstance.encryptedAESKey;

      if (options.data.runtimeType != Null) {
        payload = EncryptionUtilsAES.getInstance
            .encryptedPayload(payload: options.data);
      }
    }
    if (payload != null) {
      options.data = {"requestEncryptedData": payload};
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.data["responseEncryptedData"] != null) {
      response.data = response.data["responseEncryptedData"];
      if (cryptoEnabled(endpoint: response.requestOptions.path)) {
        try {
          final decryptedData = EncryptionUtilsAES.getInstance.decryptPayload(
              payload: response.data,
              completion: (map) {
                final decryptedData = map;
                response.data = decryptedData;
                super.onResponse(response, handler);
              },
              isAsync: false);
          response.data = decryptedData;
          if (kDebugMode) {
            log.i(response);
          }
          super.onResponse(response, handler);
        } catch (e, s) {
          if (kDebugMode) {
            log.i(response);
            log.e(e, stackTrace: s);
          }
          super.onResponse(response, handler);
        }
      }
    } else {
      super.onResponse(response, handler);
    }
  }
}
