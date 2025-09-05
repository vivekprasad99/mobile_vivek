import 'dart:convert';
import 'package:common/features/home/data/models/landing_page_banner_response.dart';
import 'package:common/features/home/data/models/landing_pre_offer_request.dart';
import 'package:common/features/home/data/models/landing_pre_offer_response.dart';
import 'package:common/features/home/data/models/loan_amount_request.dart';
import 'package:common/features/home/data/models/loan_amount_response.dart';
import 'package:common/features/home/data/models/pre_approved_offer_response.dart';
import 'package:common/features/home/data/models/update_theme_request.dart';
import 'package:common/features/home/data/models/update_theme_response.dart';
import 'package:common/features/home/data/models/welcomeNotify_request.dart';
import 'package:core/config/error/failure.dart';
import 'package:core/config/flavor/app_config.dart';
import 'package:core/config/network/dio_client.dart';
import 'package:core/config/network/network_utils.dart';
import 'package:dartz/dartz.dart';
import 'package:product_details/data/models/active_loan_list_request.dart';
import 'package:product_details/data/models/active_loan_list_response.dart';
import '../../../../config/network/api_endpoints.dart';
import '../models/logout_response.dart';

class HomeDataSource {
  DioClient dioClient;

  HomeDataSource({required this.dioClient});

  Future<Either<Failure, UpdateThemeResponse>> updateThemeResponse(
      UpdateThemeRequest updateThemeRequest,) async {
      final response = await dioClient.postRequest(
          getMsApiUrl(ApiEndpoints.updateThemeDetail),
          converter: (response) =>
              UpdateThemeResponse.fromJson(response as Map<String, dynamic>),
          data: updateThemeRequest.toJson(),);
      return response;
    }

  Future<Either<Failure, HomeBannerResponse>> getCMSBanner() async {
      final response = await dioClient.getRequest(
        getCMSApiUrl(ApiEndpoints.getLandingBanner),
        converter: (response) =>
            HomeBannerResponse.fromJson(response as Map<String, dynamic>),
      );
      return response;
    }

  Future<Either<Failure, PreApprovedOffersResponse>> getOffers() async {
      final response = await dioClient.getRequest(
        getCMSApiUrl(ApiEndpoints.getOffers),
        converter: (response) => PreApprovedOffersResponse.fromJson(
            response as Map<String, dynamic>,),
      );
      return response;
    }

  Future<Either<Failure, ActiveLoanListResponse>> getLoansList(
      ActiveLoanListRequest request,) async {
      final response = await dioClient.postRequest(
          getMsApiUrl(ApiEndpoints.getLoanList),
          converter: (response) =>
              ActiveLoanListResponse.fromJson(response as Map<String, dynamic>),
          data: request.toJson(),);
      return response;
    }

  Future<Either<Failure, LoanAmountResponse>> getLoansAmount(
      LoanAmountRequest request,) async {
      final response = await dioClient.postRequest(
          getMsApiUrl(ApiEndpoints.getLoanAmount),
          converter: (response) =>
              LoanAmountResponse.fromJson(response as Map<String, dynamic>),
          data: request.toJson(),);
      return response;
    }

  Future<Either<Failure, LandingPreOfferResponse>> getLandingPreOffer(
      LandingPreOfferRequest request,) async {
      final response = await dioClient.postRequest(
          getMsApiUrl(ApiEndpoints.getLandingPreOfferDetails),
          converter: (response) => LandingPreOfferResponse.fromJson(
              response as Map<String, dynamic>,),
          data: request.toJson(),);
      return response;
    }

  Future<Either<Failure, LogoutResponse>> logout(String token) async {
    String username = AppConfig.shared.postLoginTokenUserName;
    String password = AppConfig.shared.postLoginTokenPassword;
    String basicAuth =
        'Basic ${base64.encode(utf8.encode('$username:$password'))}';
    var headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': basicAuth,
      'access_token': token,
    };
    final response = await dioClient.postRequest(
        getPostTokenUrl(ApiEndpoints.logout),
        converter: (response) =>
            LogoutResponse.fromJson(response as Map<String, dynamic>),
        header: headers,);
    return response;
  }

  Future welcomenotifyRequest(WelcomeNotifyRequest request) async {
      final response = await dioClient.postRequest(
          getMsApiUrl(ApiEndpoints.welcomeNotifyreq),
          converter: (response) => "",
          data: request.toJson(),);
      return response;
    }
  }
