import 'dart:io';
import 'package:auth/config/routes/route.dart';
import 'package:auth/features/login_and_registration/presentation/login/second_factor_argument.dart';
import 'package:auth/features/mobile_otp/data/models/reg_status_request.dart';
import 'package:auth/features/mobile_otp/data/models/save_device_request.dart';
import 'package:auth/features/mobile_otp/data/models/validate_multiple_device_request.dart';
import 'package:common/features/startup/data/models/validate_device_response.dart';
import 'package:core/config/flavor/feature_flag/feature_flag.dart';
import 'package:core/config/flavor/feature_flag/feature_flag_keys.dart';
import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/resources/custom_outline_button.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/config/widgets/background/mf_gradient_background.dart';
import 'package:core/config/widgets/mf_custom_elevated_button.dart';
import 'package:core/config/widgets/mf_progress_bar.dart';
import 'package:auth/features/login_and_registration/presentation/login_wireframe/widgets/custom_elevated_button.dart';
import 'package:auth/features/login_and_registration/presentation/login_wireframe/widgets/custom_pin_code_text_field.dart';
import 'package:auth/features/mobile_otp/data/models/validate_otp_request.dart';
import 'package:auth/features/mobile_otp/presentation/cubit/phone_validate_cubit.dart';
import 'package:auth/features/mobile_otp/data/models/send_otp_request.dart';
import 'package:auth/features/mobile_otp/presentation/cubit/phone_validate_state.dart';
import 'package:core/config/error/failure.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:core/config/widgets/mf_toast.dart';
import 'package:core/utils/helper/theme_helper.dart';
import 'package:core/utils/pref_utils.dart';
import 'package:core/utils/size_utils.dart';
import 'package:core/utils/utils.dart';
import 'package:core/utils/validation_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';
import 'package:mobile_number/mobile_number.dart';
import '../../login_and_registration/presentation/login/auth_enum.dart';
import '../../login_and_registration/presentation/login_wireframe/widgets/custom_floating_text_field.dart';
import 'package:core/utils/const.dart';
import 'package:common/config/routes/route.dart' as common_route;
import 'package:auth/config/routes/route.dart' as auth;
import 'package:help/features/utils/constant_help.dart';
import 'package:help/features/utils/help_common_widget.dart';

class ValidatePhoneScreen extends StatefulWidget {
  @override
  createState() => ValidatePhoneScreenState();

  const ValidatePhoneScreen({super.key});
}

