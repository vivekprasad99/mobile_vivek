import 'dart:convert';
import 'package:auth/features/mobile_otp/presentation/cubit/phone_validate_cubit.dart';
import 'package:auth/features/mobile_otp/presentation/cubit/phone_validate_state.dart';
import 'package:common/features/search/data/model/search_response.dart';
import 'package:common/features/startup/data/models/validate_device_response.dart';
import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/resources/custom_image_view.dart';
import 'package:core/config/resources/image_constant.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/config/widgets/background/mf_gradient_background.dart';
import 'package:core/config/widgets/mf_progress_bar.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:core/config/widgets/mf_toast.dart';
import 'package:core/utils/const.dart';
import 'package:core/utils/size_utils.dart';
import 'package:core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:profile/config/routes/route.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:profile/data/models/get_profile_img_req.dart';
import 'package:profile/data/models/my_profile_model_request.dart';
import 'package:profile/data/models/my_profile_model_response.dart';
import 'package:profile/presentation/cubit/profile_cubit.dart';
import 'package:profile/presentation/screens/components/widgets/my_profile_info_widget.dart';
import 'package:profile/utils/utils.dart';
import 'package:intl/intl.dart';
import '../../../data/models/customer_info_args.dart';
import '../../../data/models/validate_aadhaar_detail.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});
  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  MyProfileResponse? myProfileResponse;
  bool showLoader = false;
  bool showNoRecordsFound = false;
  String? _base62Image;
  bool? canUpdateAddress;
  bool? canUpdateOtherDetails;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ProfileCubit>(context).getMyProfile(MyProfileRequest(
        ucic: getUCIC(), superAppId: getSuperAppId(), source: AppConst.source));
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody(context);
  }

  Widget _buildBody(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: _buildAppBar(context),
        body: MultiBlocListener(listeners: [
          BlocListener<PhoneValidateCubit, MobileOtpState>(listener: (context, state) {
            if (state is SendOtpSuccess ) {
              if (state.response.code == AppConst.codeSuccess) {
                context.pushNamed(Routes.myProfileOtpScreen.name, extra: {
                  "otpScreenType": OtpScreenType.mobileOtp,
                  "mobileNumber": getPhoneNumber(),
                  "validateAadhaarDetail": ProfileExtras(
                      newPhoneNumber: getPhoneNumber(),
                      operation: Operation.mapMyLoan,
                      custName:
                      myProfileResponse?.data?.customerName),
                  "customerInfoArg" : CustomerInfoArg()
                });
              } else {
                displayAlertSingleAction(
                    context, getString(state.response.responseCode ?? lblProfileErrorGeneric),
                    btnLbl: getString(lblProfileOk));
              }
            } else if(state is SendOtpFailure) {
              displayAlertSingleAction(
                  context, getFailureMessage(state.error),
                  btnLbl: getString(lblProfileOk));
            } else if (state is ApiLoadingState) {
              if (state.isloading) {
                showLoaderDialog(context, getString(lblLoading));
              } else {
                Navigator.of(context, rootNavigator: true).pop();
              }
            }
          })
        ],child: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            if (state is MyProfileSuccessState) {
              if (state.response.code == AppConst.codeFailure) {
                showNoRecordsFound = true;
              } else {
                myProfileResponse = state.response;
                canUpdateAddress =
                    myProfileResponse?.data?.addressUpdateAllowed ?? true;
                canUpdateOtherDetails =
                    myProfileResponse?.data?.otherUpdateAllowed ?? true;

                BlocProvider.of<ProfileCubit>(context).getMyProfileImage(
                    ProfileImageRequest(
                        superAppId: getSuperAppId(), source: AppConst.source));
              }
            } else if (state is MyProfileFailureState) {
              showNoRecordsFound = true;
            } else if (state is MyProfileImageSuccessState) {
              if (state.response.code == AppConst.codeFailure) {
                _base62Image = "";
                showLoader = false;
              } else {
                _base62Image = state.response.profileImage ?? "";
                showLoader = false;
              }
            } else if (state is MyProfileImageFailureState) {
              _base62Image = "";
              showLoader = false;
            } else if (state is ProfileLoadingState && state.isloading) {
              return Align(
                alignment: Alignment.bottomCenter,
                child: Center(
                    child: CircularProgressIndicator(
                  color: Theme.of(context).indicatorColor,
                  strokeWidth: 2,
                )),
              );
            } else if (state is ImageLoadingState) {
              showLoader = state.isImageloading;
            }
            return MFGradientBackground(
                horizontalPadding: 4.h,
                child: showNoRecordsFound
                    ? Center(
                        child: noRecordFound(),
                      )
                    : SingleChildScrollView(
                        child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 10.h, horizontal: 10.v),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      if (canUpdateOtherDetails!) {
                                        context.pushNamed(
                                            Routes.myProfileUploadPhoto.name,
                                            extra: _base62Image ?? "");
                                      } else {
                                        showFreezePeriodDialog(context);
                                      }
                                    },
                                    child: Column(
                                      children: [
                                        CircleAvatar(
                                          radius: 50,
                                          backgroundColor:
                                              AppColors.primaryLight5,
                                          child: ClipRRect(
                                              child: !showLoader
                                                  ? _base62Image != "" &&
                                                          _base62Image != null
                                                      ? Image.memory(
                                                          base64Decode(
                                                              _base62Image!),
                                                          height: 380,
                                                          fit: BoxFit.fill,
                                                        )
                                                      : Text(
                                                          getInitials(
                                                              myProfileResponse
                                                                      ?.data
                                                                      ?.customerName ??
                                                                  ""),
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .displayLarge
                                                                  ?.copyWith(
                                                                    color: AppColors
                                                                        .nameInitialsColorLight,
                                                                  ),
                                                        )
                                                  : const Center(
                                                      child:
                                                          CircularProgressIndicator(),
                                                    )),
                                        ),
                                        SizedBox(height: 10.v),
                                        Text(getString(lblUploadPhoto),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall
                                                ?.copyWith(
                                                    color: AppColors
                                                        .secondaryLight)),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 200.adaptSize,
                                          child: Text(
                                              myProfileResponse
                                                      ?.data?.customerName ??
                                                  '',
                                              softWrap: true,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge
                                                  ?.copyWith(
                                                      color: setColorBasedOnTheme(
                                                          context: context,
                                                          lightColor: AppColors
                                                              .myProfileNameColor,
                                                          darkColor: AppColors
                                                              .backgroundLight5))),
                                        ),
                                        SizedBox(height: 10.v),
                                        Text(
                                            "${getString(lblPANdob)} - ${formatDate(myProfileResponse?.data?.dob ?? '')}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall
                                                ?.copyWith(
                                                    color: setColorBasedOnTheme(
                                                        context: context,
                                                        lightColor:
                                                            AppColors.textLight,
                                                        darkColor: AppColors
                                                            .backgroundLight5))),
                                        isCustomer()
                                            ? Text(
                                                "${getString(lblCustID)} - ${getUCIC()}",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall
                                                    ?.copyWith(
                                                        color: setColorBasedOnTheme(
                                                            context: context,
                                                            lightColor:
                                                                AppColors
                                                                    .textLight,
                                                            darkColor: AppColors
                                                                .backgroundLight5)))
                                            : const SizedBox(),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 18.h),
                                        )
                                      ],
                                    ),
                                  )
                                ]),
                            SizedBox(height: 20.v),
                            _buildMapMyLoanWidget(),
                            SizedBox(height: 20.v),
                            _buildPictureAndNameWidget(myProfileResponse),
                          ],
                        ),
                      )));
          },
        )));
  }

  Widget _buildPictureAndNameWidget(MyProfileResponse? myProfileResponse) {
    return Container(
      padding: const EdgeInsets.only(left: 16.0, bottom: 8.0, right: 16.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            8.h,
          ),
          color: Theme.of(context).cardColor),
      child: Column(
        children: [
          MyProfileInfoWidget(
              heading: getString(lblMobile),
              onTap: () {
                if (canUpdateOtherDetails!) {
                  context.pushNamed(Routes.myProfileUpdateMobileNumber.name,
                      pathParameters: {'updateOperationType': Operation.updatePhoneNumber.value},
                      extra: ServicesNavigationRequest(myProfileResponse: myProfileResponse?.data ?? ProfileInfo()).toJson());
                } else {
                  showFreezePeriodDialog(context);
                }
              },
              isEdit: true,
              subheading: maskString(
                  myProfileResponse?.data?.mobileNumber ?? '',
                  MaskingFieldType.mobile)),
          divide(),
          MyProfileInfoWidget(
              heading: getString(lblEmailID),
              onTap: () {
                if (canUpdateOtherDetails!) {
                  context.pushNamed(Routes.myProfileUpdateEmailID.name,
                      extra: ServicesNavigationRequest(myProfileResponse: myProfileResponse?.data ?? ProfileInfo()).toJson());
                } else {
                  showFreezePeriodDialog(context);
                }
              },
              isEdit: true,
              subheading: maskString(myProfileResponse?.data?.emailID ?? '',
                  MaskingFieldType.email)),
          divide(),
          isCustomer()
              ? MyProfileInfoWidget(
                  heading: getString(lblProfilePermanentAddress),
                  onTap: () {
                    if (canUpdateOtherDetails! && canUpdateAddress!) {
                      context.pushNamed(
                          Routes.myProfileUpdateAddress.name,
                          extra:ServicesNavigationRequest(addressType: AddressType.permanent,myProfileResponse:  myProfileResponse?.data ?? ProfileInfo()).toJson()
                      );
                    } else {
                      showFreezePeriodDialog(context);
                    }
                  },
                  isEdit: true,
                  subheading:
                      myProfileResponse?.data?.permanentAddr?.fullAddress ?? "")
              : const SizedBox(),
          isCustomer() ? divide() : const SizedBox(),
          isCustomer()
              ? MyProfileInfoWidget(
                  heading: getString(lblCurrentAddress),
                  onTap: () {
                    if (canUpdateOtherDetails! && canUpdateAddress!) {
                      context.pushNamed(
                          Routes.myProfileUpdateAddress.name,
                          extra:ServicesNavigationRequest(addressType: AddressType.current ,myProfileResponse:  myProfileResponse?.data ?? ProfileInfo()).toJson()
                      );
                    } else {
                      showFreezePeriodDialog(context);
                    }
                  },
                  isEdit: true,
                  subheading:
                      myProfileResponse?.data?.communicationAddr?.fullAddress ??
                          '')
              : const SizedBox(),
          isCustomer() ? divide() : const SizedBox(),
          MyProfileInfoWidget(
              heading: getString(lblLoginPanCard),
              onTap: () {
                if (canUpdateOtherDetails!) {
                  context.pushNamed(
                      Routes.myProfileAddPanData.name,
                      extra: ServicesNavigationRequest(myProfileResponse:  myProfileResponse?.data ?? ProfileInfo()).toJson());
                } else {
                  showFreezePeriodDialog(context);
                }
              },
              isEdit: myProfileResponse?.data?.pan != null &&
                      myProfileResponse?.data?.pan != ""
                  ? false
                  : true,
              subheading: maskString(
                  myProfileResponse?.data?.pan ?? '-', MaskingFieldType.pan)),

        ],
      ),
    );
  }

  Opacity divide() => Opacity(
      opacity: 0.5,
      child: Divider(
        color: Theme.of(context).dividerColor,
      ));

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        color: setColorBasedOnTheme(
            context: context,
            lightColor: AppColors.secondaryLight,
            darkColor: AppColors.backgroundLight5),
        onPressed: () {
          context.pop(false);
        },
      ),
      elevation: 0.0,
      title: Text(getString(lblMyProfile),
          style: Theme.of(context).textTheme.titleLarge),
    );
  }

  getInitials(String name) {
    if (name.isEmpty) {
      return name;
    }
    name = name.trim();
    List<String> words = name.split(' ');
    String firstInitial = words.first[0].toUpperCase();
    String lastInitial = words.last[0].toUpperCase();
    return firstInitial + lastInitial;
  }

  noRecordFound() {
    return Container(
        margin: EdgeInsets.only(bottom: 16.v, top: 10.v),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomImageView(
                imagePath: ImageConstant.vector,
                height: 50.adaptSize,
                width: 50.adaptSize,
                color: setColorBasedOnTheme(
                    context: context,
                    lightColor: AppColors.primaryLight,
                    darkColor: AppColors.backgroundDarkGradient6)),
            SizedBox(
              width: 15.v,
            ),
            Text(getString(NOC010))
          ],
        ));
  }

  showFreezePeriodDialog(BuildContext context) {
    if(!canUpdateAddress!)
    {
        toastForFailureMessage(context: context, msg: getString(msgSixHourFreeze));
    }
    else if(!canUpdateOtherDetails!)
    {
      toastForFailureMessage(context: context, msg: getString(msgFourHourFreeze));
    }
  }

  Widget _buildMapMyLoanWidget(){
    final Brightness brightness = Theme.of(context).brightness;
    return Visibility(visible: !isCustomer(),child: InkWell(
      onTap: () {
        context.pushNamed(Routes.profilechooseSecondFactor.name, extra: {
          "currentProfile": Profiles(
              ucic: getUCIC(),
              superAppId: getSuperAppId(),
              mobileNumber: getPhoneNumber(),
              userFullName: getUserName(),
              isCustomer: false), "profileInfo" : myProfileResponse?.data
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              8.h,
            ),
            color: AppColors.primaryLight6),child: Row(
        children: <Widget>[
          SvgPicture.asset(
            brightness == Brightness.light
                ? ImageConstant.imgNotificationActiveIconLight
                : ImageConstant.imgNotificationActiveIconDark,
          ),
          SizedBox(width: 10.h,),
          Expanded(
            flex: 2,
            child: Text(getString(lblUnableToSeeAccount), style: Theme.of(context).textTheme.titleSmall),
          ),
          SizedBox(width: 10.h,),
          Text(getString(lblUpdateNow), style: Theme.of(context).textTheme.titleSmall?.copyWith(color: AppColors.textFieldErrorColor),
          ),
        ],
      ),
      ),
    ),);
  }

  formatDate(String date) {
    if (date.isNotEmpty) {
      DateFormat inputFormat = DateFormat('dd/MM/yyyy');
      DateFormat outputFormat = DateFormat('dd MMM yyyy');
      DateTime dateTime = inputFormat.parse(date);
      return outputFormat.format(dateTime);
    } else {
      return date;
    }
  }
}
