import 'package:core/config/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:loan/features/loan_cancellation/data/models/create_sr_request.dart';
import 'package:loan/features/loan_cancellation/data/models/create_sr_response.dart';
import 'package:loan/features/loan_cancellation/data/models/get_flp_tenure_response.dart';
import 'package:loan/features/loan_cancellation/data/models/get_loan_charges_request.dart';
import 'package:loan/features/loan_cancellation/data/models/get_loan_charges_response.dart';
import 'package:loan/features/loan_cancellation/data/models/get_offers_response.dart';
import 'package:loan/features/loan_cancellation/data/datasource/lc_datasource.dart';
import 'package:loan/features/loan_cancellation/data/models/fetch_sr_request.dart';
import 'package:loan/features/loan_cancellation/data/models/fetch_sr_response.dart';
import 'package:loan/features/loan_cancellation/data/models/get_lc_list_request.dart';
import 'package:loan/features/loan_cancellation/data/models/get_lc_list_response.dart';
import 'package:loan/features/loan_cancellation/data/models/get_lc_reasons_response.dart';
import 'package:loan/features/loan_cancellation/domain/repositories/lc_repository.dart';

class LoanCancellationRepositoryImpl implements LoanCancellationRepository {
  LoanCancellationRepositoryImpl({required this.datasource});
  final LoanCancellationDatasource datasource;

  @override
  Future<Either<Failure, GetLoanCancellationResponse>> getLoans(
      GetLoansCancellationRequest getLoansRequest) async {
    final result = await datasource.getLoans(getLoansRequest);
    return result.fold((left) => Left(left), (right) => Right(right));
  }

  @override
  Future<Either<Failure, GetLoanCancellationReasonsResponse>>
      getReasons() async {
    final result = await datasource.getReasons();
    return result.fold((left) => Left(left), (right) => Right(right));
  }

  @override
  Future<Either<Failure, FetchSrResponse>> fetchSR(
      FetchSrRequest request) async {
    final result = await datasource.fetchSR(request);
    return result.fold((left) => Left(left), (right) => Right(right));
  }

  @override
  Future<Either<Failure, GetOffersResponse>> getOffers() async {
    final result = await datasource.getOffers();
    return result.fold((left) => Left(left), (right) => Right(right));
  }

  @override
  Future<Either<Failure, CreateSrResponse>> createSR(
      CreateSrRequest request) async {
    final result = await datasource.createSR(request);
    return result.fold((left) => Left(left), (right) => Right(right));
  }

  @override
  Future<Either<Failure, GetFlpTenureResponse>> getFlpTenure() async {
    final result = await datasource.getFlpTenure();
    return result.fold((left) => Left(left), (right) => Right(right));
  }

  @override
  Future<Either<Failure, GetLoanChargesResponse>> getLoanCharges(
      GetLoanChargesRequest request) async {
    final result = await datasource.getLoanCharges(request);
    return result.fold((left) => Left(left), (right) => Right(right));
  }
}
