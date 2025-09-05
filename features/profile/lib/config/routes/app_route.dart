import 'package:auth/features/login_and_registration/presentation/cubit/auth_cubit.dart';
import 'package:auth/features/mobile_otp/presentation/cubit/phone_validate_cubit.dart';
import 'package:common/features/rate_us/presentation/cubit/rate_us_cubit.dart';
import 'package:go_router/go_router.dart';
import 'package:profile/config/routes/route.dart';
import 'package:profile/presentation/screens/mapmyloan/profile_second_factor_arg.dart';
import 'package:profile/presentation/screens/mapmyloan/profile_second_factor_screen.dart';
import 'package:profile/presentation/screens/mapmyloan/profile_select_second_factor_screen.dart';
import 'package:service_ticket/features/presentation/cubit/service_request_cubit.dart';
import 'package:profile/presentation/cubit/profile_cubit.dart';

import 'package:profile/presentation/screens/address/address_auth.dart';
import 'package:profile/presentation/screens/address/confirm_details.dart';
import 'package:profile/presentation/screens/address/service_request_generated.dart';
import 'package:profile/presentation/screens/address/update_address.dart';
import 'package:profile/presentation/screens/components/widgets/mismatch_screen.dart';
import 'package:profile/presentation/screens/emailID/update_email_id.dart';
import 'package:profile/presentation/screens/pancard/add_pancard.dart';
import 'package:profile/presentation/screens/post_login_profile/my_profile.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/services/di/injection_container.dart';
import 'package:profile/presentation/screens/update_mobile_number/authentication_mobile_number.dart';
import 'package:profile/presentation/screens/update_mobile_number/update_mobile_aadhar_auth.dart';
import 'package:profile/presentation/screens/update_mobile_number/update_mobile_number.dart';
import 'package:profile/presentation/screens/otp/otp_screen.dart';
import 'package:profile/presentation/screens/upload_photo/profile_upload_photo.dart';
import 'package:common/features/search/data/model/search_response.dart';

