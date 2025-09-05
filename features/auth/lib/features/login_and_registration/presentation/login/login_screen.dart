import 'package:auth/config/routes/route.dart';
import 'package:auth/features/login_and_registration/data/models/delete_profile_req.dart';
import 'package:auth/features/login_and_registration/data/models/login_request.dart';
import 'package:auth/features/login_and_registration/presentation/cubit/auth_result_cubit.dart';
import 'package:auth/features/login_and_registration/presentation/cubit/auth_state.dart';
import 'package:auth/features/login_and_registration/presentation/login/widget/select_prof_widget.dart';
import 'package:auth/features/login_and_registration/presentation/login/second_factor_argument.dart';
import 'package:auth/features/login_and_registration/presentation/login_wireframe/widgets/custom_pin_code_text_field.dart';
import 'package:auth/features/mobile_otp/presentation/cubit/phone_validate_cubit.dart';
import 'package:common/features/language_selection/data/models/app_label_request.dart';
import 'package:common/features/language_selection/presentation/cubit/select_language_cubit.dart';
import 'package:common/features/language_selection/presentation/cubit/select_language_state.dart';
import 'package:common/features/startup/data/models/validate_device_request.dart';
import 'package:common/features/startup/data/models/validate_device_response.dart';
import 'package:common/features/startup/presentation/cubit/app_launch_cubit.dart';
import 'package:common/features/startup/presentation/cubit/validate_device_cubit.dart';
import 'package:common/features/startup/presentation/cubit/validate_device_state.dart';
import 'package:core/config/error/failure.dart';
import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/config/widgets/background/mf_gradient_background.dart';
import 'package:core/config/widgets/bottom_sheet/mf_bottom_sheet_with_button.dart';
import 'package:core/config/widgets/custom_buttons/mf_custom_elevated_button.dart';
import 'package:core/config/widgets/mf_progress_bar.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:core/config/widgets/mf_toast.dart';
import 'package:core/services/di/injection_container.dart';
import 'package:core/utils/const.dart';
import 'package:core/utils/pref_utils.dart';
import 'package:core/utils/size_utils.dart';
import 'package:core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../mobile_otp/data/models/reg_status_request.dart';
import '../../../mobile_otp/data/models/send_otp_request.dart';
import '../../../mobile_otp/presentation/cubit/phone_validate_state.dart';
import '../cubit/auth_cubit.dart';
import 'package:common/config/routes/route.dart' as common;
import 'auth_enum.dart';
import 'package:sfmc/sfmc.dart';
import 'dart:io';
import 'package:help/features/utils/help_common_widget.dart';
import 'package:help/features/utils/constant_help.dart';

// ignore_for_file: must_be_immutable
class LoginScreen extends StatefulWidget {
  List<Profiles>? profiles;

  LoginScreen({super.key, required this.profiles});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _mPinController = TextEditingController();
  String? errorText;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Profiles? currentProfile;
  int currentAttempt = 0;

