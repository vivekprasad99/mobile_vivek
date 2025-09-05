import 'package:core/config/flavor/app_config.dart';
import 'package:core/config/flavor/feature_flag/feature_flag.dart';
import 'package:core/config/string_resource/config.dart';
import 'package:core/utils/const.dart';
import 'package:core/utils/utils.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_logs/flutter_logs.dart';

import '../../utils/encryption/encryption_interceptor.dart';
import '../error/failure.dart';
import '../flavor/feature_flag/feature_flag_keys.dart';
import 'dio_interceptor.dart';
import 'isolate_parser.dart';

typedef ResponseConverter<T> = T Function(dynamic response);

class DioClient {
  String? _auth;
  String? _token;
  bool _isUnitTest = false;
  late Dio _dio;
  bool hasTokenGenerated = true;

  DioClient({bool isUnitTest = false}) {
    _isUnitTest = isUnitTest;

    try {
      _auth = 'Bearer ${getAccessToken()}';
    } catch (_) {}

    _dio = _createDio();

    if (!_isUnitTest) _dio.interceptors.add(DioInterceptor(_dio));
  }

  Dio get dio {
    if (_isUnitTest) {
      return _dio;
    } else {
      try {
         _token = getAccessToken();
        _auth = 'Bearer $_token';
      } catch (_) {}

      if (_token != null && _token!.isNotEmpty) {
        hasTokenGenerated = true;
      } else {
        hasTokenGenerated = false;
      }
      final dio = _createDio();

      if (!_isUnitTest) dio.interceptors.add(DioInterceptor(dio));
      if (hasTokenGenerated) {
        dio.interceptors.add(EncryptionInterceptor());
      }

      return dio;
    }
  }

  Dio _createDio() => Dio(
        BaseOptions(
          baseUrl: AppConfig.shared.baseUrl,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            if (_auth != null) ...{
              'Authorization': _auth,
            },
          },
          receiveTimeout: const Duration(minutes: 1),
          connectTimeout: const Duration(minutes: 1),
          validateStatus: (int? status) {
            return status! > 0;
          },
        ),
      );

  Future<Either<Failure, T>> getRequest<T>(
    String url, {
    Map<String, dynamic>? queryParameters,
    required ResponseConverter<T> converter,
    bool isIsolate = true,
  }) async {
    try {
      final response = await dio.get(url, queryParameters: queryParameters);
      if (isFeatureEnabled(featureName: featureEnableLogs)) {
        FlutterLogs.logInfo("RestApi", "Response",
            "$response\n--------------------------------------------------------------------------------------\n");
      }
      if ((response.statusCode ?? 0) < 200 ||
          (response.statusCode ?? 0) > 201) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
        );
      }

      if (!isIsolate) {
        return Right(converter(response.data));
      }
      final isolateParse = IsolateParser<T>(
        response.data as Map<String, dynamic>,
        converter,
      );
      final result = await isolateParse.parseInBackground();
      return Right(result);
    } on DioException catch (e, stackTrace) {
      if (!_isUnitTest) {
        log.d('error: $e, stackTrace: $stackTrace');
      }
      if (e.response != null && e.response?.data != null) {
        if (e.response?.data['errors'] != null &&
            e.response?.data['errors'][0] != null &&
            e.response?.data['errors'][0]["statusCode"] != null &&
            e.response?.data['errors'][0]["statusCode"] ==
                AppConst.preConditionFailServerError) {
          return Left(
            ServerFailure(
                statusCode: e.response?.statusCode.toString(),
                e.response?.data['errors'][0]["statusMessage"] ?? e.message),
          );
        } else if (e.response?.data['fault'] != null) {
          return Left(
            ServerFailure(
              statusCode: e.response?.statusCode.toString(),
              e.response?.data['fault']['faultstring'],
            ),
          );
        }
        return Left(
          ServerFailure(
              statusCode: e.response?.statusCode.toString(),
              e.response?.data['error'] as String? ?? e.message),
        );
      } else {
        return Left(ServerFailure(e.message));
      }
    }
  }

  Future<Either<Failure, T>> postRequest<T>(
    String url, {
    Map<String, dynamic>? data,
    required ResponseConverter<T> converter,
    bool isIsolate = true,
    Map<String, dynamic>? header,
  }) async {
    try {
      final response = header != null
          ? await dio.post(url, data: data, options: Options(headers: header))
          : await dio.post(url, data: data);
      if (isFeatureEnabled(featureName: featureEnableLogs)) {
        FlutterLogs.logInfo("RestApi", "Response",
            "$response\n--------------------------------------------------------------------------------------\n");
      }
      if ((response.statusCode ?? 0) < 200 ||
          (response.statusCode ?? 0) > 201) {
        throw DioException(
            requestOptions: response.requestOptions,
            response: response,
            message: getString(msgSomethingWentWrong));
      }

      if (!isIsolate) {
        return Right(converter(response.data));
      }
      final isolateParse = IsolateParser<T>(
        response.data as Map<String, dynamic>,
        converter,
      );
      final result = await isolateParse.parseInBackground();
      return Right(result);
    } on DioException catch (e, stackTrace) {
      if (!_isUnitTest) {
        log.d('error: $e, stackTrace: $stackTrace');
      }
      if (e.response != null && e.response?.data != null) {
        if (e.response?.data['errors'] != null &&
            e.response?.data['errors'][0] != null &&
            e.response?.data['errors'][0]["statusCode"] != null &&
            e.response?.data['errors'][0]["statusCode"] == AppConst.preConditionFailServerError || e.response?.data['errors'][0]["statusCode"] == AppConst.badRequest) {
          return Left(
            ServerFailure(
                e.response?.data['errors'][0]["statusMessage"] ?? e.message),
          );
        } else if (e.response?.data['fault'] != null) {
          return Left(
            ServerFailure(
              e.response?.data['fault']['faultstring'],
            ),
          );
        }
        return Left(
          ServerFailure(e.response?.data['error'] as String? ?? e.message),
        );
      } else {
        return Left(ServerFailure(e.message));
      }
    }
  }
}
