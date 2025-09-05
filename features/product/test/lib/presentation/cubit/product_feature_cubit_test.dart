import 'package:bloc_test/bloc_test.dart';
import 'package:core/config/error/failure.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:product/data/models/product_feature_request.dart';
import 'package:product/data/models/product_feature_response.dart';
import 'package:product/domain/usecases/product_feature_usecase.dart';
import 'package:product/presentation/cubit/product_feature_cubit.dart';
import 'package:product/presentation/cubit/product_feature_state.dart';
import 'package:dartz/dartz.dart';

import 'product_feature_cubit_test.mocks.dart';

@GenerateMocks([ProductFeatureUseCase, Failure])
class TestFailure extends Failure {
  final String message;

  TestFailure(this.message);
}

void main() {
  late ProductFeatureCubit cubit;
  late MockProductFeatureUseCase mockUseCase;
  late ProductFeatureRequest mockRequest;
  late ProductFeatureResponse mockResponse;
  var mockError = TestFailure('Some Error');

  setUp(() {
    mockUseCase = MockProductFeatureUseCase();
    cubit = ProductFeatureCubit(productFeatureUseCase: mockUseCase);
    mockResponse = ProductFeatureResponse();

    mockRequest = ProductFeatureRequest();
  });

  group('ProductFeatureCubit', () {
    blocTest(
        'emits [LoadingState, ProductFeatureSuccessState] when login is successful',
        build: () {
          when(mockUseCase.call(mockRequest))
              .thenAnswer((_) async => Right(mockResponse));
          return cubit;
        },
        act: (ProductFeatureCubit productFeatureCubit) {
          productFeatureCubit.productFeature(
              productFeatureRequest: mockRequest);
        },
        expect: () => [
              const LoadingState(isloading: true, sliderIndex: 0),
              ProductFeatureSuccessState(
                  response: mockResponse, sliderIndex: 0),
            ]);

    blocTest(
        'emits [LoadingState, ProductFeatureFailureState] when login fails',
        build: () {
          when(mockUseCase.call(mockRequest))
              .thenAnswer((_) async => Left((mockError)));
          return cubit;
        },
        act: (ProductFeatureCubit productFeatureCubit) {
          productFeatureCubit.productFeature(
              productFeatureRequest: mockRequest);
        },
        wait: const Duration(milliseconds: 100),
        expect: () => [
              const LoadingState(isloading: true, sliderIndex: 0),
              ProductFeatureFailureState(error: mockError, sliderIndex: 0)
            ]);
  });
}
