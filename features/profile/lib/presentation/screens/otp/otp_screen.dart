import 'package:auth/features/login_and_registration/data/models/register_user_request.dart';
import 'package:auth/features/login_and_registration/presentation/cubit/auth_cubit.dart';
import 'package:auth/features/login_and_registration/presentation/cubit/auth_state.dart';
import 'package:auth/features/mobile_otp/data/models/send_email_otp_request.dart';
import 'package:auth/features/mobile_otp/data/models/send_otp_request.dart';
import 'package:auth/features/mobile_otp/data/models/validate_aadhaar_otp_res.dart';
import 'package:auth/features/mobile_otp/data/models/validate_email_otp_request.dart';
import 'package:auth/features/mobile_otp/data/models/validate_otp_request.dart';
import 'package:auth/features/mobile_otp/presentation/cubit/phone_validate_cubit.dart';
import 'package:auth/features/mobile_otp/presentation/cubit/phone_validate_state.dart';
import 'package:common/features/rate_us/data/models/rate_us_request.dart';
import 'package:common/features/rate_us/presentation/cubit/rate_us_cubit.dart' as rate_us;
import 'package:common/features/rate_us/presentation/widget/rate_us_dialog_box.dart';
import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/config/widgets/mf_progress_bar.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:core/config/widgets/mf_toast.dart';
import 'package:core/services/di/injection_container.dart';
import 'package:core/utils/const.dart';
import 'package:core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:help/features/utils/constant_help.dart';
import 'package:help/features/utils/help_common_widget.dart';
import 'package:core/config/widgets/mf_appbar.dart';
import 'package:core/utils/size_utils.dart';
import 'package:core/config/widgets/background/mf_gradient_background.dart';
import 'package:core/config/widgets/custom_buttons/mf_custom_elevated_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:profile/config/routes/route.dart';
import 'package:profile/data/models/active_loan_list_request.dart';
import 'package:profile/data/models/name_match_req.dart';
import 'package:profile/data/models/update_email_request.dart';
import 'package:auth/features/mobile_otp/data/models/validate_aadhaar_otp_req.dart';
import 'package:profile/data/models/update_phone_req.dart';
import 'package:profile/presentation/cubit/profile_cubit.dart';
import 'package:profile/presentation/screens/components/widgets/email_otp_widget.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';
import '../../../config/profile_constant.dart';
import '../../../data/models/aadhaar_consent_req.dart';
import '../../../data/models/customer_info_args.dart';
import '../../../data/models/dob_gender_match_req.dart';
import '../../../data/models/validate_aadhaar_detail.dart';
import '../../../data/models/validate_driving_license_details.dart';
import '../../../utils/utils.dart';
import 'package:common/config/routes/route.dart' as common_routes;
import 'package:common/features/rate_us/utils/helper/constant_data.dart';


class OtpScreen extends StatefulWidget {
  final OtpScreenType otpScreenType;
  final String mobileNumber;
  final ProfileExtras extras;
  final CustomerInfoArg customerInfoArg;


