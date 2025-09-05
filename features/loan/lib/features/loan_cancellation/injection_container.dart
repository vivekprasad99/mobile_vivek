import 'package:core/services/di/injection_container.dart';
import 'package:loan/features/loan_cancellation/data/datasource/lc_datasource.dart';
import 'package:loan/features/loan_cancellation/data/repositories/lc_repository_impl.dart';
import 'package:loan/features/loan_cancellation/domain/repositories/lc_repository.dart';
import 'package:loan/features/loan_cancellation/domain/usecases/lc_usecase.dart';
import 'package:loan/features/loan_cancellation/presentation/cubit/loan_cancellation_cubit.dart';

Future<void> initLoanCancellationDi() async {
  di.registerFactory(() => LoanCancellationDatasource(dioClient: di()));
  di.registerFactory<LoanCancellationRepository>(
      () => LoanCancellationRepositoryImpl(datasource: di()));
  di.registerFactory(() => LoanCancellationUseCase(loanCancellationRepository: di()));
  di.registerFactory(() => LoanCancellationCubit(loanCancellationUseCase: di()));
}