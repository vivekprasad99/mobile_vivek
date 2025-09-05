import 'dart:convert';
import 'package:core/config/error/failure.dart';
import 'package:core/config/network/dio_client.dart';
import 'package:core/config/network/network_utils.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';
import 'package:product_details/config/network/api_endpoints.dart';
import 'package:product_details/data/models/active_loan_detail_request.dart';
import 'package:product_details/data/models/active_loan_detail_response.dart';
import 'package:product_details/data/models/active_loan_list_request.dart';
import 'package:product_details/data/models/active_loan_list_response.dart';
import 'package:product_details/data/models/documents_response.dart';
import 'package:product_details/data/models/doucments_request.dart';
import 'package:product_details/data/models/payment_request.dart';
import 'package:product_details/data/models/payment_response.dart';
import 'package:product_details/data/models/set_payemnt_reminder_request.dart';
import 'package:product_details/data/models/set_payment_reminder_reponse.dart';

class ProductDetailsDatasource {
  DioClient dioClient;

  ProductDetailsDatasource({required this.dioClient});

  Future<Either<Failure, ActiveLoanListResponse>> getActiveLoansList(
      ActiveLoanListRequest getActiveLoansListRequest) async {
      final response = await dioClient.postRequest(
        getMsApiUrl(ApiEndpoints.getActiveLoanList),
        data: getActiveLoansListRequest.toJson(),
        converter: (response) =>
            ActiveLoanListResponse.fromJson(response as Map<String, dynamic>),
      );
      return response;
    }

  Future<Either<Failure, ActiveLoanDetailResponse>> getActiveLoansDetails(
      ActiveLoanDetailRequest getActiveLoansDetailsRequest) async {
      final response = await dioClient.postRequest(
        getMsApiUrl(ApiEndpoints.getActiveLoanDetails),
        data: getActiveLoansDetailsRequest.toJson(),
        converter: (response) =>
            ActiveLoanDetailResponse.fromJson(response as Map<String, dynamic>),
      );
      return response;
  }

  Future<Either<Failure, DocumentsResponse>> getDocuments(
      DocumentsRequest documentsRequest) async {
      final response = await dioClient.postRequest(
        getMsApiUrl(ApiEndpoints.getDocuments),
        data: documentsRequest.toJson(),
        converter: (response) =>
            DocumentsResponse.fromJson(response as Map<String, dynamic>),
      );
      return response;
    }

  Future<Either<Failure, PaymentResponse>> getPaymentHistory(
      PaymentRequest getPaymentRequest) async {
      final response = await dioClient.postRequest(
        getMsApiUrl(ApiEndpoints.getPaymentHistory),
        data: getPaymentRequest.toJson(),
        converter: (response) =>
            PaymentResponse.fromJson(response as Map<String, dynamic>),
      );
      return response;
    }

  Future<Either<Failure, SetPaymentReminderResponse>> setPaymentReminders(
      SetPaymentReminderRequest setPaymentReminderRequest) async {
    final loginStubData = await rootBundle
        .loadString('assets/stubdata/product_details/active_loan_details.json');
    final body = json.decode(loginStubData);
    Either<Failure, SetPaymentReminderResponse> response = Right(
        SetPaymentReminderResponse.fromJson(body as Map<String, dynamic>));
    return response;
  }
}
