import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/config/widgets/common_widgets/custom_checkbox_button.dart';
import 'package:core/config/widgets/common_widgets/custom_floating_text_field.dart';
import 'package:core/config/widgets/mf_progress_bar.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:core/config/widgets/mf_toast.dart';
import 'package:core/utils/const.dart';
import 'package:core/utils/utils.dart';
import 'package:core/utils/validation_functions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:profile/config/profile_constant.dart';
import 'package:profile/config/routes/route.dart';
import 'package:core/config/widgets/mf_appbar.dart';
import 'package:help/features/utils/constant_help.dart';
import 'package:help/features/utils/help_common_widget.dart';
import 'package:core/utils/size_utils.dart';

import 'package:core/config/widgets/background/mf_gradient_background.dart';
import 'package:core/config/widgets/custom_buttons/mf_custom_elevated_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:profile/data/models/aadhaar_consent_req.dart';
import 'package:profile/data/models/customer_info_args.dart';
import 'package:profile/data/models/my_profile_model_response.dart';
import 'package:profile/data/models/validate_aadhaar_detail.dart';
import 'package:profile/presentation/cubit/profile_cubit.dart';

import '../../../utils/utils.dart';

class AuthenticateAadharMobileNumber extends StatefulWidget {
  final ProfileInfo profileInfo;
  final String newPhoneNumber;
  final Operation updateOperationType;
  final CustomerInfoArg customerInfoArg;

  const AuthenticateAadharMobileNumber({required this.profileInfo, required this.newPhoneNumber, required this.customerInfoArg, required this.updateOperationType, super.key});

  @override
  State<AuthenticateAadharMobileNumber> createState() =>
      _AuthenticateAadharMobileNumberState();
}

