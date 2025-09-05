import 'package:auth/config/routes/route.dart';
import 'package:auth/features/login_and_registration/presentation/cubit/auth_cubit.dart';
import 'package:auth/features/login_and_registration/presentation/login/biometric_registeration.dart';
import 'package:auth/features/login_and_registration/presentation/login/login_screen.dart';
import 'package:auth/features/login_and_registration/presentation/login/old_mpin_screen.dart';
import 'package:auth/features/login_and_registration/presentation/login/register_status.dart';
import 'package:auth/features/login_and_registration/presentation/login/second_factor_argument.dart';
import 'package:auth/features/login_and_registration/presentation/login/second_factor_auth_screen.dart';
import 'package:auth/features/login_and_registration/presentation/login/user_info_screen.dart';
import 'package:common/features/language_selection/presentation/cubit/select_language_cubit.dart';
import 'package:common/features/startup/data/models/validate_device_response.dart';
import 'package:common/features/startup/presentation/cubit/validate_device_cubit.dart';
import 'package:core/services/di/injection_container.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../features/login_and_registration/presentation/cubit/biometric_cubit.dart';
import '../../features/login_and_registration/presentation/login/choose_second_factor_auth_screen.dart';
import '../../features/login_and_registration/presentation/login/mpin_screen.dart';
import '../../features/login_and_registration/presentation/login/mpin_success_screen.dart';
import '../../features/mobile_otp/presentation/cubit/phone_validate_cubit.dart';
import '../../features/mobile_otp/presentation/validate_phone_screen.dart';

final List<GoRoute> loginRoutes = [
  GoRoute(
      path: Routes.mobileOtp.path,
      name: Routes.mobileOtp.name,
      builder: (context, state) => BlocProvider<PhoneValidateCubit>(
            create: (context) => di<PhoneValidateCubit>(),
            child: const ValidatePhoneScreen(),
          )),
  GoRoute(
    path: Routes.chooseSecondFactorAuth.path,
    name: Routes.chooseSecondFactorAuth.name,
    builder: (context, state) {
      Map<String, dynamic> args = state.extra as Map<String, dynamic>;
      return BlocProvider(
          create: (context) => di<AuthCubit>(),
          child: ChooseSecondFactorAuthScreen(
            currentProfile: args["currentProfile"]!,
          ));
    },
  ),
  GoRoute(
      path: Routes.secondfactorauth.path,
      name: Routes.secondfactorauth.name,
      builder: (context, state) => MultiBlocProvider(
            providers: [
              BlocProvider<AuthCubit>(
                create: (context) => di<AuthCubit>(),
              ),
              BlocProvider<PhoneValidateCubit>(
                create: (context) => di<PhoneValidateCubit>(),
              ),
              BlocProvider<SelectLanguageCubit>(
                create: (context) => di<SelectLanguageCubit>(),
              ),
              BlocProvider<ValidateDeviceCubit>(
                create: (context) => di<ValidateDeviceCubit>(),
              )
            ],
            child: SecondFactorAuthScreen(
                authType:
                    int.parse(state.pathParameters['authType'].toString()),
                mobileNumber: state.pathParameters['mobileNumber'].toString(),
                extras: state.extra != null
                    ? state.extra as SecondFactorAuthArg
                    : SecondFactorAuthArg()),
          )),
  GoRoute(
      path: Routes.userInfo.path,
      name: Routes.userInfo.name,
      builder: (_, __) => BlocProvider<AuthCubit>(
          create: (context) => di<AuthCubit>(), child: const UserInfoScreen())),
  GoRoute(
      path: Routes.registerStatus.path,
      name: Routes.registerStatus.name,
      builder: (context, state) => BlocProvider<AuthCubit>(
          create: (context) => di<AuthCubit>(),
          child: RegisterStatus(
            registerStatus:
                bool.parse(state.pathParameters['registerStatus'].toString()),
          ))),
  GoRoute(
      path: Routes.mpin.path,
      name: Routes.mpin.name,
      builder: (context, state) => MultiBlocProvider(
        providers: [
          BlocProvider<AuthCubit>(
            create: (context) => di<AuthCubit>(),
          ),
          BlocProvider<PhoneValidateCubit>(
            create: (context) => di<PhoneValidateCubit>(),
          ),
          BlocProvider<SelectLanguageCubit>(
            create: (context) => di<SelectLanguageCubit>(),
          )
        ],
        child: MPINScreen(currentProfile: state.extra as Profiles),
      )),
  GoRoute(
      path: Routes.biometric.path,
      name: Routes.biometric.name,
      builder: (context, state) => BlocProvider<BiometricCubit>(
          create: (context) => di<BiometricCubit>(),
          child: BiometricRegistrationScreen(isFromSetting: state.extra as bool,))),
  GoRoute(
      path: Routes.mpinSuccess.path,
      name: Routes.mpinSuccess.name,
      builder: (_, __) => BlocProvider<BiometricCubit>(
          create: (context) => di<BiometricCubit>(),
          child: const MPINSuccessScreen())),
  GoRoute(
      path: Routes.login.path,
      name: Routes.login.name,
      builder: (context, state) => MultiBlocProvider(
            providers: [
              BlocProvider<AuthCubit>(
                create: (context) => di<AuthCubit>(),
              ),
              BlocProvider<PhoneValidateCubit>(
                create: (context) => di<PhoneValidateCubit>(),
              ),
              BlocProvider<ValidateDeviceCubit>(
                create: (context) => di<ValidateDeviceCubit>(),
              ),
              BlocProvider<SelectLanguageCubit>(
                create: (context) => di<SelectLanguageCubit>(),
              )
            ],
            child: LoginScreen(profiles: state.extra as List<Profiles>),
          )),
  GoRoute(
      path: Routes.changeLoginPin.path,
      name: Routes.changeLoginPin.name,
      builder: (_, __) => BlocProvider<AuthCubit>(
          create: (context) => di<AuthCubit>(), child: const OldMPINScreen())),
];
