part of 'loan_cancellation_cubit.dart';

@immutable
sealed class LoanCancellationState extends Equatable {}

final class LoanCancellationInitial extends LoanCancellationState {
  @override
  List<Object?> get props => [];
}

class LoadingState extends LoanCancellationState {
  final bool isloading;

  LoadingState({required this.isloading});

  @override
  List<Object?> get props => [isloading];
}

class SelectedLoanItemState extends LoanCancellationState {
  final LoanCancelItem? loanItem;

  SelectedLoanItemState({required this.loanItem});

  @override
  List<Object?> get props => [loanItem];
}

class LoanCancellationGetLoansSuccessState extends LoanCancellationState {
  final GetLoanCancellationResponse response;

  LoanCancellationGetLoansSuccessState({required this.response});

  @override
  List<Object?> get props => [response];
}

class LoanCancellationGetLoansFailureState extends LoanCancellationState {
  final Failure failure;

  LoanCancellationGetLoansFailureState({required this.failure});

  @override
  List<Object?> get props => [failure];
}

class GetCancelReasonsSuccessState extends LoanCancellationState {
  final List<CancelReasons> response;

  GetCancelReasonsSuccessState({required this.response});

  @override
  List<Object?> get props => [response];
}

class GetCancelReasonsFailureState extends LoanCancellationState {
  final Failure failure;

  GetCancelReasonsFailureState({required this.failure});

  @override
  List<Object?> get props => [failure];
}

class DropDownState extends LoanCancellationState {
  final CancelReasons resaon;
  final String name;

  DropDownState({required this.resaon, required this.name});

  @override
  List<Object?> get props => [resaon, name];
}

class FetchSrSuccessState extends LoanCancellationState {
  final FetchSrResponse response;
  final int? flpTenureDays;

  FetchSrSuccessState({required this.response, required this.flpTenureDays});

  @override
  List<Object?> get props => [response, flpTenureDays];
}

class FetchSrFailureState extends LoanCancellationState {
  final Failure failure;

  FetchSrFailureState({required this.failure});

  @override
  List<Object?> get props => [failure];
}

class LoanCancellationgetOffersSuccessState extends LoanCancellationState {
  final GetOffersResponse response;

  LoanCancellationgetOffersSuccessState({required this.response});

  @override
  List<Object?> get props => [response];
}

class LoanCancellationgetOffersFailureState extends LoanCancellationState {
  final Failure failure;

  LoanCancellationgetOffersFailureState({required this.failure});

  @override
  List<Object?> get props => [failure];
}

class GetFlpTenureSuccessState extends LoanCancellationState {
  final GetFlpTenureResponse response;

  GetFlpTenureSuccessState({required this.response});

  @override
  List<Object?> get props => [response];
}

class GetFlpTenureFailureState extends LoanCancellationState {
  final Failure failure;

  GetFlpTenureFailureState({required this.failure});

  @override
  List<Object?> get props => [failure];
}

class GetLoanChargesSuccessState extends LoanCancellationState {
  final GetLoanChargesResponse response;

  GetLoanChargesSuccessState({required this.response});

  @override
  List<Object?> get props => [response];
}

class GetLoanChargesFailureState extends LoanCancellationState {
  final Failure failure;

  GetLoanChargesFailureState({required this.failure});

  @override
  List<Object?> get props => [failure];
}

class CreateSrSuccessState extends LoanCancellationState {
  final CreateSrResponse response;

  CreateSrSuccessState({required this.response});

  @override
  List<Object?> get props => [response];
}

class CreateSrFailureState extends LoanCancellationState {
  final Failure failure;

  CreateSrFailureState({required this.failure});

  @override
  List<Object?> get props => [failure];
}

class FetchSRLoadingState extends LoanCancellationState {
  @override
  List<Object?> get props => [];
}
