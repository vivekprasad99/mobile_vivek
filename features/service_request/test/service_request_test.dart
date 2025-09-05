/*
import 'package:flutter_test/flutter_test.dart';
import 'package:service_request/data/models/fetch_loan_account_number_list_request.dart';
import 'package:service_request/data/models/fetch_loan_account_number_list_response.dart';
import 'package:service_request/data/models/fetch_product_list_request.dart';
import 'package:service_request/data/models/fetch_product_list_response.dart';
import 'package:service_request/data/models/fetch_query_list_request.dart';
import 'package:service_request/data/models/query_subquery_response.dart';
import 'package:service_request/data/models/fetch_sub_query_list_request.dart';
import 'package:service_request/data/models/fetch_sub_query_list_response.dart';
import 'package:service_request/domain/usecasses/service_request_usecase.dart';
import 'package:service_request/presentation/cubit/general_queries_cubit.dart';
import 'package:service_request/presentation/cubit/general_queries_state.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:core/config/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'service_request_test.mocks.dart';

@GenerateMocks([ServiceRequestUseCase])
void main() {
  late GeneralQueriesCubit cubit;
  var mockServiceRequestUseCase = MockServiceRequestUseCase();
  var mockFetchQueryListRequest =
      FetchQueryListRequest(mobileNumber: '99999999999');
  var mockFetchQueryListResponse =
      FetchQueryListResponse(message: 'Success', code: '22333444');
  var mockFetchSubQueryListRequest = FetchSubQueryListRequest(query: 'Query');
  var mockFetchSubQueryListResponse =
      FetchSubQueryListResponse(message: 'Success', code: '22333444');
  var mockFetchProductListRequest = FetchProductListRequest(query: 'Query');
  var mockFetchProductListResponse =
      FetchProductListResponse(message: 'Success', code: '22333444');
  var mockFetchLoanAccountNumberListRequest =
      FetchLoanAccountNumberListRequest(product: 'Query');
  var mockFetchLoanAccountNumberListResponse =
      FetchLoanAccountNumberListResponse(message: 'Success', code: '22333444');
  var mockError = const ServerFailure('some error');

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    cubit = GeneralQueriesCubit(
        serviceRequestUseCaseUse: mockServiceRequestUseCase);
  });

  group('fetch Query List', () {
    blocTest(
      'should emit success',
      build: () {
        when(mockServiceRequestUseCase
                .fetchQueryList(mockFetchQueryListRequest))
            .thenAnswer((_) async => Right(mockFetchQueryListResponse));
        return cubit;
      },
      act: (GeneralQueriesCubit cubit) {
        cubit.fetchQueryListFunction(fetchQueryList: mockFetchQueryListRequest);
      },
      expect: () => [
        FetchQueryListSuccessState(response: mockFetchQueryListResponse),
      ],
    );

    blocTest(
      'should emit failure',
      build: () {
        when(mockServiceRequestUseCase
                .fetchQueryList(mockFetchQueryListRequest))
            .thenAnswer((_) async => Left(mockError));
        return cubit;
      },
      act: (GeneralQueriesCubit cubit) {
        cubit.fetchQueryListFunction(fetchQueryList: mockFetchQueryListRequest);
      },
      expect: () => [
        FetchQueryListFailureState(error: mockError),
      ],
    );
  });

  group('fetch Sub Query List', () {
    blocTest(
      'should emit success',
      build: () {
        when(mockServiceRequestUseCase
                .fetchSubQueryList(mockFetchSubQueryListRequest))
            .thenAnswer((_) async => Right(mockFetchSubQueryListResponse));
        return cubit;
      },
      act: (GeneralQueriesCubit cubit) {
        cubit.fetchSubQueryListFunction(
            fetchSubQueryList: mockFetchSubQueryListRequest);
      },
      expect: () => [
        FetchSubQueryListSuccessState(response: mockFetchSubQueryListResponse),
      ],
    );

    blocTest(
      'should emit failure',
      build: () {
        when(mockServiceRequestUseCase
                .fetchSubQueryList(mockFetchSubQueryListRequest))
            .thenAnswer((_) async => Left(mockError));
        return cubit;
      },
      act: (GeneralQueriesCubit cubit) {
        cubit.fetchSubQueryListFunction(
            fetchSubQueryList: mockFetchSubQueryListRequest);
      },
      expect: () => [
        FetchSubQueryListFailureState(error: mockError),
      ],
    );
  });

  group('fetch Product List', () {
    blocTest(
      'should emit success',
      build: () {
        when(mockServiceRequestUseCase
                .fetchProductList(mockFetchProductListRequest))
            .thenAnswer((_) async => Right(mockFetchProductListResponse));
        return cubit;
      },
      act: (GeneralQueriesCubit cubit) {
        cubit.fetchProductListFunction(
            fetchProductList: mockFetchProductListRequest);
      },
      expect: () => [
        FetchProductListSuccessState(response: mockFetchProductListResponse),
      ],
    );

    blocTest(
      'should emit failure',
      build: () {
        when(mockServiceRequestUseCase
                .fetchProductList(mockFetchProductListRequest))
            .thenAnswer((_) async => Left(mockError));
        return cubit;
      },
      act: (GeneralQueriesCubit cubit) {
        cubit.fetchProductListFunction(
            fetchProductList: mockFetchProductListRequest);
      },
      expect: () => [
        FetchProductListFailureState(error: mockError),
      ],
    );
  });

  group('fetch Loan Account Number List', () {
    blocTest(
      'should emit success',
      build: () {
        when(mockServiceRequestUseCase.fetchLoanAccountNumberList(
                mockFetchLoanAccountNumberListRequest))
            .thenAnswer(
                (_) async => Right(mockFetchLoanAccountNumberListResponse));
        return cubit;
      },
      act: (GeneralQueriesCubit cubit) {
        cubit.fetchLanListFunction(
            fetchProductList: mockFetchLoanAccountNumberListRequest);
      },
      expect: () => [
        FetchLanListSuccessState(
            response: mockFetchLoanAccountNumberListResponse),
      ],
    );

    blocTest(
      'should emit failure',
      build: () {
        when(mockServiceRequestUseCase.fetchLoanAccountNumberList(
                mockFetchLoanAccountNumberListRequest))
            .thenAnswer((_) async => Left(mockError));
        return cubit;
      },
      act: (GeneralQueriesCubit cubit) {
        cubit.fetchLanListFunction(
            fetchProductList: mockFetchLoanAccountNumberListRequest);
      },
      expect: () => [
        FetchLanListFailureState(error: mockError),
      ],
    );
  });
}
*/
