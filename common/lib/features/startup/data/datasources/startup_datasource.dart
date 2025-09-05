import 'dart:convert' show base64, utf8;
import 'package:auth/config/network/api_endpoints.dart';
import 'package:common/features/startup/data/models/applaunch_config_response.dart';
import 'package:common/features/startup/data/models/token_response.dart';
import 'package:common/features/startup/data/models/validate_device_request.dart';
import 'package:common/features/startup/data/models/validate_device_response.dart';
import 'package:core/config/error/failure.dart';
import 'package:core/config/flavor/app_config.dart';
import 'package:core/config/network/dio_client.dart';
import 'package:core/config/network/network_utils.dart';
import 'package:core/utils/pref_utils.dart';
import 'package:dartz/dartz.dart';
class StartUpDataSource {
  DioClient dioClient;
  StartUpDataSource({required this.dioClient});

  Future<Either<Failure, ValidateDeviceResponse>> validateDevice(ValidateDeviceRequest validateDeviceRequest) async {
      final response = await dioClient.postRequest(
          getMsApiUrl(ApiEndpoints.validateDevice),
          converter: (response) =>
              ValidateDeviceResponse.fromJson(response as Map<String, dynamic>),
          data: validateDeviceRequest.toJson(),);

      return response;
    }

  Future<Either<Failure, AppLaunchConfigResponse>> getAppLaunchConfig() async {
      final response = await dioClient.getRequest(
          getMsApiUrl(ApiEndpoints.applaunchConfig),
          converter: (response) => AppLaunchConfigResponse.fromJson(
              response as Map<String, dynamic>,),);
      return response;
    }

  Future<Either<Failure, TokenResponse>> getPreLoginToken() async {

    // TODO code for actual api call
    String username = AppConfig.shared.preLoginTokenUserName;
    String password = AppConfig.shared.preLoginTokenPassword;
    String basicAuth = 'Basic ${base64.encode(utf8.encode('$username:$password'))}';
    var headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': basicAuth,
    };
    var data = {
      'grant_type': 'client_credentials',
    };
    PrefUtils.removeData(PrefUtils.keyToken);
    final response = await dioClient.postRequest(getPreLoginTokenUrl(ApiEndpoints.preLoginToken),
        converter: (response) =>
            TokenResponse.fromJson(response as Map<String, dynamic>), header: headers, data: data,);
    return response;
  }
}
