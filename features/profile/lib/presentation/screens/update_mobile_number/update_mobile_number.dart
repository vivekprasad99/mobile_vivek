import 'package:auth/features/mobile_otp/data/models/send_otp_request.dart';
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
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:profile/config/routes/route.dart';
import 'package:profile/data/models/my_profile_model_request.dart';
import 'package:profile/data/models/my_profile_model_response.dart';
import 'package:profile/data/models/validate_aadhaar_detail.dart';
import 'package:profile/presentation/cubit/profile_cubit.dart';
import 'package:common/features/search/data/model/search_response.dart';

import '../../../data/models/customer_info_args.dart';
import '../../../utils/utils.dart';

class UpdateMobileNumber extends StatefulWidget {
  final ServicesNavigationRequest? data;
  final String? updateOperationType;

  const UpdateMobileNumber({super.key, @required this.data, @required this.updateOperationType});

  @override
  State<UpdateMobileNumber> createState() => _UpdateMobileNumberState();
}

class _UpdateMobileNumberState extends State<UpdateMobileNumber> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _mobileNumController = TextEditingController();
  bool enableCheckbox = false;
  @override
  void initState() {
    if (widget.data?.isFromSearch ?? false) {
      callProfileAPI();
    } else {
      if (widget.data?.myProfileResponse?.mobileNumber != null) {
        _mobileNumController = TextEditingController(
            text: widget.data?.myProfileResponse?.mobileNumber);
      } else {
        _mobileNumController = TextEditingController(text: "");
      }
    }
    super.initState();
  }

  callProfileAPI() async {
    BlocProvider.of<ProfileCubit>(context).getMyProfile(MyProfileRequest(
        ucic: getUCIC(), superAppId: getSuperAppId(), source: AppConst.source));
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
              HelpCommonWidget(categoryval: HelpConstantData.subCategoryProfile,subCategoryval: HelpConstantData.categoryUpdateMobile,)
            ]),
        body: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoadingState) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is MyProfileSuccessState) {
              widget.data?.myProfileResponse = state.response.data;
              _mobileNumController = TextEditingController(
                  text: widget.data?.myProfileResponse?.mobileNumber);
            }
            if (state is MobileConsentState) {
              enableCheckbox = state.isMobileConsent;
            }
            return _buildWidget(widget.data?.myProfileResponse, context);
          },
        ));
  }

  Widget _buildWidget(
      ProfileInfo? myProfileResponse, BuildContext blocContext) {
    return MFGradientBackground(
      horizontalPadding: 16.h,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              getString(lblUpdateMobileNumber),
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontSize: 20),
            ),
            SizedBox(height: 20.v),
            _buildUpdateMobileNumber(),
            SizedBox(height: 20.v),
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
              child: _buildCustomCheck(blocContext)),
            const Spacer(),
            BlocListener<PhoneValidateCubit, MobileOtpState>(
              listener: (context, state) {
                if (state is SendOtpSuccess) {
                  if (state.response.code == AppConst.codeSuccess) {
                    context.pushNamed(Routes.myProfileOtpScreen.name, extra: {
                      "otpScreenType": OtpScreenType.mobileOtp,
                      "mobileNumber": getPhoneNumber(),
                      "validateAadhaarDetail": ProfileExtras(
                          newPhoneNumber: _mobileNumController.text,
                          operation: widget.updateOperationType == Operation.mapMyLoan.value? Operation.mapMyLoan : Operation.updatePhoneNumber,
                          custName:
                              widget.data?.myProfileResponse?.customerName),
                      "customerInfoArg" : widget.data?.customerInfoArg ?? CustomerInfoArg()
                    });
                  } else {
                    toastForFailureMessage(
                        context: context,
                        msg: state.response.message ?? "",
                        bottomPadding: 40.v);
                  }
                } else if (state is SendOtpFailure) {
                  toastForFailureMessage(
                      context: context,
                      msg: getFailureMessage(state.error),
                      bottomPadding: 40.v);
                } else if (state is ApiLoadingState) {
                  if (state.isloading) {
                    showLoaderDialog(context, getString(lblLoading));
                  } else {
                    Navigator.of(context, rootNavigator: true).pop();
                  }
                }
              },
              child: MfCustomButton(
                  outlineBorderButton: false,
                  isDisabled: !enableCheckbox,
                  onPressed: () {
                    if (_formKey.currentState!.validate() &&
                        _mobileNumController.text.isNotEmpty &&
                        enableCheckbox) {
                      FocusManager.instance.primaryFocus?.unfocus();
                      SendOtpRequest sendOtpRequest = SendOtpRequest(
                          mobileNumber: _mobileNumController.text,
                          source: AppConst.source,
                          journey: widget.updateOperationType == Operation.mapMyLoan.value
                              ? AppConst.mapMyLoanMobileJourney
                              : AppConst.updateMobileJourney,
                          tncFlag: 1,
                          otpResend: false,
                          superAppId: getSuperAppId());
                      BlocProvider.of<PhoneValidateCubit>(context)
                          .sendOtp(sendOtpRequest, isFromResend: false);
                    }
                  },
                  text: getString(lblGetOtp)),
            ),
          ],
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
      text: getString(lblMobileNumberConsent),
      value: enableCheckbox,
      textStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
        fontSize: 15
      ),
      onChange: (value) {
        blocContext.read<ProfileCubit>().updateMobileConsent(value);
      },
    );
  }

  Widget _buildUpdateMobileNumber() {
    return MfCustomFloatingTextField(
      onChange: (value) {},
      autofocus: false,
      maxLength: 10,
      isReadOnly: widget.updateOperationType == Operation.mapMyLoan.value ? true : false,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly
      ],
      textInputAction: TextInputAction.done,
      textInputType: TextInputType.phone,
      controller: _mobileNumController,
      labelText: getString(lblEnterMobileNumber),
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
        if (value!.length != 10) {
          return getString(lblErrorEnterPhoneNumberLength);
        } else if (!isValidPhoneNumber(value)) {
          return getString(lblErrorEnterPhoneNumber);
        } else {
          getString(lblErrorInvalidPhoneNumber);
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
