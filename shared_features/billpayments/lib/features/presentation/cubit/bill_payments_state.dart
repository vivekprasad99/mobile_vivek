// ignore_for_file: must_be_immutable

part of 'bill_payments_cubit.dart';

@immutable
sealed class BillPaymentsState extends Equatable {}

final class BillPaymentsInitial extends BillPaymentsState {
  @override
  List<Object?> get props => [];
}

class LoadingState extends BillPaymentsState {
  final bool isloading;

  LoadingState({required this.isloading});

  @override
  List<Object?> get props => [isloading];
}

class GetActiveLoansListFailureState extends BillPaymentsState {
  final Failure failure;

  GetActiveLoansListFailureState({required this.failure});

  @override
  List<Object?> get props => [failure];
}

class GetActiveLoansListSuccessState extends BillPaymentsState {
  final ActiveLoanListResponse response;

  GetActiveLoansListSuccessState({required this.response});

  @override
  List<Object?> get props => [response];
}

class GetBbpsUrlSuccessState extends BillPaymentsState {
  final GetBillPaymentResponse response;

  GetBbpsUrlSuccessState({required this.response});

  @override
  List<Object?> get props => [response];
}

class GetBbpsUrlFailureState extends BillPaymentsState {
  final Failure failure;

  GetBbpsUrlFailureState({required this.failure});

  @override
  List<Object?> get props => [failure];
}

class PayableAmountValidationState extends BillPaymentsState {
   bool isAmountValid =  false;
  PayableAmountValidationState(this.isAmountValid);
  @override
  List<Object?> get props => [isAmountValid];
}
class ShowAmountWarningState extends BillPaymentsState {
   bool showAmountWarning = false;
  ShowAmountWarningState({required this.showAmountWarning});
  @override
  List<Object?> get props => [showAmountWarning];
}
class AmountDetailsState extends BillPaymentsState {
   bool showMoreDetails = false;
  AmountDetailsState( this.showMoreDetails);
  @override
  List<Object?> get props => [showMoreDetails];
}




