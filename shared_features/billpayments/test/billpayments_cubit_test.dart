import 'package:billpayments/features/data/models/bill_payment_request.dart';
import 'package:billpayments/features/data/models/get_bill_payments_response.dart';
import 'package:billpayments/features/domain/usecases/billpayments_usecase.dart';
import 'package:billpayments/features/presentation/cubit/bill_payments_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'billpayments_cubit_test.mocks.dart';
import 'package:core/config/error/failure.dart';


@GenerateMocks([BillPaymentsUseCase])
void main() {
  late BillPaymentsCubit cubit;
  var mockBillPaymentsUseCase = MockBillPaymentsUseCase();
  late BillPaymentRequest mockRequest;
  late GetBillPaymentResponse mockResponse;
  var mockError = const ServerFailure('some error');

  setUp(() {
    mockBillPaymentsUseCase = MockBillPaymentsUseCase();
    cubit = BillPaymentsCubit(usecase: mockBillPaymentsUseCase);
    mockResponse = GetBillPaymentResponse(message: "REQUEST COMPLETED",
        linkToRedirect: "https://billpay-qa.setu.co/somenumber",
        status: "SUCCESS");
    mockRequest = BillPaymentRequest(mobileNumber: "1234567890");
  });

  group('test Bill Payments API', () {
    blocTest(
        'should emit GetBbpsUrlSuccessState when getBbpsUrl is called',
        build: () {
          when(mockBillPaymentsUseCase.call(mockRequest))
              .thenAnswer((_) async => Right(mockResponse));
          return cubit;
        },
        act: (BillPaymentsCubit cubit) {
          cubit.getBbpsUrl(mockRequest);
        },
        wait: const Duration(seconds: 3),
        expect: () =>
        [
          LoadingState(isloading: true),
          LoadingState(isloading: false),
          GetBbpsUrlSuccessState(response: mockResponse)
        ]);
  });

  blocTest(
      'should emit LoadingState and GetBbpsUrlFailureState when getBbpsUrl with failure',
      build: () {
        when(mockBillPaymentsUseCase.call(mockRequest))
            .thenAnswer((_) async => Left(mockError));
        return cubit;
      },
      act: (BillPaymentsCubit cubit) {
        cubit.getBbpsUrl(mockRequest);
      },
      wait: const Duration(seconds: 3),
      expect: () =>
      [
        LoadingState(isloading: true),
        LoadingState(isloading: false),
        GetBbpsUrlFailureState(failure: mockError),
      ]);
}
