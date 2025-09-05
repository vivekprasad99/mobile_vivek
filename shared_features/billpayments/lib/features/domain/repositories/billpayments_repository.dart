import 'package:billpayments/features/data/models/bill_payment_request.dart';
import 'package:billpayments/features/data/models/get_bill_payments_response.dart';
import 'package:core/config/error/failure.dart';
import 'package:dartz/dartz.dart';

abstract class BillPaymentsRepository {
  Future<Either<Failure, GetBillPaymentResponse>> getBbpsUrl(BillPaymentRequest billPaymentRequest);
}