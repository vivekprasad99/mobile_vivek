import 'package:core/config/error/failure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:product/data/models/product_feature_response.dart';
import 'package:product/presentation/cubit/product_feature_state.dart';

class MockProductFeatureResponse extends Mock
    implements ProductFeatureResponse {}

class MockFailure extends Mock implements Failure {}

void main() {
  group('ProductFeatureState', () {
    test('supports value comparison', () {
      expect(
        const ProductFeatureState(sliderIndex: 0),
        const ProductFeatureState(sliderIndex: 0),
      );
    });

    test('copies with new values', () {
      const originalState = ProductFeatureState(sliderIndex: 0);
      final copiedState = originalState.copyWith(sliderIndex: 1);
      expect(originalState.sliderIndex, 0);
      expect(copiedState.sliderIndex, 1);
    });
  });

  group('ProductFeatureInitialState', () {
    test('has empty props', () {
      expect(const ProductFeatureInitialState(sliderIndex: 0).props, isEmpty);
    });
  });

  group('LoadingState', () {
    test('supports value comparison', () {
      expect(
        const LoadingState(isloading: true, sliderIndex: 0),
        const LoadingState(isloading: true, sliderIndex: 0),
      );
    });

    test('has correct props', () {
      expect(
        const LoadingState(isloading: true, sliderIndex: 0).props,
        [true],
      );
    });
  });

  group('ProductFeatureSuccessState', () {
    test('supports value comparison', () {
      final response1 = MockProductFeatureResponse();
      final response2 = MockProductFeatureResponse();
      expect(
        ProductFeatureSuccessState(response: response1, sliderIndex: 0),
        ProductFeatureSuccessState(response: response1, sliderIndex: 0),
      );
      expect(
        ProductFeatureSuccessState(response: response1, sliderIndex: 0),
        isNot(ProductFeatureSuccessState(response: response2, sliderIndex: 0)),
      );
    });

    test('has correct props', () {
      final response = MockProductFeatureResponse();
      expect(
        ProductFeatureSuccessState(response: response, sliderIndex: 0).props,
        [response],
      );
    });
  });

  group('ProductFeatureFailureState', () {
    test('supports value comparison', () {
      final failure1 = MockFailure();
      final failure2 = MockFailure();
      expect(
        ProductFeatureFailureState(error: failure1, sliderIndex: 0),
        ProductFeatureFailureState(error: failure1, sliderIndex: 0),
      );
      expect(
        ProductFeatureFailureState(error: failure1, sliderIndex: 0),
        isNot(ProductFeatureFailureState(error: failure2, sliderIndex: 0)),
      );
    });

    test('has correct props', () {
      final failure = MockFailure();
      expect(
        ProductFeatureFailureState(error: failure, sliderIndex: 0).props,
        [failure],
      );
    });
  });
}
