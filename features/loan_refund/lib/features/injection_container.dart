import 'package:ach/data/models/get_ach_loans_response.dart';
import 'package:core/services/di/injection_container.dart';
import 'package:loan_refund/features/data/datasource/loan_refund_add_bank_account_datasource.dart';
import 'package:loan_refund/features/data/datasource/loan_refund_bank_details_datasource.dart';
import 'package:loan_refund/features/data/datasource/loan_refund_datasource.dart';
import 'package:loan_refund/features/data/repositories/loan_refund_add_bank_account_repo_impl.dart';
import 'package:loan_refund/features/data/repositories/loan_refund_bank_details_repo_impl.dart';
import 'package:loan_refund/features/data/repositories/loan_refund_repo_impl.dart';
import 'package:loan_refund/features/domain/repositories/loan_refund_add_bank_account_repository.dart';
import 'package:loan_refund/features/domain/repositories/loan_refund_bank_details_repository.dart';
import 'package:loan_refund/features/domain/repositories/loan_refund_repository.dart';
import 'package:loan_refund/features/domain/usecases/loan_refund_add_bank_account_usecase.dart';
import 'package:loan_refund/features/domain/usecases/loan_refund_bank_details_usecase.dart';
import 'package:loan_refund/features/domain/usecases/loan_refund_usecases.dart';
import 'package:loan_refund/features/presentation/cubit/data_share_cubit.dart';
import 'package:loan_refund/features/presentation/cubit/loan_refund_add_bank_account_cubit.dart';
import 'package:loan_refund/features/presentation/cubit/loan_refund_bank_details_cubit.dart';
import 'package:loan_refund/features/presentation/cubit/loan_refund_cubit.dart';
import 'package:loan_refund/features/presentation/loan_refund_viewmodel.dart';

Future<void> initLoanRefundPaymentsDI() async {
  di.registerFactory(() => LoanRefundDatasource(dioClient: di()));
  di.registerFactory<LoanRefundRepository>(
      () => LoanRefundRepositoryImpl(datasource: di()));
  di.registerFactory(() => LoanRefundUseCase(repository: di()));
  di.registerFactory(
      () => LoanRefundViewModel(selectedLoan: LoanData(), loans: []));
  di.registerFactory(() => LoanRefundCubit(
      loanRefundUseCase: di(), achUsecase: di(), loanRefundViewModel: di()));

  di.registerFactory(() => LoanRefundBankDetailsDatasource(dioClient: di()));
  di.registerFactory<LoanRefundBankDetailsRepository>(
      () => LoanRefundBankDetailsRepositoryImpl(datasource: di()));
  di.registerFactory(() => LoanRefundBankDetailsUseCase(repository: di()));
  di.registerFactory(
      () => LoanRefundBankDetailsCubit(loanrefundbankdetailsusecase: di()));

  di.registerFactory(() => LoanRefundAddBankAccountDatasource(dioClient: di()));
  di.registerFactory<LoanRefundAddBankAccountRepository>(
      () => LoanRefundAddBankAccountRepositoryImpl(datasource: di()));
  di.registerFactory(() => LoanRefundAddBankAccountUseCase(repository: di()));
  di.registerFactory(() =>
      LoanRefundAddBankAccountCubit(loanrefundaddbankaccountusecase: di()));
  di.registerFactory(() => DataCubit());
}
