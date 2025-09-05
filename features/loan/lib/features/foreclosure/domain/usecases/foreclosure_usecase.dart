import 'package:core/config/error/failure.dart';
import 'package:core/config/usecase/usecase.dart';
import 'package:dartz/dartz.dart';
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

import '../../data/models/get_fund_of_source_response.dart';

class ForeclosureUseCase extends UseCase<GetLoansResponse, GetLoansRequest> {
  final ForeclosureRepository foreclosureRepository;

  ForeclosureUseCase({required this.foreclosureRepository});

  @override
  Future<Either<Failure, GetLoansResponse>> call(GetLoansRequest params) async {
    return await foreclosureRepository.getLoans(params);
  }

  Future<Either<Failure, GetLoanDetailsResponse>> getLoanDetails(
      GetLoanDetailsRequest params) async {
    return await foreclosureRepository.getLoanDetails(params);
  }

  Future<Either<Failure, GetReasonsResponse>> getReasons(
      GetLoanDetailsRequest params) async {
    return await foreclosureRepository.getReasons(params);
  }

  Future<Either<Failure, GetOffersResponse>> getOffers(
      GetLoanDetailsRequest params) async {
    return await foreclosureRepository.getOffers(params);
  }

  Future<Either<Failure, GetOffersResponse>> getPreApprovedOffers(
      GetLoanDetailsRequest params) async {
    return await foreclosureRepository.getPreApprovedOffers(params);
  }

  Future<Either<Failure, GetForeClosureDetailsResponse>> getForeClosureDetails(
      GetLoanDetailsRequest params) async {
    return await foreclosureRepository.getForeClosureDetails(params);
  }

  Future<Either<Failure, FundOfSourceResponse>> getFundOfSource(
      GetLoanDetailsRequest params) async {
    return await foreclosureRepository.getFundOfSource(params);
  }

  Future<Either<Failure, CreateFdLeadResponse>> createFDLead(
      GetLoanDetailsRequest params) async {
    return await foreclosureRepository.createFDLead(params);
  }

  Future<Either<Failure, ServiceRequestResponse>> createForeclosureSR(
      ServiceRequest params) async {
    return await foreclosureRepository.createForeclosureSR(params);
  }
}
