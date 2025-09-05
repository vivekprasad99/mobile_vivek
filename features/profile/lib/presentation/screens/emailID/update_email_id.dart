import 'package:auth/features/mobile_otp/data/models/send_email_otp_request.dart';
import 'package:auth/features/mobile_otp/presentation/cubit/phone_validate_cubit.dart';
import 'package:auth/features/mobile_otp/presentation/cubit/phone_validate_state.dart';
import 'package:core/config/widgets/common_widgets/custom_checkbox_button.dart';
import 'package:core/config/widgets/common_widgets/custom_floating_text_field.dart';
import 'package:core/config/widgets/mf_progress_bar.dart';
import 'package:core/config/widgets/mf_toast.dart';
import 'package:core/utils/const.dart';
import 'package:core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:help/features/utils/constant_help.dart';
import 'package:help/features/utils/help_common_widget.dart';
import 'package:core/config/resources/app_colors.dart';

import 'package:core/config/widgets/mf_appbar.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:core/utils/size_utils.dart';

import 'package:core/utils/validation_functions.dart';
import 'package:core/config/widgets/background/mf_gradient_background.dart';
import 'package:core/config/widgets/custom_buttons/mf_custom_elevated_button.dart';
import 'package:core/config/string_resource/Strings.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:profile/config/routes/route.dart';
import 'package:profile/data/models/my_profile_model_response.dart';
import 'package:profile/presentation/cubit/profile_cubit.dart';
import 'package:common/features/search/data/model/search_response.dart';

import '../../../data/models/customer_info_args.dart';
import '../../../data/models/validate_aadhaar_detail.dart';
import '../../../utils/utils.dart';

class UpdateEmailID extends StatefulWidget {
  final ServicesNavigationRequest? data;

  const UpdateEmailID({super.key, @required this.data});

  @override
  State<UpdateEmailID> createState() => _UpdateEmailIDState();
}

class _UpdateEmailIDState extends State<UpdateEmailID> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _emailIDController = TextEditingController();
  bool enableCheckbox = false;
  @override
  void initState() {
    if (widget.data?.myProfileResponse?.emailID != null) {
      _emailIDController = TextEditingController(
          text: widget.data?.myProfileResponse?.emailID);
    } else {
      _emailIDController = TextEditingController(text: "");
    }
    super.initState();
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
              Navigator.pop(context);
            },
            actions: [
              HelpCommonWidget(categoryval: HelpConstantData.subCategoryProfile,subCategoryval: HelpConstantData.subCategoryDetails,)
            ]),
        body: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            if (state is EmailConsentState) {
              enableCheckbox = state.isEmailConsent;
            }

            return _buildWidget(widget.data?.myProfileResponse, context);
          },
        ));
  }

  Widget _buildWidget(ProfileInfo? myProfileResponse, BuildContext blocContext) {
    return MFGradientBackground(
      horizontalPadding: 16.h,
      child: Form(
        key: _formKey,
        child: BlocListener<PhoneValidateCubit, MobileOtpState>(
          listener: (context, state) {
            if(state is ApiLoadingState) {
              if (state.isloading) {
                showLoaderDialog(context, getString(lblLoading));
              } else {
                Navigator.of(context, rootNavigator: true).pop();
              }
            } else if(state is SendEmailOtpSuccess){
              if(state.response.code == AppConst.codeSuccess){
                context.pushNamed(Routes.myProfileOtpScreen.name,
                    extra: {"otpScreenType": OtpScreenType.emailOtp, "mobileNumber":_emailIDController.text, "validateAadhaarDetail": ProfileExtras(oldEmailId: widget.data?.myProfileResponse?.emailID ?? "", newEmail: _emailIDController.text, operation: Operation.updateEmail, custName: widget.data?.myProfileResponse?.customerName), "customerInfoArg" : CustomerInfoArg()});
              } else {
                toastForFailureMessage(
                    context: context,
                    msg: getString(state.response.responseCode ?? lblErrorGeneric));
              }
            } else if(state is SendEmailOtpFailure){
              toastForFailureMessage(
                  context: context,
                  msg: getFailureMessage(state.error));
            }
          },
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              getString(lblUpdateEmailID),
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontSize: 20),
            ),
            SizedBox(height: 20.v),
            _buildEnterEmailID(myProfileResponse),
            SizedBox(height: 20.v),
            _buildCustomCheck(blocContext),
            const Spacer(),
            MfCustomButton(
                outlineBorderButton: false,
                isDisabled: !enableCheckbox,
                onPressed: () {
                  if (_formKey.currentState!.validate() &&
                      _emailIDController.text.isNotEmpty &&
                      enableCheckbox) {
                    FocusManager.instance.primaryFocus?.unfocus();
                    var request = SendEmailOtpRequest(source: AppConst.source,email: _emailIDController.text, superAppId: getSuperAppId(),journey: AppConst.updateEmailJourney);
                    context
                        .read<PhoneValidateCubit>()
                        .sendEmailOtp(request);
                    // context.pushNamed(
                    //   Routes.myProfileOtpScreen.name,
                    //   extra: OtpScreenExtrasModel(
                    //       otpScreenType: "email_otp",
                    //       emailId: _emailIDController.text),
                    // );
                  }
                },
                text: getString(lblGetOtp)),
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
      text: getString(lblEmailIDConsent),
      value: enableCheckbox,
      textStyle: Theme.of(context).textTheme.labelSmall,
      onChange: (value) {
        blocContext.read<ProfileCubit>().updateEmailConsent(value);
      },
    );
  }

  Widget _buildEnterEmailID(ProfileInfo? myProfileResponse) {
    return MfCustomFloatingTextField(
      onChange: (value) {},
      controller: _emailIDController,
      labelText: getString(lblEnterEmailID),
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
        if (!isValidEmail(value)) {
          return getString(enterValidEmail);
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
}
