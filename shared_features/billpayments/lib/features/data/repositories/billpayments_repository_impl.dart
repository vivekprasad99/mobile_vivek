import 'package:billpayments/features/data/datasource/billpayments_datasource.dart';
import 'package:billpayments/features/data/models/bill_payment_request.dart';
import 'package:billpayments/features/data/models/get_bill_payments_response.dart';
import 'package:billpayments/features/domain/repositories/billpayments_repository.dart';
import 'package:core/config/error/failure.dart';
import 'package:dartz/dartz.dart';


class BillPaymentsRepositoryImpl implements BillPaymentsRepository {
  BillPaymentsRepositoryImpl({required this.datasource});
  final BillPaymentsDatasource datasource;

  @override
  Future<Either<Failure, GetBillPaymentResponse>> getBbpsUrl(BillPaymentRequest billPaymentRequest) async{
    final result = await datasource.getBbpsUrl(billPaymentRequest);
    return result.fold((left) => Left(left), (right) => Right(right));
  }

}