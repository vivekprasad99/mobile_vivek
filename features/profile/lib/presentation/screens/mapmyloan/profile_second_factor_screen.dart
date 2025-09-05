
import 'package:auth/features/login_and_registration/data/models/authentication_request.dart';
import 'package:auth/features/login_and_registration/data/models/authentication_ucic_request.dart';
import 'package:auth/features/login_and_registration/presentation/cubit/auth_cubit.dart';
import 'package:auth/features/login_and_registration/presentation/cubit/auth_state.dart';
import 'package:auth/features/login_and_registration/presentation/login/auth_enum.dart';
import 'package:auth/features/login_and_registration/presentation/login/second_factor_argument.dart';
import 'package:auth/features/login_and_registration/presentation/login/second_factor_auth_header.dart';
import 'package:auth/features/login_and_registration/presentation/login_wireframe/widgets/custom_checkbox_button.dart';
import 'package:auth/features/login_and_registration/presentation/login_wireframe/widgets/custom_elevated_button.dart';
import 'package:auth/features/login_and_registration/presentation/login_wireframe/widgets/custom_floating_text_field.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:common/features/search/data/model/search_response.dart';
import 'package:core/config/managers/quick_action_manager.dart';
import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/config/widgets/background/mf_gradient_background.dart';
import 'package:core/config/widgets/common_widgets/mf_custom_text_field.dart';
import 'package:core/config/widgets/custom_buttons/mf_custom_elevated_button.dart';
import 'package:core/config/widgets/mf_progress_bar.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:core/config/widgets/mf_toast.dart';
import 'package:core/utils/const.dart';
import 'package:core/utils/pref_utils.dart';
import 'package:core/utils/size_utils.dart';
import 'package:core/utils/utils.dart';
import 'package:core/utils/validation_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:help/features/utils/constant_help.dart';
import 'package:help/features/utils/help_common_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:profile/config/routes/route.dart';
import 'package:profile/data/models/customer_info_args.dart';
import 'package:profile/presentation/screens/mapmyloan/profile_second_factor_arg.dart';
import 'package:common/config/routes/route.dart' as common_routes;
import 'package:profile/utils/utils.dart';

import '../../../data/models/my_profile_model_response.dart';

// ignore_for_file: must_be_immutable
class ProfileSecondFactorScreen extends StatefulWidget {
  int? authType;
  ProfileSecondFactorArg? extras;
  ProfileSecondFactorScreen({super.key, this.authType, this.extras});

  @override
  State<ProfileSecondFactorScreen> createState() => _ProfileSecondFactorScreenState();
}

