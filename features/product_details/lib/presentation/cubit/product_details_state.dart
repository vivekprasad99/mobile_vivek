// ignore_for_file: public_member_api_docs, sort_constructors_first

part of 'product_details_cubit.dart';

@immutable
sealed class ProductDetailsState extends Equatable {}

final class ProductDetailsInitial extends ProductDetailsState {
  @override
  List<Object?> get props => [];
}

class LoadingState extends ProductDetailsState {
  final bool isloading;

  LoadingState({required this.isloading});

  @override
  List<Object?> get props => [isloading];
}

class GetActiveLoansListSuccessState extends ProductDetailsState {
  final ActiveLoanListResponse response;

  GetActiveLoansListSuccessState({required this.response});

  @override
  List<Object?> get props => [response];
}

class GetActiveLoansListFailureState extends ProductDetailsState {
  final Failure failure;

  GetActiveLoansListFailureState({required this.failure});

  @override
  List<Object?> get props => [failure];
}

class GetActiveLoansDetailsSuccessState extends ProductDetailsState {
  final ActiveLoanDetailResponse response;

  GetActiveLoansDetailsSuccessState({required this.response});

  @override
  List<Object?> get props => [response];
}

class GetActiveLoansDetailsFailureState extends ProductDetailsState {
  final Failure failure;

  GetActiveLoansDetailsFailureState({required this.failure});

  @override
  List<Object?> get props => [failure];
}

class GetPaymentHistorySuccessState extends ProductDetailsState {
  final PaymentResponse response;

  GetPaymentHistorySuccessState({required this.response});

  @override
  List<Object?> get props => [response];
}

class GetPaymentHistoryFailureState extends ProductDetailsState {
  final Failure failure;

  GetPaymentHistoryFailureState({required this.failure});

  @override
  List<Object?> get props => [failure];
}

class GetDocumentsSuccessState extends ProductDetailsState {
  final DocumentsResponse response;

  GetDocumentsSuccessState({required this.response});

  @override
  List<Object?> get props => [response];
}

class GetDocumentsFailureState extends ProductDetailsState {
  final Failure failure;

  GetDocumentsFailureState({required this.failure});

  @override
  List<Object?> get props => [failure];
}

class SetPaymentReminderFailureState extends ProductDetailsState {
  final Failure failure;

  SetPaymentReminderFailureState({required this.failure});

  @override
  List<Object?> get props => [failure];
}

class SetPaymentReminderSuccessState extends ProductDetailsState {
  final SetPaymentReminderResponse response;

  SetPaymentReminderSuccessState({required this.response});

  @override
  List<Object?> get props => [response];
}
// ignore_for_file: must_be_immutable
final class AmountDetailsState extends ProductDetailsState {
  AmountDetailsState(this.showMoreDetails);

  bool showMoreDetails = false;

  @override
  List<Object?> get props => [showMoreDetails];
}

final class PayableAmountValidationState extends ProductDetailsState {
  PayableAmountValidationState(this.isAmountValid, this.amountInWords);
  String amountInWords;
  bool isAmountValid = false;

  @override
  List<Object?> get props => [isAmountValid, amountInWords];
}

final class ShowAmountWarningState extends ProductDetailsState {
  ShowAmountWarningState(this.showAmountWarning);

  bool showAmountWarning = false;

  @override
  List<Object?> get props => [showAmountWarning];
}

class GetForeClosureDetailsSuccessState extends ProductDetailsState {
  final GetForeClosureDetailsResponse response;

  GetForeClosureDetailsSuccessState({required this.response});

  @override
  List<Object?> get props => [response];
}

class GetForeClosureDetailsFailureState extends ProductDetailsState {
  final Failure failure;

  GetForeClosureDetailsFailureState({required this.failure});

  @override
  List<Object?> get props => [failure];
}

class GetLoanDetailsSuccessState extends ProductDetailsState {
  final GetLoanDetailsResponse response;

  GetLoanDetailsSuccessState({required this.response});

  @override
  List<Object?> get props => [response];
}

class GetLoanDetailsFailureState extends ProductDetailsState {
  final Failure failure;

  GetLoanDetailsFailureState({required this.failure});

  @override
  List<Object?> get props => [failure];
}

class ProductDetailBannerSuccessState extends ProductDetailsState {
  final ProductFeatureResponse response;

  ProductDetailBannerSuccessState({required this.response});

  @override
  List<Object?> get props => [response];
}

class ProductDetailBannerFailureState extends ProductDetailsState {
  final Failure failure;

  ProductDetailBannerFailureState({required this.failure});

  @override
  List<Object?> get props => [failure];
}

class BottomToTopState extends ProductDetailsState {
  final bool? isBottom;

  BottomToTopState({required this.isBottom});

  @override
  List<Object?> get props => [isBottom];
}

class GetRepaymentScheduleSuccessState extends ProductDetailsState {
  final DocumentsResponse response;

  GetRepaymentScheduleSuccessState({required this.response});

  @override
  List<Object?> get props => [response];
}

class GetRepaymentScheduleFailureState extends ProductDetailsState {
  final Failure failure;

  GetRepaymentScheduleFailureState({required this.failure});

  @override
  List<Object?> get props => [failure];
}

class GetKfsSuccessState extends ProductDetailsState {
  final DocumentsResponse response;

  GetKfsSuccessState({required this.response});

  @override
  List<Object?> get props => [response];
}

class GetKfsFailureState extends ProductDetailsState {
  final Failure failure;

  GetKfsFailureState({required this.failure});

  @override
  List<Object?> get props => [failure];
}

class UpdateSeeMoreState extends ProductDetailsState {
  final int? length;

  UpdateSeeMoreState({required this.length});

  @override
  List<Object?> get props => [length];
}
