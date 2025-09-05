import 'package:bloc_test/bloc_test.dart';
import 'package:core/config/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loan/features/loan_cancellation/data/models/fetch_sr_request.dart';
import 'package:loan/features/loan_cancellation/data/models/fetch_sr_response.dart';
import 'package:loan/features/loan_cancellation/data/models/get_lc_list_request.dart';
import 'package:loan/features/loan_cancellation/data/models/get_lc_list_response.dart';
import 'package:loan/features/loan_cancellation/data/models/get_lc_reasons_response.dart';
import 'package:loan/features/loan_cancellation/data/models/get_offers_response.dart';
import 'package:loan/features/loan_cancellation/domain/usecases/lc_usecase.dart';
import 'package:loan/features/loan_cancellation/presentation/cubit/loan_cancellation_cubit.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'lc_cubit_test.mocks.dart';

@GenerateMocks([LoanCancellationUseCase])
void main() async {
  late LoanCancellationCubit cubit;
  var mockLoanCancellatonUseCase = MockLoanCancellationUseCase();
  var mockError = const ServerFailure('some error');
  var mockGetLoansCancellationRequest = GetLoansCancellationRequest();
  var mockGetLoanCancellationResponse = GetLoanCancellationResponse();
  var mockGetCancelReasons = GetLoanCancellationReasonsResponse();
  var mockFetchSrRequest = FetchSrRequest();
  var mockFetchSrResponse = FetchSrResponse();
  var mockGetOffersResponse = GetOffersResponse();
  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    cubit = LoanCancellationCubit(
        loanCancellationUseCase: mockLoanCancellatonUseCase);
  });
  group('test getloanslist', () {
    blocTest(
      'should emit LoanCancellationGetLoansSuccessState',
      build: () {
        when(mockLoanCancellatonUseCase.call(mockGetLoansCancellationRequest))
            .thenAnswer((_) async => Right(mockGetLoanCancellationResponse));
        return cubit;
      },
      act: (LoanCancellationCubit cubit) {
        cubit.getLoans(mockGetLoansCancellationRequest);
      },
      wait: const Duration(seconds: 3),
      expect: () => [
        LoadingState(isloading: true),
        LoadingState(isloading: false),
        LoanCancellationGetLoansSuccessState(
            response: mockGetLoanCancellationResponse),
      ],
    );

    blocTest(
      'should emit LoanCancellationGetLoansFailureState when get loans is called with failure',
      build: () {
        when(mockLoanCancellatonUseCase.call(mockGetLoansCancellationRequest))
            .thenAnswer((_) async => Left(mockError));
        return cubit;
      },
      act: (LoanCancellationCubit cubit) {
        cubit.getLoans(mockGetLoansCancellationRequest);
      },
      wait: const Duration(seconds: 3),
      expect: () => [
        LoadingState(isloading: true),
        LoadingState(isloading: false),
        LoanCancellationGetLoansFailureState(failure: mockError)
      ],
    );

    blocTest(
      'should emit LoanCancellationGetLoansFailureState when get loans is called and thrown exception',
      build: () {
        when(mockLoanCancellatonUseCase.call(mockGetLoansCancellationRequest))
            .thenThrow((_) async => Exception('some error'));
        return cubit;
      },
      act: (LoanCancellationCubit cubit) {
        cubit.getLoans(mockGetLoansCancellationRequest);
      },
      wait: const Duration(seconds: 3),
      expect: () => [
        LoadingState(isloading: true),
        LoanCancellationGetLoansFailureState(failure: NoDataFailure()),
      ],
    );
  });
  group('test getReasons', () {
    blocTest(
      'should emit GetCancelReasonsSuccessState',
      build: () {
        when(mockLoanCancellatonUseCase.getReasons())
            .thenAnswer((_) async => Right(mockGetCancelReasons));
        return cubit;
      },
      act: (LoanCancellationCubit cubit) {
        cubit.getReasons();
      },
      wait: const Duration(seconds: 3),
      expect: () => [
        LoadingState(isloading: true),
        LoadingState(isloading: false),
        GetCancelReasonsSuccessState(response: mockGetCancelReasons.data ?? []),
      ],
    );

    blocTest(
      'should emit GetCancelReasonsFailureState when getReasons is called with failure',
      build: () {
        when(mockLoanCancellatonUseCase.getReasons())
            .thenAnswer((_) async => Left(mockError));
        return cubit;
      },
      act: (LoanCancellationCubit cubit) {
        cubit.getReasons();
      },
      wait: const Duration(seconds: 3),
      expect: () => [
        LoadingState(isloading: true),
        LoadingState(isloading: false),
        GetCancelReasonsFailureState(failure: mockError)
      ],
    );

    blocTest(
      'should emit GetCancelReasonsFailureState when getReasons is called and thrown exception',
      build: () {
        when(mockLoanCancellatonUseCase.getReasons())
            .thenThrow((_) async => Exception('some error'));
        return cubit;
      },
      act: (LoanCancellationCubit cubit) {
        cubit.getReasons();
      },
      wait: const Duration(seconds: 3),
      expect: () => [
        LoadingState(isloading: true),
        GetCancelReasonsFailureState(failure: NoDataFailure()),
      ],
    );
  });
  group('test fetchSR', () {
    blocTest(
      'should emit FetchSrSuccessState',
      build: () {
        when(mockLoanCancellatonUseCase.fetchSR(mockFetchSrRequest))
            .thenAnswer((_) async => Right(mockFetchSrResponse));
        return cubit;
      },
      act: (LoanCancellationCubit cubit) {
        cubit.fetchSR(mockFetchSrRequest);
      },
      wait: const Duration(seconds: 3),
      expect: () => [
        LoadingState(isloading: true),
        LoadingState(isloading: false),
        FetchSrSuccessState(response: mockFetchSrResponse, flpTenureDays: 0),
      ],
    );

    blocTest(
      'should emit FetchSrFailureState when fetchSR is called with failure',
      build: () {
        when(mockLoanCancellatonUseCase.fetchSR(mockFetchSrRequest))
            .thenAnswer((_) async => Left(mockError));
        return cubit;
      },
      act: (LoanCancellationCubit cubit) {
        cubit.fetchSR(mockFetchSrRequest);
      },
      wait: const Duration(seconds: 3),
      expect: () => [
        LoadingState(isloading: true),
        LoadingState(isloading: false),
        FetchSrFailureState(failure: mockError)
      ],
    );

    blocTest(
      'should emit FetchSrFailureState when fetchSR is called and thrown exception',
      build: () {
        when(mockLoanCancellatonUseCase.fetchSR(mockFetchSrRequest))
            .thenThrow((_) async => Exception('some error'));
        return cubit;
      },
      act: (LoanCancellationCubit cubit) {
        cubit.fetchSR(mockFetchSrRequest);
      },
      wait: const Duration(seconds: 3),
      expect: () => [
        LoadingState(isloading: true),
        FetchSrFailureState(failure: NoDataFailure()),
      ],
    );
  });
  group('test getOffers', () {
    blocTest(
      'should emit LoanCancellationgetOffersSuccessState',
      build: () {
        when(mockLoanCancellatonUseCase.getOffers())
            .thenAnswer((_) async => Right(mockGetOffersResponse));
        return cubit;
      },
      act: (LoanCancellationCubit cubit) {
        cubit.getOffers();
      },
      wait: const Duration(seconds: 3),
      expect: () => [
        LoadingState(isloading: true),
        LoadingState(isloading: false),
        LoanCancellationgetOffersSuccessState(response: mockGetOffersResponse),
      ],
    );

    blocTest(
      'should emit LoanCancellationgetOffersFailureState when getOffers is called with failure',
      build: () {
        when(mockLoanCancellatonUseCase.getOffers())
            .thenAnswer((_) async => Left(mockError));
        return cubit;
      },
      act: (LoanCancellationCubit cubit) {
        cubit.getOffers();
      },
      wait: const Duration(seconds: 3),
      expect: () => [
        LoadingState(isloading: true),
        LoadingState(isloading: false),
        LoanCancellationgetOffersFailureState(failure: mockError)
      ],
    );

    blocTest(
      'should emit LoanCancellationgetOffersFailureState when getOffers is called and thrown exception',
      build: () {
        when(mockLoanCancellatonUseCase.getOffers())
            .thenThrow((_) async => Exception('some error'));
        return cubit;
      },
      act: (LoanCancellationCubit cubit) {
        cubit.getOffers();
      },
      wait: const Duration(seconds: 3),
      expect: () => [
        LoadingState(isloading: true),
        LoanCancellationgetOffersFailureState(failure: NoDataFailure()),
      ],
    );
  });
}