class _AuthenticateAadharMobileNumberState
    extends State<AuthenticateAadharMobileNumber> {
  ValueNotifier<bool> isValidated = ValueNotifier<bool>(false);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _aadharNumberController = TextEditingController();
  bool enableCheckbox = false;
  String? accessKey;
  String? caseId;
  int attemptCount = 0;

  @override
  void initState() {
    super.initState();
    if(widget.profileInfo.aadhaarNumber!=null && widget.profileInfo.aadhaarNumber!.isNotEmpty){
      _aadharNumberController.text = maskString(widget.profileInfo.aadhaarNumber!,MaskingFieldType.aadhaar);
    }
    else{
      _aadharNumberController.text = "";
    }
    

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: _buildAppBar(context),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state is EnterAadharConsentState) {
            enableCheckbox = state.isEnterAadharConsent;
            validateForm();
          }

          return _buildWidget(context);
        },
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return customAppbar(
        context: context,
        title: '',
        onPressed: () {
          Navigator.pop(context);
        },
        actions: [
          HelpCommonWidget(categoryval: HelpConstantData.subCategoryProfile,subCategoryval: HelpConstantData.subCategoryUpdateAadhaar,)
        ]);
  }

  Widget _buildWidget(BuildContext blocContext) {
    return MFGradientBackground(
      horizontalPadding: 16.h,
      child: Form(
        key: _formKey,
        child: BlocListener<ProfileCubit, ProfileState>(
          listener: (context, state) {
            if (state is GetAadhaarConsentSuccessState) {
              if (state.response.code == AppConst.codeSuccess) {

                var validateAadhaarDetail = ProfileExtras(
                    custName: widget.profileInfo.customerName ?? "",
                    newPhoneNumber: widget.newPhoneNumber,
                    aadhaarNumber: _aadharNumberController.text,
                    transactionId: state.response.transactionId,
                    operation: widget.updateOperationType);

                context.pushNamed(Routes.myProfileOtpScreen.name, extra: {
                  "otpScreenType": OtpScreenType.aadhaarOtp,
                  "mobileNumber": getPhoneNumber(),
                  "validateAadhaarDetail": validateAadhaarDetail,
                  "customerInfoArg": widget.customerInfoArg
                });
              } else {
                attemptCount++;
                if (attemptCount < ProfileConst.maxAadhaarAttempt) {
                    toastForFailureMessage(
                      context: context,
                      msg: getString(state.response.responseCode ?? lblErrorGeneric));
                }
                else
                {
                    context.pushNamed(
                    Routes.myProfileAuthenticateMobileNumber.name,
                    extra: {"newPhoneNumber": widget.newPhoneNumber , "isUserToCustomer" : true, "customerInfoArg" : widget.customerInfoArg, "updateOperation" : Operation.mapMyLoan});
                }
              }
            } else if (state is GetAadhaarConsentFailureState) {
              attemptCount++;
              if (attemptCount < ProfileConst.maxAadhaarAttempt) {
                  toastForFailureMessage(
                  context: context,
                  msg: getFailureMessage(state.failure));
              }
              else
              {
                  context.pushNamed(
                    Routes.myProfileAuthenticateMobileNumber.name,
                    extra: {"newPhoneNumber": widget.newPhoneNumber , "isUserToCustomer" : true, "customerInfoArg" : widget.customerInfoArg, "updateOperation" : Operation.mapMyLoan});
              }

            } else if (state is SentAadhaarOtpSuccessState) {
              if(state.response.code == AppConst.codeSuccess){
                var validateAadhaarDetail = ProfileExtras(custName: widget.profileInfo.customerName ?? "", newPhoneNumber: widget.newPhoneNumber, aadhaarNumber: _aadharNumberController.text);
                context.pushNamed(Routes.myProfileOtpScreen.name,
                    extra: {"otpScreenType": OtpScreenType.aadhaarOtp, "mobileNumber": getPhoneNumber(), "validateAadhaarDetail": validateAadhaarDetail, "customerInfoArg" : widget.customerInfoArg});
              } else {
                toastForFailureMessage(
                    context: context,
                    msg: state.response.responseCode ?? "");
              }
            } else if (state is SentAadhaarOtpFailureState) {
              toastForFailureMessage(
                  context: context,
                  msg: getFailureMessage(state.failure));
            }
            else if (state is ProfileLoadingState) {
              if (state.isloading) {
                showLoaderDialog(context, getString(lblLoading));
              } else {
                Navigator.of(context, rootNavigator: true).pop();
              }
            }
          },
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              getString(lblAuth),
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontSize: 20),
            ),
            SizedBox(height: 10.v),
            Text(
              getString(lblVerifyOption),
              style: Theme.of(context).textTheme.labelMedium,
            ),
            SizedBox(height: 20.v),
            _buildEnterAadharNumber(),
            SizedBox(height: 20.v),
            _buildCustomCheck(blocContext),
            const Spacer(),
            ValueListenableBuilder(
                valueListenable: isValidated,
                builder: (context, bool isValid, child) {
                  return MfCustomButton(
                outlineBorderButton: false,
                isDisabled: !isValid,
                onPressed: () async{
                  FocusManager.instance.primaryFocus?.unfocus();
                  String userAgent = await getUserAgent();
                  var aadhaarConsent = AadhaarConsentReq(
                    source: AppConst.source,
                    purpose: AppConst.updateMobileJourney,
                    userName: widget.profileInfo.customerName ?? "",
                    superAppId: getSuperAppId(),
                    aadhaarNo: _aadharNumberController.text,
                    userAgent: userAgent
                  );
                  BlocProvider.of<ProfileCubit>(context)
                      .getAadhaarConsent(aadhaarConsent);
                },
                text: getString(lblLoginGetOtp));}),
            SizedBox(height: 10.v),
            //TODO Currenlty out of scope
            // MfCustomButton(
            //     outlineBorderButton: true,
            //     isDisabled: false,
            //     onPressed: () {
            //
            //     },
            //     text: getString(lblVerifyDigilocker)),
          ],
        ),
),
      ),
    );
  }

  CustomCheckboxButton _buildCustomCheck(BuildContext blocContext) {
    return CustomCheckboxButton(
      activeColor: Theme.of(context).primaryColor,
      checkColor: Theme.of(context).scaffoldBackgroundColor,
      textAlignment: TextAlign.start,
      isExpandedText: true,
      alignment: Alignment.center,
      text: getString(lblEnterAadharConsent),
      value: enableCheckbox,
      textStyle: Theme.of(context).textTheme.labelMedium,
      onChange: (value) {
        blocContext.read<ProfileCubit>().enterAadharConsent(value);
      },
    );
  }

  Widget _buildEnterAadharNumber() {
    return MfCustomFloatingTextField(
      onChange: (value) {
        validateForm();
      },
      controller: _aadharNumberController,
      maxLength: 12,
      labelText: getString(lblEnterAadhar),
      textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: setColorBasedOnTheme(
            context: context,
            lightColor: AppColors.primaryLight,
            darkColor: AppColors.secondaryLight5,
          )),
      labelStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: setColorBasedOnTheme(
            context: context,
            lightColor: AppColors.primaryLight,
            darkColor: AppColors.secondaryLight5,
          )),
      validator: (value) {
        if (!isValidAadhaarNumber(value)) {
          return getString(enterValidAadhaarText);
        }
        return null;
      },
      borderDecoration: UnderlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(
          color: setColorBasedOnTheme(
            context: context,
            lightColor: AppColors.primaryLight,
            darkColor: AppColors.secondaryLight5,
          ),
          width: 1,
        ),
      ),
    );
  }

   validateForm(){
    if(isValidAadhaarNumber(_aadharNumberController.text) && enableCheckbox){
      isValidated.value = true;
    } else {
      isValidated.value = false;
    }
  }
}
