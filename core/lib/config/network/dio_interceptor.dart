
import 'package:auth/features/login_and_registration/data/datasources/auth_datasource.dart';
import 'package:common/features/startup/data/datasources/startup_datasource.dart';
import 'package:core/config/network/certificate_pinning.dart';
import 'package:core/services/di/injection_container.dart';
import 'package:core/utils/encryption/aes_encryption_utils.dart';
import 'package:core/utils/navigator_service.dart';
import 'package:core/utils/pref_utils.dart';
import 'package:core/utils/utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:core/config/string_resource/Strings.dart';
import '../flavor/feature_flag/feature_flag.dart';
import '../flavor/feature_flag/feature_flag_keys.dart';

class DioInterceptor extends Interceptor {
  CertificatePinning? certificatePin;
  StartUpDataSource? datasource;
  AuthDatasource? authDatasource;
  Dio? dio;

  DioInterceptor(this.dio);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    try {
      certificatePin?.loadCertificate(
          Dio(BaseOptions(baseUrl: options.baseUrl, headers: options.headers)));
    } catch (e) {
      log.d("certificate error  $e");
    }
    String headerMessage = "";
    options.headers.forEach((k, v) => headerMessage += '► $k: $v\n');

    try {
      options.queryParameters.forEach(
        (k, v) => debugPrint(
          '► $k: $v',
        ),
      );
    } catch (_) {}
    try {
      log.d(
        // ignore: unnecessary_null_comparison
        "REQUEST ► ︎ ${options.method != null ? options.method.toUpperCase() : 'METHOD'} ${"${options.baseUrl}${options.path}"}\n\n"
        "Headers:\n"
        "$headerMessage\n"
        "❖ QueryParameters : \n"
        "Body: ${options.data}",
      );
      if (isFeatureEnabled(featureName: featureEnableLogs)) {
        FlutterLogs.logInfo("RestApi", "Request",
            "--------------------------------------------------------------------------------------\n${"${options.baseUrl}${options.path}"}\n${options.data}\n\n");
      }
    } catch (e, stackTrace) {
      log.e("Failed to extract json request $e");
      log.d('error: $e, stackTrace: $stackTrace');
    }

    super.onRequest(options, handler);
  }

  @override
  // ignore: avoid_renaming_method_parameters
  void onError(DioException dioException, ErrorInterceptorHandler handler) {
    log.e(
      "<-- ${dioException.message} ${dioException.response?.requestOptions != null ? (dioException.response!.requestOptions.baseUrl + dioException.response!.requestOptions.path) : 'URL'}\n\n"
      "${dioException.response != null ? dioException.response!.data : 'Unknown Error'}",
    );

    log.d('error: $dioException, stackTrace: ${dioException.stackTrace}');
    if (isFeatureEnabled(featureName: featureEnableLogs)) {
      FlutterLogs.logInfo("RestApi", "Response",
          "${dioException.stackTrace}\n--------------------------------------------------------------------------------------\n");
    }
    super.onError(dioException, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    String headerMessage = "";

    response.headers.forEach((k, v) => headerMessage += '► $k: $v\n');

    log.d(
      // ignore: unnecessary_null_comparison
      "◀ ︎RESPONSE ${response.statusCode} ${response.requestOptions != null ? (response.requestOptions.baseUrl + response.requestOptions.path) : 'URL'}\n\n"
      "Headers:\n"
      "$headerMessage\n"
      "❖ Results : \n"
      "Response: ${response.data}",
    );

    if (response.statusCode == 401) {
      try {
        await refreshToken(response, handler);
      } catch (e) {
        log.d("Exception $e");
      }
    } else {
      super.onResponse(response, handler);
    }
  }

  refreshToken(Response response, handler) async {
    datasource = di.get<StartUpDataSource>();
    authDatasource = di.get<AuthDatasource>();

    final options = response.requestOptions;
    //if (response.data["requestEncryptedData"] != null) {
    final decryptedData = EncryptionUtilsAES.getInstance.decryptPayload(
        payload: options.data["requestEncryptedData"],
        completion: (map) {
          final decryptedData = map;
          response.data = decryptedData;
          super.onResponse(response, handler);
        },
        isAsync: false);
    options.data = decryptedData;

    final mPin = PrefUtils.getString(PrefUtils.keyMpin, "");
    try {
      if (mPin.isEmpty) {
        final result = await datasource?.getPreLoginToken();
        result?.fold((left) => showDialog(), (right) {
          reRequestAPI(right, options);
        });
      } else {
        final result =
            await authDatasource?.getPostLoginToken(getSuperAppId(), mPin);
        result?.fold((l) => showDialog(), (r) {
          reRequestAPI(r, options);
        });
      }
    } catch (e) {
      log.d("Exception $e");
      handler.reject(e as DioException);
    }

    return handler.resolve(await dio!.fetch(options));
  }

  showDialog() {
    displayAlert(NavigatorService.navigatorKey.currentState!.overlay!.context,
        getString(AUTH1001));
  }

  reRequestAPI(rightResult, options) {
    // Navigator.maybePop(
    //     NavigatorService.navigatorKey.currentState!.overlay!.context);
    PrefUtils.removeData(PrefUtils.keyToken);
    PrefUtils.saveString(PrefUtils.keyToken, rightResult.access_token ?? "");
    options.headers['Authorization'] = 'Bearer ${rightResult.access_token}';
  }
}