  const OtpScreen({required this.otpScreenType, required this.mobileNumber, required this.extras, required this.customerInfoArg, super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final CountdownController _timerForResentOtp = CountdownController(autoStart: true);
  bool _showResendOtpBtn = false;
  bool _showOtpTimer = true;
  bool _showOtpError = false;
  String? _errorMessage = "";
  bool _enableVerifyOtpBtn = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _otpController = TextEditingController();
  int _currentAttempt = 0;
  ValidateAadhaarOtpRes? _aadhaarInfo;
  String _rateUsFeature = "";

  @override
  void initState() {
    super.initState();
    context.read<PhoneValidateCubit>().startResendOtpTimer(true);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: customAppbar(
            context: context,
            title: '',
            onPressed: () {
             context.pop();
            },
            actions: [
              HelpCommonWidget(categoryval: HelpConstantData.subCategoryProfile,subCategoryval: HelpConstantData.subCategoryOtpValidation,)
            ]),
        body: _buildWidget());
  }

  Widget _buildWidget() {
    return MFGradientBackground(
      horizontalPadding: 16.h,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              getString(lblLoginEnterOtp),
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontSize: 20),
            ),
            SizedBox(height: 10.v),
            Text(
            widget.otpScreenType == OtpScreenType.aadhaarOtp? getString(lblEnterSixDigitAadhaarOtp) :getString(lblProfileEnterSixDigitOtp) + ((widget.otpScreenType == OtpScreenType.emailOtp ? widget.extras.newEmail : widget.extras.newPhoneNumber) ?? ""),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            SizedBox(height: 10.v),
            // SizedBox(height: 20.v),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.h),
              child: CustomEmailOtpTextField(
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
            ),

            //SizedBox(height: 4.v),
            _buildShowOtpError(context),
            //SizedBox(height: 12.v),
            _buildResendOtp(context),
            const Spacer(),
            BlocBuilder<PhoneValidateCubit, MobileOtpState>(
              buildWhen:(context, state) => state is VerifyButtonState,
              builder: (context, state) {
                return MfCustomButton(
                    outlineBorderButton: false,
                    isDisabled: !_enableVerifyOtpBtn,
                    onPressed: () {
                      if (_enableVerifyOtpBtn) {
                        if(widget.otpScreenType == OtpScreenType.mobileOtp) {
                          ValidateOtpRequest validateOtpRequest =
                          ValidateOtpRequest(
                              otp: _otpController.text,
                              mobileNumber: widget.extras.newPhoneNumber,
                              tNCFlag: 2,
                              journey: widget.extras.operation == Operation.mapMyLoan ? AppConst.mapMyLoanMobileJourney : AppConst.updateMobileJourney,
                              source: AppConst.source);
                          BlocProvider.of<PhoneValidateCubit>(context)
                              .validateOtp(validateOtpRequest);
                        } else if(widget.otpScreenType == OtpScreenType.emailOtp){
                          var request =
                          ValidateEmailOtpRequest(
                              otp: _otpController.text,
                              email: widget.mobileNumber,
                              journey: AppConst.updateEmailJourney,
                              source: AppConst.source, superAppId: getSuperAppId());
                          BlocProvider.of<PhoneValidateCubit>(context).validateEmailOtp(request);
                        } else if(widget.otpScreenType == OtpScreenType.aadhaarOtp) {
                          var request = ValidateAadhaarOtpReq(
                              userOtp: _otpController.text,
                              aadhaarNo: widget.extras.aadhaarNumber,
                              superAppId: getSuperAppId(),
                              transactionId: widget.extras.transactionId,
                              source: AppConst.source);
                          BlocProvider.of<PhoneValidateCubit>(context).validateAadhaarOtp(request);
                        }
                      }
                    },
                    text: getString(lblLoginVerify));
              },
            ),
            SizedBox(height: 12.v),
            Visibility(visible: (widget.otpScreenType == OtpScreenType.mobileOtp && widget.extras.operation == Operation.updatePhoneNumber ), child: MfCustomButton(
                outlineBorderButton: true,
                isDisabled: false,
                onPressed: () {
                  context.pop();
                },
                text: getString(lblTryDiffNumber))),
          ],
        ),
      ),
    );
  }

  Widget _buildResendOtp(BuildContext context) {
    return MultiBlocListener(listeners: [
      BlocListener<PhoneValidateCubit, MobileOtpState>(listener: (context, state) {
        if (state is ResendOtpState) {
          FocusManager.instance.primaryFocus?.unfocus();
          _showResendOtpBtn = state.showResendOtp;
          _showOtpTimer = state.showTimer;
          if (state.showTimer) {
            _timerForResentOtp.start();
          }
        } else if(state is ApiLoadingState){
          if (state.isloading) {
            showLoaderDialog(context, getString(lblLoginLoading));
          } else {
            Navigator.of(context, rootNavigator: true).pop();
          }
        } else if (state is VerifyButtonState) {
          _enableVerifyOtpBtn = state.isEnable;
        } else if (state is ValidateOtpSuccess) {
          if (state.response.code == AppConst.codeSuccess) {
            if (isCustomer()) {
              context.pushNamed(
                  Routes.myProfileAuthenticateMobileNumber.name,
                  extra: {"newPhoneNumber": widget.extras.newPhoneNumber , "isUserToCustomer" : false, "customerInfoArg" : CustomerInfoArg(), "updateOperation" : Operation.updatePhoneNumber});
            } else {
              if (widget.extras.operation == Operation.mapMyLoan) {
                context.pushNamed(
                    Routes.myProfileAuthenticateMobileNumber.name,
                    extra: {"newPhoneNumber": widget.extras.newPhoneNumber , "isUserToCustomer" : true, "customerInfoArg" : widget.customerInfoArg, "updateOperation" : Operation.mapMyLoan});
              } else {
              UpdatePhoneReq request = UpdatePhoneReq(ucic: getUCIC(),
                  source: AppConst.source,
                  superAppId: getSuperAppId(),
                  mobileNumber: widget.extras.newPhoneNumber,
                  oldMobileNumber: getPhoneNumber(),
                  consentFlag: true.toString(), customerName: widget.extras.custName);
              context.read<ProfileCubit>().updatePhoneNumber(request);
              }
            }
          } else {
            _currentAttempt++;
            context.read<PhoneValidateCubit>().enableVerifyButton(false);
            if (_currentAttempt < ProfileConst.maxOtpAttempt) {
              _showOtpError = true;
              _errorMessage = getString("${state.response.responseCode}_Auth");
            } else {
              _showOtpError = false;
              displayAlertSingleAction(
                  context, getString(msgErrorMobileAuthMax),
                  btnLbl: getString(lblProfileOk), btnTap: () {
                Navigator.of(context).popUntil(ModalRoute.withName(
                    Routes.myProfileData.name));
              });
            }
          }
        } else if (state is ValidateOtpFailure) {
          toastForFailureMessage(
              context: context,
              msg:getFailureMessage(state.error));
        } else if (state is ValidateEmailOtpSuccess) {
          if (state.response.code == AppConst.codeSuccess) {
            var request = UpdateEmailRequest(emailId: widget.mobileNumber, superAppId: getSuperAppId(), consentFlag: true.toString() ,oldEmailId: widget.extras.oldEmailId ,ucic: getUCIC(), source: AppConst.source, customerName: widget.extras.custName);
            context.read<ProfileCubit>().updateEmailId(request);
          } else {
            _currentAttempt++;
            context.read<PhoneValidateCubit>().enableVerifyButton(false);
            if (_currentAttempt < ProfileConst.maxEmailAttempt) {
              _showOtpError = true;
              _errorMessage = getString(state.response.responseCode ?? lblProfileErrorGeneric);
            } else {
              _showOtpError = false;
              displayAlertSingleAction(
                  context, getString(msgErrorEmailAuthMax),
                  btnLbl: getString(lblProfileOk), btnTap: () {
                Navigator.of(context).popUntil(ModalRoute.withName(
                    Routes.myProfileData.name));
              });
            }
          }
        } else if (state is ValidateEmailOtpFailure) {
          _showOtpError = false;
          toastForFailureMessage(
              context: context,
              msg: getFailureMessage(state.error));
        } else if (state is ValidateAadhaarOtpSuccessState) {
          if (state.response.code == AppConst.codeSuccess) {
            _aadhaarInfo = state.response;
           var nameMatchRequest = NameMatchReq(superAppId: getSuperAppId(),  ucic: getUCIC(), sourceName: state.response.aadhaarName ?? "", targetName: widget.extras.custName);
           context.read<ProfileCubit>().validateNameMatch(nameMatchRequest);
          } else {
            _currentAttempt++;
            context.read<PhoneValidateCubit>().enableVerifyButton(false);
            if (_currentAttempt < ProfileConst.maxAadhaarAttempt) {
              _showOtpError = true;
              _errorMessage = getString(state.response.responseCode ?? lblProfileErrorGeneric);
            } else {
              _showOtpError = false;
              displayAlertSingleAction(
                  context, getString(msgErrorAadhaarAddressAuthMax),
                  btnLbl: getString(lblProfileOk), btnTap: () {
                Navigator.of(context).popUntil(ModalRoute.withName(
                    Routes.myProfileData.name));
              });
            }
          }
        } else if (state is ValidateAadhaarOtpFailureState) {
          _showOtpError = false;
          toastForFailureMessage(
              context: context,
              msg: getFailureMessage(state.failure));
        } else if(state is SendEmailOtpSuccess){
          if(state.response.code == AppConst.codeSuccess){
            context.read<PhoneValidateCubit>().startResendOtpTimer(true);
          } else {
            toastForFailureMessage(
                context: context,
                msg: _errorMessage = getString(state.response.responseCode ?? lblProfileErrorGeneric));
          }
        } else if(state is SendEmailOtpFailure){
          toastForFailureMessage(
              context: context,
              msg: getFailureMessage(state.error));
        }
      }),
      BlocListener<ProfileCubit, ProfileState>(listener: (context, state) {
        if(state is ProfileLoadingState){
          if (state.isloading) {
            showLoaderDialog(context, getString(lblLoginLoading));
          } else {
            Navigator.of(context, rootNavigator: true).pop();
          }
        } else if(state is UpdateEmailSuccessState){
          if(state.response.code == AppConst.codeSuccess){
            toastForSuccessMessage(context: context, msg: getString(msgEmailUpdateSuccess));
            checkLastRatingDate(context, ConstantData.emailUpdate);
            _rateUsFeature = ConstantData.emailUpdate;
            Navigator.of(context).popUntil(ModalRoute.withName(
                  Routes.myProfileData.name));
            setState(() {});
          } else {
            displayAlertSingleAction(
                context, getString(state.response.responseCode ?? lblProfileErrorGeneric),
                btnLbl: getString(lblProfileOk), btnTap: () {
              Navigator.of(context).popUntil(ModalRoute.withName(
                  Routes.myProfileData.name));
            });
          }
        } else if(state is UpdateEmailFailureState){
          displayAlertSingleAction(
              context, getFailureMessage(state.failure),
              btnLbl: getString(lblProfileOk), btnTap: () {
            Navigator.of(context).popUntil(ModalRoute.withName(
                Routes.myProfileData.name));
          });
        } else if(state is SentAadhaarOtpSuccessState){
          if(state.response.code == AppConst.codeSuccess){
            context.read<PhoneValidateCubit>().startResendOtpTimer(true);
          } else {
            toastForFailureMessage(
                context: context,
                msg: _errorMessage = getString(state.response.message ?? msgSomethingWentWrong));
          }
        } else if(state is SentAadhaarOtpFailureState){
          toastForFailureMessage(
              context: context,
              msg: getFailureMessage(state.failure));
        } else if(state is NameMatchSuccessState){
          if(state.response.code == AppConst.codeSuccess){
            if(widget.extras.operation == Operation.updateAddress) {
              if (state.response.score! >= ProfileConst.nameMatchScore) {
                  var gobGenderMatchRequest = DobGenderMatchRequest(
                      sourceDob: widget.extras.profileInfo?.dob,
                      targetDob: _aadhaarInfo?.dob,
                      sourceGender: widget.extras.profileInfo?.gender ?? "M",
                      targetGender: _aadhaarInfo?.gender);
                  BlocProvider.of<ProfileCubit>(context)
                      .validateDOBGenderMatch(gobGenderMatchRequest);
              } else {
                context.pushNamed(
                    Routes.myProfileNameMismatch.name, extra: {
                  "errorTitle": getString(msgSorryWeCould),
                  "errorMessage": getString(msgErrorNameMatchAddress)
                });
              }
            } else {
              if (state.response.score! >= ProfileConst.nameMatchScore) {
                if (widget.extras.operation == Operation.mapMyLoan) {
                  context.read<ProfileCubit>().getActiveLoansList(ActiveLoanListRequest(ucic: widget.customerInfoArg.ucic));
                } else {
                  UpdatePhoneReq request = UpdatePhoneReq(ucic: getUCIC(),
                      source: AppConst.source,
                      superAppId: getSuperAppId(),
                      mobileNumber: widget.extras.newPhoneNumber,
                      oldMobileNumber: getPhoneNumber(),
                      consentFlag: true.toString(),
                      customerName: widget.extras.custName);
                  context.read<ProfileCubit>().updatePhoneNumber(request);
                }
              } else {
                context.pushNamed(
                    Routes.myProfileNameMismatch.name, extra: {
                  "errorTitle": getString(msgSorryWeCould),
                  "errorMessage": getString(msgErrorNameMatchPhoneNumber)
                });
              }
            }
          } else {
            context.pushNamed(
                Routes.myProfileNameMismatch.name, extra: {
              "errorTitle": getString(msgSorryWeCould),
              "errorMessage": widget.extras.operation == Operation.updateAddress ? getString(msgErrorNameMatchAddress) : getString(msgErrorNameMatchPhoneNumber)
            });
          }
        } else if(state is NameMatchFailureState){
          displayAlertSingleAction(
              context, getFailureMessage(state.failure),
              btnLbl: getString(lblProfileOk), btnTap: () {
            Navigator.of(context).popUntil(ModalRoute.withName(
                Routes.myProfileData.name));
          });
        } else if(state is UpdatePhoneSuccessState){
          if(state.response.code == AppConst.codeSuccess){
            if(widget.extras.operation ==Operation.mapMyLoan){
              var request = RegisterUserRequest(
                  userFullName: widget.customerInfoArg.userFullName,
                  mobileNumber: getPhoneNumber(),
                  source: AppConst.source,
                  ucic: widget.customerInfoArg.ucic,
                  languageCode: getSelectedLanguage(),
                  deviceId: getDeviceId(),
                  superAppId: getSuperAppId(),
                  logoutSuperAppId: "" // need to add when logout from prev device
              );
              BlocProvider.of<AuthCubit>(context).registerUser(
                  request,
                  widget.customerInfoArg.userFullName ?? "",
                  widget.customerInfoArg.ucic ?? "");
            } else {
              toastForSuccessMessage(
                  context: context, msg: state.response.responseCode ?? "");
              checkLastRatingDate(context, ConstantData.mobileNumberUpdate);
              _rateUsFeature = ConstantData.mobileNumberUpdate;
              setState(() {});
            }
          } else {
            displayAlertSingleAction(
                context, getString(state.response.responseCode ?? lblProfileErrorGeneric),
                btnLbl: getString(lblProfileOk), btnTap: () {
              Navigator.of(context).popUntil(ModalRoute.withName(
                  Routes.myProfileData.name));
            });
          }
        } else if (state is UpdatePhoneFailureState) {
          toastForFailureMessage(
              context: context,
              msg: getFailureMessage(state.failure));
        } else if (state is DobGenderMatchSuccessState) {
          if (state.response.code == AppConst.codeFailure) {
              context.pushNamed(
                  Routes.myProfileNameMismatch.name, extra: {
                "errorTitle": getString(msgSorryWeCould),
                "errorMessage": getString(msgVisitBranch)
              });
          } else {
            if (state.response.dobScore! >= ProfileConst.dobMatchScore && state.response.genderScore! >= ProfileConst.genderMatchScore) {
              context
                  .pushNamed(Routes.myProfileConfirmDetails.name, extra: {
                "confirmScreenType":
                ConfirmDetailScreenType.aadhaarDetails,
                "validateDrivingLicenseDetail":
                ValidateDrivingLicenseDetail(), "aadhaarInfo" : _aadhaarInfo, "addressType" : widget.extras.addressType
              });
            } else {
              context.pushNamed(
                  Routes.myProfileNameMismatch.name, extra: {
                "errorTitle": getString(msgSorryWeCould),
                "errorMessage": getString(msgVisitBranch)
              });
            }
          }
        } else if(state is DobGenderMatchFailureState){
          displayAlertSingleAction(
              context, getFailureMessage(state.failure),
              btnLbl: getString(lblProfileOk), btnTap: () {
            Navigator.of(context).popUntil(ModalRoute.withName(
                Routes.myProfileData.name));
          });
        } else if(state is GetActiveLoansListSuccessState){
          if (state.response.code == AppConst.codeSuccess) {
            if (state.response.loanList?.isNotEmpty == true && getActiveLoanList(state.response.loanList ?? [])?.isNotEmpty == true) {
              UpdatePhoneReq request = UpdatePhoneReq(ucic: widget.customerInfoArg.ucic,
                  source: AppConst.source,
                  superAppId: getSuperAppId(),
                  mobileNumber: getPhoneNumber(),
                  oldMobileNumber: getPhoneNumber(),
                  consentFlag: true.toString(),
                  customerName: widget.customerInfoArg.userFullName);
              context.read<ProfileCubit>().updatePhoneNumber(request);
            } else {
              displayAlertSingleAction(
                  context, getString(INL1001),
                  btnLbl: getString(lblProfileOk), btnTap: () {
                Navigator.of(context).popUntil(ModalRoute.withName(
                    Routes.myProfileData.name));
              });
            }
          } else {
            displayAlertSingleAction(
                context, getString(state.response.responseCode ?? lblProfileErrorGeneric),
                btnLbl: getString(lblProfileOk), btnTap: () {
              Navigator.of(context).popUntil(ModalRoute.withName(
                  Routes.myProfileData.name));
            });
          }
        } else if(state is GetActiveLoansListFailureState){
          displayAlertSingleAction(
              context, getFailureMessage(state.failure),
              btnLbl: getString(lblProfileOk), btnTap: () {
            Navigator.of(context).popUntil(ModalRoute.withName(
                Routes.myProfileData.name));
          });
        } else if (state is GetAadhaarConsentSuccessState) {
          if (state.response.code == AppConst.codeSuccess) {
            context.read<PhoneValidateCubit>().startResendOtpTimer(true);
          } else {
            toastForFailureMessage(
                context: context,
                msg: getString(state.response.responseCode ?? lblProfileErrorGeneric));
          }
        } else if (state is GetAadhaarConsentFailureState) {
          toastForFailureMessage(
              context: context,
              msg: getFailureMessage(state.failure));
        }
      }),
        BlocListener<rate_us.RateUsCubit, rate_us.RateUsState>(
            listener: (context, state) {
              if (state is rate_us.RateUsSuccessState) {
                if (state.response.code == AppConst.codeSuccess) {
                  if (state.response.rateUsStatus ?? false) {
                    showRateUsPopup(context, _rateUsFeature);
                  } else {
                    Navigator.of(context).popUntil(
                        ModalRoute.withName(common_routes.Routes.home.name));
                    context.pushNamed(Routes.myProfileData.name);
                  }
                } else {
                  toastForFailureMessage(
                      context: context,
                      msg: getString(
                          state.response.responseCode ?? msgSomethingWentWrong));
                }
              } else if (state is rate_us.RateUsFailureState) {
                showSnackBar(
                    context: context, message: getFailureMessage(state.failure));
              }
            },),
      BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if(state is UserInfoSuccessState) {
            if (state.response.code == AppConst.codeSuccess) {
              Navigator.of(context).popUntil(
                  ModalRoute.withName(common_routes.Routes.home.name));
              context.pushNamed(Routes.myProfileData.name);
            } else {
              displayAlertSingleAction(
                  context, getString(state.response.responseCode ?? lblProfileErrorGeneric),
                  btnLbl: getString(lblProfileOk), btnTap: () {
                Navigator.of(context).popUntil(ModalRoute.withName(
                    Routes.myProfileData.name));
              });
            }
          } else if(state is UserInfoFailureState){
            displayAlertSingleAction(
                context, getFailureMessage(state.failure),
                btnLbl: getString(lblProfileOk), btnTap: () {
              Navigator.of(context).popUntil(ModalRoute.withName(
                  Routes.myProfileData.name));
            });
          }
        },)
    ], child: BlocBuilder<PhoneValidateCubit, MobileOtpState>(
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
                  visible: _showOtpTimer,
                  child: Countdown(
                    controller: _timerForResentOtp,
                    seconds: AppConst.resendOtpTime,
                    build: (BuildContext context, double time) =>
                        Text(_formatDuration(time.toInt())),
                    interval: const Duration(seconds: 1),
                    onFinished: () {
                      context
                          .read<PhoneValidateCubit>()
                          .showResendOtpButton(false, true, false);
                    },
                  )),
              Visibility(
                  visible: !_showOtpTimer,
                  child: Text(
                      _showResendOtpBtn
                          ? getString(lblProfileDidNotReceive)
                          : getString(lblFacingIssue),
                      style: Theme.of(context).textTheme.labelSmall))
            ]),
            Stack(
              children: [
                Visibility(
                    visible: _showResendOtpBtn,
                    child: InkWell(
                      onTap: () async {
                        _showOtpError = false;
                        _errorMessage = "";
                        if(widget.otpScreenType == OtpScreenType.mobileOtp) {
                          if (widget.extras.operation == Operation.mapMyLoan) {
                            SendOtpRequest sendOtpRequest = SendOtpRequest(
                                mobileNumber: getPhoneNumber(),
                                source: AppConst.source,
                                journey: AppConst.mapMyLoanMobileJourney,
                                tncFlag: 1,
                                otpResend: true,
                                superAppId: getSuperAppId());
                            BlocProvider.of<PhoneValidateCubit>(context)
                                .sendOtp(sendOtpRequest, isFromResend: true);
                          } else {
                            BlocProvider.of<PhoneValidateCubit>(context)
                                .sendOtp(
                                SendOtpRequest(
                                    source: AppConst.source,
                                    journey: AppConst.updateMobileJourney,
                                    mobileNumber: widget.extras.newPhoneNumber,
                                    tncFlag: 1,
                                    otpResend: true),
                                isFromResend: true);
                          }
                        } else if(widget.otpScreenType == OtpScreenType.emailOtp){
                          var request = SendEmailOtpRequest(source: AppConst.source, email: widget.mobileNumber, superAppId: getSuperAppId(), journey: AppConst.updateEmailJourney);
                          context
                              .read<PhoneValidateCubit>()
                              .sendEmailOtp(request);
                        } else if(widget.otpScreenType == OtpScreenType.aadhaarOtp){
                          String userAgent = await getUserAgent();
                          var aadhaarConsent = AadhaarConsentReq(
                            source: AppConst.source,
                            purpose: AppConst.updateMobileJourney,
                            userName: widget.extras.custName ?? "",
                            superAppId: getSuperAppId(),
                            aadhaarNo: widget.extras.aadhaarNumber,
                            userAgent: userAgent
                          );
                          BlocProvider.of<ProfileCubit>(context)
                              .getAadhaarConsent(aadhaarConsent);
                        }
                      },
                      child: Text(getString(lblProfileResendOtp),
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall
                              ?.copyWith(
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
    }));

  }

  Widget _buildShowOtpError(BuildContext context) {
    return BlocBuilder<PhoneValidateCubit, MobileOtpState>(
        buildWhen: (context, state) {
          return state is ValidateOtpFailure || state is ValidateOtpSuccess || state is ResendOtpState || state is ValidateEmailOtpSuccess || state is ValidateEmailOtpFailure || state is ValidateAadhaarOtpSuccessState || state is ValidateAadhaarOtpFailureState;
        }, builder: (context, state) {
      return Visibility(
          visible: _showOtpError,
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

  // otpResultNavigation(BuildContext context) {
  //   switch (widget.otpScreenType) {
  //     case OtpScreenType.mobileOtp:
  //       context.pushNamed(Routes.myProfileAuthenticateMobileNumber.name);
  //       break;
  //
  //     case OtpScreenType.aadharOtp:
  //       context.pushNamed(Routes.myProfileNameMismatch.name);
  //       break;
  //
  //     case OtpScreenType.emailOtp:
  //       context.pushNamed(Routes.myProfileData.name);
  //       break;
  //     default:
  //   }
  // }

  void checkLastRatingDate(BuildContext context, String featureType) async {
    RateUsRequest rateUsRequest =
    RateUsRequest(superAppId: getSuperAppId(), feature: featureType);
    BlocProvider.of<rate_us.RateUsCubit>(context).getRateUs(rateUsRequest);
  }

  void showRateUsPopup(BuildContext context, String featureType) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return BlocProvider(
          create: (context) => di<rate_us.RateUsCubit>(),
          child: RateUsDialogBox(featureType,onTap: (BuildContext dialogContex){
            dialogDissmiss(dialogContex);
          },),
        );
      },
    );
  }

  dialogDissmiss(BuildContext dialogContex)  {
    Navigator.of(dialogContex).pop();
    Navigator.of(context).popUntil(ModalRoute.withName(
        common_routes.Routes.home.name));
    context.pushNamed(Routes.myProfileData.name);
  }

  String _formatDuration(int totalSeconds) {
    final duration = Duration(seconds: totalSeconds);
    final minutes = duration.inMinutes;
    final seconds = totalSeconds % 60;

    final minutesString = '$minutes'.padLeft(2, '0');
    final secondsString = '$seconds'.padLeft(2, '0');
    return '$minutesString:$secondsString';
  }
}
