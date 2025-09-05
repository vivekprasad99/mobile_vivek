import 'package:common/features/home/data/models/landing_page_banner_response.dart';
import 'package:common/features/home/data/models/landing_pre_offer_response.dart';
import 'package:common/features/home/data/models/loan_amount_response.dart';
import 'package:common/features/home/data/models/pre_approved_offer_response.dart';
import 'package:core/config/error/failure.dart';
import 'package:equatable/equatable.dart';
import 'package:product_details/data/models/active_loan_list_response.dart';

class LandingPageState extends Equatable {
  const LandingPageState({required this.sliderIndex});

  final int sliderIndex;

  @override
  List<Object?> get props => [
        sliderIndex,
      ];

  LandingPageState copyWith({
    int? sliderIndex,
  }) {
    return LandingPageState(
      sliderIndex: sliderIndex ?? this.sliderIndex,
    );
  }
}

class LandingPageInitial extends LandingPageState {
  const LandingPageInitial({required super.sliderIndex});

  @override
  List<Object?> get props => [];
}

class LoanAmountLoadingState extends LandingPageState {
  final bool isLoading;
  const LoanAmountLoadingState(
      {required this.isLoading, required super.sliderIndex,});

  @override
  List<Object?> get props => [isLoading];
}

class LandingLoadingState extends LandingPageState {
  final bool isLoadingLoans;

  const LandingLoadingState(
      {required this.isLoadingLoans, required super.sliderIndex,});

  @override
  List<Object?> get props => [isLoadingLoans];
}

class LandingBannerLoadingState extends LandingPageState {
  final bool isLoadingBanner;

  const LandingBannerLoadingState(
      {required this.isLoadingBanner, required super.sliderIndex,});

  @override
  List<Object?> get props => [isLoadingBanner];
}

class GetLoansSuccess extends LandingPageState {
  final ActiveLoanListResponse response;

  const GetLoansSuccess({required this.response, required super.sliderIndex});
}

class GetLandingPreOfferSuccess extends LandingPageState {
  final LandingPreOfferResponse response;

  const GetLandingPreOfferSuccess(
      {required this.response, required super.sliderIndex,});
}

class GetLoanAmountSuccess extends LandingPageState {
  final LoanAmountResponse response;

  const GetLoanAmountSuccess(
      {required this.response, required super.sliderIndex,});
}

class GetBannerSuccess extends LandingPageState {
  final HomeBannerResponse response;

  const GetBannerSuccess({required this.response, required super.sliderIndex});
}

class GetOfferSuccess extends LandingPageState {
  final PreApprovedOffersResponse response;

  const GetOfferSuccess({required this.response, required super.sliderIndex});
}

class GetPreOffer extends LandingPageState {
  final LandingPreOfferResponse response;

  const GetPreOffer({required this.response, required super.sliderIndex});
}

class GetOfferBind extends LandingPageState {
  final List<dynamic> response;
  final int offerCount;
  final String responseCode;
  final String code;

  const GetOfferBind(
      {required this.response,
      required this.responseCode,
      required this.code,
      required super.sliderIndex,
      required this.offerCount,});
}

class OfferLoadingState extends LandingPageState {
  final bool isLoading;
  const OfferLoadingState(
      {required this.isLoading, required super.sliderIndex,});

  @override
  List<Object?> get props => [isLoading];
}

class PreOfferLoadingState extends LandingPageState {
  final bool isLoading;
  const PreOfferLoadingState(
      {required this.isLoading, required super.sliderIndex,});

  @override
  List<Object?> get props => [isLoading];
}

class LandingPreOfferLoadingState extends LandingPageState {
  final bool isLoading;
  const LandingPreOfferLoadingState(
      {required this.isLoading, required super.sliderIndex,});

  @override
  List<Object?> get props => [isLoading];
}

class FailureState extends LandingPageState {
  final Failure error;

  const FailureState({required this.error, required super.sliderIndex});

  @override
  List<Object?> get props => [error];
}

class BannerFailureState extends LandingPageState {
  final Failure error;

  const BannerFailureState({required this.error, required super.sliderIndex});

  @override
  List<Object?> get props => [error];
}

class PreOfferFailureState extends LandingPageState {
  final Failure error;

  const PreOfferFailureState({required this.error, required super.sliderIndex});

  @override
  List<Object?> get props => [error];
}

class CheckBoxState extends LandingPageState {
  final bool ischecked;

  const CheckBoxState(this.ischecked, {required super.sliderIndex});

  @override
  List<Object?> get props => [ischecked];
}

class MyOfferSuccessState extends LandingPageState {
  final List<OfferDatum> suvidhaResponse;
  final List<OffersDetail> plLeadResponse;
  final List<OfferDetail> cmsOfferResponse;
  final String responseCode;
  final String code;

  const MyOfferSuccessState(
      {required this.responseCode,
      required this.code,
      required this.cmsOfferResponse,
      required this.suvidhaResponse,
      required this.plLeadResponse,
      required super.sliderIndex,});
}
