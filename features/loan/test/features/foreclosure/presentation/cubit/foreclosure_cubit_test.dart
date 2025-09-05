import 'package:bloc_test/bloc_test.dart';
import 'package:core/config/error/failure.dart';
import 'package:core/utils/utils.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loan/features/foreclosure/data/models/create_fd_lead_response.dart';
import 'package:loan/features/foreclosure/data/models/create_foreclosure_sr_response.dart';
import 'package:loan/features/foreclosure/data/models/get_foreclosure_details.dart';
import 'package:loan/features/foreclosure/data/models/get_loan_details_request.dart';
import 'package:loan/features/foreclosure/data/models/get_loan_details_response.dart';
import 'package:loan/features/foreclosure/data/models/get_loans_request.dart';
import 'package:loan/features/foreclosure/data/models/get_loans_response.dart';
import 'package:loan/features/foreclosure/data/models/get_offers_response.dart';
import 'package:loan/features/foreclosure/data/models/get_reasons_response.dart';
import 'package:loan/features/foreclosure/domain/usecases/foreclosure_usecase.dart';
import 'package:loan/features/foreclosure/presentation/cubit/foreclosure_cubit.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'foreclosure_cubit_test.mocks.dart';

@GenerateMocks([ForeclosureUseCase])
void main() async {
  late ForeclosureCubit cubit;
  var mockForeclosureUseCase = MockForeclosureUseCase();
  var mockError = const ServerFailure('some error');

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    cubit = ForeclosureCubit(foreclosureUseCase: mockForeclosureUseCase);
  });

  var mockGetLoansRequest = GetLoansRequest(ucic: getUCIC());
  var loanItem = LoanItem(
      ucic: '1234',
      tenantId: '1',
      loanNumber: '',
      totalPendingAmount: '1000',
      totalAmount: '2000',
      sourceSystem: '',
      productcode: '',
      loanType: 'Personal Loan');

  var mockGetLoanResponse = GetLoansResponse(
      data: [loanItem],
      message: 'Request completed successfully',
      status: 'Success');

  group('test getLoans API', () {
    blocTest(
        'should emit ForeclosureGetLoansSuccessState when get loan is called',
        build: () {
          when(mockForeclosureUseCase.call(mockGetLoansRequest))
              .thenAnswer((_) async => Right(mockGetLoanResponse));
          return cubit;
        },
        act: (ForeclosureCubit cubit) {
          cubit.getLoans(mockGetLoansRequest);
        },
        wait: const Duration(seconds: 3),
        expect: () => [
              LoadingState(isloading: true),
              LoadingState(isloading: false),
              ForeclosureGetLoansSuccessState(response: mockGetLoanResponse)
            ]);

    blocTest(
        'should emit LoadingState and ForeclosureGetLoansFailureState when getLoanList with failure',
        build: () {
          when(mockForeclosureUseCase.call(mockGetLoansRequest))
              .thenAnswer((_) async => Left(mockError));
          return cubit;
        },
        act: (ForeclosureCubit cubit) {
          cubit.getLoans(mockGetLoansRequest);
        },
        wait: const Duration(seconds: 3),
        expect: () => [
              LoadingState(isloading: true),
              LoadingState(isloading: false),
              ForeclosureGetLoansFailureState(failure: mockError),
            ]);
  });

  var mockGetLoanDetailsRequest = GetLoanDetailsRequest(
      loanNumber: '', productCategory: '', sourceSystem: '');
  var loanDetails = LoanDetails(
      ucic: '',
      loanNumber: '',
      totalPendingAmount: '',
      totalAmount: '',
      isServiceRequestExist: false,
      serviceRequestStatus: '',
      lockingPeriodEndDate: '01 July 2024',
      isLockingPeriod: false,
      isFreezePeriod: false,
      sourceSystem: '',
      productCode: '',
      isRuleOnePassed: false,
      loanType: 'Personal Loan');

  var mockGetLoanDetailResponse = GetLoanDetailsResponse(
      status: 'Success',
      message: 'Request completed successfully',
      data: loanDetails);

  group('test getLoanDetails API', () {
    blocTest(
        'should emit GetLoanDetailsSuccessState when getLoanDetails called',
        build: () {
          when(mockForeclosureUseCase.getLoanDetails(mockGetLoanDetailsRequest))
              .thenAnswer((_) async => Right(mockGetLoanDetailResponse));
          return cubit;
        },
        act: (ForeclosureCubit cubit) {
          cubit.getLoanDetails(mockGetLoanDetailsRequest, loanItem);
        },
        wait: const Duration(seconds: 3),
        expect: () => [
              LoadingState(isloading: true),
              LoadingState(isloading: false),
              GetLoanDetailsSuccessState(
                  response: mockGetLoanDetailResponse,
                  selectLoanItem: loanItem),
            ]);

    blocTest(
        'should emit LoadingState and GetLoanDetailsFailureState when getLoanDetails called with failure',
        build: () {
          when(mockForeclosureUseCase.getLoanDetails(mockGetLoanDetailsRequest))
              .thenAnswer((_) async => Left(mockError));
          return cubit;
        },
        act: (ForeclosureCubit cubit) {
          cubit.getLoanDetails(mockGetLoanDetailsRequest, loanItem);
        },
        wait: const Duration(seconds: 3),
        expect: () => [
              LoadingState(isloading: true),
              LoadingState(isloading: false),
              GetLoanDetailsFailureState(failure: mockError),
            ]);
  });
  var reasons = [Reasons(id: 1, name: '')];
  var mockGetReasonsResponse = GetReasonsResponse(
      data: reasons,
      message: 'Request completed successfully',
      status: 'Success');

  group('test getReasons API', () {
    blocTest('should emit GetReasonsSuccessState when getReasons called',
        build: () {
          when(mockForeclosureUseCase.getReasons(mockGetLoanDetailsRequest))
              .thenAnswer((_) async => Right(mockGetReasonsResponse));
          return cubit;
        },
        act: (ForeclosureCubit cubit) {
          cubit.getReasons(mockGetLoanDetailsRequest);
        },
        wait: const Duration(seconds: 3),
        expect: () => [
              LoadingState(isloading: true),
              LoadingState(isloading: false),
              GetReasonsSuccessState(response: reasons),
            ]);

    blocTest(
        'should emit LoadingState and GetReasonsFailureState when getReasons called with failure',
        build: () {
          when(mockForeclosureUseCase.getReasons(mockGetLoanDetailsRequest))
              .thenAnswer((_) async => Left(mockError));
          return cubit;
        },
        act: (ForeclosureCubit cubit) {
          cubit.getReasons(mockGetLoanDetailsRequest);
        },
        wait: const Duration(seconds: 3),
        expect: () => [
              LoadingState(isloading: true),
              LoadingState(isloading: false),
              GetReasonsFailureState(failure: mockError),
            ]);
  });

  var offers = [Offers(id: 1, image: '', title: '')];
  var mockGetOffersResponse = GetOffersResponse(data: offers);
  group('test getOffers API', () {
    blocTest('should emit GetOffersSuccessState when getOffers called',
        build: () {
          when(mockForeclosureUseCase.getOffers(mockGetLoanDetailsRequest))
              .thenAnswer((_) async => Right(mockGetOffersResponse));
          return cubit;
        },
        act: (ForeclosureCubit cubit) {
          cubit.getOffers(mockGetLoanDetailsRequest);
        },
        wait: const Duration(seconds: 3),
        expect: () => [
              LoadingState(isloading: true),
              LoadingState(isloading: false),
              GetOffersSuccessState(response: mockGetOffersResponse),
            ]);

    blocTest(
        'should emit LoadingState and GetOffersFailureState when getOffers called with failure',
        build: () {
          when(mockForeclosureUseCase.getOffers(mockGetLoanDetailsRequest))
              .thenAnswer((_) async => Left(mockError));
          return cubit;
        },
        act: (ForeclosureCubit cubit) {
          cubit.getOffers(mockGetLoanDetailsRequest);
        },
        wait: const Duration(seconds: 3),
        expect: () => [
              LoadingState(isloading: true),
              LoadingState(isloading: false),
              GetOffersFailureState(failure: mockError),
            ]);
  });

  var foreclosureDetails = ForeclosureDetails();
  var mockGetForeClosureDetailsResponse =
      GetForeClosureDetailsResponse(data: foreclosureDetails);
  group('test getForeClosureDetails API', () {
    blocTest(
        'should emit GetForeClosureDetailsSuccessState when getForeClosureDetails called',
        build: () {
          when(mockForeclosureUseCase
                  .getForeClosureDetails(mockGetLoanDetailsRequest))
              .thenAnswer(
                  (_) async => Right(mockGetForeClosureDetailsResponse));
          return cubit;
        },
        act: (ForeclosureCubit cubit) {
          cubit.getForeClosureDetails(mockGetLoanDetailsRequest);
        },
        wait: const Duration(seconds: 3),
        expect: () => [
              LoadingState(isloading: true),
              LoadingState(isloading: false),
              GetForeClosureDetailsSuccessState(
                  response: mockGetForeClosureDetailsResponse),
            ]);

    blocTest(
        'should emit LoadingState and GetForeClosureDetailsFailureState when getForeClosureDetails called with failure',
        build: () {
          when(mockForeclosureUseCase
                  .getForeClosureDetails(mockGetLoanDetailsRequest))
              .thenAnswer((_) async => Left(mockError));
          return cubit;
        },
        act: (ForeclosureCubit cubit) {
          cubit.getForeClosureDetails(mockGetLoanDetailsRequest);
        },
        wait: const Duration(seconds: 3),
        expect: () => [
              LoadingState(isloading: true),
              LoadingState(isloading: false),
              GetForeClosureDetailsFailureState(failure: mockError),
            ]);
  });

  var mockCreateFdLeadResponse =
      CreateFdLeadResponse(data: FDleadId(fixedDepositLeadId: '1'));
  group('test createFDLead API', () {
    blocTest('should emit CreateFDLeadSuccessState when createFDLead called',
        build: () {
          when(mockForeclosureUseCase.createFDLead(mockGetLoanDetailsRequest))
              .thenAnswer((_) async => Right(mockCreateFdLeadResponse));
          return cubit;
        },
        act: (ForeclosureCubit cubit) {
          cubit.createFDLead(mockGetLoanDetailsRequest);
        },
        wait: const Duration(seconds: 3),
        expect: () => [
              LoadingState(isloading: true),
              LoadingState(isloading: false),
              CreateFDLeadSuccessState(response: mockCreateFdLeadResponse),
            ]);

    blocTest(
        'should emit LoadingState and CreateFDLeadFailureState when createFDLead called with failure',
        build: () {
          when(mockForeclosureUseCase.createFDLead(mockGetLoanDetailsRequest))
              .thenAnswer((_) async => Left(mockError));
          return cubit;
        },
        act: (ForeclosureCubit cubit) {
          cubit.createFDLead(mockGetLoanDetailsRequest);
        },
        wait: const Duration(seconds: 3),
        expect: () => [
              LoadingState(isloading: true),
              LoadingState(isloading: false),
              CreateFDLeadFailureState(failure: mockError),
            ]);
  });

  var mockCreateForeclosureSRResponse =
      CreateForeclosureSrResponse(data: Data());
  group('test createForeclosureSR API', () {
    blocTest(
        'should emit CreateForeclosureSRSuccessState when createForeclosureSR called',
        build: () {
          when(mockForeclosureUseCase
                  .createForeclosureSR(mockGetLoanDetailsRequest))
              .thenAnswer((_) async => Right(mockCreateForeclosureSRResponse));
          return cubit;
        },
        act: (ForeclosureCubit cubit) {
          cubit.createForeclosureSR(mockGetLoanDetailsRequest);
        },
        wait: const Duration(seconds: 3),
        expect: () => [
              LoadingState(isloading: true),
              LoadingState(isloading: false),
              CreateForeclosureSRSuccessState(
                  response: mockCreateForeclosureSRResponse),
            ]);

    blocTest(
        'should emit LoadingState and CreateFDLeadFailureState when createFDLead called with failure',
        build: () {
          when(mockForeclosureUseCase
                  .createForeclosureSR(mockGetLoanDetailsRequest))
              .thenAnswer((_) async => Left(mockError));
          return cubit;
        },
        act: (ForeclosureCubit cubit) {
          cubit.createForeclosureSR(mockGetLoanDetailsRequest);
        },
        wait: const Duration(seconds: 3),
        expect: () => [
              LoadingState(isloading: true),
              LoadingState(isloading: false),
              CreateForeclosureSRFailureState(failure: mockError),
            ]);
  });
}
