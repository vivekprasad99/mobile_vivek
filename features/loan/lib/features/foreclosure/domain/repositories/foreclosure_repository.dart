import 'package:core/config/error/failure.dart';
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
import 'package:service_ticket/features/data/models/service_request_response.dart';

import '../../data/models/get_fund_of_source_response.dart';

abstract class ForeclosureRepository {
  Future<Either<Failure, GetLoansResponse>> getLoans(
      GetLoansRequest getLoansRequest);

  Future<Either<Failure, GetLoanDetailsResponse>> getLoanDetails(
      GetLoanDetailsRequest getLoanDetailsRequest);

  Future<Either<Failure, GetReasonsResponse>> getReasons(
      GetLoanDetailsRequest getLoanDetailsRequest);

  Future<Either<Failure, GetOffersResponse>> getPreApprovedOffers(
      GetLoanDetailsRequest getLoanDetailsRequest);

  Future<Either<Failure, GetOffersResponse>> getOffers(
      GetLoanDetailsRequest getLoanDetailsRequest);

  Future<Either<Failure, GetForeClosureDetailsResponse>> getForeClosureDetails(
      GetLoanDetailsRequest getLoanDetailsRequest);

  Future<Either<Failure, FundOfSourceResponse>> getFundOfSource(
      GetLoanDetailsRequest request);

  Future<Either<Failure, CreateFdLeadResponse>> createFDLead(
      GetLoanDetailsRequest getLoanDetailsRequest);

  Future<Either<Failure, ServiceRequestResponse>> createForeclosureSR(
      ServiceRequest request);
}
