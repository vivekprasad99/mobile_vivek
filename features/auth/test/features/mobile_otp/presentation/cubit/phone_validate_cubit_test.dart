import 'package:auth/features/mobile_otp/domain/usecases/user_consent_usecase.dart';
import 'package:core/utils/pref_utils.dart';
import 'package:core/utils/validation_functions.dart';
import 'package:auth/features/mobile_otp/data/models/send_otp_response.dart';
import 'package:auth/features/mobile_otp/data/models/send_otp_request.dart';
import 'package:auth/features/mobile_otp/data/models/validate_otp_request.dart';
import 'package:auth/features/mobile_otp/data/models/validate_otp_response.dart';
import 'package:auth/features/mobile_otp/domain/usecases/phone_validate_usecase.dart';
import 'package:auth/features/mobile_otp/domain/usecases/validate_otp_usecase.dart';
import 'package:auth/features/mobile_otp/presentation/cubit/phone_validate_cubit.dart';
import 'package:auth/features/mobile_otp/presentation/cubit/phone_validate_state.dart';
import 'package:core/config/config.dart';
import 'package:core/config/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'phone_validate_cubit_test.mocks.dart';

@GenerateMocks(
    [PhoneValidateUseCase, ValidateOtpUsecase, UserConsentUseCase, PrefUtils])
void main() async {
  late PhoneValidateCubit cubit;
  MockPhoneValidateUseCase mockPhoneValidateUseCase =
      MockPhoneValidateUseCase();
  MockValidateOtpUsecase mockValidateOtpUsecase = MockValidateOtpUsecase();
  var mockSendOtpRequest = SendOtpRequest();
  MockUserConsentUseCase mockUserConsentUseCase = MockUserConsentUseCase();
  var mockSendOtpResponse =
      SendOtpResponse(code: "", isOtpSent: "", message: "");
  var mockError = const ServerFailure('some error');
  var mockValidateRequest = ValidateOtpRequest(mobileNumber: "", otp: "");
  var mockValidateResponse = ValidateOtpResponse(code: "", message: "");

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    cubit = PhoneValidateCubit(
        sendOtpUsecase: mockPhoneValidateUseCase,
        validateOtpUsecase: mockValidateOtpUsecase,
        userConsentUseCase: mockUserConsentUseCase);
    SharedPreferences.setMockInitialValues({});
    await SharedPreferences.getInstance();
    PrefUtils();
  });

  group('Phone & OTP validation', () {
    test("test valid Phone", () {
      bool isValid = isValidPhoneNumber('+919898767783');
      expect(isValid, true);
    });

    test("test invalid Phone", () {
      bool isValid = isValidPhoneNumber('98987677');
      expect(isValid, false);
    });
  });
  group('test sendOtp', () {
    blocTest(
      'should emit OtpViewState, MobileNumberEnableState, ResendOtpState when sendOTP is called & isFromResend: false',
      build: () {
        when(mockPhoneValidateUseCase.call(mockSendOtpRequest))
            .thenAnswer((_) async => Right(mockSendOtpResponse));
        return cubit;
      },
      act: (PhoneValidateCubit cubit) {
        cubit.sendOtp(mockSendOtpRequest, isFromResend: false);
      },
      wait: const Duration(milliseconds: 100),
      expect: () => [
        MobileOtpInitState(false, false, false),
        ResendOtpState(true, false, false)
      ],
    );

    blocTest(
      'should emit only ResendOtpState when Resend OTP is called & isFromResend: true',
      build: () {
        when(mockPhoneValidateUseCase.call(mockSendOtpRequest))
            .thenAnswer((_) async => Right(mockSendOtpResponse));
        return cubit;
      },
      act: (PhoneValidateCubit cubit) {
        cubit.sendOtp(mockSendOtpRequest, isFromResend: true);
      },
      wait: const Duration(milliseconds: 100),
      expect: () => [ResendOtpState(true, false, false)],
    );

    blocTest(
      'should emit SendOtpFailure when Resend OTP is called with failure',
      build: () {
        when(mockPhoneValidateUseCase.call(mockSendOtpRequest))
            .thenAnswer((_) async => Left(mockError));
        return cubit;
      },
      act: (PhoneValidateCubit cubit) {
        cubit.sendOtp(mockSendOtpRequest, isFromResend: true);
      },
      wait: const Duration(milliseconds: 100),
      expect: () => [SendOtpFailure(error: mockError)],
    );

    blocTest(
        'should emit SendOtpFailure when Resend OTP is called and thrown exception',
        build: () {
          when(mockPhoneValidateUseCase.call(mockSendOtpRequest))
              .thenThrow((_) async => Exception('some error'));
          return cubit;
        },
        act: (PhoneValidateCubit cubit) {
          cubit.sendOtp(mockSendOtpRequest, isFromResend: true);
        },
        wait: const Duration(milliseconds: 100),
        expect: () => [
              SendOtpFailure(error: NoDataFailure()),
            ]);
  });

  group('test validateOtp', () {
    blocTest(
      'should emit ValidateOtpSuccess',
      build: () {
        when(mockValidateOtpUsecase.call(mockValidateRequest))
            .thenAnswer((_) async => Right(mockValidateResponse));
        return cubit;
      },
      act: (PhoneValidateCubit cubit) {
        cubit.validateOtp(mockValidateRequest);
      },
      wait: const Duration(milliseconds: 100),
      expect: () => [
        ValidateOtpSuccess(response: mockValidateResponse),
      ],
    );

    blocTest(
      'should emit ValidateOtpFailure when Validate OTP is called with failure',
      build: () {
        when(mockValidateOtpUsecase.call(mockValidateRequest))
            .thenAnswer((_) async => Left(mockError));
        return cubit;
      },
      act: (PhoneValidateCubit cubit) {
        cubit.validateOtp(mockValidateRequest);
      },
      wait: const Duration(milliseconds: 100),
      expect: () => [ValidateOtpFailure(error: mockError)],
    );

    blocTest(
        'should emit ValidateOtpFailure when Validate OTP is called and thrown exception',
        build: () {
          when(mockValidateOtpUsecase.call(mockValidateRequest))
              .thenThrow((_) async => Exception('some error'));
          return cubit;
        },
        act: (PhoneValidateCubit cubit) {
          cubit.validateOtp(mockValidateRequest);
        },
        wait: const Duration(milliseconds: 100),
        expect: () => [
              ValidateOtpFailure(error: NoDataFailure()),
            ]);
  });
}
