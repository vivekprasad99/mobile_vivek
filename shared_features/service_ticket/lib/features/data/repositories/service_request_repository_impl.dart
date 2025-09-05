import 'dart:io';
import 'package:core/config/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:service_ticket/features/data/models/reopen_case_request.dart';
import 'package:service_ticket/features/data/models/reopen_case_response.dart';
import 'package:service_ticket/features/data/models/sr_details_request.dart';
import '../../domain/repositories/service_request_repository.dart';
import '../datasource/service_request_datasource.dart';
import '../models/get_preset_uri_request.dart';
import '../models/get_preset_uri_response.dart';
import '../models/query_subquery_request.dart';
import '../models/query_subquery_response.dart';
import '../models/reopen_reason_response.dart';
import '../models/view_sr_request.dart';
import '../models/service_request_response.dart';
import '../models/sr_request.dart';
import '../models/view_sr_response.dart';

class ServiceRequestRepositoryImpl extends ServiceRequestRepository {
  ServiceRequestRepositoryImpl({required this.datasource});

  final ServiceRequestDatasource datasource;

  @override
  Future<Either<Failure, ViewSRResponse>> viewServiceRequest(
      ViewSRRequest request) async {
    final result = await datasource.viewServiceRequest(request);
    return result.fold((left) => Left(left), (right) => Right(right));
  }

  @override
  Future<Either<Failure, FetchQuerySubQueryResponse>> fetchQuerySubQuery(
      FetchQuerySubQueryRequest request) async {
    final result = await datasource.fetchQuerySubQuery(request);
    return result.fold((left) => Left(left), (right) => Right(right));
  }

  @override
  Future<Either<Failure, ReopenReasonResponse>> reopeningReason() async {
    final result = await datasource.reopeningReason();
    return result.fold((left) => Left(left), (right) => Right(right));
  }

  @override
  Future<Either<Failure, GetPresetUriResponse>> getPresetUri(
      GetPresetUriRequest req) async {
    final result = await datasource.getPresetUri(req);
    return result.fold((left) => Left(left), (right) => Right(right));
  }

  @override
  Future<Either<Failure, String>> uploadDocument(
      String presetUri, File file) async {
    final result = await datasource.uploadDocument(presetUri, file);
    return result.fold((left) => Left(left), (right) => Right(right));
  }

  @override
  Future<Either<Failure, String>> deleteDocument(String presetUri) async {
    final result = await datasource.deleteDocuments(presetUri);
    return result.fold((left) => Left(left), (right) => Right(right));
  }

  @override
  Future<Either<Failure, ServiceRequestResponse>> generateServiceRequest(
      SRRequest request) async {
    final result = await datasource.generateServiceRequest(request);
    return result.fold((left) => Left(left), (right) => Right(right));
  }

  @override
  Future<Either<Failure, ReopenCaseResponse>> reopenServiceRequest(
      ReopenCaseRequest request) async {
    final result = await datasource.reopenCase(request);
    return result.fold((left) => Left(left), (right) => Right(right));
  }

  @override
  Future<Either<Failure, ViewSRResponse>> srDetailsBySrNumber(
      SRDetailsRequest request) async {
    final result = await datasource.srDetailsBySrNumber(request);
    return result.fold((left) => Left(left), (right) => Right(right));
  }
}