final List<GoRoute> profileFeatureRoutes = [
  GoRoute(
      path: Routes.myProfileData.path,
      name: Routes.myProfileData.name,
      builder: (context, state) => MultiBlocProvider(
        providers: [
          BlocProvider<ProfileCubit>(
            create: (context) => di<ProfileCubit>(),
          ),
          BlocProvider<PhoneValidateCubit>(
            create: (context) => di<PhoneValidateCubit>(),
          ),
        ],
        child: const MyProfile(),
      )),
  GoRoute(
      path: Routes.myProfileAddPanData.path,
      name: Routes.myProfileAddPanData.name,
      builder: (context, state) => BlocProvider<ProfileCubit>(
            create: (context) => di<ProfileCubit>(),
            child: BlocProvider<RateUsCubit>(
              create: (context) => di<RateUsCubit>(),
              child: AddPanCard(data: ServicesNavigationRequest.fromJson(state.extra as Map<dynamic,dynamic>)),
            ),
          )),
  GoRoute(
      path: Routes.myProfileUploadPhoto.path,
      name: Routes.myProfileUploadPhoto.name,
      builder: (context, state) => BlocProvider<ProfileCubit>(
            create: (context) => di<ProfileCubit>(),
            child: ProfileUploadPhoto(profileImage: state.extra as String,),
          )),
  GoRoute(
      path: Routes.myProfileUpdateEmailID.path,
      name: Routes.myProfileUpdateEmailID.name,
      builder: (context, state) => MultiBlocProvider(
            providers: [
              BlocProvider<ProfileCubit>(
                create: (context) => di<ProfileCubit>(),
              ),
              BlocProvider<PhoneValidateCubit>(
                create: (context) => di<PhoneValidateCubit>(),
              ),
            ],
            child: UpdateEmailID(data: ServicesNavigationRequest.fromJson(state.extra as Map<dynamic,dynamic>)),
          )),
  GoRoute(
      path: Routes.myProfileUpdateMobileNumber.path,
      name: Routes.myProfileUpdateMobileNumber.name,
      builder: (context, state) => MultiBlocProvider(
            providers: [
              BlocProvider<ProfileCubit>(
                create: (context) => di<ProfileCubit>(),
              ),
              BlocProvider<PhoneValidateCubit>(
                create: (context) => di<PhoneValidateCubit>(),
              ),
            ],
            child: UpdateMobileNumber(updateOperationType: state.pathParameters['updateOperationType'].toString(),
                data: ServicesNavigationRequest.fromJson(state.extra as Map<dynamic,dynamic>)),
          )),
  GoRoute(
      path: Routes.myProfileUpdateAddress.path,
      name: Routes.myProfileUpdateAddress.name,
      builder: (context, state) {
        return BlocProvider<ProfileCubit>(
          create: (context) => di<ProfileCubit>(),
          child: UpdateAddress(data: ServicesNavigationRequest.fromJson(state.extra as Map<dynamic,dynamic>)),
        );
      }),
  GoRoute(
      path: Routes.myProfileUpdateAddressAuth.path,
      name: Routes.myProfileUpdateAddressAuth.name,
      builder: (context, state) {
        Map<String, dynamic> args = state.extra as Map<String, dynamic>;
        return MultiBlocProvider(
          providers: [
            BlocProvider<ProfileCubit>(
              create: (context) => di<ProfileCubit>(),
            ),
            BlocProvider<ServiceRequestCubit>(
              create: (context) => di<ServiceRequestCubit>(),
            ),
          ],
          child: UpdateAddressAuth(addressType: args["addressType"],profileData: args["profileData"]
          ),
          );
      }),
  GoRoute(
      path: Routes.myProfileServiceRequestGenerated.path,
      name: Routes.myProfileServiceRequestGenerated.name,
      builder: (context, state) => BlocProvider<ProfileCubit>(
            create: (context) => di<ProfileCubit>(),
            child: const ServiceRequestScreen(),
          )),
  GoRoute(
      path: Routes.myProfileConfirmDetails.path,
      name: Routes.myProfileConfirmDetails.name,
      builder: (context, state) {
        Map<String, dynamic> args = state.extra as Map<String, dynamic>;
        return BlocProvider<ProfileCubit>(
          create: (context) => di<ProfileCubit>(),
          child: BlocProvider<RateUsCubit>(
            create: (context) => di<RateUsCubit>(),
            child: ConfirmDetails(
              confirmScreenType: args["confirmScreenType"],
              licenseDetail: args["validateDrivingLicenseDetail"],
              aadhaarInfo: args["aadhaarInfo"],
              addressType: args["addressType"],
            ),
          ),
        );
      }),
  GoRoute(
      path: Routes.myProfileNameMismatch.path,
      name: Routes.myProfileNameMismatch.name,
      builder: (context, state) {
        Map<String, dynamic> args = state.extra as Map<String, dynamic>;
        return ProfileNameMismatchScreen(
            errorTitle: args["errorTitle"], errorMessage: args["errorMessage"]);
      }),
  GoRoute(
      path: Routes.myProfileOtpScreen.path,
      name: Routes.myProfileOtpScreen.name,
      builder: (context, state) {
        Map<String, dynamic> args = state.extra as Map<String, dynamic>;
        return MultiBlocProvider(
          providers: [
            BlocProvider<ProfileCubit>(
              create: (context) => di<ProfileCubit>(),
            ),
            BlocProvider<PhoneValidateCubit>(
              create: (context) => di<PhoneValidateCubit>(),
            ),
            BlocProvider<RateUsCubit>(
              create: (context) => di<RateUsCubit>(),
            ),
            BlocProvider<AuthCubit>(
              create: (context) => di<AuthCubit>(),
            ),
          ],
          child: OtpScreen(
              otpScreenType: args["otpScreenType"]!,
              mobileNumber: args["mobileNumber"]!,
              extras: args["validateAadhaarDetail"]!, customerInfoArg: args["customerInfoArg"]!,),
        );
      }),
  GoRoute(
    path: Routes.myProfileUpdateMobileNumAadharAuth.path,
    name: Routes.myProfileUpdateMobileNumAadharAuth.name,
    builder: (context, state) {
      Map<String, dynamic> args = state.extra as Map<String, dynamic>;
      return BlocProvider(
          create: (context) => di<ProfileCubit>(),
          child: AuthenticateAadharMobileNumber(
              profileInfo: args["profileInfo"]!,
              newPhoneNumber: args["newPhoneNumber"]!, customerInfoArg: args["customerInfoArg"]!, updateOperationType: args["updateOperation"]!,));
    },
  ),
  GoRoute(
    path: Routes.myProfileAuthenticateMobileNumber.path,
    name: Routes.myProfileAuthenticateMobileNumber.name,
    builder: (context, state) {
      Map<String, dynamic> args = state.extra as Map<String, dynamic>;
      return BlocProvider(
          create: (context) => di<ProfileCubit>(),
          child: AuthenticateUpdateMobileNumber(
              newPhoneNumber: args["newPhoneNumber"]!, isUserToCustomer: args["isUserToCustomer"]!, customerInfoArg: args["customerInfoArg"]!, updateOperation: args["updateOperation"]!));
    },
  ),
  GoRoute(
    path: Routes.profilechooseSecondFactor.path,
    name: Routes.profilechooseSecondFactor.name,
    builder: (context, state) {
      Map<String, dynamic> args = state.extra as Map<String, dynamic>;
      return BlocProvider(
          create: (context) => di<AuthCubit>(),
          child: ProfileChooseSecondFactorScreen(
            currentProfile: args["currentProfile"]!,profileInfo: args["profileInfo"]!,
          ));
    },
  ),

  GoRoute(
      path: Routes.profilesecondfactor.path,
      name: Routes.profilesecondfactor.name,
      builder: (context, state) => MultiBlocProvider(
        providers: [
          BlocProvider<AuthCubit>(
            create: (context) => di<AuthCubit>(),
          ),
          BlocProvider<PhoneValidateCubit>(
            create: (context) => di<PhoneValidateCubit>(),
          )
        ],
        child: ProfileSecondFactorScreen(
            authType:
            int.parse(state.pathParameters['authType'].toString()),
            extras: state.extra != null
                ? state.extra as ProfileSecondFactorArg
                : ProfileSecondFactorArg()),
      )),
];
