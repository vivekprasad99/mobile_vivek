import 'package:ach/data/models/fetch_applicant_name_req.dart';
import 'package:ach/data/models/fetch_bank_account_req.dart';
import 'package:ach/data/models/get_ach_loans_request.dart';
import 'package:ach/data/models/get_ach_loans_response.dart';
import 'package:ach/domain/usecases/ach_usecase.dart';
import 'package:core/config/error/failure.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loan_refund/features/data/models/loan_refund_consent_request.dart';
import 'package:loan_refund/features/domain/usecases/loan_refund_usecases.dart';
import 'package:loan_refund/features/presentation/cubit/loan_refund_state.dart';
import 'package:loan_refund/features/presentation/loan_refund_viewmodel.dart';

class LoanRefundCubit extends Cubit<LoanRefundState> {
  final LoanRefundUseCase loanRefundUseCase;
  final AchUsecase achUsecase;
  final LoanRefundViewModel loanRefundViewModel;

  LoanRefundCubit(
      {required this.loanRefundUseCase,
      required this.achUsecase,
      required this.loanRefundViewModel})
      : super(LoanRefundInitial());

  void getLoanList({required GetAchLoansRequest request}) async {
    try {
      emit(LoanRefundLoadingState(isLoading: true));
      final result = await achUsecase.call(request);
      emit(LoanRefundLoadingState(isLoading: false));
      result.fold((l) {
        emit(LoanRefundFailureState(error: l));
      }, (r) {
        loanRefundViewModel.setLoanList(r.data ?? []);
        emit(RefundLoanListSuccessState(response: r));
      });
    } catch (e) {
      emit(LoanRefundLoadingState(isLoading: false));
      emit(LoanRefundFailureState(error: NoDataFailure()));
    }
  }

  void fetchApplicantName(
      FetchApplicantNameReq request,
      LoanRefundState loanRefundState,
      bool isPennyDropOnly,
      bool isAdjust) async {
    try {
      emit(LoanRefundLoadingState(isLoading: true));
      final result = await achUsecase.fetchApplicantName(request);
      emit(LoanRefundLoadingState(isLoading: false));
      result.fold(
          (l) => emit(FetchApplicantNameFailureState(failure: l)),
          (r) => emit(FetchApplicantNameSuccessState(
              response: r,
              loanRefundState: loanRefundState,
              forPennyDropOnly: isPennyDropOnly,
              forAdjust: isAdjust)));
    } catch (e) {
      emit(LoanRefundLoadingState(isLoading: false));
      emit(FetchApplicantNameFailureState(failure: NoDataFailure()));
    }
  }

  void fetchBankAccount(
      FetchBankAccountRequest request,
      LoanRefundState? loanRefundState,
      bool? isPennyDropOnly,
      bool? isAdjust) async {
    try {
      emit(LoanRefundLoadingState(isLoading: true));
      final result = await achUsecase.fetchBankAccount(request);
      emit(LoanRefundLoadingState(isLoading: false));
      result.fold(
          (l) => emit(FetchBankAccountFailureState(failure: l)),
          (r) => emit(FetchBankAccountSuccessState(
              response: r,
              loanRefundState: loanRefundState,
              forPennyDropOnly: isPennyDropOnly,
              forAdjust: isAdjust)));
    } catch (e) {
      emit(LoanRefundLoadingState(isLoading: false));
      emit(FetchBankAccountFailureState(failure: NoDataFailure()));
    }
  }

  void doConsent({required LoanRefundConsentRequest request}) async {
    try {
      emit(LoanRefundLoadingState(isLoading: true));
      final result = await loanRefundUseCase.call(request);
      emit(LoanRefundLoadingState(isLoading: false));
      result.fold((l) {
        emit(LoanRefundFailureState(error: l));
      }, (r) {
        emit(OverdueAdjustmentConsentDone(response: r));
      });
    } catch (e) {
      emit(LoanRefundLoadingState(isLoading: false));
      emit(LoanRefundFailureState(error: NoDataFailure()));
    }
  }

  void doRefund(LoanData loanData, {bool forceAdjust = false}) {
    emit(LoanRefundLoadingState(isLoading: true));
    loanRefundViewModel.setSelectedLoan(loanData);
    if (loanRefundViewModel.isRefundOrAdjustAnythingApplicable()) {
      var refundStateResult =
          loanRefundViewModel.refund(forceAdjust: forceAdjust);
      refundStateResult.selectedLoan = loanData;
      emit(LoanRefundLoadingState(isLoading: false));
      emit(refundStateResult);
    } else {
      emit(LoanRefundLoadingState(isLoading: false));
      emit(NoRefund());
    }
  }
}
