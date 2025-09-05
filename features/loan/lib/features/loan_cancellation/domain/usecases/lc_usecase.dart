import 'package:core/config/error/failure.dart';
import 'package:core/config/usecase/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:loan/features/loan_cancellation/data/models/create_sr_request.dart';
import 'package:loan/features/loan_cancellation/data/models/create_sr_response.dart';
import 'package:loan/features/loan_cancellation/data/models/fetch_sr_request.dart';
import 'package:loan/features/loan_cancellation/data/models/fetch_sr_response.dart';
import 'package:loan/features/loan_cancellation/data/models/get_flp_tenure_response.dart';
import 'package:loan/features/loan_cancellation/data/models/get_lc_list_request.dart';
import 'package:loan/features/loan_cancellation/data/models/get_lc_list_response.dart';
import 'package:loan/features/loan_cancellation/data/models/get_lc_reasons_response.dart';
import 'package:loan/features/loan_cancellation/data/models/get_loan_charges_request.dart';
import 'package:loan/features/loan_cancellation/data/models/get_loan_charges_response.dart';
import 'package:loan/features/loan_cancellation/data/models/get_offers_response.dart';
import 'package:loan/features/loan_cancellation/domain/repositories/lc_repository.dart';

class LoanCancellationUseCase
    extends UseCase<GetLoanCancellationResponse, GetLoansCancellationRequest> {
  final LoanCancellationRepository loanCancellationRepository;

  LoanCancellationUseCase({required this.loanCancellationRepository});

  @override
  Future<Either<Failure, GetLoanCancellationResponse>> call(
      GetLoansCancellationRequest params) async {
    return await loanCancellationRepository.getLoans(params);
  }

  Future<Either<Failure, GetLoanCancellationReasonsResponse>>
      getReasons() async {
    return await loanCancellationRepository.getReasons();
  }

  Future<Either<Failure, FetchSrResponse>> fetchSR(
      FetchSrRequest request) async {
    return await loanCancellationRepository.fetchSR(request);
  }

  Future<Either<Failure, GetOffersResponse>> getOffers() async {
    return await loanCancellationRepository.getOffers();
  }

  Future<Either<Failure, GetFlpTenureResponse>> getFlpTenure() async {
    return await loanCancellationRepository.getFlpTenure();
  }

  Future<Either<Failure, GetLoanChargesResponse>> getLoanCharges(
      GetLoanChargesRequest request) async {
    return await loanCancellationRepository.getLoanCharges(request);
  }

  Future<Either<Failure, CreateSrResponse>> createSR(
      CreateSrRequest request) async {
    return await loanCancellationRepository.createSR(request);
  }
}
