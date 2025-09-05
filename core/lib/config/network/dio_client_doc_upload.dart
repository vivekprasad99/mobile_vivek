import 'dart:io';
import 'package:core/utils/helper/log.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../error/failure.dart';
import 'package:path/path.dart';

typedef ResponseConverter<T> = T Function(dynamic response);

class DioClientDocUpload {
  bool _isUnitTest = false;
  late Dio _dio;

  DioClientDocUpload({bool isUnitTest = false}) {
    _isUnitTest = isUnitTest;

    _dio = _createDio();
  }

  Dio get dio {
    if (_isUnitTest) {
      return _dio;
    } else {

      final dio = _createDio();

      return dio;
    }
  }

  Dio _createDio() => Dio(
        BaseOptions(
          receiveTimeout: const Duration(minutes: 1),
          connectTimeout: const Duration(minutes: 1),
          validateStatus: (int? status) {
            return status! > 0;
          },
        ),
      );

  Future<Either<Failure, String>> uploadDocument<T>(
      String url, File file) async {
    try {
      String filename= basename(file.path);
      var len = await file.length();
      var response = await dio.put(url,
          data: file.openRead(),
          options: Options(headers: {
            Headers.contentLengthHeader: len,
          } // set content-length
          ));
      if ((response.statusCode ?? 0) < 200 ||
          (response.statusCode ?? 0) > 201) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
        );
      }

      return Right(filename);
    } on DioException catch (e, stackTrace) {
      if (!_isUnitTest) {
        log.d('error: $e, stackTrace: $stackTrace');
      }
      if (e.response?.data['fault'] != null) {
        return Left(
          ServerFailure(
            e.response?.data['fault']['faultstring'],
          ),
        );
      }
      return Left(
        ServerFailure(
          e.response?.data['error'] as String? ?? e.message,
        ),
      );
    }
  }

  Future<Either<Failure, String>> deleteDocument<T>(String url) async {
    try {
      var response = await dio.delete(url);
      if ((response.statusCode ?? 0) < 200 ||
          (response.statusCode ?? 0) > 204) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
        );
      }

      return Right(url);
    } on DioException catch (e, stackTrace) {
      if (!_isUnitTest) {
        log.d('error: $e, stackTrace: $stackTrace');
      }
      if (e.response?.data['fault'] != null) {
        return Left(
          ServerFailure(
            e.response?.data['fault']['faultstring'],
          ),
        );
      }
      return Left(
        ServerFailure(
          e.response?.data['error'] as String? ?? e.message,
        ),
      );
    }
  }
}
