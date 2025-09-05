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
import 'package:dartz/dartz.dart';
import 'package:product_details/data/models/active_loan_list_request.dart';
import 'package:product_details/data/models/active_loan_list_response.dart';

import '../../data/models/logout_response.dart';

abstract class HomeRepository {
  Future<Either<Failure, UpdateThemeResponse>> updateUserTheme(
      UpdateThemeRequest updateThemeRequest,);
  Future<Either<Failure, HomeBannerResponse>> getLandingPageBannerRepo();
  Future<Either<Failure, PreApprovedOffersResponse>> getOffers();
  Future<Either<Failure, ActiveLoanListResponse>> getLoans(
      ActiveLoanListRequest getLoansRequest,);
  Future<Either<Failure, LoanAmountResponse>> getLoanAmount(
      LoanAmountRequest loanAmountRequest,);
  Future<Either<Failure, LandingPreOfferResponse>> getLandingPreOffer(
      LandingPreOfferRequest landingPreOfferRequest,);
  Future welcomenotify(
      WelcomeNotifyRequest welcomenotifyRequest,);
  Future<Either<Failure, LogoutResponse>> logout(String token);
}
