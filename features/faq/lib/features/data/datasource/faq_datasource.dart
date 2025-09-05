import 'package:core/config/error/failure.dart';
import 'package:core/config/network/dio_client.dart';
import 'package:core/config/network/network_utils.dart';
import 'package:dartz/dartz.dart';
import 'package:faq/config/network/api_endpoints.dart';
import '../models/faq_request.dart';
import '../models/faq_response.dart';

class FAQDataSource {
  DioClient dioClient;
  FAQDataSource({required this.dioClient});

  Future<Either<Failure, FAQResponse>> getFAQ(FAQRequest request) async {
      final response = await dioClient.getRequest(
        getCMSApiUrl(ApiEndpoints.getFAQ),
        converter: (response) =>
            FAQResponse.fromJson(response as Map<String, dynamic>),
      );
      return response;
    }
}
