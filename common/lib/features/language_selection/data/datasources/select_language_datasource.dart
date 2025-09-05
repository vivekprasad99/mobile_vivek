import 'dart:convert';

import 'package:common/features/language_selection/data/models/app_label_request.dart';
import 'package:common/features/language_selection/data/models/app_labels_response.dart';
import 'package:core/config/error/failure.dart';
import 'package:core/config/flavor/feature_flag/feature_flag.dart';
import 'package:core/config/flavor/feature_flag/feature_flag_keys.dart';
import 'package:core/config/network/dio_client.dart';
import 'package:core/config/network/network_utils.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';
import '../../../../config/network/api_endpoints.dart';
import '../models/language_response.dart';
import '../models/update_device_lang_request.dart';
import '../models/update_device_lang_response.dart';

class SelectLanguageDataSource {
  DioClient dioClient;

  SelectLanguageDataSource({required this.dioClient});

  Future<Either<Failure, SelectLanguageResponse>> getAppLanguages() async {
      final response = await dioClient.getRequest(getCMSApiUrl(ApiEndpoints.getAppLanguages),
          converter: (response) =>
              SelectLanguageResponse.fromJson(response as Map<String, dynamic>),);
      return response;
    }

  Future<Either<Failure, AppLabelsResponse>> getAppLabels(
      AppLabelRequest appLabelRequest,) async {
      final response = await dioClient.getRequest(
          getCMSApiUrl(ApiEndpoints.getAppLabels),
          converter: (response) =>
              AppLabelsResponse.fromJson(response as Map<String, dynamic>),);
      return response;
    }

  Future<Either<Failure, UpdateDeviceLangResponse>> updateDeviceLanguage(
      UpdateUserLangRequest request) async {
    if (isFeatureEnabled(featureName: featureEnableStubData)) {
      final appLabelStubData =
      await rootBundle.loadString('assets/stubdata/update_app_language.json');
      final body = json.decode(appLabelStubData);
      Either<Failure, UpdateDeviceLangResponse> response =
      Right(UpdateDeviceLangResponse.fromJson(body as Map<String, dynamic>));
      return response;
    } else {
      final response = await dioClient.postRequest(getMsApiUrl(ApiEndpoints.updateDeviceLang),
          converter: (response) =>
              UpdateDeviceLangResponse.fromJson(response as Map<String, dynamic>), data: request.toJson());
      return response;
    }
  }
  }
