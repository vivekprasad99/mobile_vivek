import 'package:core/config/error/failure.dart';
import 'package:dartz/dartz.dart';
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

abstract class ProductDetailsRepository {
  Future<Either<Failure, ActiveLoanListResponse>> getActiveLoansList(
      ActiveLoanListRequest getActiveLoanRequest);

  Future<Either<Failure, ActiveLoanDetailResponse>> getActiveLoansDetails(
      ActiveLoanDetailRequest getActiveLoanDetailRequest);

  Future<Either<Failure, PaymentResponse>> getPaymentHistory(
      PaymentRequest getPaymentRequest);

  Future<Either<Failure, DocumentsResponse>> getDocuments(
      DocumentsRequest getDocumentRequest);

  Future<Either<Failure, SetPaymentReminderResponse>>
      setPaymentReminderResponse(
          SetPaymentReminderRequest setPaymentReminderRequest);
}
