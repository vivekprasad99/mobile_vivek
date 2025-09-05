import 'package:common/features/home/data/datasources/home_datasource.dart';
import 'package:common/features/home/data/models/landing_page_banner_response.dart';
import 'package:common/features/home/data/models/landing_pre_offer_request.dart';
import 'package:common/features/home/data/models/landing_pre_offer_response.dart';
import 'package:common/features/home/data/models/loan_amount_request.dart';
import 'package:common/features/home/data/models/loan_amount_response.dart';
import 'package:common/features/home/data/models/pre_approved_offer_response.dart';
import 'package:common/features/home/data/models/update_theme_request.dart';
import 'package:common/features/home/data/models/update_theme_response.dart';
import 'package:common/features/home/data/models/welcomeNotify_request.dart';
import 'package:common/features/home/domain/repositories/home_repository.dart';
import 'package:core/config/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:product_details/data/models/active_loan_list_request.dart';
import 'package:product_details/data/models/active_loan_list_response.dart';
import '../models/logout_response.dart';

class HomeRepositoryImpl implements HomeRepository {
  HomeRepositoryImpl({required this.datasource});

  final HomeDataSource datasource;

  @override
  Future<Either<Failure, UpdateThemeResponse>> updateUserTheme(
      UpdateThemeRequest updateThemeRequest,) async {
    final result = await datasource.updateThemeResponse(updateThemeRequest);
    return result.fold((left) => Left(left), (right) => Right(right));
  }

  @override
  Future<Either<Failure, HomeBannerResponse>> getLandingPageBannerRepo() async {
    final result = await datasource.getCMSBanner();
    return result.fold((left) => Left(left), (right) => Right(right));
  }

  @override
  Future<Either<Failure, PreApprovedOffersResponse>> getOffers() async {
    final result = await datasource.getOffers();
    return result.fold((left) => Left(left), (right) => Right(right));
  }

  @override
  Future<Either<Failure, ActiveLoanListResponse>> getLoans(
      ActiveLoanListRequest getLoansRequest,) async {
    final result = await datasource.getLoansList(getLoansRequest);
    return result.fold((left) => Left(left), (right) => Right(right));
  }

  @override
  Future<Either<Failure, LoanAmountResponse>> getLoanAmount(
      LoanAmountRequest loanAmountRequest,) async {
    final result = await datasource.getLoansAmount(loanAmountRequest);
    return result.fold((left) => Left(left), (right) => Right(right));
  }

  @override
  Future<Either<Failure, LandingPreOfferResponse>> getLandingPreOffer(
      LandingPreOfferRequest landingPreOfferRequest,) async {
    final result = await datasource.getLandingPreOffer(landingPreOfferRequest);
    return result.fold((left) => Left(left), (right) => Right(right));
  }

  @override
  Future welcomenotify(WelcomeNotifyRequest welcomeNotifyrequest) async {
    final result = await datasource.welcomenotifyRequest(welcomeNotifyrequest);
    return result.fold((left) => Left(left), (right) => Right(right));
  }

  @override
  Future<Either<Failure, LogoutResponse>> logout(String token) async {
    final result = await datasource.logout(token);
    return result.fold((left) => Left(left), (right) => Right(right));
  }
}
