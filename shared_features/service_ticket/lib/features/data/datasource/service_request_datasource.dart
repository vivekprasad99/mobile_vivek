import 'dart:convert';
import 'dart:io';
import 'package:core/config/error/failure.dart';
import 'package:core/config/flavor/feature_flag/feature_flag.dart';
import 'package:core/config/flavor/feature_flag/feature_flag_keys.dart';
import 'package:core/config/network/dio_client.dart';
import 'package:core/config/network/dio_client_doc_upload.dart';
import 'package:core/config/network/network_utils.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';
import 'package:service_ticket/features/data/models/reopen_case_request.dart';
import 'package:service_ticket/features/data/models/sr_details_request.dart';
import '../../../../config/network/api_endpoints.dart';
import '../../constants/sr_constant.dart';
import '../models/get_preset_uri_request.dart';
import '../models/get_preset_uri_response.dart';
import '../models/query_subquery_request.dart';
import '../models/query_subquery_response.dart';
import '../models/reopen_case_response.dart';
import '../models/reopen_reason_response.dart';
import '../models/view_sr_request.dart';
import '../models/service_request_response.dart';
import '../models/sr_request.dart';
import '../models/view_sr_response.dart';

class ServiceRequestDatasource {
  DioClient dioClient;
  DioClientDocUpload dioClientUnc;
  ServiceRequestDatasource(
      {required this.dioClient, required this.dioClientUnc});

  Future<Either<Failure, FetchQuerySubQueryResponse>>
      fetchQuerySubQuery(FetchQuerySubQueryRequest request) async {
    //if (isFeatureEnabled(featureName: featureEnableStubData)) {
      final fetchQuerySubQueryStubData = await rootBundle
          .loadString('assets/stubdata/service_requests/${request.type}.json');
      final body = json.decode(fetchQuerySubQueryStubData);
      Either<Failure, FetchQuerySubQueryResponse> response = Right(
          FetchQuerySubQueryResponse.fromJson(body as Map<String, dynamic>));
      return response;
    // } else {
    //   final response = await dioClient.getRequest(
    //     getCMSApiUrl(ApiEndpoints.querySubQuery, category: request.type),
    //     converter: (response) => FetchQuerySubQueryResponse.fromJson(
    //         response as Map<String, dynamic>),
    //   );
    //   return response;
    // }
  }

  Future<Either<Failure, GetPresetUriResponse>> getPresetUri(
      GetPresetUriRequest request) async {
    if (isFeatureEnabled(featureName: featureEnableStubData)) {
      String fileName = request.useCase == SRConst.deleteDocument
          ? 'assets/stubdata/ach/get_preset_uri_delete.json'
          : 'assets/stubdata/ach/get_preset_uri.json';
      final loginStubData = await rootBundle.loadString(fileName);
      final body = json.decode(loginStubData);
      Either<Failure, GetPresetUriResponse> response =
          Right(GetPresetUriResponse.fromJson(body as Map<String, dynamic>));
      return response;
    } else {
      final response = await dioClient.postRequest(
          getMsApiUrl(ApiEndpoints.getPresetUri),
          converter: (response) =>
              GetPresetUriResponse.fromJson(response as Map<String, dynamic>),
          data: request.toJson());
      return response;
    }
  }

  Future<Either<Failure, String>> uploadDocument(
      String presetUri, File file) async {
    final response = await dioClientUnc.uploadDocument(presetUri, file);
    return response;
  }

  Future<Either<Failure, String>> deleteDocuments(String presetUri) async {
    final response = await dioClientUnc.deleteDocument(presetUri);
    return response;
  }

  Future<Either<Failure, ServiceRequestResponse>> generateServiceRequest(
      SRRequest request) async {
    if (isFeatureEnabled(featureName: featureEnableStubData)) {
      final getLoansStubData = await rootBundle
          .loadString('assets/stubdata/foreclosure/generate_sr.json');
      final body = json.decode(getLoansStubData);
      Either<Failure, ServiceRequestResponse> response =
          Right(ServiceRequestResponse.fromJson(body as Map<String, dynamic>));
      return response;
    } else {
      final response = await dioClient.postRequest(
          getMsApiUrl(ApiEndpoints.createCase),
          converter: (response) =>
              ServiceRequestResponse.fromJson(response as Map<String, dynamic>),
          data: request.toJson());
      return response;
    }
  }

  Future<Either<Failure, ViewSRResponse>> viewServiceRequest(
      ViewSRRequest request) async {
    if (isFeatureEnabled(featureName: featureEnableStubData)) {
      final viewServiceRequestStubData = await rootBundle.loadString(
          'assets/stubdata/service_requests/view_service_requests.json');
      final body = json.decode(viewServiceRequestStubData);
      Either<Failure, ViewSRResponse> response =
          Right(ViewSRResponse.fromJson(body as Map<String, dynamic>));
      return response;
    } else {
      final response = await dioClient.postRequest(
          getMsApiUrl(ApiEndpoints.viewServiceRequest),
          converter: (response) =>
              ViewSRResponse.fromJson(response as Map<String, dynamic>),
          data: request.toJson());
      return response;
    }
  }

  Future<Either<Failure, ReopenReasonResponse>> reopeningReason() async {
    final response = await dioClient.getRequest(
        getCMSApiUrl(ApiEndpoints.reopenReasons,
            category: 'reason_for_reopening'),
        converter: (response) =>
            ReopenReasonResponse.fromJson(response as Map<String, dynamic>));
    return response;
  }

  Future<Either<Failure, ReopenCaseResponse>> reopenCase(
      ReopenCaseRequest request) async {
    if (isFeatureEnabled(featureName: featureEnableStubData)) {
      final reopenServiceRequestStubData = await rootBundle.loadString(
          'assets/stubdata/service_requests/reopen_service_request.json');
      final body = json.decode(reopenServiceRequestStubData);
      Either<Failure, ReopenCaseResponse> response =
          Right(ReopenCaseResponse.fromJson(body as Map<String, dynamic>));
      return response;
    } else {
      final response = await dioClient.postRequest(
          getMsApiUrl(ApiEndpoints.reopenCase),
          converter: (response) =>
              ReopenCaseResponse.fromJson(response as Map<String, dynamic>),
          data: request.toJson());
      return response;
    }
  }

  Future<Either<Failure, ViewSRResponse>> srDetailsBySrNumber(
      SRDetailsRequest request) async {
    if (isFeatureEnabled(featureName: featureEnableStubData)) {
      final viewServiceRequestStubData = await rootBundle.loadString(
          'assets/stubdata/service_requests/view_service_requests.json');
      final body = json.decode(viewServiceRequestStubData);
      Either<Failure, ViewSRResponse> response =
      Right(ViewSRResponse.fromJson(body as Map<String, dynamic>));
      return response;
    } else {
      final response = await dioClient.postRequest(
          getMsApiUrl(ApiEndpoints.srDetailsByNumber),
          converter: (response) =>
              ViewSRResponse.fromJson(response as Map<String, dynamic>),
          data: request.toJson());
      return response;
    }
  }
}
