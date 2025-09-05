import 'dart:convert';
import 'package:core/config/error/failure.dart';
import 'package:core/config/network/dio_client.dart';
import 'package:core/config/network/network_utils.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';
import 'package:help/features/data/models/help_request.dart';
import 'package:help/features/data/models/help_response.dart';
import '../../../../config/network/api_endpoints.dart';


class HelpDataSource {
  DioClient dioClient;

  HelpDataSource({required this.dioClient});

  Future<Either<Failure, HelpResponse>> getHelpData(
      HelpRequest request) async {
    if (true) {
      final getFAQStubData =
      await rootBundle.loadString('assets/stubdata/faq/help.json');
      final body = json.decode(getFAQStubData);
      Either<Failure, HelpResponse> response =
      Right(HelpResponse.fromJson(body as Map<String, dynamic>));
      return response;
    } else {
      // TODO code for actual api call
      final response = await dioClient.getRequest(
        getCMSApiUrl(ApiEndpoints.getHelp),
        converter: (response) =>
            HelpResponse.fromJson(response as Map<String, dynamic>),
      );
      return response;
    }
  }
}
