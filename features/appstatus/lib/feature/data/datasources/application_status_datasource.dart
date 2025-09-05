import 'package:appstatus/config/network/api_endpoints.dart';
import 'package:appstatus/feature/data/models/application_status_category_response.dart';
import 'package:appstatus/feature/data/models/application_status_request.dart';
import 'package:appstatus/feature/data/models/application_status_response.dart';
import 'package:core/config/error/failure.dart';
import 'package:core/config/network/dio_client.dart';
import 'package:core/config/network/network_utils.dart';
import 'package:dartz/dartz.dart';

class ApplicationStatusDataSource {
  DioClient dioClient;
  ApplicationStatusDataSource({required this.dioClient});

  Future<Either<Failure, ApplicationStatusResponse>> getApplicationStatus(
      ApplicationStatusRequest applicationStatusRequest) async {
      final response = await dioClient.postRequest(
          getMsApiUrl(ApiEndpoints.getApplicationStatus),
          converter: (response) => ApplicationStatusResponse.fromJson(
              response as Map<String, dynamic>),
          data: applicationStatusRequest.toJson());
      return response;
    }

  Future<Either<Failure, ApplicationStatusCategoryResponse>>
      getApplicationStatusCategory() async {
      final response = await dioClient.getRequest(
          getMsApiUrl(ApiEndpoints.getApplicationStatusCategory),
          converter: (response) => ApplicationStatusCategoryResponse.fromJson(
              response as Map<String, dynamic>));
      return response;
    }
  }
