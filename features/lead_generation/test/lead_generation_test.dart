import 'package:core/config/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lead_generation/data/models/create_lead_generation_request.dart';
import 'package:lead_generation/data/models/create_lead_generation_response.dart';
import 'package:lead_generation/domain/usecases/lead_generation_usecase.dart';
import 'package:lead_generation/presentation/cubit/lead_generation_cubit.dart';
import 'package:lead_generation/presentation/cubit/lead_generation_state.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:bloc_test/bloc_test.dart';
import 'lead_generation_test.mocks.dart';

@GenerateMocks([LeadGenerationUseCase])
void main() {
  late LeadGenerationCubit cubit;
  var mockLeadGenUseCase = MockLeadGenerationUseCase();
  var mockLeadGenerationRequest = LeadGenerationRequest(
      name: 'Test',
      mobileNumber: '99999999999',
      leadType: 'sme',
      pinCode: '628801');
  var mockLeadGenerationResponse =
      CreateLeadGenerationResponse(message: 'Success', enquiryId: '22333444');
  var mockError = const ServerFailure('some error');

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    cubit = LeadGenerationCubit(leadGenerationUseCase: mockLeadGenUseCase);
  });

  group('Checking all mandatory fields are valid', () {
    late LeadGenerationCubit leadGenerationCubit;
    var mockLeadGenUseCase = MockLeadGenerationUseCase();

    setUp(() {
      leadGenerationCubit =
          LeadGenerationCubit(leadGenerationUseCase: mockLeadGenUseCase);
    });

    tearDown(() {
      leadGenerationCubit.close();
    });

    test('Initial value', () {
      expect(leadGenerationCubit.state, ValidateState(isValid: false));
    });

    blocTest<LeadGenerationCubit, LeadGenerationState>(
      'Validation success',
      build: () {
        return leadGenerationCubit;
      },
      act: (cubit) => cubit.validateInput(true),
      expect: () => [ValidateState(isValid: true)],
    );
  });

  group('create Lead Generation', () {
    blocTest(
      'should emit success',
      build: () {
        when(mockLeadGenUseCase.call(mockLeadGenerationRequest))
            .thenAnswer((_) async => Right(mockLeadGenerationResponse));
        return cubit;
      },
      act: (LeadGenerationCubit cubit) {
        cubit.createLeadGeneration(
            applicationStatusRequest: mockLeadGenerationRequest);
      },
      wait: const Duration(milliseconds: 100),
      expect: () => [
        LoadingState(isLoading: true),
        LoadingState(isLoading: false),
        LeadGenerationSuccessState(response: mockLeadGenerationResponse),
      ],
    );

    blocTest(
      'should emit failure',
      build: () {
        when(mockLeadGenUseCase.call(mockLeadGenerationRequest))
            .thenAnswer((_) async => Left(mockError));
        return cubit;
      },
      act: (LeadGenerationCubit cubit) {
        cubit.createLeadGeneration(
            applicationStatusRequest: mockLeadGenerationRequest);
      },
      wait: const Duration(milliseconds: 100),
      expect: () => [
        LoadingState(isLoading: true),
        LoadingState(isLoading: false),
        LeadGenerationFailureState(error: mockError)
      ],
    );

    blocTest('should emit exception',
        build: () {
          when(mockLeadGenUseCase.call(mockLeadGenerationRequest))
              .thenThrow((_) async => Exception('some error'));
          return cubit;
        },
        act: (LeadGenerationCubit cubit) {
          cubit.createLeadGeneration(
              applicationStatusRequest: mockLeadGenerationRequest);
        },
        wait: const Duration(milliseconds: 100),
        expect: () => [
              LoadingState(isLoading: true),
              LoadingState(isLoading: false),
              LeadGenerationFailureState(error: NoDataFailure()),
            ]);
  });
}
