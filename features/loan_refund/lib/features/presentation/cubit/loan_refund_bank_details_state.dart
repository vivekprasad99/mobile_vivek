import 'package:core/config/error/failure.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:loan_refund/features/data/models/loan_refund_bank_details_response.dart';

@immutable
sealed class LoanRefundBankDetailsState extends Equatable {}

class LoanRefundBankDetailsInitialState extends LoanRefundBankDetailsState {
  @override
  List<Object?> get props => [];
}

class LoanRefundBankDetailsLoadingState extends LoanRefundBankDetailsState {
  final bool isLoading;
  LoanRefundBankDetailsLoadingState({required this.isLoading});
  @override
  List<Object?> get props => [];
}

class LoanRefundBankDetailsSuccessState extends LoanRefundBankDetailsState {
  final LoanRefundBankAccountDetailsResponse bankresponse;
  LoanRefundBankDetailsSuccessState({required this.bankresponse});
  @override
  List<Object?> get props => [bankresponse];
}

class LoanRefundBankDetailsFailureState extends LoanRefundBankDetailsState {
  final Failure error;
  LoanRefundBankDetailsFailureState({required this.error});

  @override
  List<Object?> get props => [error];
}
