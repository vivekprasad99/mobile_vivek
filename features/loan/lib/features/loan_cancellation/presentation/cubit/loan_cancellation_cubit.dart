import 'package:bloc/bloc.dart';
import 'package:core/config/error/failure.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
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
import 'package:loan/features/loan_cancellation/domain/usecases/lc_usecase.dart';
import 'package:meta/meta.dart';

part 'loan_cancellation_state.dart';

class LoanCancellationCubit extends Cubit<LoanCancellationState> {
  LoanCancellationCubit({required this.loanCancellationUseCase})
      : super(LoanCancellationInitial());

  final LoanCancellationUseCase loanCancellationUseCase;

  void getLoans(GetLoansCancellationRequest request) async {
    try {
      emit(LoadingState(isloading: true));
      final result = await loanCancellationUseCase.call(request);
      emit(LoadingState(isloading: false));
      result.fold((l) => emit(LoanCancellationGetLoansFailureState(failure: l)),
          (r) => emit(LoanCancellationGetLoansSuccessState(response: r)));
    } catch (e) {
      emit(LoanCancellationGetLoansFailureState(failure: NoDataFailure()));
    }
  }

  void getReasons() async {
    try {
      emit(LoadingState(isloading: true));
      final result = await loanCancellationUseCase.getReasons();
      emit(LoadingState(isloading: false));
      result.fold((l) => emit(GetCancelReasonsFailureState(failure: l)),
          (r) => emit(GetCancelReasonsSuccessState(response: r.data ?? [])));
    } catch (e) {
      emit(GetCancelReasonsFailureState(failure: NoDataFailure()));
    }
  }

  void getOffers() async {
    try {
      emit(LoadingState(isloading: true));

      final result = await loanCancellationUseCase.getOffers();
      emit(LoadingState(isloading: false));
      result.fold(
          (l) => emit(LoanCancellationgetOffersFailureState(failure: l)),
          (r) => emit(LoanCancellationgetOffersSuccessState(response: r)));
    } catch (e) {
      emit(LoanCancellationgetOffersFailureState(failure: NoDataFailure()));
    }
  }

  void fetchSR(FetchSrRequest request) async {
    try {
      final result = await loanCancellationUseCase.fetchSR(request);
      final flpTenure = await loanCancellationUseCase.getFlpTenure();

      result.fold(
        (l) => emit(FetchSrFailureState(failure: l)),
        (r) => emit(
          FetchSrSuccessState(
            response: r,
            flpTenureDays: flpTenure.fold((l) => 0, (a) => a.data?.days),
          ),
        ),
      );
    } catch (e) {
      emit(FetchSrFailureState(failure: NoDataFailure()));
    }
  }

  void getLoanCharges(GetLoanChargesRequest request) async {
    try {
      emit(LoadingState(isloading: true));
      final result = await loanCancellationUseCase.getLoanCharges(request);
      emit(LoadingState(isloading: false));
      result.fold((l) => emit(GetLoanChargesFailureState(failure: l)),
          (r) => emit(GetLoanChargesSuccessState(response: r)));
    } catch (e) {
      emit(FetchSrFailureState(failure: NoDataFailure()));
    }
  }

  void createSR(CreateSrRequest request) async {
    try {
      emit(LoadingState(isloading: true));
      final result = await loanCancellationUseCase.createSR(request);
      emit(LoadingState(isloading: false));
      result.fold((l) => emit(CreateSrFailureState(failure: l)),
          (r) => emit(CreateSrSuccessState(response: r)));
    } catch (e) {
      emit(FetchSrFailureState(failure: NoDataFailure()));
    }
  }

  void setLoanItem(LoanCancelItem? loanItem) {
    emit(SelectedLoanItemState(loanItem: loanItem));
  }

  void selectReason(CancelReasons reasons, String name) {
    emit(DropDownState(resaon: reasons, name: name));
  }
}
