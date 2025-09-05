// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:core/config/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:product_details/data/datasource/product_detail_datasource.dart';
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

class ProductDetailsRepositoryImpl extends ProductDetailsRepository {
  final ProductDetailsDatasource datasource;

  ProductDetailsRepositoryImpl({
    required this.datasource,
  });

  @override
  Future<Either<Failure, ActiveLoanListResponse>> getActiveLoansList(
      ActiveLoanListRequest getActiveLoanRequest) async {
    final result =
        await datasource.getActiveLoansList(getActiveLoanRequest);
    return result.fold((left) => Left(left), (right) => Right(right));
  }

  @override
  Future<Either<Failure, ActiveLoanDetailResponse>> getActiveLoansDetails(
      ActiveLoanDetailRequest getActiveLoanDetailRequest) async {
    final result =
        await datasource.getActiveLoansDetails(getActiveLoanDetailRequest);
    return result.fold((left) => Left(left), (right) => Right(right));
  }

  @override
  Future<Either<Failure, PaymentResponse>> getPaymentHistory(
      PaymentRequest getPaymentRequest) async {
    final result = await datasource.getPaymentHistory(getPaymentRequest);
    return result.fold((left) => Left(left), (right) => Right(right));
  }

  @override
  Future<Either<Failure, SetPaymentReminderResponse>>
      setPaymentReminderResponse(
          SetPaymentReminderRequest setPaymentReminderRequest) async {
    final result =
        await datasource.setPaymentReminders(setPaymentReminderRequest);
    return result.fold((left) => Left(left), (right) => Right(right));
  }

  @override
  Future<Either<Failure, DocumentsResponse>> getDocuments(
      DocumentsRequest getDocumentRequest) async {
    final result = await datasource.getDocuments(getDocumentRequest);
    return result.fold((left) => Left(left), (right) => Right(right));
  }
}
