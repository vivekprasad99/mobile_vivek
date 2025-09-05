import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loan/features/foreclosure/data/models/get_foreclosure_details.dart';
import 'package:loan/features/foreclosure/data/models/get_loan_details_request.dart';
import 'package:loan/features/foreclosure/data/models/get_loan_details_response.dart';
import 'package:loan/features/foreclosure/domain/usecases/foreclosure_usecase.dart';
import 'package:payment_gateway/features/domain/models/payment_params/payment_product_type.dart';
import 'package:payment_gateway/features/domain/models/payment_params/payment_source_system.dart';
import 'package:product/data/models/product_feature_request.dart';
import 'package:product/data/models/product_feature_response.dart';
import 'package:product/domain/usecases/product_feature_usecase.dart';
import 'package:product_details/data/models/active_loan_detail_request.dart';
import 'package:product_details/data/models/active_loan_detail_response.dart';
import 'package:product_details/data/models/active_loan_list_request.dart';
import 'package:product_details/data/models/active_loan_list_response.dart';
import 'package:product_details/data/models/documents_response.dart';
import 'package:product_details/data/models/doucments_request.dart';
import 'package:product_details/data/models/payment_request.dart';
import 'package:product_details/data/models/payment_response.dart';
import 'package:product_details/data/models/set_payemnt_reminder_request.dart';
import 'package:product_details/data/models/set_payment_reminder_reponse.dart';
import 'package:product_details/domain/usecases/product_detail_usecases.dart';
import 'package:equatable/equatable.dart';
import 'package:core/config/error/failure.dart';
import 'package:product_details/utils/constants.dart';
import 'package:product_details/utils/services.dart';

part 'product_details_state.dart';

