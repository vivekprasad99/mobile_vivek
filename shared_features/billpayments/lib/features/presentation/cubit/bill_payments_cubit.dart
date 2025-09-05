import 'package:billpayments/features/data/models/bill_payment_request.dart';
import 'package:billpayments/features/data/models/get_bill_payments_response.dart';
import 'package:billpayments/features/domain/usecases/billpayments_usecase.dart';
import 'package:billpayments/features/presentation/upcoming_loans_vm.dart';
import 'package:billpayments/features/presentation/utils/constants.dart';
import 'package:billpayments/features/presentation/utils/services.dart';
import 'package:bloc/bloc.dart';
import 'package:core/config/error/failure.dart';
import 'package:flutter/widgets.dart';
import 'package:equatable/equatable.dart';
import 'package:product_details/data/models/active_loan_list_request.dart';
import 'package:product_details/data/models/active_loan_list_response.dart';
import 'package:product_details/domain/usecases/product_detail_usecases.dart';
part 'bill_payments_state.dart';

class BillPaymentsCubit extends Cubit<BillPaymentsState> {
  final BillPaymentsUseCase usecase;
  final ProductDetailsUseCase productDetailsUseCase;
  final UpcomingPaymentViewModel upcomingPaymentViewModel;

  BillPaymentsCubit({required this.usecase, required this.productDetailsUseCase, required this.upcomingPaymentViewModel}) : super(BillPaymentsInitial());

  void getBbpsUrl(BillPaymentRequest request) async {
    emit(LoadingState(isloading: true));
    await Future.delayed(const Duration(seconds: 3));
    final result = await usecase.call(request);
    emit(LoadingState(isloading: false));
    result.fold((l) => emit(GetBbpsUrlFailureState(failure: l)),
        (r) => emit(GetBbpsUrlSuccessState(response: r)));
  }


  void getActiveLoansList(ActiveLoanListRequest request) async {
    emit(LoadingState(isloading: true));
    await Future.delayed(const Duration(seconds: 3));
    final result = await productDetailsUseCase.call(request);
    emit(LoadingState(isloading: false));
    result.fold((l) => emit(GetActiveLoansListFailureState(failure: l)),
        (r) => emit(GetActiveLoansListSuccessState(response: r)));
  }

  

   void setPayableAmountValidation(String amount) {
    if (getAmountAsDouble(amount) < PaymentConstants.minimumPayableAmount) {
      emit(PayableAmountValidationState(false));
    } else {
      emit(PayableAmountValidationState(true));
    }
  }

  void showAmountDetails(bool showMoreDetails) {
    emit(AmountDetailsState(showMoreDetails));
  }
}
