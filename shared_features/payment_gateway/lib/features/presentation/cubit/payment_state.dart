part of 'payment_cubit.dart';

sealed class PaymentGatewayState {}

final class PaymentGatewayInitialState extends PaymentGatewayState {}

final class TestState extends PaymentGatewayState {}

class LoadingState extends PaymentGatewayState {
  final bool isLoading;
  LoadingState({required this.isLoading});
}

final class AmountDetailsState extends PaymentGatewayState {
  AmountDetailsState(this.showMoreDetails);
  bool showMoreDetails = false;
}

final class ShowTransactionMoreDetailsState extends PaymentGatewayState {
  ShowTransactionMoreDetailsState(this.showMoreDetails);
  bool showMoreDetails = false;
}

final class ChoosePaymentModeState extends PaymentGatewayState {
  ChoosePaymentModeState(this.paymentMode);
  PaymentModeEnum paymentMode;
}

final class PayableAmountValidationState extends PaymentGatewayState {
  PayableAmountValidationState(this.isAmountValid);
  bool isAmountValid = false;
}

final class ShowAmountWarningState extends PaymentGatewayState {
  ShowAmountWarningState(this.showAmountWarning);
  bool showAmountWarning = false;
}

final class PaymentStatusDataState extends PaymentGatewayState {
  PaymentStatusDataState(this.paymentStatusDataModel);
  PaymentStatusDataModel paymentStatusDataModel;
}

final class GetTransactionIdResponseState extends PaymentGatewayState {
  GetTransactionIdResponseState({required this.response});
  GetTransactionIdResponse response;
}

final class UpdatePaymentDetailState extends PaymentGatewayState {
  UpdatePaymentDetailState({required this.response});
  UpdatePaymentDetailResponse response;
}
final class GetPaymentCredentialsState extends PaymentGatewayState {
  GetPaymentCredentialsState({required this.response});
  PaymentCredentialsResponseModel response;
}

class PaymentGatewayFailureState extends PaymentGatewayState {
  final Failure error;
  PaymentGatewayFailureState({required this.error});
}

final class GetPaymentOptionsState extends PaymentGatewayState {
  GetPaymentOptionsState({required this.response});
  PaymentOptionsResponeModel response;
}