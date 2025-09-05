import 'dart:io';
import 'package:core/config/network/dio_client_doc_upload.dart';
import 'package:core/config/network/network_utils.dart';
import 'package:core/config/error/failure.dart';
import 'package:core/config/network/dio_client.dart';
import 'package:dartz/dartz.dart';
import 'package:loan/features/foreclosure/data/models/get_loans_request.dart';
import 'package:loan/features/foreclosure/data/models/get_loans_response.dart';
import 'package:service_request/features/bureau/config/network/api_endpoints.dart';
import 'package:service_request/features/bureau/data/models/bureau_response.dart';
import 'package:service_request/features/bureau/data/models/dedupe_request.dart';
import 'package:service_request/features/bureau/data/models/dedupe_response.dart';
import 'package:service_request/features/bureau/data/models/get_preset_uri_request.dart';
import 'package:service_request/features/bureau/data/models/get_preset_uri_response.dart';
import 'package:service_request/features/bureau/data/models/loan_payment_request.dart';
import 'package:service_request/features/bureau/data/models/loan_payment_response.dart';
import 'package:service_request/features/bureau/data/models/reason_response.dart';

class BureauDataSource {
  DioClient dioClient;
  DioClientDocUpload dioClientUnc;

  BureauDataSource({required this.dioClient, required this.dioClientUnc});

  Future<Either<Failure, BureauResponse>> getBureaus() async {
      final response = await dioClient.getRequest(
          getCMSApiUrl(ApiEndpoints.getBureaus, category: 'Bureaus'),
          converter: (response) =>
              BureauResponse.fromJson(response as Map<String, dynamic>));
      return response;
    }

  Future<Either<Failure, ReasonResponse>> getReason() async {
      final response = await dioClient.getRequest(
          getCMSApiUrl(ApiEndpoints.getReasons, category: 'bureau_reasons'),
          converter: (response) =>
              ReasonResponse.fromJson(response as Map<String, dynamic>));
      return response;
    }

  Future<Either<Failure, GetPresetUriResponse>> getPresetUri(
      GetPresetUriRequest request) async {
      final response = await dioClient.postRequest(
          getMsApiUrl(ApiEndpoints.getPresetUri),
          converter: (response) =>
              GetPresetUriResponse.fromJson(response as Map<String, dynamic>),
          data: request.toJson());
      return response;
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

  Future<Either<Failure, GetLoansResponse>> getLoans(
      GetLoansRequest request) async {
      final response = await dioClient.postRequest(
          getMsApiUrl(ApiEndpoints.getLoanList),
          converter: (response) =>
              GetLoansResponse.fromJson(response as Map<String, dynamic>),
          data: request.toJson());

      return response;
    }

  Future<Either<Failure, DedupeResponse>> getDedupeCheck(
      DedupeRequest request) async {
      final response = await dioClient.postRequest(
          getMsApiUrl(ApiEndpoints.postDedupe),
          converter: (response) =>
              DedupeResponse.fromJson(response as Map<String, dynamic>),
          data: request.toJson());
      return response;
    }

  Future<Either<Failure, PaymentResponse>> getLoanPayment(
      PaymentRequest request) async {
      final response = await dioClient.postRequest(
          getMsApiUrl(ApiEndpoints.paymentHistory),
          converter: (response) =>
              PaymentResponse.fromJson(response as Map<String, dynamic>),
          data: request.toJson());

      return response;
    }
  }
