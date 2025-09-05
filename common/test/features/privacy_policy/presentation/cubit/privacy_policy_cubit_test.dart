import 'package:bloc_test/bloc_test.dart';
import 'package:common/features/privacy_policy/data/models/get_privacy_policy_request.dart';
import 'package:common/features/privacy_policy/data/models/get_privacy_policy_response.dart';
import 'package:common/features/privacy_policy/domain/usecases/privacy_policy_usecases.dart';
import 'package:common/features/privacy_policy/presentation/cubit/privacy_policy_cubit.dart';
import 'package:common/features/privacy_policy/presentation/cubit/privacy_policy_state.dart';
import 'package:core/config/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'privacy_policy_cubit_test.mocks.dart';

@GenerateMocks([PrivacyPolicyUseCase])
void main() {
  late PrivacyPolicyCubit cubit;
  var mockPrivacyPolicyUseCase = MockPrivacyPolicyUseCase();
  var mockError = const ServerFailure('some error');

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    cubit = PrivacyPolicyCubit(privacyPolicyUseCase: mockPrivacyPolicyUseCase);
  });

  var mockPrivacyPolicyRequest =
      GetPrivacyPolicyRequest(category: 'privacy-policy', language: 'en');
  var mockPrivacyPolicyResponse = GetPrivacyPolicyResponse(data: '');
  group('Privacy Policy API Test', () {
    blocTest('should emit PrivacyPolicySuccessState when API get called',
        build: () {
          when(mockPrivacyPolicyUseCase.call(mockPrivacyPolicyRequest))
              .thenAnswer((_) async => Right(mockPrivacyPolicyResponse));
          return cubit;
        },
        act: (PrivacyPolicyCubit cubit) {
          cubit.getPrivacyPolicy(mockPrivacyPolicyRequest);
        },
        wait: const Duration(seconds: 2),
        expect: () => [
              LoadingState(isLoading: true),
              LoadingState(isLoading: false),
              PrivacyPolicySuccessState(response: mockPrivacyPolicyResponse),
            ],);

    blocTest(
        'should emit PrivacyPolicyLoadingState and PrivacyPolicyFailureState, when privacy-policy with failure',
        build: () {
          when(mockPrivacyPolicyUseCase.call(mockPrivacyPolicyRequest))
              .thenAnswer((_) async => Left(mockError));
          return cubit;
        },
        act: (PrivacyPolicyCubit cubit) {
          cubit.getPrivacyPolicy(mockPrivacyPolicyRequest);
        },
        wait: const Duration(seconds: 2),
        expect: () => [
              LoadingState(isLoading: true),
              LoadingState(isLoading: false),
              PrivacyPolicyFailureState(failure: mockError),
            ],);
  });
}
