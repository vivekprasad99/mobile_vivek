import 'package:core/config/error/error.dart';
import 'package:dartz/dartz.dart';
import 'package:loan/features/loan_cancellation/data/models/create_sr_request.dart';
import 'package:loan/features/loan_cancellation/data/models/create_sr_response.dart';
import 'package:loan/features/loan_cancellation/data/models/get_flp_tenure_response.dart';
import 'package:loan/features/loan_cancellation/data/models/get_loan_charges_request.dart';
import 'package:loan/features/loan_cancellation/data/models/get_loan_charges_response.dart';
import 'package:loan/features/loan_cancellation/data/models/get_offers_response.dart';
import 'package:loan/features/loan_cancellation/data/models/fetch_sr_request.dart';
import 'package:loan/features/loan_cancellation/data/models/fetch_sr_response.dart';
import 'package:loan/features/loan_cancellation/data/models/get_lc_list_request.dart';
import 'package:loan/features/loan_cancellation/data/models/get_lc_list_response.dart';
import 'package:loan/features/loan_cancellation/data/models/get_lc_reasons_response.dart';

abstract class LoanCancellationRepository {
  Future<Either<Failure, GetLoanCancellationResponse>> getLoans(
      GetLoansCancellationRequest getLoansRequest);

  Future<Either<Failure, GetLoanCancellationReasonsResponse>> getReasons();

  Future<Either<Failure, FetchSrResponse>> fetchSR(FetchSrRequest request);
  Future<Either<Failure, GetOffersResponse>> getOffers();
  Future<Either<Failure, GetFlpTenureResponse>> getFlpTenure();
  Future<Either<Failure, GetLoanChargesResponse>> getLoanCharges(
      GetLoanChargesRequest request);
  Future<Either<Failure, CreateSrResponse>> createSR(CreateSrRequest request);
}
