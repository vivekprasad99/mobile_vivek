import 'package:core/config/error/failure.dart';
import 'package:core/config/usecase/usecase.dart';
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
import 'package:product_details/domain/reposittories/product_detail_repository.dart';

class ProductDetailsUseCase
    extends UseCase<ActiveLoanListResponse, ActiveLoanListRequest> {
  final ProductDetailsRepository productDetailsRepository;

  ProductDetailsUseCase({required this.productDetailsRepository});

  @override
  Future<Either<Failure, ActiveLoanListResponse>> call(
      ActiveLoanListRequest params) async {
    return await productDetailsRepository.getActiveLoansList(params);
  }

  Future<Either<Failure, ActiveLoanDetailResponse>> getActiveLoansDetails(
      ActiveLoanDetailRequest params) async {
    return await productDetailsRepository.getActiveLoansDetails(params);
  }

  Future<Either<Failure, PaymentResponse>> getPaymentHistory(
      PaymentRequest params) async {
    return await productDetailsRepository.getPaymentHistory(params);
  }

  Future<Either<Failure, DocumentsResponse>> getDocuments(
      DocumentsRequest params) async {
    return await productDetailsRepository.getDocuments(params);
  }

  Future<Either<Failure, SetPaymentReminderResponse>> setPaymentReminderRequest(
      SetPaymentReminderRequest params) async {
    return await productDetailsRepository.setPaymentReminderResponse(params);
  }
}
