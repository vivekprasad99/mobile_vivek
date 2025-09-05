

import 'package:core/services/di/injection_container.dart';
import 'package:payment_gateway/features/data/datasource/payment_gateway_datasource.dart';
import 'package:payment_gateway/features/data/repositories/payment_gateway_repository_impl.dart';
import 'package:payment_gateway/features/domain/repositories/payment_repository.dart';
import 'package:payment_gateway/features/domain/usecases/get_payment_crdentials_usecase.dart';
import 'package:payment_gateway/features/domain/usecases/get_payment_option_data_usecase.dart';
import 'package:payment_gateway/features/domain/usecases/get_transaction_id_usecase.dart';
import 'package:payment_gateway/features/domain/usecases/updatePaymentDetailUsecase.dart';
import 'package:payment_gateway/features/presentation/cubit/payment_cubit.dart';


Future<void> initPaymentGatewayDI() async {
  di.registerFactory(() => PaymentGatewayCubit(
      getTransactionIDUsecase: di(),
      updatePaymentDetailUsecase: di(),
      getPaymentCredentialsUsecase: di(),
      getPaymentOptionDataUsecase: di()));
  di.registerFactory(
      () => GetTransactionIDUsecase(paymentGatewayRepository: di()));
  di.registerFactory(
      () => UpdatePaymentDetailUsecase(paymentGatewayRepository: di()));
  di.registerFactory(
      () => GetPaymentCredentialsUsecase(paymentGatewayRepository: di()));
  di.registerFactory(
      () => GetPaymentOptionDataUsecase(paymentGatewayRepository: di()));
  di.registerFactory<PaymentGatewayRepository>(
      () => PaymentGatewayRepositoryImpl(datasource: di()));
  di.registerFactory(() => PaymentGatewayDataSource(dioClient: di()));
}
