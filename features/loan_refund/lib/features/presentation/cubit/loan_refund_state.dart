import 'package:ach/data/models/fetch_applicant_name_res.dart';
import 'package:ach/data/models/fetch_bank_accoun_response.dart';
import 'package:ach/data/models/get_ach_loans_response.dart';
import 'package:core/config/error/failure.dart';
import 'package:equatable/equatable.dart';
import 'package:loan_refund/features/data/models/loan_refund_consent_response.dart';

// ignore_for_file: must_be_immutable
sealed class LoanRefundState extends Equatable {
  LoanData? selectedLoan;
}

final class LoanRefundInitial extends LoanRefundState {
  @override
  List<Object?> get props => [];
}

class LoanRefundLoadingState extends LoanRefundState {
  final bool isLoading;

  LoanRefundLoadingState({this.isLoading = false});

  @override
  List<Object?> get props => [isLoading];
}

class LoanRefundOnlyLoadingState extends LoanRefundState {
  final bool isLoading;

  LoanRefundOnlyLoadingState({required this.isLoading,

  });

  @override
  List<Object?> get props => [isLoading];
}

class RefundLoanListSuccessState extends LoanRefundState {
  final GetAchLoansResponse response;

  RefundLoanListSuccessState({required this.response});

  @override
  List<Object?> get props => [response];
}

class LoanRefundFailureState extends LoanRefundState {
  final Failure error;

  LoanRefundFailureState({required this.error});

  @override
  List<Object?> get props => [error];
}

class FetchApplicantNameSuccessState extends LoanRefundState {
  final FetchApplicantNameRes response;
  final LoanRefundState? loanRefundState;
  final bool? forPennyDropOnly;
  final bool? forAdjust;

  FetchApplicantNameSuccessState(
      {required this.response,
      this.loanRefundState,
      this.forPennyDropOnly,
      this.forAdjust});

  @override
  List<Object?> get props =>
      [response, loanRefundState, forPennyDropOnly, forAdjust];
}

class FetchApplicantNameFailureState extends LoanRefundState {
  final Failure failure;

  FetchApplicantNameFailureState({required this.failure});

  @override
  List<Object?> get props => [failure];
}

class FetchBankAccountSuccessState extends LoanRefundState {
  final FetchBankAccountResponse response;
  final LoanRefundState? loanRefundState;
  final bool? forPennyDropOnly;
  final bool? forAdjust;

  FetchBankAccountSuccessState(
      {required this.response,
      this.loanRefundState,
      this.forPennyDropOnly,
      this.forAdjust});

  @override
  List<Object?> get props =>
      [response, loanRefundState, forPennyDropOnly, forAdjust];
}

class FetchBankAccountFailureState extends LoanRefundState {
  final Failure failure;

  FetchBankAccountFailureState({required this.failure});

  @override
  List<Object?> get props => [failure];
}

class OverdueAdjustmentConsentDone extends LoanRefundState {
  final LoanRefundConsentResponse response;

  OverdueAdjustmentConsentDone({required this.response});

  @override
  List<Object?> get props => [];
}

class NoRefund extends LoanRefundState {
  final Failure? reason;

  NoRefund({this.reason});

  @override
  List<Object?> get props => [reason];
}

// Scenario 1, 4, 5
class RefundWithPennyDropAndSR extends LoanRefundState {
  final String srMessage;

  RefundWithPennyDropAndSR({required this.srMessage});

  @override
  List<Object?> get props => [srMessage];
}

//scenario 2
class AdjustOnly extends LoanRefundState {
  final String srMessage;

  AdjustOnly({required this.srMessage});

  @override
  List<Object?> get props => [srMessage, selectedLoan];
}

//scenario 3
class RefundWithCreateMandateAndSR extends LoanRefundState {
  final String srMessage;

  RefundWithCreateMandateAndSR({required this.srMessage});

  @override
  List<Object?> get props => [srMessage];
}

// scenario 6, 14
class AdjustWithHoldACHSR extends LoanRefundState {
  final String srMessage;

  AdjustWithHoldACHSR({required this.srMessage});

  @override
  List<Object?> get props => [srMessage];
}

//scenario 7
class AdjustAndRefundWithPennyDropAndHoldACHSR extends LoanRefundState {
  final String srMessage;
  final double refundAmountAfterAdjust;

  AdjustAndRefundWithPennyDropAndHoldACHSR(
      {required this.srMessage, required this.refundAmountAfterAdjust});

  @override
  List<Object?> get props => [srMessage, refundAmountAfterAdjust];
}

// scenario 8, 11
class AdjustWithSR extends LoanRefundState {
  final String srMessage;

  AdjustWithSR({required this.srMessage});

  @override
  List<Object?> get props => [srMessage];
}

// scenario 9, 12, 13  // show dues list in review
class RefundAndAdjustWithPennyDropAndSR extends LoanRefundState {
  final String srMessage;
  final double refundAmountAfterAdjust;

  RefundAndAdjustWithPennyDropAndSR(
      {required this.srMessage, required this.refundAmountAfterAdjust});

  @override
  List<Object?> get props => [srMessage, refundAmountAfterAdjust];
}

// scenario 10  // show dues list in review
class RefundAndAdjustWithCreateMandateAndSR extends LoanRefundState {
  final String srMessage;
  final double refundAmountAfterAdjust;

  RefundAndAdjustWithCreateMandateAndSR(
      {required this.srMessage, required this.refundAmountAfterAdjust});

  @override
  List<Object?> get props => [srMessage, refundAmountAfterAdjust];
}

// scenario 15
class RefundAndAdjustWithPennyDropAndHoldACHSR extends LoanRefundState {
  final String srMessage;
  final double refundAmountAfterAdjust;

  RefundAndAdjustWithPennyDropAndHoldACHSR(
      {required this.srMessage, required this.refundAmountAfterAdjust});

  @override
  List<Object?> get props => [srMessage, refundAmountAfterAdjust];
}