  @override
  void initState() {
    super.initState();
    context.read<AppLaunchCubit>().startInactivityTracker();
    if (widget.profiles != null && widget.profiles!.isNotEmpty) {
      currentProfile = _getCurrentProfile();
      _setProfileInfo();
    } else {
      BlocProvider.of<ValidateDeviceCubit>(context).validateDevice(
          validateDeviceRequest: ValidateDeviceRequest(deviceId: getDeviceId(), source: AppConst.source));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is LoginSuccessState) {
              currentAttempt++;
              if (state.response.code == AppConst.codeSuccess) {
                if (currentProfile!.isCustomer == false) {
                  if (!state.isFromDeleteProfile) {
                    var registerStatusRequest =
                        RegisterStatusRequest(mobileNumber: getPhoneNumber(), source: AppConst.source);
                    BlocProvider.of<PhoneValidateCubit>(context)
                        .getCustRegStatus(registerStatusRequest: registerStatusRequest);
                  }
                } else {
                  if (!state.isFromDeleteProfile) {
                    SFMCSdk.setContactKey(getSuperAppId());
                    BlocProvider.of<AuthCubit>(context).getPostLoginToken(
                        mobileNumber: currentProfile?.superAppId ?? "",
                        mPin: _mPinController.text,
                        isFromDeleteProfile: false);
                  }
                }
              } else if (state.response.code == AppConst.codeFailure) {
                toastForFailureMessage(
                    context: context,
                    msg: getString((currentAttempt < AppConst.maxLoginAttempt
                            ? state.response.responseCode
                            : "${state.response.responseCode}_Max") ??
                        msgSomethingWentWrong),
                    bottomPadding: 120.v);
              }
            } else if (state is LoginFailureState) {
              toastForFailureMessage(context: context, msg: getFailureMessage(state.error), bottomPadding: 40.v);
            } else if (state is LoadingState) {
              if (state.isloading) {
                showLoaderDialog(context, getString(lblLoginLoading));
              } else {
                Navigator.of(context, rootNavigator: true).pop();
              }
            } else if (state is PostLoginTokenSuccessState) {
              if (!state.isFromDeleteProfile) {
                PrefUtils.saveString(PrefUtils.keyToken, state.response.accessToken ?? "");
                if (currentProfile?.theme != null && currentProfile?.theme == AppTheme.dark.value) {
                  PrefUtils.setDarkTheme(true);
                } else {
                  PrefUtils.setDarkTheme(false);
                }
                if (getSelectedLanguage() == currentProfile?.languageCode) {
                  context.read<AuthResultCubit>().setResult(success: true);
                } else {
                  setSelectedLanguage(currentProfile?.languageCode);
                  var request = AppLabelRequest(langCode: currentProfile?.languageCode);
                  context.read<SelectLanguageCubit>().getAppLabels(request);
                }
                context.read<AppLaunchCubit>().userLoggedIn();
              }
            } else if (state is PostLoginTokenFailureState) {
              if (state.error is ServerFailure) {
                displayAlert(context, (state.error as ServerFailure).message.toString());
              } else {
                displayAlert(context, state.error.toString());
              }
            }
          },
        ),
        BlocListener<PhoneValidateCubit, MobileOtpState>(listener: (context, state) {
          if (state is SendOtpSuccess) {
            if (state.response.code == AppConst.codeSuccess) {
              currentAttempt = 0;
              _mPinController.text = "";
              context.pushNamed(Routes.mobileOtp.name);
            } else {
              toastForFailureMessage(
                  context: context,
                  msg: getString(state.response.responseCode ?? msgSomethingWentWrong),
                  bottomPadding: 40.v);
            }
          } else if (state is SendOtpFailure) {
            toastForFailureMessage(context: context, msg: getFailureMessage(state.error), bottomPadding: 40.v);
          } else if (state is ApiLoadingState) {
            if (state.isloading) {
              showLoaderDialog(context, getString(lblLoginLoading));
            } else {
              Navigator.of(context, rootNavigator: true).pop();
            }
          } else if (state is CustRegStatusSuccessState) {
            if (state.response.code == AppConst.codeSuccess) {
              PrefUtils.saveString(PrefUtils.keyMpin, _mPinController.text);
              var userStatus = getUserRegisterStatus();
              if (userStatus == UserRegStatus.pan) {
                PrefUtils.saveInt(PrefUtils.keyAuthNavFlow, AuthNavFlow.changeUserToCustomer.value);
                context.pushReplacementNamed(Routes.chooseSecondFactorAuth.name,
                    extra: {"currentProfile": currentProfile});
              } else if (userStatus == UserRegStatus.customer) {
                PrefUtils.saveInt(PrefUtils.keyAuthNavFlow, AuthNavFlow.changeUserToCustomer.value);
                SecondFactorAuthArg arg = SecondFactorAuthArg(
                    isMultipleUCIC: false, prePopulatedAuthNumber: "", headerDesc: "", currentProfile: currentProfile);
                context.pushReplacementNamed(Routes.secondfactorauth.name,
                    pathParameters: {'authType': AuthType.account.value.toString(), 'mobileNumber': getPhoneNumber()},
                    extra: arg);
              } else {
                SFMCSdk.setContactKey(currentProfile?.superAppId ?? "");
                BlocProvider.of<AuthCubit>(context).getPostLoginToken(
                    mobileNumber: currentProfile?.superAppId ?? "",
                    mPin: _mPinController.text,
                    isFromDeleteProfile: false);
              }
            } else {
              toastForFailureMessage(
                  context: context, msg: getString("${state.response.responseCode}_Auth"), bottomPadding: 40.v);
            }
          } else if (state is CustRegStatusFailureState) {
            toastForFailureMessage(context: context, msg: getFailureMessage(state.error), bottomPadding: 40.v);
          }
        }),
        BlocListener<ValidateDeviceCubit, ValidateDeviceState>(
          listener: (context, state) {
            if (state is ValidateDeviceSuccessState) {
              if (state.response.code == AppConst.codeSuccess) {
                setState(() {
                  widget.profiles = state.response.profiles;
                  currentProfile = _getCurrentProfile();
                  _setProfileInfo();
                });
              } else {
                toastForFailureMessage(
                    context: context,
                    msg: getString(state.response.responseCode ?? msgSomethingWentWrong),
                    bottomPadding: 40.v);
              }
            } else if (state is ValidateDeviceFailureState) {
              toastForFailureMessage(context: context, msg: getFailureMessage(state.error), bottomPadding: 40.v);
            }
          },
        ),
        BlocListener<SelectLanguageCubit, SelectLanguageState>(
          listener: (context, state) {
            if (state is AppLabelSuccess) {
              context.read<AuthResultCubit>().setResult(success: true);
            } else if (state is AppLabelFailure) {
              toastForFailureMessage(context: context, msg: getFailureMessage(state.error), bottomPadding: 40.v);
            } else if (state is AppLabelLoadingState) {
              if (state.isloading) {
                showLoaderDialog(context, getString(lblLoginLoading));
              } else {
                Navigator.of(context, rootNavigator: true).pop();
              }
            }
          },
        )
      ],
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          toolbarHeight: 64.h,
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          automaticallyImplyLeading: false,
          elevation: 0.0,
          actions: [
            HelpCommonWidget(
                categoryval: HelpConstantData.categoryLogin, subCategoryval: HelpConstantData.subCategoryMpin)
          ],
        ),
        body: Stack(
          children: [
            Form(
              key: _formKey,
              child: MFGradientBackground(
                  horizontalPadding: 16.h,
                  verticalPadding: 0.v,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20.v),
                      Text(
                        "${getString(lblHi)} ${currentProfile?.userFullName?.toTitleCase()}!",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 20),
                      ),
                      SizedBox(height: 20.v),
                      Text(
                        getString(lblEnter4DigitMpin),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: setColorBasedOnTheme(
                              context: context,
                              lightColor: AppColors.primaryLight,
                              darkColor: AppColors.secondaryLight5,
                            )),
                      ),
                      SizedBox(height: 10.v),
                      SizedBox(
                        width: 240.h,
                        child: BlocBuilder<AuthCubit, AuthState>(
                          buildWhen: (prev, curr) => curr is LoginSuccessState || curr is LoginFailureState,
                          builder: (context, state) {
                            return Opacity(
                                opacity: currentAttempt < AppConst.maxLoginAttempt ? 1.0 : 0.4,
                                child: CustomPinCodeTextField(
                                  length: 4,
                                  enabledTextField: currentAttempt < AppConst.maxLoginAttempt ? true : false,
                                  alignment: Alignment.topLeft,
                                  textStyle: Theme.of(context).textTheme.titleSmall,
                                  context: context,
                                  controller: _mPinController,
                                  onChanged: (value) {
                                    if (value.length == 4) {
                                      errorText = "";
                                      if (_formKey.currentState!.validate()) {
                                        FocusManager.instance.primaryFocus?.unfocus();
                                        final loginRequest = LoginRequest(
                                            mPin: _mPinController.text,
                                            superAppId: currentProfile?.superAppId,
                                            source: AppConst.source);
                                        BlocProvider.of<AuthCubit>(context)
                                            .login(loginRequest: loginRequest, isFromDeleteProfile: false);
                                      }
                                    }
                                  },
                                  validator: (value) {
                                    if (errorText != null && errorText!.isNotEmpty) {
                                      return errorText;
                                    }
                                    return null;
                                  },
                                ));
                          },
                        ),
                      ),
                      SizedBox(height: 25.v),
                      Visibility(
                        visible: (widget.profiles!.length == 1 &&
                            PrefUtils.getBool(PrefUtils.keyEnableBioMetric, false) &&
                            PrefUtils.getBool(PrefUtils.keyActiveBioMetric, false)),
                        child: biometricWidget(),
                      ),
                      Expanded(child: SizedBox(height: 26.v)),
                      SizedBox(
                        width: 328.h,
                        height: 42.v,
                        child: ElevatedButton(
                          onPressed: () {
                            PrefUtils.saveInt(PrefUtils.keyAuthNavFlow, AuthNavFlow.forgotMpin.value);
                            SendOtpRequest sendOtpRequest = SendOtpRequest(
                                mobileNumber: getPhoneNumber(),
                                source: AppConst.source,
                                journey: AppConst.forgotPassJourney,
                                tncFlag: 1,
                                otpResend: false,
                                superAppId: currentProfile?.superAppId);
                            BlocProvider.of<PhoneValidateCubit>(context).sendOtp(sendOtpRequest, isFromResend: false);
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                            shadowColor: MaterialStateProperty.all<Color>(Colors.transparent),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                side: BorderSide(
                                  color: setColorBasedOnTheme(
                                    context: context,
                                    lightColor: AppColors.secondaryLight,
                                    darkColor: AppColors.secondaryLight5,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          child: Text(getString(lblForgotMpin),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: setColorBasedOnTheme(
                                    context: context,
                                    lightColor: AppColors.secondaryLight,
                                    darkColor: AppColors.secondaryLight5,
                                  ))),
                        ),
                      ),
                      SizedBox(height: 24.v),
                      Center(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Visibility(
                            visible: widget.profiles!.length < AppConst.maxProfileSupport,
                            child: TextButton(
                                child: Text(
                                  getString(lblAddAnotherProfile),
                                  style: setStyleTheme(context: context),
                                ),
                                onPressed: () {
                                  _mPinController.text = "";
                                  showMFFormBottomSheetWithButton(context,
                                      title: getString(lblAddingProfileTitle),
                                      message: getString(lblAddingProfileDecs),
                                      leftBtnLbl: getString(lblBack),
                                      rightBtnLbl: getString(lblLoginContinue), leftBtnOnPressed: () {
                                    Navigator.pop(context);
                                  }, rightBtnOnPressed: () {
                                    Navigator.pop(context);
                                    context.goNamed(common.Routes.languageSelection.name);
                                  });
                                }),
                          ),
                          Visibility(
                              visible:
                                  (widget.profiles!.length < AppConst.maxProfileSupport && widget.profiles!.length > 1),
                              child: Text(
                                " | ",
                                style: setStyleTheme(context: context),
                              )),
                          Visibility(
                              visible: widget.profiles!.length > 1,
                              child: BlocBuilder<AuthCubit, AuthState>(
                                builder: (context, state) {
                                  return TextButton(
                                      child: Text(
                                        getString(lblSwitchProfile),
                                        style: setStyleTheme(context: context),
                                      ),
                                      onPressed: () async {
                                        _mPinController.text = "";
                                        bool? needRefresh = await _showBottomUp(context);
                                        if (needRefresh == true) {
                                          setState(() {});
                                        }
                                      });
                                },
                              )),
                        ],
                      )),
                      SizedBox(height: 24.v),
                      Padding(padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom))
                    ],
                  )),
            ),
            BlocBuilder<ValidateDeviceCubit, ValidateDeviceState>(
              buildWhen: (context, state) => state is LoadingDialogState,
              builder: (context, state) {
                if (state is LoadingDialogState) {
                  return Visibility(
                      visible: state.isValidateDeviceLoading,
                      child: MFGradientBackground(
                        horizontalPadding: 16.h,
                        verticalPadding: 1.v,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ));
                } else {
                  return Container();
                }
              },
            )
          ],
        ),
      ),
    );
  }

  Widget biometricWidget() {
    return BlocConsumer<AuthCubit, AuthState>(
      buildWhen: (context, state) {
        return state is BiometricLoginState;
      },
      listener: (context, state) {
        if (state is BiometricLoginState) {
          if (state.isBiometricLoginSuccess) {
            context.goNamed(Routes.home.name);
          } else {
            if ((state).remainingAttempt != 0) {
              toastForFailureMessage(
                  context: context,
                  msg: "${state.remainingAttempt} ${getString(attemptsRemainig)}",
                  bottomPadding: 120.v);
            } else {
              toastForFailureMessage(context: context, msg: getString(msgTooManyAttempt), bottomPadding: 120.v);
            }
          }
        }
      },
      builder: (context, state) {
        return Column(
          children: [
            if ((state as BiometricLoginState).remainingAttempt != 0) ...{
              GestureDetector(
                onTap: () {
                  BlocProvider.of<AuthCubit>(context).loginWithBiometric((state).remainingAttempt);
                },
                child: RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.bodySmall,
                    children: [
                      TextSpan(
                        text: getString(lblLoginUseYour),
                      ),
                      TextSpan(
                          text: getString(lblLoginFaceId),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: setColorBasedOnTheme(
                                context: context,
                                lightColor: AppColors.secondaryLight,
                                darkColor: AppColors.secondaryLight5,
                              ))),
                      TextSpan(
                        text: Platform.isAndroid ? getString(lblLoginOr) : "",
                      ),
                      TextSpan(
                          text: Platform.isAndroid ? getString(lblLoginFingerPrint) : "",
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: setColorBasedOnTheme(
                                context: context,
                                lightColor: AppColors.secondaryLight,
                                darkColor: AppColors.secondaryLight5,
                              ))),
                      TextSpan(
                        text: getString(lblLoginToLogin),
                      ),
                    ],
                  ),
                ),
              ),
            },
          ],
        );
      },
    );
  }

  _showBottomUp(BuildContext context) async {
    bool isSwitchProfile = true;
    int selectedProfile = widget.profiles?.indexWhere((element) => element.superAppId == getSuperAppId()) ?? 0;
    return showModalBottomSheet<bool>(
      isScrollControlled: true,
      context: context,
      isDismissible: false,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (BuildContext context, StateSetter mSetState /*You can rename this!*/) {
          return SizedBox(
              height: 300.h,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 18.0, right: 18.0, top: 18.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          isSwitchProfile ? getString(lblSwitchProfile) : getString(lblManageProfile),
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        GestureDetector(
                          onTap: () {
                            if (isSwitchProfile) {
                              isSwitchProfile = false;
                              mSetState(() {});
                            } else {
                              showMFFormBottomSheetWithButton(context,
                                  title: getString(lblAddingProfileTitle),
                                  message: getString(lblAddingProfileDecs),
                                  leftBtnLbl: getString(lblBack),
                                  rightBtnLbl: getString(lblLoginContinue), leftBtnOnPressed: () {
                                Navigator.pop(context);
                              }, rightBtnOnPressed: () {
                                Navigator.pop(context);
                                context.goNamed(common.Routes.languageSelection.name);
                              });
                            }
                          },
                          child: Text(
                            isSwitchProfile
                                ? getString(lblManageProfile)
                                : widget.profiles!.length < AppConst.maxProfileSupport
                                    ? getString(lblAddProfile)
                                    : "",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: Theme.of(context).highlightColor),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.2,
                      child: ListView.builder(
                          itemCount: widget.profiles?.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) => FDSelectTile(
                              isSelected: (index == selectedProfile) ? true : false,
                              title: widget.profiles?.elementAt(index).userFullName,
                              onTap: () {
                                selectedProfile = index;
                                mSetState(() {});
                              })),
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(left: 6.0, right: 6.0, bottom: 10.0),
                    child: Center(
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: MfCustomButton(
                                  outlineBorderButton: true,
                                  isDisabled: false,
                                  onPressed: () {
                                    context.pop(true);
                                  },
                                  width: 180,
                                  text: getString(lblBack)),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: BlocProvider(
                                create: (context) => di<SelectLanguageCubit>(),
                                child: BlocConsumer<SelectLanguageCubit, SelectLanguageState>(
                                  listener: (context, state) {
                                    if (state is AppLabelLoadingState) {
                                      if (state.isloading) {
                                        showLoaderDialog(context, getString(lblLoginLoading));
                                      } else {
                                        Navigator.of(context, rootNavigator: true).pop();
                                      }
                                    } else if (state is AppLabelSuccess) {
                                      Navigator.pop(context);
                                      currentProfile = widget.profiles?[selectedProfile];
                                      if (currentProfile?.mpinExists == true) {
                                        _setProfileInfo();
                                        setState(() {});
                                      } else {
                                        setSuperAppId(currentProfile?.superAppId ?? "");
                                        context.pushNamed(Routes.mpin.name, extra: Profiles());
                                      }
                                    }
                                  },
                                  builder: (context, state) {
                                    return MfCustomButton(
                                        outlineBorderButton: false,
                                        isDisabled: false,
                                        onPressed: () async {
                                          if (isSwitchProfile) {
                                            if (widget.profiles?[selectedProfile].languageCode != getSelectedLanguage()) {
                                              setSelectedLanguage(widget.profiles?[selectedProfile].languageCode);
                                              context.read<SelectLanguageCubit>().getAppLabels(
                                                  AppLabelRequest(
                                                      langCode: widget.profiles?[selectedProfile].languageCode),
                                                  widget.profiles);
                                            } else {
                                              Navigator.pop(context);
                                              currentProfile = widget.profiles?[selectedProfile];
                                              if (currentProfile?.mpinExists == true) {
                                                _setProfileInfo();
                                                setState(() {});
                                              } else {
                                                setSuperAppId(currentProfile?.superAppId ?? "");
                                                context.pushNamed(Routes.mpin.name, extra: Profiles());
                                              }
                                            }
                                          } else {
                                            var profile = widget.profiles![selectedProfile];
                                            if (currentProfile?.superAppId != profile.superAppId) {
                                              bool refreshProfile = await _showBottomUpForMPin(profile: profile);
                                              if (refreshProfile) {
                                                widget.profiles?.remove(profile);
                                                mSetState(() {});
                                              }
                                            } else {
                                              toastForFailureMessage(
                                                  context: context, msg: getString(msgErrorRemoveProfile));
                                            }
                                          }
                                        },
                                        width: 180,
                                        text: isSwitchProfile ? getString(lblLoginContinue) : getString(lblRemove));
                                  },
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ));
        });
      },
    );
  }

  _showBottomUpForMPin({required Profiles profile}) async {
    int currentAttempt = 0;
    ValueNotifier<bool> isValidated = ValueNotifier<bool>(false);
    final TextEditingController mPinBottomController = TextEditingController();
    return showModalBottomSheet<bool>(
      isScrollControlled: true,
      context: context,
      isDismissible: false,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      builder: (innerContext) => BlocProvider.value(
        value: context.read<AuthCubit>(),
        child: SizedBox(
            height: 300.v,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 18.0, right: 18.0, top: 18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profile.userFullName! + getString(lblUserMpin),
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      SizedBox(
                        height: 5.v,
                      ),
                      Text(
                        getString(lblRemoveMPin).replaceAll("#&#", profile.userFullName.toString()),
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      SizedBox(
                        height: 10.v,
                      ),
                      Text(
                        getString(lblenterMPin),
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      SizedBox(
                        height: 15.v,
                      ),
                      Opacity(
                          opacity: currentAttempt < AppConst.maxLoginAttempt ? 1.0 : 0.4,
                          child: CustomPinCodeTextField(
                            length: 4,
                            enabledTextField: currentAttempt < AppConst.maxLoginAttempt ? true : false,
                            alignment: Alignment.topLeft,
                            textStyle: Theme.of(context).textTheme.titleSmall,
                            context: context,
                            controller: mPinBottomController,
                            onChanged: (value) {
                              if (value.length == 4) {
                                isValidated.value = true;
                              } else {
                                isValidated.value = false;
                              }
                            },
                            validator: (value) {
                              return null;
                            },
                          ))
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 18.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      MfCustomButton(
                          outlineBorderButton: true,
                          isDisabled: false,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          width: 180,
                          text: getString(lblBack)),
                      const SizedBox(
                        width: 10,
                      ),
                      BlocListener<AuthCubit, AuthState>(
                          listener: (context, state) {
                            if (state is LoginSuccessState) {
                              currentAttempt++;
                              if (state.response.code == AppConst.codeSuccess) {
                                if (state.isFromDeleteProfile) {
                                  BlocProvider.of<AuthCubit>(context).getPostLoginToken(
                                      mobileNumber: profile.superAppId ?? "",
                                      mPin: mPinBottomController.text,
                                      isFromDeleteProfile: state.isFromDeleteProfile);
                                }
                              } else if (state.response.code == AppConst.codeFailure) {
                                toastForFailureMessage(
                                    context: context,
                                    msg: getString((currentAttempt < AppConst.maxLoginAttempt
                                            ? state.response.responseCode
                                            : "${state.response.responseCode}_Max") ??
                                        msgSomethingWentWrong),
                                    bottomPadding: 120.v);
                              }
                            } else if (state is LoginFailureState) {
                              toastForFailureMessage(
                                  context: context, msg: getFailureMessage(state.error), bottomPadding: 40.v);
                            } else if (state is LoadingState) {
                              if (state.isloading) {
                                showLoaderDialog(context, getString(lblLoginLoading));
                              } else {
                                Navigator.of(context, rootNavigator: true).pop();
                              }
                            } else if (state is DeleteProfileSuccessState) {
                              if (state.resp.code == AppConst.codeSuccess) {
                                context.pop(true);
                                toastForSuccessMessage(
                                    context: context, msg: getString(state.resp.responseCode), bottomPadding: 40.v);
                              } else {
                                toastForFailureMessage(
                                    context: context, msg: getString(state.resp.responseCode), bottomPadding: 40.v);
                              }
                            } else if (state is DeleteProfileFailureState) {
                              toastForFailureMessage(
                                  context: context, msg: getFailureMessage(state.error), bottomPadding: 40.v);
                            } else if (state is PostLoginTokenSuccessState) {
                              if (state.isFromDeleteProfile) {
                                PrefUtils.saveString(PrefUtils.keyToken, state.response.accessToken ?? "");
                                final deleteProfileRequest =
                                    DeleteProfileReq(superAppId: profile.superAppId ?? "", source: AppConst.source);
                                BlocProvider.of<AuthCubit>(context).deleteProfile(deleteProfileRequest);
                              }
                            } else if (state is PostLoginTokenFailureState) {
                              if (state.error is ServerFailure) {
                                displayAlert(context, (state.error as ServerFailure).message.toString());
                              } else {
                                displayAlert(context, state.error.toString());
                              }
                            }
                          },
                          child: ValueListenableBuilder(
                              valueListenable: isValidated,
                              builder: (context, bool isValid, child) {
                                return MfCustomButton(
                                    outlineBorderButton: false,
                                    isDisabled: !isValid,
                                    onPressed: () {
                                      FocusManager.instance.primaryFocus?.unfocus();
                                      final loginRequest = LoginRequest(
                                          mPin: mPinBottomController.text,
                                          superAppId: profile.superAppId,
                                          source: AppConst.source);
                                      BlocProvider.of<AuthCubit>(context)
                                          .login(loginRequest: loginRequest, isFromDeleteProfile: true);
                                    },
                                    width: 180,
                                    text: getString(lblConfirm));
                              })),
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  Profiles? _getCurrentProfile() {
    for (var profile in widget.profiles!) {
      if (profile.superAppId == getSuperAppId()) {
        return profile;
      }
    }
    return widget.profiles?[0];
  }

  void _setProfileInfo() {
    setUCIC(currentProfile?.ucic ?? "");
    if (currentProfile?.theme != null && currentProfile?.theme == AppTheme.dark.value) {
      PrefUtils.setDarkTheme(true);
    } else {
      PrefUtils.setDarkTheme(false);
    }
    PrefUtils.saveBool(PrefUtils.keyIsCustomer, currentProfile?.isCustomer ?? false);
    PrefUtils.saveString(PrefUtils.keySuperAppId, currentProfile?.superAppId ?? "");
    PrefUtils.saveString(PrefUtils.keyUserName, currentProfile?.userFullName ?? "");
    PrefUtils.saveString(PrefUtils.keyPhoneNumber, currentProfile?.mobileNumber ?? "");
  }
}
