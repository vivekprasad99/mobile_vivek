import 'dart:io';

import 'package:auth/config/routes/route.dart';
import 'package:auth/features/login_and_registration/data/models/mpin_request.dart';
import 'package:auth/features/login_and_registration/presentation/cubit/auth_cubit.dart';
import 'package:auth/features/login_and_registration/presentation/cubit/auth_state.dart';
import 'package:auth/features/login_and_registration/presentation/login/widget/exit_pop.dart';
import 'package:auth/features/login_and_registration/presentation/login_wireframe/widgets/custom_pin_code_text_field.dart';
import 'package:common/features/language_selection/data/models/app_label_request.dart';
import 'package:common/features/language_selection/presentation/cubit/select_language_cubit.dart';
import 'package:common/features/language_selection/presentation/cubit/select_language_state.dart';
import 'package:common/features/startup/data/models/validate_device_response.dart';
import 'package:core/config/config.dart';
import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/widgets/background/mf_gradient_background.dart';
import 'package:core/config/widgets/mf_progress_bar.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:core/config/widgets/mf_toast.dart';
import 'package:core/utils/const.dart';
import 'package:core/utils/size_utils.dart';
import 'package:core/utils/helper/theme_helper.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/utils/pref_utils.dart';
import 'package:core/utils/utils.dart';
import 'package:core/utils/validation_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../login_wireframe/widgets/custom_elevated_button.dart';
import 'package:sfmc/sfmc.dart';
import 'package:help/features/utils/help_common_widget.dart';
import 'package:help/features/utils/constant_help.dart';
// ignore_for_file: must_be_immutable
class MPINScreen extends StatefulWidget {
  Profiles? currentProfile;
  MPINScreen({super.key, this.currentProfile});
  

  @override
  State<MPINScreen> createState() => _MPINScreenState();
}

class _MPINScreenState extends State<MPINScreen> {
  String? errorText;
  bool enableMpinBtn = false;
  bool exhaustedMpinAttempt = false;
  int currentAttempt = 0;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _mPinController = TextEditingController();

  final TextEditingController _confirmPinController = TextEditingController();


