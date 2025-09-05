import 'package:core/config/error/failure.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loan_refund/features/data/models/loan_refund_bank_details_request.dart';
import 'package:loan_refund/features/domain/usecases/loan_refund_bank_details_usecase.dart';
import 'package:loan_refund/features/presentation/cubit/loan_refund_bank_details_state.dart';

class LoanRefundBankDetailsCubit extends Cubit<LoanRefundBankDetailsState> {
  final LoanRefundBankDetailsUseCase loanrefundbankdetailsusecase;
  LoanRefundBankDetailsCubit({required this.loanrefundbankdetailsusecase}) : super(LoanRefundBankDetailsInitialState());
  getLoanRefundBankDetailList(
    LoanRefundBankAccountDetailsRequest request,
  ) async {
    try {
      emit(LoanRefundBankDetailsLoadingState(isLoading: true));
      final result = await loanrefundbankdetailsusecase.call(request);
      emit(LoanRefundBankDetailsLoadingState(isLoading: false));
      result.fold((l) => emit(LoanRefundBankDetailsFailureState(error: l)),
          (r) => emit(LoanRefundBankDetailsSuccessState(bankresponse: r)));
    } catch (e) {
      emit(LoanRefundBankDetailsLoadingState(isLoading: false));
      emit(LoanRefundBankDetailsFailureState(error: NoDataFailure()));
    }
  }
}
