import 'package:auth/config/routes/route.dart';
import 'package:auth/features/login_and_registration/presentation/cubit/auth_cubit.dart';
import 'package:auth/features/login_and_registration/presentation/login_wireframe/widgets/custom_floating_text_field.dart';
import 'package:common/features/startup/data/models/validate_device_response.dart';
import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/config/widgets/background/mf_gradient_background.dart';
import 'package:core/config/widgets/mf_progress_bar.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:core/config/widgets/mf_toast.dart';
import 'package:core/utils/const.dart';
import 'package:core/utils/helper/theme_helper.dart';
import 'package:core/utils/pref_utils.dart';
import 'package:core/utils/size_utils.dart';
import 'package:core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../data/models/register_user_request.dart';
import '../cubit/auth_state.dart';
import '../login_wireframe/widgets/custom_elevated_button.dart';
import 'package:help/features/utils/help_common_widget.dart';
import 'package:help/features/utils/constant_help.dart';

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({super.key});

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  bool enableVerifyBtn = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(builder: (context, state) {
      return SafeArea(
        child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            toolbarHeight: 64.h,
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            leading: IconButton(
                icon: Icon(Icons.arrow_back,
                    color: Theme.of(context).highlightColor),
                onPressed: () {
                  _showExitPopUp(context);
                }),
            elevation: 0.0,
            actions: [HelpCommonWidget(categoryval: HelpConstantData.categoryRegistration,subCategoryval: HelpConstantData.subCategoryName)],
          ),
          body: MFGradientBackground(
            horizontalPadding: 1.0,
            verticalPadding: 0.0,
            child: SizedBox(
              width: SizeUtils.width,
              child: Form(
                key: _formKey,
                child: Container(
                  width: double.maxFinite,
                  padding: EdgeInsets.symmetric(horizontal: 16.h),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          getString(tellUsAboutYourself),
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(fontSize: 20),
                        ),
                      ),
                      SizedBox(height: 20.v),
                      CustomFloatingTextField(
                        onChange: (value) {
                          value.isEmpty
                              ? BlocProvider.of<AuthCubit>(context)
                                  .validateUserInfo(false)
                              : BlocProvider.of<AuthCubit>(context)
                                  .validateUserInfo(true);
                        },
                        controller: _firstNameController,
                        textStyle:
                            Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: setColorBasedOnTheme(
                                  context: context,
                                  lightColor: AppColors.primaryLight,
                                  darkColor: AppColors.secondaryLight5,
                                )),
                        labelStyle:
                            Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: setColorBasedOnTheme(
                                  context: context,
                                  lightColor: AppColors.primaryLight,
                                  darkColor: AppColors.secondaryLight5,
                                )),
                        labelText: getString(lblHintEnterFirstName),
                        textInputAction: TextInputAction.next,
                        textInputType: TextInputType.name,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return getString(lblErrorEnterFirstName);
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
                      ),
                      SizedBox(height: 24.v),
                      const Expanded(child: SizedBox()),
                      _buildVerifyButton(),
                      SizedBox(height: 20.v),
                      Padding(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom))
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }, listener: (context, state) {
      if (state is UserInfoSuccessState) {
        if (state.response.code == AppConst.codeSuccess) {
          PrefUtils.saveString(PrefUtils.keySuperAppId, state.response.superAppId ?? "");
          PrefUtils.saveString(PrefUtils.keyUserName, state.userFullName);
          context.goNamed(Routes.mpin.name, extra: Profiles());
        } else {
          context.goNamed(Routes.registerStatus.name,
              pathParameters: {'registerStatus': "false"});
        }
      } else if (state is UserInfoFailureState) {
        toastForFailureMessage(
            context: context,
            msg: getFailureMessage(state.failure),
            bottomPadding: 40.v);
      } else if (state is LoadingState) {
        if (state.isloading) {
          showLoaderDialog(context, getString(lblLoginLoading));
        } else {
          Navigator.of(context, rootNavigator: true).pop();
        }
      }
    });
  }

  Widget _buildVerifyButton() {
    return BlocConsumer<AuthCubit, AuthState>(buildWhen: (context, state) {
      return state is UserInfoValidateState || state is LoadingState;
    }, listener: (context, state) {
      if (state is UserInfoValidateState) {
        enableVerifyBtn = state.isValid;
      }
    }, builder: (context, state) {
      return AbsorbPointer(
          absorbing: !enableVerifyBtn,
          child: Align(
              alignment: Alignment.center,
              child: CustomElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    FocusManager.instance.primaryFocus?.unfocus();
                    var request = RegisterUserRequest(
                        userFullName: _firstNameController.text,
                        mobileNumber: getPhoneNumber(),
                        source: AppConst.source,
                        ucic: "",
                        languageCode: getSelectedLanguage(),
                        deviceId: getDeviceId());
                    BlocProvider.of<AuthCubit>(context).registerUser(request, _firstNameController.text, "");
                  }
                },
                width: double.maxFinite,
                text: (state is LoadingState && state.isloading)
                    ? getString(lblVerifying)
                    : getString(lblLoginContinue),
                margin: EdgeInsets.symmetric(horizontal: 3.h),
                buttonStyle: ElevatedButton.styleFrom(
                    backgroundColor: enableVerifyBtn
                        ? Theme.of(context).highlightColor
                        : Theme.of(context).disabledColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.h),
                    )),
                buttonTextStyle: enableVerifyBtn
                    ? Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: AppColors.white)
                    : Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).unselectedWidgetColor),
              )));
    });
  }

  _showExitPopUp(BuildContext context) {
    showModalBottomSheet<void>(
      isScrollControlled: true,
      backgroundColor: Theme.of(context).cardColor,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.0)),
      ),
      builder: (BuildContext context) {
        return SizedBox(
          height: 230.h,
          child: Center(
            child: _buildExitPopup(context),
          ),
        );
      },
    );
  }

  Widget _buildExitPopup(BuildContext context) {
    return Container(
      width: double.maxFinite,
      color: Theme.of(context).cardColor,
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
                getString(warnBackBtnTitle),
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ),
          SizedBox(height: 20.v),
          Expanded(
              child: Text(
            getString(warnBackBtnDesc),
            style: Theme.of(context).textTheme.labelMedium,
          )),
          SizedBox(height: 12.v),
          _buildBottomButton(context)
        ],
      ),
    );
  }

  Widget _buildBottomButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 3.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              width: 166.v,
              height: 42.h,
              child: ElevatedButton(
                  onPressed: () {
                    context.goNamed(Routes.mobileOtp.name);
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Theme.of(context).cardColor),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              side: BorderSide(
                                  color: setColorBasedOnTheme(
                                context: context,
                                lightColor: AppColors.secondaryLight,
                                darkColor: AppColors.secondaryLight5,
                              ))))),
                  child: Text(getString(lblBack),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: setColorBasedOnTheme(
                            context: context,
                            lightColor: AppColors.secondaryLight,
                            darkColor: AppColors.secondaryLight5,
                          )))
                  //  margin: EdgeInsets.symmetric(horizontal: 3.h),
                  )),
          SizedBox(
            width: 166.v,
            height: 42.h,
            child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        Theme.of(context).highlightColor),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side: BorderSide(
                                color: Theme.of(context).highlightColor)))),
                child: Text(getString(lblStay),
                    textAlign: TextAlign.start,
                    maxLines: 1,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: AppColors.white))),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    super.dispose();
  }
}
