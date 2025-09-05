import 'package:core/config/network/dio_client.dart';
import 'package:core/features/app_content/config/network/api_endpoints.dart';
import 'package:core/features/app_content/data/model/app_content_response.dart';
import 'package:dartz/dartz.dart';
import '../../../../config/error/failure.dart';
import '../../../../config/network/network_utils.dart';

class AppContentDataSource {
  AppContentDataSource({required this.dioClient});
  DioClient dioClient;

  Future<Either<Failure, AppContentResponse>> getTollFreeNum() async {
      final response = await dioClient.getRequest(
        getCMSApiUrl(ApiEndpoints.tollNumber),
        converter: (response) => AppContentResponse.fromJson(
            response["data"] as Map<String, dynamic>),
      );
      return response;
  }
}
