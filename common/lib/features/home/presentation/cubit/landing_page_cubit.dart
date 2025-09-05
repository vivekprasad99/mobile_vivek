import 'package:common/features/home/data/models/landing_pre_offer_request.dart';
import 'package:common/features/home/data/models/landing_pre_offer_response.dart';
import 'package:common/features/home/data/models/loan_amount_request.dart';
import 'package:common/features/home/data/models/pre_approved_offer_response.dart';
import 'package:common/features/home/data/models/welcomeNotify_request.dart';
import 'package:common/features/home/presentation/cubit/landing_page_state.dart';
import 'package:common/features/home/domain/usecases/landing_page_usecase.dart';
import 'package:core/config/config.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/utils/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_details/data/models/active_loan_list_request.dart';

class LandingPageCubit extends Cubit<LandingPageState> {
  LandingPageCubit({required this.landingPageUsecase})
      : super(const LandingPageInitial(sliderIndex: 0));

  final LandingPageUsecase landingPageUsecase;

  Future<void> getLoanList(
      {required ActiveLoanListRequest landingPageRequest,}) async {
    try {
      emit(const LandingLoadingState(isLoadingLoans: true, sliderIndex: 0));

      final result = await landingPageUsecase.call(landingPageRequest);
      emit(const LandingLoadingState(isLoadingLoans: false, sliderIndex: 0));
      result.fold(
        (l) => emit(FailureState(error: l, sliderIndex: 0)),
        (r) => emit(GetLoansSuccess(response: r, sliderIndex: 0)),
      );
    } catch (e) {
      emit(const LandingLoadingState(isLoadingLoans: false, sliderIndex: 0));
      emit(FailureState(error: NoDataFailure(), sliderIndex: 0));
    }
  }

  Future<void> getLandingBannerList() async {
    try {
      emit(const LandingBannerLoadingState(
          isLoadingBanner: true, sliderIndex: 0,),);

      final result = await landingPageUsecase.bannerCall();
      emit(const LandingBannerLoadingState(
          isLoadingBanner: false, sliderIndex: 0,),);

      result.fold((l) => emit(BannerFailureState(error: l, sliderIndex: 0)),
          (r) => emit(GetBannerSuccess(response: r, sliderIndex: 0)),);
    } catch (e) {
      emit(const LandingBannerLoadingState(
          isLoadingBanner: false, sliderIndex: 0,),);
      emit(BannerFailureState(error: NoDataFailure(), sliderIndex: 0));
    }
  }

  Future<void> getLandingOfferList() async {
    try {
      emit(const OfferLoadingState(isLoading: true, sliderIndex: 0));

      final result = await landingPageUsecase.getOffers();

      emit(const OfferLoadingState(isLoading: false, sliderIndex: 0));
      result.fold((l) => emit(FailureState(error: l, sliderIndex: 0)),
          (r) => emit(GetOfferSuccess(response: r, sliderIndex: 0)),);
    } catch (e) {
      emit(const OfferLoadingState(isLoading: false, sliderIndex: 0));
      emit(FailureState(error: NoDataFailure(), sliderIndex: 0));
    }
  }

  Future<void> getLoanAmount(
      {required LoanAmountRequest landingPageRequest,}) async {
    try {
      emit(const LoanAmountLoadingState(sliderIndex: 0, isLoading: true));

      final result = await landingPageUsecase.getLoanAmount(landingPageRequest);
      emit(const LoanAmountLoadingState(isLoading: false, sliderIndex: 0));
      result.fold(
        (l) => emit(FailureState(error: l, sliderIndex: 0)),
        (r) => emit(GetLoanAmountSuccess(response: r, sliderIndex: 0)),
      );
    } catch (e) {
      emit(const LoanAmountLoadingState(isLoading: false, sliderIndex: 0));
      emit(FailureState(error: NoDataFailure(), sliderIndex: 0));
    }
  }

  List<dynamic> preOfferResponse = [];
  int offersCount = 0;

