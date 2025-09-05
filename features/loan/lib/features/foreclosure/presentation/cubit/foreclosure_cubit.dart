import 'package:bloc/bloc.dart';
import 'package:core/config/error/failure.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:loan/features/foreclosure/data/models/get_foreclosure_details.dart';
import 'package:loan/features/foreclosure/data/models/get_fund_of_source_response.dart';
import 'package:loan/features/foreclosure/data/models/get_loan_details_request.dart';
import 'package:loan/features/foreclosure/data/models/get_loan_details_response.dart';
import 'package:loan/features/foreclosure/data/models/get_loans_request.dart';
import 'package:loan/features/foreclosure/data/models/get_loans_response.dart';
import 'package:loan/features/foreclosure/data/models/get_offers_response.dart';
import 'package:loan/features/foreclosure/data/models/get_reasons_response.dart';
import 'package:loan/features/foreclosure/domain/usecases/foreclosure_usecase.dart';
import 'package:meta/meta.dart';
import 'package:payment_gateway/features/domain/models/payment_params/payment_product_type.dart';
import 'package:payment_gateway/features/domain/models/payment_params/payment_source_system.dart';
import 'package:service_ticket/features/data/models/service_request_response.dart';

import '../../data/models/service_request.dart';

part 'foreclosure_state.dart';

class ForeclosureCubit extends Cubit<ForeclosureState> {
  ForeclosureCubit({required this.foreclosureUseCase})
      : super(ForeclosureInitial());

  final ForeclosureUseCase foreclosureUseCase;

  void getLoans(GetLoansRequest request) async {
    emit(LoadingState(isloading: true));
    try {
      final result = await foreclosureUseCase.call(request);
      emit(LoadingState(isloading: false));
      result.fold((l) => emit(ForeclosureGetLoansFailureState(failure: l)),
          (r) => emit(ForeclosureGetLoansSuccessState(response: r)));
    } catch (e) {
      emit(LoadingState(isloading: false));
      emit(ForeclosureGetLoansFailureState(failure: NoDataFailure()));
    }
  }

  void getLoanDetails(GetLoanDetailsRequest request, LoanItem loanItem) async {
    emit(LoadingState(isloading: true));
    try {
      final result = await foreclosureUseCase.getLoanDetails(request);
      emit(LoadingState(isloading: false));
      result.fold(
          (l) => emit(GetLoanDetailsFailureState(failure: l)),
          (r) => emit(GetLoanDetailsSuccessState(
              response: r, selectLoanItem: loanItem)));
    } catch (e) {
      emit(LoadingState(isloading: false));
      emit(GetLoanDetailsFailureState(failure: NoDataFailure()));
    }
  }

  void getForeClosureDetails(GetLoanDetailsRequest request) async {
    try {
      emit(LoadingState(isloading: true));
      final result = await foreclosureUseCase.getForeClosureDetails(request);
      emit(LoadingState(isloading: false));
      result.fold((l) => emit(GetForeClosureDetailsFailureState(failure: l)),
          (r) => emit(GetForeClosureDetailsSuccessState(response: r)));
    } catch (e) {
      emit(LoadingState(isloading: false));
      emit(GetForeClosureDetailsFailureState(failure: NoDataFailure()));
    }
  }

  void getReasons(GetLoanDetailsRequest request) async {
    emit(LoadingState(isloading: true));
    try {
      final result = await foreclosureUseCase.getReasons(request);
      emit(LoadingState(isloading: false));
      result.fold((l) => emit(GetReasonsFailureState(failure: l)),
          (r) => emit(GetReasonsSuccessState(response: r.data!)));
    } catch (e) {
      emit(LoadingState(isloading: false));
      emit(GetReasonsFailureState(failure: NoDataFailure()));
    }
  }

