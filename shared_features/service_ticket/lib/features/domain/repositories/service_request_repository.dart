import 'dart:io';

import 'package:core/config/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:service_ticket/features/data/models/reopen_case_request.dart';
import 'package:service_ticket/features/data/models/reopen_case_response.dart';
import 'package:service_ticket/features/data/models/sr_details_request.dart';
import '../../data/models/get_preset_uri_request.dart';
import '../../data/models/get_preset_uri_response.dart';
import '../../data/models/query_subquery_request.dart';
import '../../data/models/query_subquery_response.dart';
import '../../data/models/reopen_reason_response.dart';
import '../../data/models/view_sr_request.dart';
import '../../data/models/service_request_response.dart';
import '../../data/models/sr_request.dart';
import '../../data/models/view_sr_response.dart';

abstract class ServiceRequestRepository {
  Future<Either<Failure, FetchQuerySubQueryResponse>> fetchQuerySubQuery(
      FetchQuerySubQueryRequest request);

  Future<Either<Failure, ReopenReasonResponse>> reopeningReason();

  Future<Either<Failure, GetPresetUriResponse>> getPresetUri(
      GetPresetUriRequest req);

  Future<Either<Failure, String>> uploadDocument(String presetUri, File file);

  Future<Either<Failure, String>> deleteDocument(String presetUri);

  Future<Either<Failure, ServiceRequestResponse>> generateServiceRequest(
      SRRequest request);

  Future<Either<Failure, ViewSRResponse>> viewServiceRequest(
      ViewSRRequest request);

  Future<Either<Failure, ReopenCaseResponse>> reopenServiceRequest(
      ReopenCaseRequest request);

  Future<Either<Failure, ViewSRResponse>> srDetailsBySrNumber(
      SRDetailsRequest request);
}
