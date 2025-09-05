import 'package:core/config/error/failure.dart';
import 'package:core/config/network/dio_client.dart';
import 'package:core/config/network/network_utils.dart';
import 'package:dartz/dartz.dart';
import '../../../../config/network/api_endpoints.dart';
import '../models/terms_conditions_request.dart';
import '../models/terms_conditions_response.dart';

class TermsConditionsDataSource {
  DioClient dioClient;
  TermsConditionsDataSource({required this.dioClient});
  Future<Either<Failure, TermsConditionsResponse>> getTermsConditions(
      TermsConditionsRequest request,) async {
      final response = await dioClient.getRequest(
        getCMSApiUrl(ApiEndpoints.staticContent, category: 'legal_notice'),
        converter: (response) =>
            TermsConditionsResponse.fromJson(response as Map<String, dynamic>),
      );
      return response;
    }
  }