class ValidatePhoneScreenState extends State<ValidatePhoneScreen>
    with CodeAutoFill {
  final TextEditingController _mobileNumberController = TextEditingController();
  TextEditingController _otpController = TextEditingController();
  final CountdownController _timerForResentOtp =
      CountdownController(autoStart: true);
  bool? enableWACheckbox = false;
  bool? _enableTNCCheckbox = false;
  bool? _enableGetOtpBtn = false;
  bool? _enableVerifyOtpBtn = false;
  bool? _showResendOtpBtn = false;
  bool? _showIvrOtpBtn = false;
  bool? _showOtpTimer = true;
  bool? _showOtpError = false;
  String? _errorMessage = "";
  bool? _showPhoneValidateView = true;
  String _mobileNumber = '';
  List<SimCard> simCard = <SimCard>[];
  final GlobalKey<FormState> _formPhoneKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formOTpKey = GlobalKey<FormState>();
  late BuildContext _blocContext;
  int currentResendOtpAttempt = 0;
  int currentValidateOtpAttempt = 0;

  @override
  void initState() {
    super.initState();
    listenForCode();
    enableWACheckbox = PrefUtils.getBool(PrefUtils.keyWAConsent, false);
    // _enableTNCCheckbox = _enableGetOtpBtn =
    //     PrefUtils.getBool(PrefUtils.keyTermsCondition, false);
    if (PrefUtils.getInt(
            PrefUtils.keyAuthNavFlow, AuthNavFlow.register.value) ==
        AuthNavFlow.forgotMpin.value) {
      _showPhoneValidateView = false;
      BlocProvider.of<PhoneValidateCubit>(context).showOtpView();
    } else {
      getPermissionsForSimCardDetails();
    }
    MobileNumber.listenPhonePermission((isPermissionGranted) {
      if (isPermissionGranted) {
        getPermissionsForSimCardDetails();
      }
    });
  }

  Future<void> getPermissionsForSimCardDetails() async {
    if (Platform.isIOS) {
      return;
    }
    if (!await MobileNumber.hasPhonePermission) {
      await MobileNumber.requestPhonePermission;
      return;
    } else {
      try {
        _mobileNumber = (await MobileNumber.mobileNumber)!;
        simCard = (await MobileNumber.getSimCards)!;

        if (simCard.isNotEmpty) {
          setDefaultPhoneNumber();
          showSimCardPopUp();
        }
      } on PlatformException catch (e) {
        debugPrint("Failed to get mobile number because of '${e.message}'");
      }
    }
  }

  setDefaultPhoneNumber() {
    _mobileNumber = simCard[0].number!;
    context.read<PhoneValidateCubit>().setMobileNumber(_mobileNumber);
    PrefUtils.saveString(PrefUtils.keyPhoneNumber, _mobileNumber);
  }

  showSimCardPopUp() {
    _simCardPopUp(context);
  }

  @override
  Widget build(BuildContext context) {
    _blocContext = context;
    return SafeArea(
        child: Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(64.h),
          child: BlocBuilder<PhoneValidateCubit, MobileOtpState>(
            buildWhen: (context, state) {
              return state is MobileOtpInitState;
            },
            builder: (context, state) {
              return AppBar(
                leading: IconButton(
                    icon: Icon(Icons.arrow_back,
                        color: Theme.of(context).highlightColor),
                    onPressed: () {
                      if (PrefUtils.getInt(PrefUtils.keyAuthNavFlow, AuthNavFlow.register.value) ==
                          AuthNavFlow.forgotMpin.value) {
                        context.pop();
                      } else {
                        if (_showPhoneValidateView == false) {
                          _showOtpError = false;
                          _mobileNumberController.text = "";
                          _otpController.text = "";
                          getPermissionsForSimCardDetails();
                          BlocProvider.of<PhoneValidateCubit>(context).resetPhoneNumber();
                        } else {
                          WidgetsBinding.instance.addPostFrameCallback((_) => exit(0));
                        }
                      }
                    }),
                toolbarHeight: 64.h,
                backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
                actions: [HelpCommonWidget(categoryval: HelpConstantData.categoryLogin,subCategoryval: HelpConstantData.subCategoryLanguageSelection),],
              );
            },
          )),
      body: MFGradientBackground(

        child: SizedBox(
          width: SizeUtils.width,
          child: BlocConsumer<PhoneValidateCubit, MobileOtpState>(
              listener: (context, state) {
            try {
              if (state is MobileOtpInitState) {
                _showPhoneValidateView = state.showPhoneView;
                _enableGetOtpBtn = state.enableButton;
                _enableTNCCheckbox = state.isUserConsent;
                if (!_showPhoneValidateView!) {
                  _otpController = TextEditingController();
                }
              } else if (state is WAConsentState) {
                enableWACheckbox = state.isWAConsent;
              } else if (state is ResendOtpState) {
                _showIvrOtpBtn = state.showIvrOtp;
                FocusManager.instance.primaryFocus?.unfocus();
                if (_showIvrOtpBtn ?? false) {
                  customShowToast(
                      containerColor: Colors.white,
                      msg: getString(msgOtpMpinError),
                      icon: Icons.info,
                      iconColor: Colors.red,
                      bottomPadding: 110);
                }
                _showResendOtpBtn = state.showResendOtp;
                _showOtpTimer = state.showTimer;
                if (state.showTimer) {
                  _timerForResentOtp.start();
                }
              } else if (state is CustRegStatusSuccessState) {
                if (state.response.code == AppConst.codeSuccess) {
                  var userStatus = getUserRegisterStatus();
                  if (userStatus == UserRegStatus.newUser) {
                    if (PrefUtils.getInt(PrefUtils.keyAuthNavFlow,
                            AuthNavFlow.register.value) ==
                        AuthNavFlow.forgotMpin.value) {
                      context.pushNamed(Routes.mpin.name, extra: Profiles());
                    } else {
                      ValidateMultiPleDeviceRequest
                          validateMultiPleDeviceRequest =
                          ValidateMultiPleDeviceRequest(
                              deviceId: getDeviceId(),
                              mobileNumber: getPhoneNumber(),
                              source: AppConst.source);
                      BlocProvider.of<PhoneValidateCubit>(context)
                          .validateMultipleDevice(
                              validateMultiPleDeviceRequest:
                                  validateMultiPleDeviceRequest);
                    }
                  } else if (userStatus == UserRegStatus.pan) {
                    if (PrefUtils.getInt(PrefUtils.keyAuthNavFlow,
                            AuthNavFlow.register.value) ==
                        AuthNavFlow.register.value) {
                      context.goNamed(Routes.chooseSecondFactorAuth.name,
                          extra: {"currentProfile": Profiles()});
                    } else {
                      context.pushReplacementNamed(
                          Routes.chooseSecondFactorAuth.name,
                          extra: {"currentProfile": Profiles()});
                    }
                  } else if (userStatus == UserRegStatus.customer) {
                    SecondFactorAuthArg arg = SecondFactorAuthArg(
                        isMultipleUCIC: false,
                        prePopulatedAuthNumber: "",
                        headerDesc: "",
                        currentProfile: Profiles());
                    if (PrefUtils.getInt(PrefUtils.keyAuthNavFlow,
                            AuthNavFlow.register.value) ==
                        AuthNavFlow.register.value) {
                      context.goNamed(Routes.secondfactorauth.name,
                          pathParameters: {
                            'authType': AuthType.account.value.toString(),
                            'mobileNumber': getDeviceId()
                          },
                          extra: arg);
                    } else {
                      context.pushReplacementNamed(Routes.secondfactorauth.name,
                          pathParameters: {
                            'authType': AuthType.account.value.toString(),
                            'mobileNumber': getDeviceId()
                          },
                          extra: arg);
                    }
                  }
                  // }
                } else {
                  displayAlertSingleAction(context, getString("${state.response.responseCode}_Auth"),
                      btnLbl: getString(lblLoginRetry), btnTap: () {
                    RegisterStatusRequest registerStatusRequest =
                        RegisterStatusRequest(mobileNumber: getPhoneNumber(), source: AppConst.source);
                    BlocProvider.of<PhoneValidateCubit>(context)
                        .getCustRegStatus(registerStatusRequest: registerStatusRequest);
                  });
                }
              }
              // else if (state is UpdateDeviceLangSuccess) {
              //   if (state.response.code == AppConst.codeSuccess) {
              //     RegisterStatusRequest registerStatusRequest =
              //         RegisterStatusRequest(
              //             mobileNumber: getPhoneNumber(),
              //             source: AppConst.source);
              //     BlocProvider.of<PhoneValidateCubit>(context).getCustRegStatus(
              //         registerStatusRequest: registerStatusRequest);
              //   } else {
              //     displayAlertSingleAction(context, state.response.message ?? "", btnLbl: getString(lblRetry),
              //         btnTap: () {
              //       UpdateUserLangRequest request = UpdateUserLangRequest(
              //           deviceId: getDeviceId(),
              //           languageCode: PrefUtils.getString(PrefUtils.keySelectedLanguage, AppConst.defaultAppLang));
              //       BlocProvider.of<PhoneValidateCubit>(context).updateUserLanguage(request);
              //     });
              //   }
              // } else if (state is UpdateDeviceLangFailure) {
              //   displayAlertSingleAction(context, getFailureMessage(state.error), btnLbl: getString(lblRetry),
              //       btnTap: () {
              //     UpdateUserLangRequest request = UpdateUserLangRequest(
              //         deviceId: getDeviceId(),
              //         languageCode: PrefUtils.getString(PrefUtils.keySelectedLanguage, AppConst.defaultAppLang));
              //     BlocProvider.of<PhoneValidateCubit>(context).updateUserLanguage(request);
              //   });
              // }
              else if (state is SendOtpFailure) {
                _showOtpError = false;
                toastForFailureMessage(
                    context: context,
                    msg: getFailureMessage(state.error),
                    bottomPadding: 40.v);
              } else if (state is CustRegStatusFailureState) {
                _showOtpError = false;
                displayAlertSingleAction(context, getFailureMessage(state.error), btnLbl: getString(lblLoginRetry),
                    btnTap: () {
                  RegisterStatusRequest registerStatusRequest =
                      RegisterStatusRequest(mobileNumber: getPhoneNumber(), source: AppConst.source);
                  BlocProvider.of<PhoneValidateCubit>(context)
                      .getCustRegStatus(registerStatusRequest: registerStatusRequest);
                });
              } else if (state is SendOtpSuccess) {
                if (state.response.code == AppConst.codeFailure) {
                  toastForFailureMessage(
                      context: context,
                      msg: getString("${state.response.responseCode}_Auth"),
                      bottomPadding: 40.v);
                }
              } else if (state is ValidateOtpFailure) {
                _errorMessage =
                    (state.error as ServerFailure).message.toString();
                toastForFailureMessage(
                    context: context,
                    msg: getFailureMessage(state.error),
                    bottomPadding: 40.v);
              } else if (state is ValidateOtpSuccess) {
                if (state.response.code == AppConst.codeSuccess) {
                  if (_mobileNumberController.text.isNotEmpty) {
                    PrefUtils.saveString(
                        PrefUtils.keyPhoneNumber, _mobileNumberController.text);
                  }
                  RegisterStatusRequest registerStatusRequest =
                      RegisterStatusRequest(
                          mobileNumber: getPhoneNumber(),
                          source: AppConst.source);
                  BlocProvider.of<PhoneValidateCubit>(context).getCustRegStatus(
                      registerStatusRequest: registerStatusRequest);
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                } else {
                  currentValidateOtpAttempt++;
                  context.read<PhoneValidateCubit>().enableVerifyButton(false);
                    if (currentValidateOtpAttempt < AppConst.maxValidateOtpCount) {
                      _showOtpError = true;
                      _errorMessage =
                          getString("${state.response.responseCode}");
                    } else {
                    displayAlertSingleAction(context,
                        getString(msgMaxOtpValidateError),
                        btnLbl: getString(lblLoginOk), btnTap: () {
                      _showOtpError = false;
                      _mobileNumberController.text = "";
                      _otpController.text = "";
                      getPermissionsForSimCardDetails();
                      BlocProvider.of<PhoneValidateCubit>(context)
                          .resetPhoneNumber();
                    });
                  }
                }
              } else if (state is ApiLoadingState) {
                if (state.isloading) {
                  showLoaderDialog(context, getString(lblLoginLoading));
                } else {
                  Navigator.of(context, rootNavigator: true).pop();
                }
              } else if (state is ValidateMultipleDeviceSuccessState) {
                if (state.response.code == AppConst.codeSuccess) {
                  if (state.response.otherDeviceExists!) {
                    _showPrevDevicePopUp(
                        context, state.response.superAppId ?? "");
                  } else {
                    context.goNamed(common_route.Routes.privacyPolicy.name);
                  }
                } else {
                  displayAlertSingleAction(context, getString(state.response.responseCode ?? lblLoginErrorGeneric),
                      btnLbl: getString(lblLoginRetry), btnTap: () {

                    ValidateMultiPleDeviceRequest validateMultiPleDeviceRequest = ValidateMultiPleDeviceRequest(
                        deviceId: getDeviceId(), mobileNumber: getPhoneNumber(), source: AppConst.source);
                    BlocProvider.of<PhoneValidateCubit>(context)
                        .validateMultipleDevice(validateMultiPleDeviceRequest: validateMultiPleDeviceRequest);
                  });
                }
              } else if (state is ValidateMultipleDeviceFailureState) {
                displayAlertSingleAction(context, getFailureMessage(state.error), btnLbl: getString(lblLoginRetry),
                    btnTap: () {
                  ValidateMultiPleDeviceRequest validateMultiPleDeviceRequest = ValidateMultiPleDeviceRequest(
                      deviceId: getDeviceId(), mobileNumber: getPhoneNumber(), source: AppConst.source);
                  BlocProvider.of<PhoneValidateCubit>(context)
                      .validateMultipleDevice(validateMultiPleDeviceRequest: validateMultiPleDeviceRequest);
                });
              } else if (state is SaveDeviceSuccessState) {
                if (state.response.code == AppConst.codeSuccess) {
                  setSuperAppId(state.superAppId);
                  Navigator.pop(context);
                  context.goNamed(Routes.mpin.name, extra: Profiles());
                } else {
                  toastForFailureMessage(
                      context: context,
                      msg: state.response.message ?? "",
                      bottomPadding: 40.v);
                }
              } else if (state is SaveDeviceFailureState) {
                toastForFailureMessage(
                    context: context,
                    msg: getFailureMessage(state.error),
                    bottomPadding: 40.v);
              }
            } catch (e) {
              toastForFailureMessage(
                  context: context,
                  msg: getString(lblLoginErrorGeneric),
                  bottomPadding: 40.v);
            }
          }, buildWhen: (context, state) {
            return state is MobileOtpInitState || state is WAConsentState;
          }, builder: (context, state) {
            return Stack(
              children: [
                Visibility(
                    visible: _showPhoneValidateView!,
                    child: _buildPhoneValidate(context)),
                Visibility(
                    visible: !_showPhoneValidateView!,
                    child: _buildValidateOtp(context)),
              ],
            );
          }),
        ),
      ),
    ));
  }

  @override
  void dispose() {
    super.dispose();
    cancel();
  }

  Future _simCardPopUp(BuildContext context) {
    final Brightness brightness = Theme.of(context).brightness;
    return showModalBottomSheet(
      backgroundColor: Theme.of(context).cardColor,
      context: context,
      elevation: 0,
      isDismissible: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.0)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              margin: const EdgeInsets.only(top: 14, left: 12.0, right: 12.0),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        getString(msgSelectNumberRegister),
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      for (int i = 0; i < simCard.length; i++)
                        contactSelectContainer(
                            simCard[i], i, setState, brightness),
                      const SizedBox(
                        height: 12,
                      ),
                      bottomPopUpButtons(context, brightness),
                      SizedBox(
                        height: 12.v,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget bottomPopUpButtons(BuildContext context, brightness) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: CustomOutlinedButton(
            height: 48.v,
            text: getString(lblBack),
            margin: EdgeInsets.only(right: 5.h),
            buttonStyle: OutlinedButton.styleFrom(
              side: BorderSide(
                color: setColorBasedOnTheme(
                  context: context,
                  lightColor: AppColors.secondaryLight,
                  darkColor: AppColors.secondaryLight5,
                ),
                width: 1,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.h),
              ),
            ),
            buttonTextStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: setColorBasedOnTheme(
                  context: context,
                  lightColor: AppColors.secondaryLight,
                  darkColor: AppColors.secondaryLight5,
                )),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        Expanded(
          child: CustomElevatedButton(
            height: 48.v,
            text: getString(lblLoginProceed),
            margin: EdgeInsets.only(left: 5.h),
            buttonStyle: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).highlightColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.h),
              ),
            ),
            onPressed: () {
              if (_mobileNumber.isNotEmpty) {
                _mobileNumberController.text = formatPhoneNumber(_mobileNumber);
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(getString(msgSelectNumber))));
              }
            },
          ),
        ),
      ],
    );
  }

  Widget contactSelectContainer(SimCard simCard, index, setState, brightness) {
    return Container(
      height: 62.v,
      margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
      decoration: BoxDecoration(
          border: brightness == Brightness.light
              ? Border.all(
                  color: _mobileNumber == simCard.number
                      ? AppColors.borderLight
                      : AppColors.primaryLight6,
                  width: 1)
              : Border.all(
                  color: _mobileNumber == simCard.number
                      ? AppColors.borderSelectedDark
                      : AppColors.shadowDark,
                  width: 1),
          borderRadius: const BorderRadius.all(Radius.circular(8))),
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
              formatMobileNumber(
                simCard.number.toString(),
              ),
              style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(
            width: 10,
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _mobileNumber = simCard.number!;
              });
            },
            child: _mobileNumber == simCard.number
                ? Icon(
                    Icons.check_circle_outline,
                    color: Theme.of(context).primaryColor,
                  )
                : null,
          ),
        ],
      ),
    );
  }

  String formatMobileNumber(String contactNumber) {
    String number = "";
    number =
        "${contactNumber.substring(0, 3)}-${contactNumber.substring(3, 8)}-${contactNumber.substring(8, contactNumber.length)}";
    return number;
  }

  Widget _buildPhoneValidate(BuildContext context) {
    return Form(
      key: _formPhoneKey,
      child: Container(
        width: double.maxFinite,
        padding: EdgeInsets.symmetric(
          horizontal: 1.h,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              getString(msgStartRegistration),
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontSize: 20),
            ),
            SizedBox(height: 10.v),
            _buildMobileNumber(context),
            SizedBox(height: 20.v),
            Expanded(child: _buildUserConsent(context)),
            Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom))
          ],
        ),
      ),
    );
  }

  Widget _buildValidateOtp(BuildContext context) {
    return Form(
      key: _formOTpKey,
      child: Container(
        width: double.maxFinite,
        padding: EdgeInsets.symmetric(
          horizontal: 1.h,
          vertical: 1.v,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10.v),
            Text(
              getString(lblLoginEnterOtp),
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontSize: 20),
            ),
            SizedBox(height: 10.v),
            Text(
              getString(lblLoginEnterSixDigitOtp) +
                  (PrefUtils.getInt(PrefUtils.keyAuthNavFlow,
                              AuthNavFlow.register.value) ==
                          AuthNavFlow.forgotMpin.value
                      ? getPhoneNumber()
                      : _mobileNumberController.text),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            SizedBox(height: 10.v),
            _buildOtpView(context),
            _buildShowOtpError(context),
            _buildResendOtp(context),
            const Expanded(child: SizedBox()),
            _buildVerifyOtp(context),
            SizedBox(height: 20.v),
            Visibility(
              visible: PrefUtils.getInt(
                      PrefUtils.keyAuthNavFlow, AuthNavFlow.register.value) ==
                  AuthNavFlow.register.value,
              child: _buildTryADifferentPhoneNumber(context),
            ),
            SizedBox(height: 20.v),
            Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom))
          ],
        ),
      ),
    );
  }

  Widget _buildMobileNumber(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 1.h),
        child: CustomFloatingTextField(
            autofocus: false,
            maxLength: 10,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
            controller: _mobileNumberController,
            textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: setColorBasedOnTheme(
                  context: context,
                  lightColor: AppColors.primaryLight,
                  darkColor: AppColors.secondaryLight5,
                )),
            labelText: getString(lblHintEnterPhoneNumber),
            labelStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: setColorBasedOnTheme(
                  context: context,
                  lightColor: AppColors.primaryLight,
                  darkColor: AppColors.secondaryLight5,
                )),
            textInputAction: TextInputAction.done,
            textInputType: TextInputType.phone,
            borderDecoration: UnderlineInputBorder(
              borderRadius: BorderRadius.zero,
              borderSide: BorderSide(
                color: setColorBasedOnTheme(
                  context: context,
                  lightColor: AppColors.primaryLight3,
                  darkColor: AppColors.secondaryLight5,
                ),
                width: 1,
              ),
            ),
            validator: (value) {
              if (value!.length != 10) {
                return getString(lblLoginErrorEnterPhoneNumberLength);
              } else if (!isValidPhoneNumber(value)) {
                return getString(lblErrorEnterPhoneNumber);
              }
              return null;
            }));
  }

  Widget _buildUserConsent(BuildContext context) {
    return BlocBuilder<PhoneValidateCubit, MobileOtpState>(
        buildWhen: (context, state) {
      return state is MobileOtpInitState;
    }, builder: (context, state) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Theme(
                data: ThemeData(
                    checkboxTheme: CheckboxThemeData(
                        side: MaterialStateBorderSide.resolveWith(
                  (states) => BorderSide(
                    width: 2.0,
                    color: setColorBasedOnTheme(
                        context: context,
                        lightColor: AppColors.primaryLight,
                        darkColor: AppColors
                            .primaryLight6), // Change the border color here
                  ),
                ))),
                child: Checkbox(
                    activeColor: setColorBasedOnTheme(
                        context: context,
                        lightColor: AppColors.primaryLight,
                        darkColor: AppColors.primaryLight6),
                    visualDensity: const VisualDensity(
                      vertical: -4,
                      horizontal: -4,
                    ),
                    value: _enableTNCCheckbox,
                    onChanged: (value) async {
                      if (value!) {
                        // _blocContext
                        //     .read<PhoneValidateCubit>()
                        //     .changeCheckBox(true, value);
                        bool? isTermsConditionAgreed = await context.pushNamed(
                            common_route.Routes.termsConditions.name);
                        _blocContext.read<PhoneValidateCubit>().changeCheckBox(
                            isTermsConditionAgreed ?? false,
                            isTermsConditionAgreed ?? false);
                      } else {
                        _blocContext
                            .read<PhoneValidateCubit>()
                            .changeCheckBox(false, value);
                      }
                    }),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 2.0),
                  child: Text(getString(msgIveReadThrough),
                      style: Theme.of(context)
                          .textTheme
                          .labelMedium
                          ?.copyWith(letterSpacing: 0.4)),
                ),
              )
            ],
          ),
          //TODO need to uncomment code once whatsApp feauture will be enable
          // SizedBox(
          //   height: 12.v,
          // ),
          // CustomCheckboxButton(
          //   activeColor: Theme.of(context).primaryColor,
          //   checkColor: Theme.of(context).scaffoldBackgroundColor,
          //   textAlignment: TextAlign.center,
          //   isExpandedText: false,
          //   alignment: Alignment.center,
          //   text: getString(lblConnectOverWhatsapp),
          //   value: _enableWACheckbox,
          //   textStyle: Theme.of(context).textTheme.labelSmall,
          //   onChange: (value) {
          //     _blocContext.read<PhoneValidateCubit>().changeWAConsent(value);
          //   },
          // ),
          const Spacer(),

          SizedBox(height: 20.v),
          CustomElevatedButton(
            height: 42.h,
            onPressed: _enableGetOtpBtn!
                ? () async {
                    // await SmsAutoFill().listenForCode();
                    if (_formPhoneKey.currentState!.validate()) {
                      FocusManager.instance.primaryFocus?.unfocus();
                      // PrefUtils.saveBool(
                      //     PrefUtils.keyTermsCondition, _enableTNCCheckbox!);
                      // PrefUtils.saveBool(
                      //     PrefUtils.keyWAConsent, _enableWACheckbox!);
                      SendOtpRequest sendOtpRequest = SendOtpRequest(
                          mobileNumber: _mobileNumberController.text,
                          source: AppConst.source,
                          journey: AppConst.registrationJourney,
                          tncFlag: 1,
                          otpResend: false);
                      BlocProvider.of<PhoneValidateCubit>(context)
                          .sendOtp(sendOtpRequest, isFromResend: false);
                    }
                  }
                : null,
            text: getString(lblLoginGetOtp),
            margin: EdgeInsets.symmetric(horizontal: 3.h),
            buttonStyle: ElevatedButton.styleFrom(
                backgroundColor: _enableGetOtpBtn!
                    ? Theme.of(context).highlightColor
                    : Theme.of(context).disabledColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.h),
                )),
            buttonTextStyle: _enableGetOtpBtn!
                ? Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: AppColors.white)
                : Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Theme.of(context).unselectedWidgetColor),
          ),
          SizedBox(height: 10.v),
          //TODO common shouldn't be called from any package, so it navigation should be corected
          isFeatureEnabled(featureName: featureEnableCustomLogin)
              ? Align(
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: () {
                      context.goNamed(auth.Routes.home.name);
                    },
                    child: Padding(
                      padding: EdgeInsets.all(5.h),
                      child: Text(
                        "Custom Login",
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                                color: Colors.blue,
                                decoration: TextDecoration.underline),
                      ),
                    ),
                  ),
                )
              : Container(),
          isFeatureEnabled(featureName: featureEnableLogs)
              ? Align(
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: () {
                      exportLogToDownloadFile(context);
                    },
                    child: Padding(
                      padding: EdgeInsets.all(5.h),
                      child: Text(
                        "Get Log File",
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                                color: Colors.blue,
                                decoration: TextDecoration.underline),
                      ),
                    ),
                  ),
                )
              : Container(),
          SizedBox(height: 10.v),
        ],
      );
    });
  }

  Widget _buildOtpView(BuildContext context) {
    return BlocConsumer<PhoneValidateCubit, MobileOtpState>(
        buildWhen: (context, state) {
      return state is OtpReceiveState;
    }, builder: (context, state) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 3.h),
        child: CustomPinCodeTextField(
            context: context,
            controller: _otpController,
            onChanged: (value) {
              _otpController.text = value;
            },
            validator: (value) {
              if (value!.length < 6) {
                context.read<PhoneValidateCubit>().enableVerifyButton(false);
              } else {
                context.read<PhoneValidateCubit>().enableVerifyButton(true);
              }
              return null;
            }),
      );
    }, listener: (context, state) {
      if (state is OtpReceiveState) {
        _otpController.text = state.otp;
      }
    });
  }

  Widget _buildShowOtpError(BuildContext context) {
    return BlocBuilder<PhoneValidateCubit, MobileOtpState>(
        buildWhen: (context, state) {
      return state is ValidateOtpFailure || state is ValidateOtpSuccess;
    }, builder: (context, state) {
      return Visibility(
          visible: _showOtpError!,
          child: Padding(
            padding: EdgeInsets.only(left: 3.h),
            child: Text(_errorMessage!,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(color: Theme.of(context).highlightColor)),
          ));
    });
  }

  Widget _buildResendOtp(BuildContext context) {
    return BlocBuilder<PhoneValidateCubit, MobileOtpState>(
        buildWhen: (context, state) {
      return state is ResendOtpState;
    }, builder: (context, state) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 3.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Stack(children: [
              Visibility(
                  visible: _showOtpTimer!,
                  child: Countdown(
                    controller: _timerForResentOtp,
                    seconds: AppConst.resendOtpTime,
                    build: (BuildContext context, double time) =>
                        Text(_formatDuration(time.toInt())),
                    interval: const Duration(seconds: 1),
                    onFinished: () {
                      currentResendOtpAttempt++;
                      if(currentResendOtpAttempt < AppConst.maxResendOtpAttempt) {
                        context
                            .read<PhoneValidateCubit>()
                            .showResendOtpButton(false, true, false);
                      } else {
                        currentResendOtpAttempt = 0;
                        context
                            .read<PhoneValidateCubit>()
                            .showResendOtpButton(false, false, false);
                        toastForFailureMessage(context: context, msg: getString(msgOtpMpinError));
                      }
                    },
                  )),
              Visibility(
                  visible: !_showOtpTimer!,
                  child: Text(
                      _showResendOtpBtn!
                          ? getString(lblLoginDidNotReceive)
                          : "",
                      style: Theme.of(context).textTheme.labelSmall))
            ]),
            Stack(
              children: [
                Visibility(
                    visible: _showIvrOtpBtn!,
                    child: InkWell(
                      onTap: () {
                        BlocProvider.of<PhoneValidateCubit>(context).sendOtp(
                            SendOtpRequest(
                                source: AppConst.source,
                                journey: AppConst.registrationJourney,
                                mobileNumber: _mobileNumberController.text,
                                tncFlag: 0,
                                otpResend: true),
                            isFromResend: true);
                      },
                      child: Text(getString(lblOtpByCall),
                          style: Theme.of(context).textTheme.titleSmall),
                    )),
                Visibility(
                    visible: _showResendOtpBtn!,
                    child: InkWell(
                      onTap: () {
                        BlocProvider.of<PhoneValidateCubit>(context).sendOtp(
                            SendOtpRequest(
                                source: AppConst.source,
                                journey: AppConst.registrationJourney,
                                mobileNumber: _mobileNumberController.text,
                                tncFlag: 0,
                                otpResend: true),
                            isFromResend: true);
                      },
                      child: Text(getString(lblLoginResendOtp),
                          style:
                              Theme.of(context).textTheme.labelSmall?.copyWith(
                                      color: setColorBasedOnTheme(
                                    context: context,
                                    lightColor: AppColors.secondaryLight,
                                    darkColor: AppColors.secondaryLight5,
                                  ))),
                    ))
              ],
            )
          ],
        ),
      );
    });
  }

  String _formatDuration(int totalSeconds) {
    final duration = Duration(seconds: totalSeconds);
    final minutes = duration.inMinutes;
    final seconds = totalSeconds % 60;

    final minutesString = '$minutes'.padLeft(2, '0');
    final secondsString = '$seconds'.padLeft(2, '0');
    return '$minutesString:$secondsString';
  }

  Widget _buildVerifyOtp(BuildContext context) {
    return BlocConsumer<PhoneValidateCubit, MobileOtpState>(
        builder: (context, state) {
      return Center(
        child: CustomElevatedButton(
          height: 42.v,
          width: 305.h,
          onPressed: _enableVerifyOtpBtn!
              ? () {
                  ValidateOtpRequest validateOtpRequest = ValidateOtpRequest(
                      otp: _otpController.text,
                      mobileNumber: PrefUtils.getInt(PrefUtils.keyAuthNavFlow,
                                  AuthNavFlow.register.value) ==
                              AuthNavFlow.forgotMpin.value
                          ? getPhoneNumber()
                          : _mobileNumberController.text,
                      tNCFlag: 2,
                      journey: PrefUtils.getInt(PrefUtils.keyAuthNavFlow,
                                  AuthNavFlow.register.value) ==
                              AuthNavFlow.forgotMpin.value
                          ? AppConst.forgotPassJourney
                          : AppConst.registrationJourney,
                      source: AppConst.source);
                  BlocProvider.of<PhoneValidateCubit>(context)
                      .validateOtp(validateOtpRequest);
                }
              : null,
          text: getString(lblLoginVerify),
          margin: EdgeInsets.symmetric(horizontal: 3.h),
          buttonStyle: ElevatedButton.styleFrom(
              backgroundColor: _enableVerifyOtpBtn!
                  ? Theme.of(context).highlightColor
                  : Theme.of(context).disabledColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.h),
              )),
          buttonTextStyle: _enableVerifyOtpBtn!
              ? Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Theme.of(context).cardColor)
              : Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Theme.of(context).unselectedWidgetColor),
        ),
      );
    }, listener: (context, state) {
      if (state is VerifyButtonState) {
        _enableVerifyOtpBtn = state.isEnable;
      }
    });
  }

  Widget _buildTryADifferentPhoneNumber(BuildContext context) {
    return Center(
      child: MfCustomButton(
        outlineBorderButton: true,
        height: 42.v,
        width: 305.h,
        onPressed: () {
          _showOtpError = false;
          _mobileNumberController.text = "";
          _otpController.text = "";
          getPermissionsForSimCardDetails();
          BlocProvider.of<PhoneValidateCubit>(context).resetPhoneNumber();
        },
        text: getString(lblTryDiffNumber),
        textStyle: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 14,
              color: setColorBasedOnTheme(
                context: context,
                lightColor: AppColors.secondaryLight,
                darkColor: AppColors.secondaryLight5,
              )),
      ),
    );
  }

  _showPrevDevicePopUp(BuildContext context, String superAppId) {
    showModalBottomSheet<void>(
      backgroundColor: Theme.of(context).cardColor,
      isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.0)),
      ),
      builder: (BuildContext context) {
        return SizedBox(
          height: 262.h,
          child: Center(
            child: Container(
              color: Theme.of(context).cardColor,
              width: double.maxFinite,
              padding: EdgeInsets.symmetric(
                horizontal: 14.h,
                vertical: 16.v,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Opacity(
                    opacity: 0.4,
                    child: Container(
                      height: 4.v,
                      width: 32.h,
                      decoration: BoxDecoration(
                        color: appTheme.gray600.withOpacity(0.49),
                        borderRadius: BorderRadius.circular(
                          2.h,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 19.v),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 1.h),
                      child: Text(
                        getString(msgLogoutDeviceTitle),
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.v),
                  Expanded(
                      child: Text(
                    getString(msgLogoutDeviceDesc),
                    style: Theme.of(context).textTheme.titleSmall,
                  )),
                  SizedBox(height: 12.v),
                  _buildPrevDeviceButton(context, superAppId)
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPrevDeviceButton(BuildContext context, String superAppId) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 3.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomElevatedButton(
            height: 42.h,
            onPressed: () {
              SaveDeviceRequest saveDeviceRequest = SaveDeviceRequest(
                  deviceId: getDeviceId(),
                  superAppId: superAppId,
                  source: AppConst.source);
              BlocProvider.of<PhoneValidateCubit>(_blocContext)
                  .saveDevice(saveDeviceRequest: saveDeviceRequest);
            },
            text: getString(lblLoginContinue),
            margin: EdgeInsets.symmetric(horizontal: 3.h),
            buttonStyle: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).highlightColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.h),
                )),
            buttonTextStyle: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Theme.of(context).cardColor),
          ),
          SizedBox(
            height: 10.v,
          ),
          CustomElevatedButton(
            height: 42.0,
            buttonTextStyle: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(color: Theme.of(context).highlightColor),
            buttonStyle: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
              side: BorderSide(color: Theme.of(context).highlightColor),
            ))),
            onPressed: () {
              resetRegistrationFlow();
              Navigator.pop(context);
              _showOtpError = false;
              _mobileNumberController.text = "";
              _otpController.text = "";
              getPermissionsForSimCardDetails();
              BlocProvider.of<PhoneValidateCubit>(_blocContext)
                  .resetPhoneNumber();
            },
            text: getString(lblRegisterWithNewDevice),
            margin: EdgeInsets.symmetric(horizontal: 3.h),
          ),
        ],
      ),
    );
  }

  @override
  void codeUpdated() {
    if (code != null) {
      _otpController.text = code!;
    }
  }
}
