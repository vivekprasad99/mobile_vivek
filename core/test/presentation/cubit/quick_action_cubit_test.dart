import 'package:bloc_test/bloc_test.dart';
import 'package:core/config/error/failure.dart';
import 'package:core/features/app_content/data/model/app_content_response.dart';
import 'package:core/features/app_content/domain/usecases/app_content_usecase.dart';
import 'package:core/features/presentation/bloc/sticky_action_button/cubit/sticky_action_button_cubit.dart';
import 'package:core/features/presentation/bloc/sticky_action_button/sticky_action_button_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'quick_action_cubit_test.mocks.dart';

@GenerateMocks([AppContentUsecase])
void main() async {
  late QuickActionCubit cubit;
  var mockAppContentUsecase = MockAppContentUsecase();
  var mockError = const ServerFailure('some error');
  var mockAppContentResponse = AppContentResponse();
  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    cubit = QuickActionCubit(appContentUsecase: mockAppContentUsecase);
  });
  group('test getTollFreeNum', () {
    blocTest(
      'should emit StickyAtionButtonSuccessState',
      build: () {
        when(mockAppContentUsecase.call(any))
            .thenAnswer((_) async => Right(mockAppContentResponse));
        return cubit;
      },
      act: (QuickActionCubit cubit) {
        cubit.getTollFreeNum();
      },
      wait: const Duration(milliseconds: 100),
      expect: () => [
        StickyAtionButtonSuccessState(response: mockAppContentResponse),
      ],
    );

    blocTest<QuickActionCubit, QuickActionState>(
      'should emit StickyAtionButtonFailureState when getTollFreeNum is called and throws exception',
      build: () {
        when(mockAppContentUsecase.call(any)).thenThrow(Exception(mockError));
        return cubit;
      },
      act: (QuickActionCubit cubit) {
        cubit.getTollFreeNum();
      },
      expect: () => [
        StickyAtionButtonFailureState(error: NoDataFailure()),
      ],
    );
  });
}
