import 'package:core/config/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:loan/features/foreclosure/data/datasource/foreclosure_datasource.dart';
import 'package:loan/features/foreclosure/data/models/create_fd_lead_response.dart';
import 'package:loan/features/foreclosure/data/models/get_foreclosure_details.dart';
import 'package:loan/features/foreclosure/data/models/get_loan_details_request.dart';
import 'package:loan/features/foreclosure/data/models/get_loan_details_response.dart';
import 'package:loan/features/foreclosure/data/models/get_loans_request.dart';
import 'package:loan/features/foreclosure/data/models/get_loans_response.dart';
import 'package:loan/features/foreclosure/data/models/get_offers_response.dart';
import 'package:loan/features/foreclosure/data/models/get_reasons_response.dart';
import 'package:loan/features/foreclosure/data/models/service_request.dart';
import 'package:loan/features/foreclosure/domain/repositories/foreclosure_repository.dart';
import 'package:service_ticket/features/data/models/service_request_response.dart';

import '../models/get_fund_of_source_response.dart';

class ForeclosureRepositoryImpl extends ForeclosureRepository {
  ForeclosureRepositoryImpl({required this.datasource});
  final ForeClosureDatasource datasource;

  @override
  Future<Either<Failure, GetLoansResponse>> getLoans(
      GetLoansRequest getLoansRequest) async {
    final result = await datasource.getLoans(getLoansRequest);
    return result.fold((left) => Left(left), (right) => Right(right));
  }

  @override
  Future<Either<Failure, GetLoanDetailsResponse>> getLoanDetails(
      GetLoanDetailsRequest getLoanDetailsRequest) async {
    final result = await datasource.getLoanDetails(getLoanDetailsRequest);
    return result.fold((left) => Left(left), (right) => Right(right));
  }

  @override
  Future<Either<Failure, GetOffersResponse>> getOffers(
      GetLoanDetailsRequest getLoanDetailsRequest) async {
    final result = await datasource.getOffers(getLoanDetailsRequest);
    return result.fold((left) => Left(left), (right) => Right(right));
  }

  @override
  Future<Either<Failure, GetOffersResponse>> getPreApprovedOffers(
      GetLoanDetailsRequest getLoanDetailsRequest) async {
    final result = await datasource.getPreApprovedOffers(getLoanDetailsRequest);
    return result.fold((left) => Left(left), (right) => Right(right));
  }

  @override
  Future<Either<Failure, GetReasonsResponse>> getReasons(
      GetLoanDetailsRequest getLoanDetailsRequest) async {
    final result = await datasource.getReasons(getLoanDetailsRequest);
    return result.fold((left) => Left(left), (right) => Right(right));
  }

  @override
  Future<Either<Failure, GetForeClosureDetailsResponse>> getForeClosureDetails(
      GetLoanDetailsRequest getLoanDetailsRequest) async {
    final result =
        await datasource.getForeClosureDetails(getLoanDetailsRequest);
    return result.fold((left) => Left(left), (right) => Right(right));
  }

 @override
  Future<Either<Failure, FundOfSourceResponse>> getFundOfSource(
      GetLoanDetailsRequest request) async {
    final result = await datasource.getFundOfSource(request);
    return result.fold((left) => Left(left), (right) => Right(right));
  }

  @override
  Future<Either<Failure, CreateFdLeadResponse>> createFDLead(
      GetLoanDetailsRequest getLoanDetailsRequest) async {
    final result = await datasource.createFDLead(getLoanDetailsRequest);
    return result.fold((left) => Left(left), (right) => Right(right));
  }

  @override
  Future<Either<Failure, ServiceRequestResponse>> createForeclosureSR(
      ServiceRequest request) async {
    final result = await datasource.createForeclosureSR(request);
    return result.fold((left) => Left(left), (right) => Right(right));
  }

  // @override
  // Future<Either<Failure, List<ForeClosureListModel>>> getLoans(
  //     String ucic) async {
  //   final result = await datasource.getLoans(ucic);
  //   return result.fold((left) => Left(left), (right) => Right(right));
  // }
}