  Future<void> getDrawerLoanPreOffer({
    required LandingPreOfferRequest landingPreOfferRequest,
  }) async {
    try {
      List<OfferDetail>? cmsOffers = [];
      List<OfferDatum> suvidhaOffers = [];
      List<OffersDetail> leadOffers = [];
      String? responseCode;
      String? code;
      emit(const PreOfferLoadingState(isLoading: true, sliderIndex: 0));
      final result =
          await landingPageUsecase.getLandingPreOffer(landingPreOfferRequest);

     isCustomer()
          ? result.fold(
        (l) => emit(FailureState(error: l, sliderIndex: 0)),
        (r) async {
          responseCode = r.responseCode ?? '';
          code = r.code ?? '';

          suvidhaOffers = r.offerData != null && r.offerData!.isNotEmpty
              ? (r.offerData?.first.result?.offerCode == null
                  ? []
                  : r.offerData ?? [])
              : [];
          leadOffers = r.plLeadResponse?.response?.crmres?.offersDetails ?? [];
        },
      ) : null;
      try {
        final additionalOffersResult = await landingPageUsecase.getOffers();
        additionalOffersResult.fold(
          (l) => emit(FailureState(error: l, sliderIndex: 0)),
          (offersList) {
            cmsOffers = offersList.data?.offersList;
          },
        );
      } catch (e) {
        emit(FailureState(error: NoDataFailure(), sliderIndex: 0));
      }
      emit(MyOfferSuccessState(
          code: code ?? '',
          responseCode: responseCode ?? msgSomethingWentWrong,
          sliderIndex: 0,
          cmsOfferResponse: cmsOffers ?? [],
          plLeadResponse: leadOffers,
          suvidhaResponse: suvidhaOffers,),);
      emit(const PreOfferLoadingState(isLoading: false, sliderIndex: 0));
    } catch (e) {
      emit(FailureState(error: NoDataFailure(), sliderIndex: 0));
      emit(const PreOfferLoadingState(isLoading: false, sliderIndex: 0));
    }
  }

  Future<void> getLoanPreOffer({
    required LandingPreOfferRequest landingPreOfferRequest,
  }) async {
    String? responseCode;
    String? code;
    try {
      emit(const LandingPreOfferLoadingState(isLoading: true, sliderIndex: 0));
      final result =
          await landingPageUsecase.getLandingPreOffer(landingPreOfferRequest);

      isCustomer()
          ? result.fold(
        (l) => emit(PreOfferFailureState(error: l, sliderIndex: 0)),
        (r) async {
          responseCode = r.responseCode ?? '';
          code = r.code ?? '';
          final List<dynamic> offerData =
              r.offerData != null && r.offerData!.isNotEmpty
                  ? (r.offerData?.first.result?.offerCode == null
                      ? []
                      : r.offerData ?? [])
                  : [];
          final List<dynamic> offersDetails =
              r.plLeadResponse?.response?.crmres?.offersDetails ?? [];

          const maxItems = 2;
          final offerDataCount = offerData.length;
          final offersDetailsCount = offersDetails.length;
          offersCount = offerData.length + offersDetails.length;
          if (offerDataCount >= 1 && offersDetailsCount >= 1) {
            preOfferResponse
              ..add(offerData.first)
              ..add(offersDetails.first);
          } else if (offerDataCount > 1 && offersDetailsCount == 0) {
            preOfferResponse.addAll(offerData.take(maxItems));
          } else if (offerDataCount == 0 && offersDetailsCount > 1) {
            preOfferResponse.addAll(offersDetails.take(maxItems));
          } else if (offerDataCount == 1 && offersDetailsCount == 0) {
            preOfferResponse.add(offerData.first);
          } else if (offerDataCount == 0 && offersDetailsCount == 1) {
            preOfferResponse.add(offersDetails.first);
          }
        },
      ) : null;
      try {
        final additionalOffersResult = await landingPageUsecase.getOffers();
        additionalOffersResult.fold(
          (l) => emit(PreOfferFailureState(error: l, sliderIndex: 0)),
          (offersList) {
            List<OfferDetail>? cmsOffers = offersList.data?.offersList;
            preOfferResponse.add(cmsOffers);
          },
        );
      } catch (e) {
        emit(PreOfferFailureState(error: NoDataFailure(), sliderIndex: 0));
      }
      emit(GetOfferBind(
          response: preOfferResponse,
          sliderIndex: 0,
          offerCount: offersCount,
          responseCode: responseCode ?? msgSomethingWentWrong,
          code: code ?? '',),);
      emit(const LandingPreOfferLoadingState(isLoading: false, sliderIndex: 0));
    } catch (e) {
      emit(PreOfferFailureState(error: NoDataFailure(), sliderIndex: 0));
      emit(const LandingPreOfferLoadingState(isLoading: false, sliderIndex: 0));
    }
  }

  changeOfferCheckBox(bool ischecked) {
    emit(const CheckBoxState(sliderIndex: 0, false));
  }

  Future<void> welcomeNotify(
      {required WelcomeNotifyRequest welcomeNotifyRequest}) async {
    await landingPageUsecase.welcomenotify(welcomeNotifyRequest);
  }
}
