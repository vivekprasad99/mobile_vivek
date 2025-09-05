import 'package:auth/features/login_and_registration/data/models/authentication_request.dart';
import 'package:auth/features/login_and_registration/data/models/authentication_response.dart';
import 'package:auth/features/login_and_registration/domain/usecases/login_usecase.dart';
import 'package:auth/features/login_and_registration/domain/usecases/registration_usecase.dart';
import 'package:auth/features/login_and_registration/domain/usecases/second_factor_auth_usecase.dart';
import 'package:auth/features/login_and_registration/presentation/cubit/auth_cubit.dart';
import 'package:auth/features/login_and_registration/presentation/cubit/auth_state.dart';
import 'package:auth/features/login_and_registration/presentation/cubit/biometric_cubit.dart';
import 'package:auth/features/login_and_registration/presentation/cubit/biometric_state.dart';
import 'package:core/utils/validation_functions.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:core/config/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'auth_cubit_test.mocks.dart';

@GenerateMocks([
  RegistrationUseCase,
  SecondFactorAuthUseCase,
  LocalAuthentication,
  LoginUseCase
])
void main() async {
  late AuthCubit cubit;
  var mockRegistrationUseCase = MockRegistrationUseCase();
  var mockSecondFactorAuthUseCase = MockSecondFactorAuthUseCase();
  var mockLoginUseCase = MockLoginUseCase();
  var mockError = const ServerFailure('some error');
  var mockAuthenticationRequest = AuthenticateSingleUcicRequest(
      authNumber: "", authType: 0, mobileNumber: "", platform: 'App');
  var mockAuthenticationResponse =
      AuthenticationResponse(code: "", message: "");

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    cubit = AuthCubit(
        loginUsecase: mockLoginUseCase,
        registerUsecase: mockRegistrationUseCase,
        secondFactorAuthUseCase: mockSecondFactorAuthUseCase);
  });

  group('test validate PAN card and Account Number', () {
    test("test valid PAN-Card", () {
      bool isValid = isValidPanCardNo('BDZPL8987U');
      expect(isValid, true);
    });

    test("test invalid PAN-Card", () {
      bool isValid = isValidPhoneNumber('98987677');
      expect(isValid, false);
    });

    test("test valid Account Number", () {
      bool isValid = isValidAccountNumber('00061050357891');
      expect(isValid, true);
    });

    test("test invalid Account Number", () {
      bool isValid = isValidAccountNumber('98987677');
      expect(isValid, false);
    });
  });

  group('test validate PAN card and Account Number', () {
    blocTest(
      'should emit AuthenticationSuccessState, when authenticate PAN-CARD/AccountNumber is called',
      build: () {
        when(mockSecondFactorAuthUseCase.call(mockAuthenticationRequest))
            .thenAnswer((_) async => Right(mockAuthenticationResponse));
        return cubit;
      },
      act: (AuthCubit cubit) {
        cubit.authenticateSingleUcicCustomer(
            authenticationRequest: mockAuthenticationRequest);
      },
      wait: const Duration(milliseconds: 100),
      expect: () => [
        LoadingState(isloading: true),
        AuthenticationSuccessState(response: mockAuthenticationResponse),
      ],
    );

    blocTest(
      'should emit AuthenticationLoadingState and AuthenticationFailureState, when authenticate with failure',
      build: () {
        when(mockSecondFactorAuthUseCase.call(mockAuthenticationRequest))
            .thenAnswer((_) async => Left(mockError));
        return cubit;
      },
      act: (AuthCubit cubit) {
        cubit.authenticateSingleUcicCustomer(
            authenticationRequest: mockAuthenticationRequest);
      },
      wait: const Duration(milliseconds: 100),
      expect: () => [
        LoadingState(isloading: true),
        AuthenticationFailureState(error: mockError)
      ],
    );

    blocTest(
        'should emit AuthenticationLoadingState and AuthenticationFailureState and thrown exception',
        build: () {
          when(mockSecondFactorAuthUseCase.call(mockAuthenticationRequest))
              .thenThrow((_) async => Exception('some error'));
          return cubit;
        },
        act: (AuthCubit cubit) {
          cubit.authenticateSingleUcicCustomer(
              authenticationRequest: mockAuthenticationRequest);
        },
        wait: const Duration(milliseconds: 100),
        expect: () => [
              LoadingState(isloading: true),
              AuthenticationFailureState(error: NoDataFailure())
            ]);
  });

  group('Biometric Login', () {
    late AuthCubit biometricAuthCubit;
    late MockLocalAuthentication mockLocalAuthentication;
    var mockRegistrationUseCase = MockRegistrationUseCase();
    var mockSecondFactorAuthUseCase = MockSecondFactorAuthUseCase();
    var mockLoginUseCase = MockLoginUseCase();

    setUp(() {
      mockLocalAuthentication = MockLocalAuthentication();
      biometricAuthCubit = AuthCubit(
          loginUsecase: mockLoginUseCase,
          registerUsecase: mockRegistrationUseCase,
          secondFactorAuthUseCase: mockSecondFactorAuthUseCase);
    });

    tearDown(() {
      biometricAuthCubit.close();
    });

    test('Initial value', () {
      expect(
          biometricAuthCubit.state,
          BiometricLoginState(
              remainingAttempt: 3, isBiometricLoginSuccess: false));
    });

    blocTest<AuthCubit, AuthState>(
      'Biometric success',
      build: () {
        when(mockLocalAuthentication.authenticate(
          localizedReason: 'localizedReason',
          options: const AuthenticationOptions(
              stickyAuth: true, biometricOnly: true, useErrorDialogs: false),
        )).thenAnswer((_) => Future.value(true));

        return biometricAuthCubit;
      },
      act: (cubit) => cubit.loginWithBiometricCallback(3, true),
      expect: () => [biometricAuthCubit.state],
    );

    blocTest<AuthCubit, AuthState>(
      'Biometric failure',
      build: () {
        when(mockLocalAuthentication.authenticate(
          localizedReason: 'localizedReason',
          options: const AuthenticationOptions(
              stickyAuth: true, biometricOnly: true, useErrorDialogs: false),
        )).thenAnswer((_) => Future.value(false));

        return biometricAuthCubit;
      },
      act: (cubit) => cubit.loginWithBiometricCallback(2, false),
      expect: () => [biometricAuthCubit.state],
    );
  });

  group('Biometric Registration', () {
    late BiometricCubit biometricAuthCubit;
    late MockLocalAuthentication mockLocalAuthentication;

    setUp(() {
      mockLocalAuthentication = MockLocalAuthentication();
      biometricAuthCubit = BiometricCubit();
    });

    tearDown(() {
      biometricAuthCubit.close();
    });

    test('Initial value', () {
      expect(
          biometricAuthCubit.state,
          BiometricTypeFaceId(
              isUserInteracted: false,
              isFacedId: false,
              availableBiometrics: const <BiometricType>[],
              isDeviceHasBiometric: false,
              isUserInteracted: false));
    });

    blocTest<BiometricCubit, BiometricTypeFaceId>(
      'Available Biometric',
      build: () {
        when(mockLocalAuthentication.getAvailableBiometrics())
            .thenAnswer((_) async => [BiometricType.face]);

        return biometricAuthCubit;
      },
      act: (cubit) =>
          cubit.getAvailableBiometricCallback(true, [BiometricType.face], true),
      expect: () => [biometricAuthCubit.state],
    );
  });
}
