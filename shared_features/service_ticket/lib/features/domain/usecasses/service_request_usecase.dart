import 'dart:io';

import 'package:core/config/error/failure.dart';
import 'package:core/config/usecase/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:service_ticket/features/data/models/reopen_case_request.dart';
import 'package:service_ticket/features/data/models/sr_details_request.dart';
import '../../data/models/get_preset_uri_request.dart';
import '../../data/models/get_preset_uri_response.dart';
import '../../data/models/query_subquery_request.dart';
import '../../data/models/query_subquery_response.dart';
import '../../data/models/reopen_case_response.dart';
import '../../data/models/reopen_reason_response.dart';
import '../../data/models/view_sr_request.dart';
import '../../data/models/service_request_response.dart';
import '../../data/models/sr_request.dart';
import '../../data/models/view_sr_response.dart';
import '../repositories/service_request_repository.dart';

class ServiceRequestUseCase extends UseCase<ServiceRequestResponse, SRRequest> {

  final ServiceRequestRepository serviceRequestRepository;

  ServiceRequestUseCase({required this.serviceRequestRepository});

  @override
  Future<Either<Failure, ServiceRequestResponse>> call(
      SRRequest params) async {
    return await serviceRequestRepository.generateServiceRequest(params);
  }


  Future<Either<Failure, FetchQuerySubQueryResponse>> fetchQuerySubQuery(
      FetchQuerySubQueryRequest request) async {
    return await serviceRequestRepository.fetchQuerySubQuery(request);
  }


  Future<Either<Failure, ReopenReasonResponse>> reopeningReason() async {
    return await serviceRequestRepository.reopeningReason();
  }

  Future<Either<Failure, ReopenCaseResponse>> reopenCase(ReopenCaseRequest request) async {
    return await serviceRequestRepository.reopenServiceRequest(request);
  }


  Future<Either<Failure, GetPresetUriResponse>> getPresetUri(GetPresetUriRequest req) async {
    return await serviceRequestRepository.getPresetUri(req);
  }


  Future<Either<Failure, String>> uploadDocument(String presetUrl, File file) async {
    return await serviceRequestRepository.uploadDocument(presetUrl,file);
  }


  Future<Either<Failure, String>> deleteDocument(String presetUrl) async {
    return await serviceRequestRepository.deleteDocument(presetUrl);
  }


  Future<Either<Failure, ViewSRResponse>> viewServiceRequest(
      ViewSRRequest request) async {
    return await serviceRequestRepository.viewServiceRequest(request);
  }
  Future<Either<Failure, ViewSRResponse>> srDetailsBySrNumber(
      SRDetailsRequest request) async {
    return await serviceRequestRepository.srDetailsBySrNumber(request);
  }
}