  void getOffers(GetLoanDetailsRequest request) async {
    emit(LoadingState(isloading: true));
    try {
      final result = await foreclosureUseCase.getOffers(request);
      emit(LoadingState(isloading: false));
      result.fold((l) => emit(GetOffersFailureState(failure: l)),
          (r) => emit(GetOffersSuccessState(response: r)));
    } catch (e) {
      emit(LoadingState(isloading: false));
      emit(GetOffersFailureState(failure: NoDataFailure()));
    }
  }

  void getPreApprovedOffers(GetLoanDetailsRequest request) async {
    emit(LoadingState(isloading: true));
    try {
      final result = await foreclosureUseCase.getPreApprovedOffers(request);
      emit(LoadingState(isloading: false));
      result.fold((l) => emit(PreApprovedOffersFailureState(failure: l)),
          (r) => emit(PreApprovedOffersSuccessState(response: r)));
    } catch (e) {
      emit(LoadingState(isloading: false));
      emit(PreApprovedOffersFailureState(failure: NoDataFailure()));
    }
  }

  void getFundOfSource(GetLoanDetailsRequest request) async {
    emit(LoadingState(isloading: true));
    try {
      final result = await foreclosureUseCase.getFundOfSource(request);
      emit(LoadingState(isloading: false));
      result.fold((l) => emit(FundOfSourceFailureState(failure: l)),
          (r) => emit(FundOfSourceSuccessState(response: r.data!)));
    } catch (e) {
      emit(LoadingState(isloading: false));
      emit(FundOfSourceFailureState(failure: NoDataFailure()));
    }
  }

  void createForeclosureSR(ServiceRequest request) async {
    emit(LoadingState(isloading: true));
    try {
      final result = await foreclosureUseCase.createForeclosureSR(request);
      emit(LoadingState(isloading: false));
      result.fold((l) => emit(CreateForeclosureSRFailureState(failure: l)),
          (r) => emit(CreateForeclosureSRSuccessState(response: r)));
    } catch (e) {
      emit(LoadingState(isloading: false));
      emit(CreateForeclosureSRFailureState(failure: NoDataFailure()));
    }
  }

  void updateText(String? newText) {
    emit(TextFieldState(text: newText));
  }

  void setLoanItem(LoanItem? loanItem) {
    emit(SelectedLoanItemState(loanItem: loanItem));
  }

  void selectReason(Reasons reasons, String name) {
    emit(DropDownState(resaon: reasons, name: name));
  }

  void offerButtonSelect(bool isAccepted) {
    emit(OfferButtonState(offer: isAccepted));
  }

  void updateStateAfterDismiss() {
    emit(OfferRejectedState()); // Update state after dialog dismissal
  }

  void showDetails(bool showMoreDetails) {
    emit(ShowDetailsState(showMoreDetails));
  }

  getPaymentProductType({String? productCategory}) {
    if (productCategory?.toLowerCase() == 'vehicle loan') {
      return PaymentProductType.vl;
    } else if (productCategory?.toLowerCase() == 'personal loan') {
      return PaymentProductType.pl;
    } else {
      return PaymentProductType.vl;
    }
  }

  getIconProductType({String? productCategory}) {
    if (productCategory?.toLowerCase() == 'vehicle loan') {
      return PaymentProductType.vl;
    } else if (productCategory?.toLowerCase() == 'personal loan') {
      return PaymentProductType.pl;
    } else {
      return PaymentProductType.vl;
    }
  }

  getSourceSystem({String? sourceSystem}) {
    if (sourceSystem?.toLowerCase() == 'autofin') {
      return PaymentSourceSystem.autofin;
    } else if (sourceSystem?.toLowerCase() == 'finnone') {
      return PaymentSourceSystem.finone;
    } else if (sourceSystem?.toLowerCase() == 'pennant') {
      return PaymentSourceSystem.pennant;
    }
  }

  getSubtitle({String? productCategory}) {
    if (productCategory?.toLowerCase() == 'vehicle loan') {
      return "";
    } else if (productCategory?.toLowerCase() == 'personal loan') {
      return PaymentProductType.pl;
    } else {
      return PaymentProductType.vl;
    }
  }
}
