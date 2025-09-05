import 'package:common/features/privacy_policy/data/models/get_privacy_policy_request.dart';
import 'package:common/features/privacy_policy/data/models/get_privacy_policy_response.dart';
import 'package:core/config/error/failure.dart';
import 'package:core/config/network/dio_client.dart';
import 'package:core/config/network/network_utils.dart';
import 'package:dartz/dartz.dart';
import '../../../../config/network/api_endpoints.dart';

class PrivacyPolicyDataSource {
  DioClient dioClient;
  PrivacyPolicyDataSource({required this.dioClient});
  Future<Either<Failure, GetPrivacyPolicyResponse>> getPrivacyPolicy(
      GetPrivacyPolicyRequest request,) async {
      final response = await dioClient.getRequest(
          getCMSApiUrl(ApiEndpoints.staticContent,category: 'privacy_policy'),
          converter: (response) =>
              GetPrivacyPolicyResponse.fromJson(response as Map<String, dynamic>),
          );
      return response;
    }
  }

