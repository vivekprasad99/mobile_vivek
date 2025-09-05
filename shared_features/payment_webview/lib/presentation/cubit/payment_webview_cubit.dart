
import 'package:bloc/bloc.dart';
import 'package:payment_webview/presentation/cubit/payment_webview_state.dart';

class PaymentWebViewCubit extends Cubit<PaymentWebViewState> {
  PaymentWebViewCubit() : super(PaymentWebViewInitial());

  void showPaymentError({required bool showError}) {
    emit(PaymentErrorState(showError: showError));
  }
}
