import 'package:core/config/error/failure.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loan_refund/features/data/models/loan_refund_add_bank_account_request.dart';
import 'package:loan_refund/features/domain/usecases/loan_refund_add_bank_account_usecase.dart';
import 'package:loan_refund/features/presentation/cubit/loan_refund_add_bank_account_state.dart';

class LoanRefundAddBankAccountCubit extends Cubit<LoanRefundAddBankAccountState> {
  final LoanRefundAddBankAccountUseCase loanrefundaddbankaccountusecase;
  LoanRefundAddBankAccountCubit({required this.loanrefundaddbankaccountusecase})
      : super(LoanRefundAddBankAccountInitialState());

 

  addBankAccountDetailList(
    LoanRefundAddBankAccountRequest request,
  ) async {
    try {
      emit(LoanRefundAddBankAccountLoadingState(isLoading: true));
      final result = await loanrefundaddbankaccountusecase.call(request);
      emit(LoanRefundAddBankAccountLoadingState(isLoading: false));
      result.fold((l) => emit(LoanRefundAddBankAccountFailureState(error: l)),
          (r) => emit(LoanRefundAddBankAccountSuccessState(bankresponse: r)));
    } catch (e) {
      emit(LoanRefundAddBankAccountLoadingState(isLoading: false));
      emit(LoanRefundAddBankAccountFailureState(error: NoDataFailure()));
    }
  }
}