class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  ProductDetailsCubit(
      {required this.usecase,
      required this.foreclosureUseCase,
      required this.productFeatureUseCase})
      : super(ProductDetailsInitial());

  final ProductDetailsUseCase usecase;
  final ForeclosureUseCase foreclosureUseCase;
  final ProductFeatureUseCase productFeatureUseCase;

  void getActiveLoansList(ActiveLoanListRequest request) async {
    try {
      emit(LoadingState(isloading: true));
      final result = await usecase.call(request);
      emit(LoadingState(isloading: false));
      result.fold((l) => emit(GetActiveLoansListFailureState(failure: l)),
          (r) => emit(GetActiveLoansListSuccessState(response: r)));
    } catch (e) {
      emit(LoadingState(isloading: false));
      emit(GetActiveLoansListFailureState(failure: NoDataFailure()));
    }
  }

  void getActiveLoansDetails(ActiveLoanDetailRequest request) async {
    try {
      emit(LoadingState(isloading: true));
      final result = await usecase.getActiveLoansDetails(request);
      emit(LoadingState(isloading: false));
      result.fold((l) => emit(GetActiveLoansDetailsFailureState(failure: l)),
          (r) => emit(GetActiveLoansDetailsSuccessState(response: r)));
    } catch (e) {
      emit(LoadingState(isloading: false));
      emit(GetActiveLoansDetailsFailureState(failure: NoDataFailure()));
    }
  }

  void getPaymentHistory(PaymentRequest request) async {
    try {
      emit(LoadingState(isloading: true));
      final result = await usecase.getPaymentHistory(request);
      emit(LoadingState(isloading: false));
      result.fold((l) => emit(GetPaymentHistoryFailureState(failure: l)),
          (r) => emit(GetPaymentHistorySuccessState(response: r)));
    } catch (e) {
      emit(LoadingState(isloading: false));
      emit(GetPaymentHistoryFailureState(failure: NoDataFailure()));
    }
  }

  void getDocuments(DocumentsRequest request) async {
    try {
      emit(LoadingState(isloading: true));
      final result = await usecase.getDocuments(request);
      emit(LoadingState(isloading: false));
      result.fold((l) => emit(GetDocumentsFailureState(failure: l)),
          (r) => emit(GetDocumentsSuccessState(response: r)));
    } catch (e) {
      emit(LoadingState(isloading: false));
      emit(GetDocumentsFailureState(failure: NoDataFailure()));
    }
  }

  void setPaymentReminders(SetPaymentReminderRequest request) async {
    emit(LoadingState(isloading: true));
    final result = await usecase.setPaymentReminderRequest(request);
    emit(LoadingState(isloading: false));
    result.fold((l) => emit(SetPaymentReminderFailureState(failure: l)),
        (r) => emit(SetPaymentReminderSuccessState(response: r)));
  }

  void showAmountDetails(bool showMoreDetails) {
    emit(AmountDetailsState(showMoreDetails));
  }

  void setPayableAmountValidation(String amount, double maxCap) {
    var amountInWords = capitalizeAmountString(
        numberToWords(getAmountAsDouble(amount).toInt()));
    if (getAmountAsDouble(amount) < PaymentConstants.minimumPayableAmount ||
        getAmountAsDouble(amount) > maxCap) {
      emit(PayableAmountValidationState(false, amountInWords));
    } else {
      emit(PayableAmountValidationState(true, amountInWords));
    }
  }

  void setAmountWarningVisibilty(bool showAmountWarning) {
    emit(ShowAmountWarningState(showAmountWarning));
  }

  void getForeClosureDetails(GetLoanDetailsRequest request) async {
    try {
      emit(LoadingState(isloading: true));
      final result = await foreclosureUseCase.getForeClosureDetails(request);
      emit(LoadingState(isloading: false));
      result.fold((l) => emit(GetForeClosureDetailsFailureState(failure: l)),
          (r) => emit(GetForeClosureDetailsSuccessState(response: r)));
    } catch (e) {
      emit(LoadingState(isloading: false));
      emit(GetForeClosureDetailsFailureState(failure: NoDataFailure()));
    }
  }

  void getLoanDetails(GetLoanDetailsRequest request) async {
    emit(LoadingState(isloading: true));
    try {
      final result = await foreclosureUseCase.getLoanDetails(request);
      emit(LoadingState(isloading: false));
      result.fold(
          (l) => emit(GetLoanDetailsFailureState(failure: l)),
          (r) => emit(GetLoanDetailsSuccessState(
                response: r,
              )));
    } catch (e) {
      emit(LoadingState(isloading: false));
      emit(GetLoanDetailsFailureState(failure: NoDataFailure()));
    }
  }

  getPaymentProductType({String? productCategory}) {
    if (productCategory?.toLowerCase() == 'vehicle loan') {
      return PaymentProductType.vl;
    } else if (productCategory?.toLowerCase() == 'personal loan') {
      return PaymentProductType.pl;
    } else {
      return PaymentProductType.vl;
    }
  }

  getSourceSystem({String? sourceSystem}) {
    if (sourceSystem?.toLowerCase() == 'autofin') {
      return PaymentSourceSystem.autofin;
    } else if (sourceSystem?.toLowerCase() == 'finnone') {
      return PaymentSourceSystem.finone;
    } else if (sourceSystem?.toLowerCase() == 'pennant') {
      return PaymentSourceSystem.pennant;
    }
  }

  productFeature({required ProductFeatureRequest productFeatureRequest}) async {
    try {
      final result = await productFeatureUseCase.call(productFeatureRequest);
      emit(LoadingState(isloading: false));
      result.fold((l) => emit(ProductDetailBannerFailureState(failure: l)),
          (r) => emit(ProductDetailBannerSuccessState(response: r)));
    } catch (e) {
      emit(LoadingState(isloading: false));
      emit(ProductDetailBannerFailureState(failure: NoDataFailure()));
    }
  }

  void updateBottomToTop(bool? bottom) {
    emit(BottomToTopState(isBottom: bottom));
  }

  void getRepaymentScheduleDocuments(DocumentsRequest request) async {
    try {
      emit(LoadingState(isloading: true));
      final result = await usecase.getDocuments(request);
      emit(LoadingState(isloading: false));
      result.fold((l) => emit(GetRepaymentScheduleFailureState(failure: l)),
          (r) => emit(GetRepaymentScheduleSuccessState(response: r)));
    } catch (e) {
      emit(LoadingState(isloading: false));
      emit(GetRepaymentScheduleFailureState(failure: NoDataFailure()));
    }
  }

  void getKfsDocuments(DocumentsRequest request) async {
    try {
      emit(LoadingState(isloading: true));
      final result = await usecase.getDocuments(request);
      emit(LoadingState(isloading: false));
      result.fold((l) => emit(GetKfsFailureState(failure: l)),
          (r) => emit(GetKfsSuccessState(response: r)));
    } catch (e) {
      emit(LoadingState(isloading: false));
      emit(GetKfsFailureState(failure: NoDataFailure()));
    }
  }

  void updateSeeMore(int length) {
    emit(UpdateSeeMoreState(length: length));
  }
}
