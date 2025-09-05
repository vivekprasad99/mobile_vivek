import 'package:core/config/error/failure.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:loan_refund/features/data/models/loan_refund_add_bank_account_response.dart';

@immutable
sealed class LoanRefundAddBankAccountState extends Equatable {}

class LoanRefundAddBankAccountInitialState extends LoanRefundAddBankAccountState {
  @override
  List<Object?> get props => [];
}

class LoanRefundAddBankAccountLoadingState extends LoanRefundAddBankAccountState {
  final bool isLoading;
  LoanRefundAddBankAccountLoadingState({required this.isLoading});
  @override
  List<Object?> get props => [];
}

class LoanRefundAddBankAccountSuccessState extends LoanRefundAddBankAccountState {
  final LoanRefundAddBankAccountResponse bankresponse;
  LoanRefundAddBankAccountSuccessState({required this.bankresponse});
  @override
  List<Object?> get props => [bankresponse];
}

class LoanRefundAddBankAccountFailureState extends LoanRefundAddBankAccountState {
  final Failure error;
  LoanRefundAddBankAccountFailureState({required this.error});

  @override
  List<Object?> get props => [error];
}
