import 'dart:convert';
import 'package:core/config/error/failure.dart';
import 'package:core/config/network/dio_client.dart';
import 'package:core/config/network/network_utils.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';
import 'package:loan/config/network/api_endpoints.dart';
import 'package:loan/features/foreclosure/data/models/create_fd_lead_response.dart';
import 'package:loan/features/foreclosure/data/models/get_foreclosure_details.dart';
import 'package:loan/features/foreclosure/data/models/get_fund_of_source_response.dart';
import 'package:loan/features/foreclosure/data/models/get_loan_details_request.dart';
import 'package:loan/features/foreclosure/data/models/get_loan_details_response.dart';
import 'package:loan/features/foreclosure/data/models/get_loans_request.dart';
import 'package:loan/features/foreclosure/data/models/get_loans_response.dart';
import 'package:loan/features/foreclosure/data/models/get_offers_response.dart';
import 'package:loan/features/foreclosure/data/models/get_reasons_response.dart';
import 'package:service_ticket/features/data/models/service_request_response.dart';
import '../models/service_request.dart';

class ForeClosureDatasource {
  DioClient dioClient;

  ForeClosureDatasource({required this.dioClient});

  Future<Either<Failure, GetLoansResponse>> getLoans(
      GetLoansRequest request) async {
      final response = await dioClient.postRequest(
          getMsApiUrl(ApiEndpoints.getLoanList),
          converter: (response) =>
              GetLoansResponse.fromJson(response as Map<String, dynamic>),
          data: request.toJson());
      return response;
    }

  Future<Either<Failure, GetLoanDetailsResponse>> getLoanDetails(
      GetLoanDetailsRequest request) async {
      final response = await dioClient.postRequest(
          getMsApiUrl(ApiEndpoints.getLoanDetails),
          converter: (response) =>
              GetLoanDetailsResponse.fromJson(response as Map<String, dynamic>),
          data: request.toJson());
      return response;
    }

  Future<Either<Failure, GetForeClosureDetailsResponse>> getForeClosureDetails(
      GetLoanDetailsRequest request) async {
      final response = await dioClient.postRequest(
          getMsApiUrl(ApiEndpoints.getForeClosureDetails),
          converter: (response) => GetForeClosureDetailsResponse.fromJson(
              response as Map<String, dynamic>),
          data: request.toJson());
      return response;
  }

  Future<Either<Failure, GetReasonsResponse>> getReasons(
      GetLoanDetailsRequest request) async {
      final response = await dioClient.getRequest(
        getCMSApiUrl(ApiEndpoints.staticResponse, category: 'reasons'),
        converter: (response) =>
            GetReasonsResponse.fromJson(response as Map<String, dynamic>),
      );
      return response;
    }

  Future<Either<Failure, GetOffersResponse>> getOffers(
      GetLoanDetailsRequest request) async {
      final response = await dioClient.getRequest(
        getCMSApiUrl(ApiEndpoints.staticResponse, category: 'offers'),
        converter: (response) =>
            GetOffersResponse.fromJson(response as Map<String, dynamic>),
      );
      return response;
    }

  Future<Either<Failure, GetOffersResponse>> getPreApprovedOffers(
      GetLoanDetailsRequest request) async {
      final response = await dioClient.getRequest(
        getCMSApiUrl(ApiEndpoints.staticResponse,
            category: 'pre_approved_offers'),
        converter: (response) =>
            GetOffersResponse.fromJson(response as Map<String, dynamic>),
      );
      return response;
    }

  Future<Either<Failure, FundOfSourceResponse>> getFundOfSource(
      GetLoanDetailsRequest request) async {
      final response = await dioClient.getRequest(
        getCMSApiUrl(ApiEndpoints.staticResponse, category: 'fund_sources'),
        converter: (response) =>
            FundOfSourceResponse.fromJson(response as Map<String, dynamic>),
      );
      return response;
    }

  Future<Either<Failure, CreateFdLeadResponse>> createFDLead(
      GetLoanDetailsRequest request) async {
    final getLoansStubData = await rootBundle
        .loadString('assets/stubdata/foreclosure/generate_lead.json');
    final body = json.decode(getLoansStubData);
    Either<Failure, CreateFdLeadResponse> response =
        Right(CreateFdLeadResponse.fromJson(body as Map<String, dynamic>));
    return response;
  }

  Future<Either<Failure, ServiceRequestResponse>> createForeclosureSR(
      ServiceRequest request) async {
      final response = await dioClient.postRequest(
          getMsApiUrl(ApiEndpoints.createForeclosureSR),
          converter: (response) => ServiceRequestResponse.fromJson(
              response as Map<String, dynamic>),
          data: request.toJson());
      return response;
    }
  }
