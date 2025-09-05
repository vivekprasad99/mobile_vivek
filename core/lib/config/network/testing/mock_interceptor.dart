import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';

class MockInterceptor extends Interceptor {
  static const _jsonDir = '../../../../../test/stub/';
  static const _jsonExtension = '.json';

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final endpoint = options.path.split("/").reversed.first;
    final resourcePath = _jsonDir + endpoint + _jsonExtension;
    final data = await rootBundle.load(resourcePath);
    final map = json.decode(
      utf8.decode(
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
      ),
    );
    super.onResponse(map, ResponseInterceptorHandler());
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    final endpoint = response.requestOptions.path.split("/").reversed.first;
    final resourcePath = _jsonDir + endpoint + _jsonExtension;
    final data = await rootBundle.load(resourcePath);
    final map = json.decode(
      utf8.decode(
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
      ),
    );

    super.onResponse(map, handler);
  }
}
