import 'package:billpayments/features/data/datasource/billpayments_datasource.dart';
import 'package:billpayments/features/data/repositories/billpayments_repository_impl.dart';
import 'package:billpayments/features/domain/repositories/billpayments_repository.dart';
import 'package:billpayments/features/domain/usecases/billpayments_usecase.dart';
import 'package:billpayments/features/presentation/cubit/bill_payments_cubit.dart';
import 'package:billpayments/features/presentation/upcoming_loans_vm.dart';
import 'package:core/services/di/injection_container.dart';

Future<void> initBillPaymentsDI() async {
  di.registerFactory(() => BillPaymentsDatasource(dioClient: di()));
  di.registerFactory<BillPaymentsRepository>(() => BillPaymentsRepositoryImpl(datasource: di()));
  di.registerFactory(() => BillPaymentsUseCase(repository: di()));
  di.registerFactory(() => UpcomingPaymentViewModel());
  di.registerFactory(() => BillPaymentsCubit(usecase: di(), productDetailsUseCase: di(), upcomingPaymentViewModel: di()));
}