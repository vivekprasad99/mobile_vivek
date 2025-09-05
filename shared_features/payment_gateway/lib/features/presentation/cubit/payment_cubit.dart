import 'package:core/config/error/failure.dart';
import 'package:core/config/usecase/usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payment_gateway/features/data/models/get_payment_option_data_model.dart';
import 'package:payment_gateway/features/data/models/get_transaction_id_request.dart';
import 'package:payment_gateway/features/data/models/get_transaction_id_response.dart';
import 'package:payment_gateway/features/data/models/payment_cred_response_model.dart';
import 'package:payment_gateway/features/data/models/update_payment_detail_reponse.dart';
import 'package:payment_gateway/features/data/models/update_payment_detail_request.dart';
import 'package:payment_gateway/features/domain/usecases/get_payment_crdentials_usecase.dart';
import 'package:payment_gateway/features/domain/usecases/get_payment_option_data_usecase.dart';
import 'package:payment_gateway/features/domain/usecases/get_transaction_id_usecase.dart';
import 'package:payment_gateway/features/domain/usecases/updatePaymentDetailUsecase.dart';
import 'package:payment_gateway/features/presentation/utils/constants.dart';
import 'package:payment_gateway/features/presentation/utils/payment_mode_enum.dart';
import 'package:payment_gateway/features/presentation/utils/services/payment_screen_feed_model.dart';

import '../utils/services/services.dart';

part 'payment_state.dart';

class PaymentGatewayCubit extends Cubit<PaymentGatewayState> {
  PaymentGatewayCubit(
      {required this.getTransactionIDUsecase,
      required this.updatePaymentDetailUsecase,
      required this.getPaymentCredentialsUsecase,
      required this.getPaymentOptionDataUsecase,
      })
      : super(PaymentGatewayInitialState());

  final GetTransactionIDUsecase getTransactionIDUsecase;
  final UpdatePaymentDetailUsecase updatePaymentDetailUsecase;
  final GetPaymentCredentialsUsecase getPaymentCredentialsUsecase;
  final GetPaymentOptionDataUsecase getPaymentOptionDataUsecase;

  void showAmountDetails(bool showMoreDetails) {
    emit(AmountDetailsState(showMoreDetails));
  }

  void setPaymentMode(PaymentModeEnum paymentMode) {
    emit(ChoosePaymentModeState(paymentMode));
  }

  void setPayableAmountValidation(String amount) {
    if (getAmountAsDouble(amount) < PaymentConstants.minimumPayableAmount) {
      emit(PayableAmountValidationState(false));
    } else {
      emit(PayableAmountValidationState(true));
    }
  }

  void setAmountWarningVisibilty(bool showAmountWarning) {
    emit(ShowAmountWarningState(showAmountWarning));
  }

  void setTransactionMoreDetailsState(bool showMoreTransationDetail) {
    emit(ShowTransactionMoreDetailsState(showMoreTransationDetail));
  }

  void setPaymentStatusData(PaymentStatusDataModel paymentStatusDataModel) {
    emit(PaymentStatusDataState(paymentStatusDataModel));
  }

  void getTransactionId(GetTransactionIdRequest getTransactionIDRequest) async {
    try {
      emit(LoadingState(isLoading: true));
      final result =
          await getTransactionIDUsecase.call(getTransactionIDRequest);
      emit(LoadingState(isLoading: false));
      result.fold((l) => emit(PaymentGatewayFailureState(error: l)),
          (r) => emit(GetTransactionIdResponseState(response: r)));
    } catch (e) {
      emit(LoadingState(isLoading: false));
      emit(PaymentGatewayFailureState(error: NoDataFailure()));
    }
  }

  void updatePaymentDetail(
      UpdatePaymentDetailRequest updatePaymentDetailRequest) async {
    try {
      emit(LoadingState(isLoading: true));
      final result =
          await updatePaymentDetailUsecase.call(updatePaymentDetailRequest);
      emit(LoadingState(isLoading: false));
      result.fold((l) => emit(PaymentGatewayFailureState(error: l)),
          (r) => emit(UpdatePaymentDetailState(response: r)));
    } catch (e) {
      emit(LoadingState(isLoading: false));
      emit(PaymentGatewayFailureState(error: NoDataFailure()));
    }
  }
  void getPaymentCredentials() async {
    try {
      emit(LoadingState(isLoading: true));
      final result =
          await getPaymentCredentialsUsecase.call(NoParams());
      emit(LoadingState(isLoading: false));
      result.fold((l) => emit(PaymentGatewayFailureState(error: l)),
          (r) => emit(GetPaymentCredentialsState(response: r)));
    } catch (e) {
      emit(LoadingState(isLoading: false));
      emit(PaymentGatewayFailureState(error: NoDataFailure()));
    }
  }
  void getPaymentOptionData() async {
    try {
      emit(LoadingState(isLoading: true));
      final result =
          await getPaymentOptionDataUsecase.call(NoParams());
      emit(LoadingState(isLoading: false));
      result.fold((l) => emit(PaymentGatewayFailureState(error: l)),
          (r) => emit(GetPaymentOptionsState(response: r)));
    } catch (e) {
      emit(LoadingState(isLoading: false));
      emit(PaymentGatewayFailureState(error: NoDataFailure()));
    }
  }
}
