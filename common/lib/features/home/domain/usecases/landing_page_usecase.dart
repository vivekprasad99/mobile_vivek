import 'package:common/features/home/data/models/landing_page_banner_response.dart';
import 'package:common/features/home/data/models/landing_pre_offer_request.dart';
import 'package:common/features/home/data/models/landing_pre_offer_response.dart';
import 'package:common/features/home/data/models/loan_amount_request.dart';
import 'package:common/features/home/data/models/loan_amount_response.dart';
import 'package:common/features/home/data/models/pre_approved_offer_response.dart';
import 'package:common/features/home/data/models/welcomeNotify_request.dart';
import 'package:common/features/home/domain/repositories/home_repository.dart';
import 'package:core/config/error/failure.dart';
import 'package:core/config/usecase/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:product_details/data/models/active_loan_list_request.dart';
import 'package:product_details/data/models/active_loan_list_response.dart';

class LandingPageUsecase
    extends UseCase<ActiveLoanListResponse, ActiveLoanListRequest> {
  final HomeRepository repository;

  LandingPageUsecase({required this.repository});

  Future<Either<Failure, HomeBannerResponse>> bannerCall() async {
    return await repository.getLandingPageBannerRepo();
  }

  @override
  Future<Either<Failure, ActiveLoanListResponse>> call(
      ActiveLoanListRequest params,) async {
    return await repository.getLoans(params);
  }

  Future<Either<Failure, LoanAmountResponse>> getLoanAmount(
      LoanAmountRequest loanAmountRequest,) async {
    return await repository.getLoanAmount(loanAmountRequest);
  }

  Future<Either<Failure, LandingPreOfferResponse>> getLandingPreOffer(
      LandingPreOfferRequest landingPreOfferRequest,) async {
    return await repository.getLandingPreOffer(landingPreOfferRequest);
  }

  Future<Either<Failure, PreApprovedOffersResponse>> getOffers() async {
    return await repository.getOffers();
  }

  Future welcomenotify(WelcomeNotifyRequest welcomeNotifyreq) async {
    return await repository.welcomenotify(welcomeNotifyreq);
  }
}
