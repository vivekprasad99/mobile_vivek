import 'package:core/config/error/failure.dart';
import 'package:core/config/network/dio_client.dart';
import 'package:core/config/network/network_utils.dart';
import 'package:dartz/dartz.dart';
import 'package:loan/config/network/api_endpoints.dart';
import 'package:loan/features/loan_cancellation/data/models/create_sr_request.dart';
import 'package:loan/features/loan_cancellation/data/models/create_sr_response.dart';
import 'package:loan/features/loan_cancellation/data/models/fetch_sr_request.dart';
import 'package:loan/features/loan_cancellation/data/models/fetch_sr_response.dart';
import 'package:loan/features/loan_cancellation/data/models/get_flp_tenure_response.dart';
import 'package:loan/features/loan_cancellation/data/models/get_lc_list_request.dart';
import 'package:loan/features/loan_cancellation/data/models/get_lc_list_response.dart';
import 'package:loan/features/loan_cancellation/data/models/get_lc_reasons_response.dart';
import 'package:loan/features/loan_cancellation/data/models/get_loan_charges_request.dart';
import 'package:loan/features/loan_cancellation/data/models/get_loan_charges_response.dart';
import 'package:loan/features/loan_cancellation/data/models/get_offers_response.dart';

class LoanCancellationDatasource {
  DioClient dioClient;

  LoanCancellationDatasource({required this.dioClient});

  Future<Either<Failure, GetLoanCancellationResponse>> getLoans(
      GetLoansCancellationRequest request) async {
      final response = await dioClient.postRequest(
          getMsApiUrl(ApiEndpoints.getLoanList),
          converter: (response) => GetLoanCancellationResponse.fromJson(
              response as Map<String, dynamic>),
          data: request.toJson());
      return response;
  }

  Future<Either<Failure, GetLoanCancellationReasonsResponse>>
      getReasons() async {
      final response = await dioClient.getRequest(
        getCMSApiUrl(ApiEndpoints.staticResponse,
            category: 'loan_cancellation_reasons'),
        converter: (response) => GetLoanCancellationReasonsResponse.fromJson(
            response as Map<String, dynamic>),
      );
      return response;
  }

  Future<Either<Failure, GetOffersResponse>> getOffers() async {
      final response = await dioClient.getRequest(
        getCMSApiUrl(ApiEndpoints.staticResponse,
            category: 'loan_cancellation_offers'),
        converter: (response) =>
            GetOffersResponse.fromJson(response as Map<String, dynamic>),
      );
      return response;
    }

  Future<Either<Failure, FetchSrResponse>> fetchSR(
      FetchSrRequest request) async {
      final response = await dioClient.postRequest(
          getMsApiUrl(ApiEndpoints.fetchSr),
          converter: (response) =>
              FetchSrResponse.fromJson(response as Map<String, dynamic>),
          data: request.toJson());
      return response;
    }

  Future<Either<Failure, GetFlpTenureResponse>> getFlpTenure() async {
      final response = await dioClient.getRequest(
        getCMSApiUrl(ApiEndpoints.genericResponse,
            category: 'free_lookup_period'),
        converter: (response) =>
            GetFlpTenureResponse.fromJson(response as Map<String, dynamic>),
      );
      return response;
    }

  Future<Either<Failure, GetLoanChargesResponse>> getLoanCharges(
      GetLoanChargesRequest request) async {
      final response = await dioClient.postRequest(
          getMsApiUrl(ApiEndpoints.getCharges),
          converter: (response) =>
              GetLoanChargesResponse.fromJson(response as Map<String, dynamic>),
          data: request.toJson());
      return response;
    }

  Future<Either<Failure, CreateSrResponse>> createSR(
      CreateSrRequest request) async {
      final response = await dioClient.postRequest(
          getMsApiUrl(ApiEndpoints.createLCSR),
          converter: (response) =>
              CreateSrResponse.fromJson(response as Map<String, dynamic>),
          data: request.toJson());
      return response;
    }
  }