class _ProfileSecondFactorScreenState extends State<ProfileSecondFactorScreen> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _enterDOBController = TextEditingController();
  List<DateTime?> _singleDatePickerValueWithDefaultValue = [
    DateTime.now().add(const Duration(days: 1)),
  ];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String errorText = "";
  bool enableCheckbox = false;
  bool isVerifyBtnEnable = false;
  bool isPanUser = false;
  late BuildContext _blocContext;
  int currentAttempt=0;
  ValueNotifier<bool> isValidated = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    if (getUserRegisterStatus() == UserRegStatus.pan) {
      isPanUser = true;
    } else {
      isPanUser = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    _blocContext = context;
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthenticationSuccessState) {
              if (state.response.code == AppConst.codeSuccess) {
                var customerInfo = CustomerInfoArg(userFullName: state.response.userFullName, ucic:  state.response.ucic, lanAsPerDataLake:  state.response.lanAsPerDataLake, panAsPerDataLake:  state.response.panAsPerDataLake);
                context.pushNamed(Routes.myProfileUpdateMobileNumber.name,
                    pathParameters: {'updateOperationType': Operation.mapMyLoan.value},
                    extra: ServicesNavigationRequest(myProfileResponse: widget.extras?.profileInfo ?? ProfileInfo(), customerInfoArg: customerInfo)
                        .toJson());
              } else {
                currentAttempt++;
                if (currentAttempt < getPanLanMaxAttempt()) {
                  errorText = getString(state.response.responseCode ?? msgSomethingWentWrong);
                  _formKey.currentState?.validate();
                  BlocProvider.of<AuthCubit>(context).validateAuthInput(true);
                } else {
                  if (PrefUtils.getBool(PrefUtils.keyIsMultipleUCIC, false)) {
                    currentAttempt = 0;
                    SecondFactorAuthArg arg = SecondFactorAuthArg(
                        isMultipleUCIC: true,
                        prePopulatedAuthNumber: _controller.text,
                        headerDesc: state.response.message!, currentProfile: widget.extras?.currentProfile);
                    if (widget.authType == AuthType.account.value) {
                      context.pushReplacementNamed(Routes.profilesecondfactor.name,
                          pathParameters: {
                            'authType': AuthType.pan.value.toString(),
                            'mobileNumber': getPhoneNumber()
                          },
                          extra: arg);
                    } else {
                      context.pushReplacementNamed(Routes.profilesecondfactor.name,
                          pathParameters: {
                            'authType': AuthType.account.value.toString(),
                            'mobileNumber': getPhoneNumber(),
                          },
                          extra: arg);
                    }
                  } else {
                    errorText = "";
                    _formKey.currentState?.validate();
                    Navigator.of(context).popUntil(ModalRoute.withName(
                        common_routes.Routes.home.name));
                    context.pushNamed(Routes.myProfileData.name);
                  }
                }
              }
            } else if (state is AuthenticationFailureState) {
              BlocProvider.of<AuthCubit>(context).validateAuthInput(true);
              toastForFailureMessage(
                  context: context,
                  msg: getFailureMessage(state.error),
                  bottomPadding: 40.v);
            } else if (state is AuthenticateMultiUcicSuccessState) {
              if (state.response.code == AppConst.codeSuccess) {
                var customerInfo = CustomerInfoArg(userFullName: state.response.userFullName, ucic:  state.response.ucic, lanAsPerDataLake:  state.response.lanAsPerDataLake, panAsPerDataLake:  state.response.panAsPerDataLake);
                context.pushNamed(Routes.myProfileUpdateMobileNumber.name,
                    pathParameters: {'updateOperationType': Operation.mapMyLoan.value},
                    extra: ServicesNavigationRequest(myProfileResponse: widget.extras?.profileInfo ?? ProfileInfo(), customerInfoArg: customerInfo)
                        .toJson());
              } else {
                currentAttempt++;
                if (currentAttempt < getPanLanMaxAttempt()) {
                  errorText = getString(state.response.responseCode ?? msgSomethingWentWrong);
                  _formKey.currentState?.validate();
                  BlocProvider.of<AuthCubit>(context).validateAuthInput(true);
                } else {
                  errorText = "";
                  _formKey.currentState?.validate();
                  displayAlertSingleAction(context, getString("${state.response.responseCode}_Max"),
                      btnLbl: getString(lblLocateUs), btnTap: () {
                    QuickActionManager().triggerLocateUs(context);
                  });
                }
              }
            } else if (state is AuthenticateMultiUcicFailureState) {
              BlocProvider.of<AuthCubit>(context).validateAuthInput(true);
              toastForFailureMessage(
                  context: context,
                  msg: getFailureMessage(state.error),
                  bottomPadding: 40.v);
            } else if (state is LoadingState) {
              if (state.isloading) {
                showLoaderDialog(context, getString(lblLoading));
              } else {
                Navigator.of(context, rootNavigator: true).pop();
              }
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          toolbarHeight: 64.h,
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                context.pop();
              }),
          actions: [
            HelpCommonWidget(categoryval: HelpConstantData.subCategoryProfile,subCategoryval: HelpConstantData.subcategoryProfileSecondFactor,)
          ],
        ),
        body: MFGradientBackground(
          horizontalPadding: 0.0,
          verticalPadding: 0.0,
          child: BlocBuilder<AuthCubit, AuthState>(builder: (context, state) {
            if (PrefUtils.getBool(PrefUtils.keyIsMultipleUCIC, false)) {
              if (state is PanConsentState) {
                isVerifyBtnEnable = enableCheckbox = state.isPanConsent;
                validateForm();
              }
            }
            return Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 30.h),
                            SecondFactorAuthHeader(
                              headerDesc: (widget.extras!.isMultipleUCIC!
                                      ? widget.authType==AuthType.pan.value? getString(errLoginMsgLanMultiUCIC) : getString(errProfileMsgPanMultiUCIC)
                                      : getString(msgProfileWeNeedAFewMore)),
                              headerTitle: getString(lblLoginVerification),
                              titleTextStyle: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 20),
                              descTextStyle: Theme.of(context).textTheme.labelMedium,
                            ),
                            SizedBox(height: 12.v),
                            _buildPanCard(context),
                          ],
                        ),
                      ),
                    ),
                    Column(children: [
                      _buildVerifying(context),
                      SizedBox(height: 15.v),
                      Visibility(
                          visible: isPanUser && !widget.extras!.isMultipleUCIC!,
                          child: _buildTryADifferentAccountNumber(context)),
                      SizedBox(height: 20.v),
                      Padding(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom))
                    ],)
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildPanCard(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.only(left: 2.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(height: 20.v),
        Container(
          width: 328.v,
          height: 60.h,
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).disabledColor,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    textAlign: TextAlign.left,
                    widget.authType == AuthType.pan.value
                        ? getString(lblLoginPanCard)
                        : getString(lblProfileAccountNumber2),
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium?.copyWith(fontSize: 15)),
                Icon(
                  Icons.check_circle_outline,
                  color: Theme.of(context).primaryColor,
                  size: 18,
                )
              ],
            ),
          ),
        ),
        SizedBox(height: 25.v),
        CustomFloatingTextField(
            width: 328.v,
            controller: _controller,
            onChange: (value) {
              BlocProvider.of<AuthCubit>(context)
                  .validateAuthInput(widget.authType == AuthType.pan.value ? value.length >= 10  ? true : false : value.length >= 6  ? true : false);
              validateForm();
            },
            labelText: widget.authType == AuthType.pan.value
                ? getString(lblLoginPanCard)
                : getString(lblProfileAccountNumber2),
            labelStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: setColorBasedOnTheme(
                   context: context,
                    lightColor: AppColors.primaryLight,
                    darkColor: AppColors.secondaryLight5,
                )),
            textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: setColorBasedOnTheme(
                   context: context,
                    lightColor: AppColors.primaryLight,
                    darkColor: AppColors.secondaryLight5,
                )),
            textCapitalization: widget.authType == AuthType.pan.value ? TextCapitalization.characters : TextCapitalization.none,
            textInputAction: TextInputAction.done,
            textInputType: TextInputType.text,
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
            validator: (value) {
              if (widget.authType == AuthType.pan.value) {
                if (errorText.isNotEmpty) {
                  return errorText;
                } else if (!isValidPanCardNo(value)) {
                  return getString(lblProfileInvalidPanCard);
                } else {
                  return null;
                }
              } else {
                if (errorText.isNotEmpty) {
                  return errorText;
                } else if (!isValidAccountNumber(value)) {
                  return getString(lblLoginInvalidAccountNumber2);
                } else {
                  return null;
                }
              }
            }),
        Text(
            textAlign: TextAlign.left,
            widget.authType == AuthType.pan.value
                ? getString(lblLoginPanCardEx)
                : "",
            style: Theme.of(context)
                .textTheme
                .labelSmall),
      Visibility(
          visible: widget.extras!.isMultipleUCIC!,
          child:SizedBox(height: 10.v)),
      Visibility(
          visible: widget.extras!.isMultipleUCIC!,
          child:_buildFirstName()),
      Visibility(
          visible: widget.extras!.isMultipleUCIC!,
          child: SizedBox(height: 10.v)),
      Visibility(
          visible: widget.extras!.isMultipleUCIC!,
          child:_buildEnterDOB()),
        SizedBox(height: 10.v),
        Visibility(
          visible: widget.extras!.isMultipleUCIC!,
          child: Padding(
            padding: const EdgeInsets.only(right: 32.0),
            child: CustomCheckboxButton(
              activeColor: Theme.of(context).primaryColor,
              checkColor: Theme.of(context).scaffoldBackgroundColor,
              textAlignment: TextAlign.start,
              isExpandedText: true,
              text: getString(multiplUcicCheckbox),
              value: enableCheckbox,
              textStyle: Theme.of(context).textTheme.titleSmall,
              onChange: (value) {
                _blocContext.read<AuthCubit>().changePanConsent(value);
              },
            ),
          ),
        )
      ]),
    );
  }

  Widget _buildFirstName() {
    return MfCustomFloatingTextField(
      onChange: (value) {
        validateForm();
      },
      width: 328.v,
      controller: _fullNameController,
      labelText: getString(lblEnterNameAsPerPan),
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
        if (value != null) {
          if (!isValidName(value) || value.isEmpty) {
            return getString(enterProfileValidText);
          }
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

  MfCustomFloatingTextField _buildEnterDOB() {
    return MfCustomFloatingTextField(
      controller: _enterDOBController,
      hintText: "dd/mm/yyyy",
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9/]')),
        LengthLimitingTextInputFormatter(10),
        DateInputFormatter(),
      ],
      width: 328.v,
      textInputType: TextInputType.datetime,
      suffix: InkWell(child: Icon(Icons.calendar_month, color: Theme.of(context).primaryColor), onTap: (){
        final config = CalendarDatePicker2WithActionButtonsConfig(
            calendarType: CalendarDatePicker2Type.single,
            lastDate: DateTime.now(),
            selectedDayHighlightColor: setColorBasedOnTheme(
                context: context,
                lightColor: AppColors.primaryLight,
                darkColor: AppColors.secondaryLight5),
            weekdayLabelTextStyle: Theme.of(context).textTheme.bodyMedium,
            dayTextStyle: Theme.of(context).textTheme.bodyMedium,
            controlsTextStyle: Theme.of(context).textTheme.bodyMedium);
        showCalendarDatePicker2Dialog(
          config: config,
          dialogSize: const Size(325, 400),
          value: _singleDatePickerValueWithDefaultValue,
          context: context,
        ).then((value) {

        _singleDatePickerValueWithDefaultValue = value!;
        var data = DateFormat('dd/MM/yyyy').format(DateTime.parse(value.first.toString()));
        _enterDOBController.text = data;
        });
      },),
      onChange: (value) {
        validateForm();
      },
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
      labelText: getString(lblLoginEnterDOBAsPerPan),
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
      validator: (value) {
        if (value != null) {
          if (value.isEmpty) {
            return getString(lblProfileEnterValidDob);
          }
        }
        return null;
      },
    );
  }

  Widget _buildVerifying(BuildContext context) {
    return ValueListenableBuilder(
          valueListenable: isValidated,
          builder: (context, bool isValid, child) {
            return  Padding(
              padding: const EdgeInsets.only(right: 24.0),
              child: MfCustomButton(
                outlineBorderButton: false,
                isDisabled: !isValid,
                onPressed: () {
                  FocusManager.instance.primaryFocus
                      ?.unfocus();
                  errorText = "";
                  if (_formKey.currentState!.validate()) {
                    FocusManager.instance.primaryFocus?.unfocus();
                    if (widget.extras!.isMultipleUCIC!) {
                      var request = AuthenticateMultiUcicRequest(
                          pan: widget.extras!.prePopulatedAuthNumber,
                          lan: _controller.text,
                          authType: AuthType.mutliucic.value,
                          dobAsPerPan: _enterDOBController.text,
                          nameAsPerPan: _fullNameController.text,
                          source: AppConst.source);
                      BlocProvider.of<AuthCubit>(context)
                          .authenticateMultiUcicCustomer(
                          authenticateUCICRequest: request);
                    } else {
                      var request =
                      AuthenticateSingleUcicRequest(
                        authNumber: _controller.text,
                        authType: widget.authType,
                        source: AppConst.source,
                      );
                      BlocProvider.of<AuthCubit>(context)
                          .authenticateSingleUcicCustomer(
                          authenticationRequest: request);
                    }
                  }
                },
                width: double.infinity,
                text: getString(lblLoginVerify)),
            );
          });

  }

  Widget _buildTryADifferentAccountNumber(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 24.0),
      child: CustomElevatedButton(
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
          _controller.text = "";
          if (widget.authType == AuthType.pan.value) {
            widget.authType = AuthType.account.value;
          } else {
            widget.authType = AuthType.pan.value;
          }
          BlocProvider.of<AuthCubit>(context).validateAuthInput(false);
          BlocProvider.of<AuthCubit>(context).changeAuthType(widget.authType??0);
        },
        text: widget.authType == AuthType.pan.value
            ? getString(lblProfileTryDiffAccount)
            : getString(lblLoginTryDiffPan),
        margin: EdgeInsets.symmetric(horizontal: 3.h),
      ),
    );
  }



  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void validateForm(){
    if (widget.extras!.isMultipleUCIC!) {
      if((widget.authType == AuthType.pan.value ? _controller.text.length >= 10  ? true : false : _controller.text.length >= 6  ? true : false) && enableCheckbox && _fullNameController.text.isNotEmpty && _enterDOBController.text.isNotEmpty){
       isValidated.value = true;
      }  else {
        isValidated.value = false;
      }
    } else{
      if((widget.authType == AuthType.pan.value ? _controller.text.length >= 10  ? true : false : _controller.text.length >= 6  ? true : false)){
        isValidated.value = true;
      }  else {
        isValidated.value = false;
      }
    }
  }
}
