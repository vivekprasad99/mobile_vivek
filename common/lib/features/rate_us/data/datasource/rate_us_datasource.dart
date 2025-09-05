import 'package:common/features/rate_us/data/models/rate_us_request.dart';
import 'package:common/features/rate_us/data/models/rate_us_response.dart';
import 'package:common/features/rate_us/data/models/update_rate_us_request.dart';
import 'package:common/features/rate_us/data/models/update_rate_us_response.dart';
import 'package:core/config/network/dio_client.dart';
import 'package:dartz/dartz.dart';
import 'package:core/config/network/network_utils.dart';
import 'package:core/config/error/failure.dart';
import '../../../../config/network/api_endpoints.dart';

class RateUsDatasource {
  DioClient dioClient;

  RateUsDatasource({required this.dioClient});

  Future<Either<Failure, RateUsResponse>> getRateUs(
      RateUsRequest rateUsRequest,) async {
    final response = await dioClient.postRequest(
        getMsApiUrl(ApiEndpoints.getRateUs),
        converter: (response) =>
            RateUsResponse.fromJson(response as Map<String, dynamic>),
        data: rateUsRequest.toJson(),);
    return response;
  }

  Future<Either<Failure, UpdateRateUsResponse>> updateRateUsRecord(
      UpdateRateUsRequest updateRateUsRequest,) async {
    final response = await dioClient.postRequest(
        getMsApiUrl(ApiEndpoints.updateRateUs),
        converter: (response) =>
            UpdateRateUsResponse.fromJson(response as Map<String, dynamic>),
        data: updateRateUsRequest.toJson(),);
    return response;
  }
}
