import 'package:billpayments/features/data/models/bill_payment_request.dart';
import 'package:billpayments/features/data/models/get_bill_payments_response.dart';
import 'package:billpayments/features/domain/repositories/billpayments_repository.dart';
import 'package:core/config/error/failure.dart';
import 'package:core/config/usecase/usecase.dart';
import 'package:dartz/dartz.dart';

class BillPaymentsUseCase extends UseCase<GetBillPaymentResponse, BillPaymentRequest>
{
  final BillPaymentsRepository repository;
  BillPaymentsUseCase({required this.repository});

  @override
  Future<Either<Failure, GetBillPaymentResponse>> call(BillPaymentRequest params) async{
    return await repository.getBbpsUrl(params);
  }
}