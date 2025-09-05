import 'package:bloc_test/bloc_test.dart';
import 'package:common/features/rate_us/data/models/rate_us_model.dart';
import 'package:common/features/rate_us/data/models/rate_us_request.dart';
import 'package:common/features/rate_us/data/models/rate_us_response.dart';
import 'package:common/features/rate_us/data/models/update_rate_us_request.dart';
import 'package:common/features/rate_us/data/models/update_rate_us_response.dart';
import 'package:common/features/rate_us/domain/usecases/rate_us_usecase.dart';
import 'package:common/features/rate_us/presentation/cubit/rate_us_cubit.dart';
import 'package:core/config/error/failure.dart';
import 'package:core/config/resources/image_constant.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'rate_us_cubit_test.mocks.dart';


@GenerateMocks([RateUsUseCase])
void main() {
  late RateUsCubit rateUsCubit;
  var mockRateUsUseCase = MockRateUsUseCase();
  late RateUsRequest mockRequest;
  late RateUsResponse mockResponse;
  var mockError = const ServerFailure('some error');
  late UpdateRateUsRequest mockUpdateRateUsRequest;
  late UpdateRateUsResponse mockUpdateRateUsResponse;
  List<RateUsModel> rateUsList = [
    RateUsModel(
        description: labelUnhappy,
        image: ImageConstant.imgSentimentDissatisfiedLight,
        fillColorImage: ImageConstant.imgSentimentDissatisfiedLightFillup,
        ratingNum: 1,
        isSelected: true,),
    RateUsModel(
      description: labelOkay,
      image: ImageConstant.imgSentimentNeutralLight,
      fillColorImage: ImageConstant.imgSentimentNeutralLightFillup,
      ratingNum: 2,
    ),
    RateUsModel(
      description: labelHappy,
      image: ImageConstant.imgSentimentSatisfiedLight,
      fillColorImage: ImageConstant.imgSentimentSatisfiedLightFillup,
      ratingNum: 3,
    ),
  ];

  List<RateUsModel> clearRateUsList = [
    RateUsModel(
      description: labelUnhappy,
      image: ImageConstant.imgSentimentDissatisfiedLight,
      fillColorImage: ImageConstant.imgSentimentDissatisfiedLightFillup,
      ratingNum: 1,
    ),
    RateUsModel(
      description: labelOkay,
      image: ImageConstant.imgSentimentNeutralLight,
      fillColorImage: ImageConstant.imgSentimentNeutralLightFillup,
      ratingNum: 2,
    ),
    RateUsModel(
      description: labelHappy,
      image: ImageConstant.imgSentimentSatisfiedLight,
      fillColorImage: ImageConstant.imgSentimentSatisfiedLightFillup,
      ratingNum: 3,
    ),
  ];
  setUp(() async {
    mockRateUsUseCase = MockRateUsUseCase();
    rateUsCubit = RateUsCubit(usecase: mockRateUsUseCase);
    mockResponse = RateUsResponse(code: "SUCCESS",rateUsStatus: true);
    mockRequest = RateUsRequest(superAppId: "9372020045",feature: "payment");
    mockUpdateRateUsRequest = UpdateRateUsRequest(superAppId: "9372020045",feature: "payment",rating: 1,comment: "");
    mockUpdateRateUsResponse = UpdateRateUsResponse(code: "SUCCESS",message: "Rate us details save successfully");
  });

  group('test Rate Us Logic', () {
    blocTest(
      "to update Rate Us",
      build: () {
        return rateUsCubit;
      },
      act: (cubit) => cubit.updateRateUs(0),
      expect: () => [
        EmptyRateUsState(),
        ChangeRateUsState(rateUsModelList: rateUsList),
      ],
    );

    blocTest(
      "on close Rate Us",
      build: () {
        return rateUsCubit;
      },
      act: (cubit) => cubit.clearRateUsList(),
      expect: () => [
        EmptyRateUsState(),
        ChangeRateUsState(rateUsModelList: clearRateUsList),
      ],
    );
  });

  group('test Rate Us API', () {
    blocTest('should emit RateUsSuccessState when getRateUs is called',
        build: () {
          when(mockRateUsUseCase.call(mockRequest))
              .thenAnswer((_) async => Right(mockResponse));
          return rateUsCubit;
        },
      act: (RateUsCubit cubit) {
        cubit.getRateUs(mockRequest);
      },
      wait: const Duration(seconds: 1),
        expect: () =>
        [
          LoadingState(isloading: true),
          LoadingState(isloading: false),
          RateUsSuccessState(response: mockResponse),
        ],
    );

    blocTest(
        'should emit LoadingState and GetBbpsUrlFailureState when getBbpsUrl with failure',
        build: () {
          when(mockRateUsUseCase.call(mockRequest))
              .thenAnswer((_) async => Left(mockError));
          return rateUsCubit;
        },
        act: (RateUsCubit cubit) {
          cubit.getRateUs(mockRequest);
        },
        wait: const Duration(seconds: 3),
        expect: () =>
        [
          LoadingState(isloading: true),
          LoadingState(isloading: false),
          RateUsFailureState(failure: mockError),
        ],);
  });


  group('test Update Rate Us API', () {
    blocTest('should emit UpdateRateUsRecordSuccessState when updateRateUsRecord is called',
        build: () {
          when(mockRateUsUseCase.updateRateUsRecord(mockUpdateRateUsRequest))
              .thenAnswer((_) async => Right(mockUpdateRateUsResponse));
          return rateUsCubit;
        },
        act: (RateUsCubit cubit) {
          cubit.updateRateUsRecord(mockUpdateRateUsRequest,false);
        },
        wait: const Duration(seconds: 3),
        expect: () =>
        [
          LoadingState(isloading: true),
          LoadingState(isloading: false),
          UpdateRateUsRecordSuccessState(response: mockUpdateRateUsResponse,isComingFromCloseButton: false),
        ],
    );

    blocTest(
        'should emit LoadingState and RateUsFailureState when updateRateUsRecord with failure',
        build: () {
          when(mockRateUsUseCase.updateRateUsRecord(mockUpdateRateUsRequest))
              .thenAnswer((_) async => Left(mockError));
          return rateUsCubit;
        },
        act: (RateUsCubit cubit) {
          cubit.updateRateUsRecord(mockUpdateRateUsRequest,false);
        },
        wait: const Duration(seconds: 3),
        expect: () =>
        [
          LoadingState(isloading: true),
          LoadingState(isloading: false),
          RateUsFailureState(failure: mockError),
        ],);
  });
}