  @override
  void initState() {
    super.initState();
    if (PrefUtils.getInt(PrefUtils.keyAuthNavFlow, AuthNavFlow.register.value) == AuthNavFlow.register.value) {
      customShowToast(
          containerColor:Colors.white,
          msg:getString(msgSuccessRegistration).replaceAll("#&#", getUserName()),
          icon:Icons.check_circle_outline,
          iconColor:Colors.green,
          bottomPadding:45);
    }
  }
  setHeaderTitle(int value) {
    switch (value) {
      case 0:
        return getString(lblSetYourMpin);
      case 1:
        return getString(lblResetYourMpin);
      case 2:
        return getString(lblChangeYourMpin);
      default:
        return getString(lblSetYourMpin);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
        listeners: [
          BlocListener<SelectLanguageCubit, SelectLanguageState>(
            listener: (context, state) {
              if (state is AppLabelSuccess) {
                PrefUtils.removeData(PrefUtils.keyAuthNavFlow);
                context.goNamed(Routes.home.name);
              } else if (state is AppLabelFailure) {
                toastForFailureMessage(
                    context: context,
                    msg: getFailureMessage(state.error),
                    bottomPadding: 40.v);
              } else if (state is AppLabelLoadingState) {
                if (state.isloading) {
                  showLoaderDialog(context, getString(lblLoginLoading));
                } else {
                  Navigator.of(context, rootNavigator: true).pop();
                }
              }
            },
          ),
        BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is MPinSuccessState) {
              if (state.response.code == AppConst.codeSuccess) {
                if (PrefUtils.getInt(PrefUtils.keyAuthNavFlow, AuthNavFlow.register.value) ==
                    AuthNavFlow.register.value) {
                  SFMCSdk.setContactKey(getSuperAppId());
                  PrefUtils.removeData(PrefUtils.keyAuthNavFlow);
                  if (PrefUtils.getInt(PrefUtils.keyProfileCount, 0) >= 1) {
                      context.goNamed(Routes.login.name, extra: <Profiles>[]);
                    } else {
                      context.goNamed(Routes.biometric.name, extra: false);
                    }
                  } else if (PrefUtils.getInt(PrefUtils.keyAuthNavFlow, AuthNavFlow.register.value) ==
                    AuthNavFlow.forgotMpin.value) {
                  PrefUtils.removeData(PrefUtils.keyAuthNavFlow);
                  context.goNamed(Routes.login.name, extra: <Profiles>[]);
                } else if (PrefUtils.getInt(PrefUtils.keyAuthNavFlow, AuthNavFlow.register.value) ==
                    AuthNavFlow.changeMpin.value) {
                  toastForSuccessMessage(
                      context: context,
                      msg: getString(msgMpinChangeSuccess),
                      bottomPadding: 40.v);
                  PrefUtils.removeData(PrefUtils.keyAuthNavFlow);
                  context.goNamed(Routes.home.name);
                } else if (PrefUtils.getInt(PrefUtils.keyAuthNavFlow, AuthNavFlow.register.value) ==
                    AuthNavFlow.changeUserToCustomer.value) {
                  BlocProvider.of<AuthCubit>(context).getPostLoginToken(mobileNumber: getSuperAppId(), mPin: PrefUtils.getString(PrefUtils.keyMpin, ""), isFromDeleteProfile: false);
                } else {
                  PrefUtils.removeData(PrefUtils.keyAuthNavFlow);
                  context.goNamed(Routes.login.name, extra: <Profiles>[]);
                }
              } else {
                currentAttempt++;
                if(currentAttempt < getCreateMpinMaxAttempt()) {
                  toastForFailureMessage(
                      context: context,
                      msg: getString(lblLoginErrorGeneric),
                      bottomPadding: 40.v);
                } else {
                  displayAlertSingleAction(context,
                      getString(msgSetMpinError),
                      btnLbl: getString(lblLoginOk), btnTap: () {
                        exhaustedMpinAttempt = true;
                        BlocProvider.of<AuthCubit>(context)
                            .validateMPINButton(false);
                      });
                }
              }
            } else if (state is MPinFailureState) {
              errorText = (state.error as ServerFailure).message.toString();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(errorText!),
                backgroundColor: Colors.black,
              ));
            } else if (state is LoadingState) {
              if (state.isloading) {
                showLoaderDialog(context, getString(lblLoginLoading));
              } else {
                Navigator.of(context, rootNavigator: true).pop();
              }
            } else if (state is PostLoginTokenSuccessState) {
              PrefUtils.saveString(PrefUtils.keyToken, state.response.accessToken ?? "");
              if(getSelectedLanguage()== widget.currentProfile?.languageCode){
                PrefUtils.removeData(PrefUtils.keyAuthNavFlow);
                context.goNamed(Routes.home.name);
              } else {
                setSelectedLanguage(widget.currentProfile?.languageCode);
                var request = AppLabelRequest(langCode: widget.currentProfile?.languageCode);
                context.read<SelectLanguageCubit>().getAppLabels(request);
              }
            } else if (state is PostLoginTokenFailureState) {
              if (state.error is ServerFailure) {
                displayAlert(context, (state.error as ServerFailure).message.toString());
              } else {
                displayAlert(context, state.error.toString());
              }
            }
          },),
        ],
        child: SafeArea(
        child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          resizeToAvoidBottomInset: false,
        appBar: AppBar(
          toolbarHeight: 64.h,
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          automaticallyImplyLeading: false,
          elevation: 0.0,
          leading: IconButton(
              icon: Icon(Icons.arrow_back,
                  color: Theme.of(context).highlightColor),
              onPressed: () {
                if (PrefUtils.getInt(PrefUtils.keyAuthNavFlow, AuthNavFlow.register.value) != AuthNavFlow.register.value) {
                      context.pop();
                    } else {
                      showExitPopUp(context, () {
                        WidgetsBinding.instance
                            .addPostFrameCallback((_) => exit(0));
                      });
                    }
                  }),
          actions: [HelpCommonWidget(categoryval: HelpConstantData.categoryRegistration,subCategoryval: HelpConstantData.subCategoryMpin)],
        ),
        body: SizedBox(
          width: SizeUtils.width,
          child: BlocBuilder<AuthCubit, AuthState>(
            buildWhen: (context, state) {
              return state is MPinSuccessState || state is MPinFailureState;
            },
            builder: (context, state) {
              return Form(
                key: _formKey,
                child: MFGradientBackground(
                  horizontalPadding: 16.h,
                  verticalPadding: 1.v,

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10.v),
                      Text(setHeaderTitle(
                          PrefUtils.getInt(PrefUtils.keyAuthNavFlow, AuthNavFlow.register.value)),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 20),
                      ),
                      SizedBox(height: 20.v),
                      Text(getString(lblEnter4DigitMpin),
                        style: Theme.of(context)
                            .textTheme.bodySmall?.copyWith(
                            color: setColorBasedOnTheme(
                              context: context,
                              lightColor: AppColors.primaryLight,
                              darkColor: AppColors.secondaryLight5,
                            )
                        ),
                      ),
                      SizedBox(height: 10.v),

                      SizedBox(
                        width: 240.h,
                        child: CustomPinCodeTextField(
                            length: 4,
                            alignment: Alignment.topLeft,
                            textStyle: Theme.of(context).textTheme.titleSmall,
                            context: context,
                            controller: _mPinController,
                            onChanged: (value) {
                              final bool isMPinInitialState =
                              checkMpinIntialState(value);
                              _mPinController.text = value;
                              final bool isValidFirstThreeDigit =
                              checkFirstThirdDigit(value);
                              final bool isValidLastThreeDigit =
                              checkLastThreeDigit(value);
                              final bool isValidSequential =
                              checkSequential(value);
                              BlocProvider.of<AuthCubit>(context)
                                  .validateMPINText(isValidFirstThreeDigit,
                                  isValidLastThreeDigit, isValidSequential,isMPinInitialState);
                              if (isValidFirstThreeDigit ||
                                  isValidLastThreeDigit ||
                                  isValidSequential) {
                                BlocProvider.of<AuthCubit>(context)
                                    .validateMPINButton(false);
                              } else {
                                BlocProvider.of<AuthCubit>(context)
                                    .validateMPINButton(
                                    _confirmPinController.text.length == 4
                                        ? true
                                        : false);
                              }
                              return null;
                            }),
                      ),

                      SizedBox(height: 3.v),
                      _buildErrorWidget(),
                      SizedBox(height: 22.v),
                      Text(getString(lblReEnter4DigitMpin),
                          style: Theme.of(context)
                              .textTheme.bodySmall?.copyWith(
                              color: setColorBasedOnTheme(
                                context: context,
                                lightColor: AppColors.primaryLight,
                                darkColor: AppColors.secondaryLight5,
                              ))),
                      SizedBox(height: 10.v),
                      SizedBox(
                        width: 240.h,
                        child: CustomPinCodeTextField(
                          length: 4,
                          alignment: Alignment.topLeft,
                          textStyle: Theme.of(context).textTheme.titleSmall,
                          context: context,
                          controller: _confirmPinController,
                          onChanged: (value) {
                            if (value.length >= 4 &&
                                _confirmPinController.text.length >= 4) {
                              final bool isValidFirstThreeDigit =
                              checkFirstThirdDigit(_mPinController.text);
                              final bool isValidLastThreeDigit =
                              checkLastThreeDigit(_mPinController.text);
                              final bool isValidSequential =
                              checkSequential(_mPinController.text);
                              if (!isValidFirstThreeDigit ||
                                  !isValidLastThreeDigit ||
                                  !isValidSequential) {
                                BlocProvider.of<AuthCubit>(context)
                                    .validateMPINButton(false);
                              } else {
                                BlocProvider.of<AuthCubit>(context)
                                    .validateMPINButton(true);
                              }
                            } else {
                              BlocProvider.of<AuthCubit>(context)
                                  .validateMPINButton(false);
                            }
                          },
                          validator: (value) {
                            if (value == null || (!isValiPIN(value))) {
                              return getString(errMsgPleaseEnterValidPin);
                            } else if (!_isPinMatch(_mPinController.text,
                                _confirmPinController.text)) {
                              return getString(errorMsgNotMatch);
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 24.v),
                      const Expanded(child: SizedBox()),
                      _buildMPINButton(),
                      SizedBox(height: 20.v),
                      Padding(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom))
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    ));
  }

  bool _isPinMatch(String pin, String confirmpin) {
    return pin == confirmpin;
  }

  Widget _buildErrorWidget() {
    return BlocBuilder<AuthCubit, AuthState>(
      buildWhen: (context, state) {
        return state is MPINValidateTextState;
      },
      builder: (context, state) {
        return Container(
          margin: EdgeInsets.only(left: 3.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    state is MPINValidateTextState
                        ? state.isValidFirstThreeDigit
                            ? Icons.check_circle_outline
                            : Icons.cancel_outlined
                        : Icons.cancel_outlined,
                    color: state is MPINValidateTextState
                        ? state.isMPinInitialState
                            ? Theme.of(context).primaryColorDark
                            : state.isValidFirstThreeDigit
                                ? Colors.green
                                : Colors.red
                        : Theme.of(context).primaryColorDark,
                    size: 15,
                  ),
                  SizedBox(width: 5.h),
                  Text(
                    getString(msg1),
                    overflow: TextOverflow.ellipsis,
                    style:
                    state is MPINValidateTextState?
                    state.isMPinInitialState ? Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: appTheme.gray800,
                    )  :
                    state.isValidFirstThreeDigit?Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Colors.green,
                    ):Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: appTheme.red900,
                    ):
                    Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: appTheme.gray800,
                    )
                  )
                ],
              ),
              Row(
                children: [
                  Icon(
                    state is MPINValidateTextState
                        ? state.isValidLastThreeDigit
                            ? Icons.check_circle_outline
                            : Icons.cancel_outlined
                        : Icons.cancel_outlined,
                    color: state is MPINValidateTextState
                        ? state.isMPinInitialState
                            ?  Theme.of(context).primaryColorDark
                            : state.isValidLastThreeDigit
                                ? Colors.green
                                : Colors.red
                        :  Theme.of(context).primaryColorDark,
                    size: 15,
                  ),
                  SizedBox(width: 5.h),
                  Text(
                    getString(msg2),
                    overflow: TextOverflow.ellipsis,
                      style:
                      state is MPINValidateTextState?
                      state.isMPinInitialState ? Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: appTheme.gray800,
                      )  :
                      state.isValidLastThreeDigit?Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Colors.green,
                      ):Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: appTheme.red900,
                      ):
                      Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: appTheme.gray800,
                      )
                  )
                ],
              ),
              Row(
                children: [
                  Icon(
                    state is MPINValidateTextState
                        ? state.isValidSequential
                            ? Icons.check_circle_outline
                            : Icons.cancel_outlined
                        : Icons.cancel_outlined,
                    color: state is MPINValidateTextState
                        ? state.isMPinInitialState
                            ? Theme.of(context).primaryColorDark
                            : state.isValidSequential
                                ? Colors.green
                                : Colors.red
                        : Theme.of(context).primaryColorDark,
                    size: 15,
                  ),
                  SizedBox(width: 5.h),
                  Text(
                    getString(msg3),
                    overflow: TextOverflow.ellipsis,
                      style:
                      state is MPINValidateTextState?
                      state.isMPinInitialState ? Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: appTheme.gray800,
                      )  :
                      state.isValidSequential?Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Colors.green,
                      ):Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: appTheme.red900,
                      ):
                      Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: appTheme.gray800,
                      )
                  )
                ],
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildMPINButton() {

    return BlocConsumer<AuthCubit, AuthState>(buildWhen: (context, state) {
      return state is AuthInitialState ||
          state is MPINValidateState;
    }, listener: (context, state) {
      if (state is MPINValidateState) {
        enableMpinBtn = state.isValid;
      }
    }, builder: (context, state) {
      return AbsorbPointer(
          absorbing: !(enableMpinBtn && exhaustedMpinAttempt == false),
          child: Align(
              alignment: Alignment.center,
              child: CustomElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    FocusManager.instance.primaryFocus?.unfocus();
                    var request = MPinRequest(
                        mPin: _mPinController.text,
                        source: AppConst.source,
                        superAppId: getSuperAppId());
                    BlocProvider.of<AuthCubit>(context).createMPin(request);
                  }
                },
                width: double.maxFinite,
                text: (state is LoadingState && state.isloading)
                    ? getString(lblVerifying)
                    : getString(lblLoginVerify),
                margin: EdgeInsets.symmetric(horizontal: 3.h),
                buttonStyle: ElevatedButton.styleFrom(
                    backgroundColor: (enableMpinBtn && exhaustedMpinAttempt == false)
                        ? Theme.of(context).highlightColor
                        : Theme.of(context).disabledColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.h),
                    )),
                buttonTextStyle: (enableMpinBtn && exhaustedMpinAttempt == false)
                    ? Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: AppColors.white)
                    : Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).unselectedWidgetColor),

              )));
    });
  }

  @override
  void dispose() {
    _mPinController.dispose();
    _confirmPinController.dispose();
    super.dispose();
  }
}
