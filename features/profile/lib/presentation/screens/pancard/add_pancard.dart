import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:common/features/rate_us/data/models/rate_us_request.dart';
import 'package:common/features/rate_us/presentation/widget/rate_us_dialog_box.dart';
import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/config/widgets/common_widgets/custom_checkbox_button.dart';
import 'package:core/config/widgets/common_widgets/custom_floating_text_field.dart';
import 'package:common/features/rate_us/presentation/cubit/rate_us_cubit.dart'
    as rate_us;
import 'package:help/features/utils/constant_help.dart';
import 'package:help/features/utils/help_common_widget.dart';
import 'package:core/config/widgets/mf_appbar.dart';
import 'package:core/config/widgets/mf_progress_bar.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:core/config/widgets/mf_toast.dart';
import 'package:core/services/di/injection_container.dart';
import 'package:core/utils/const.dart';
import 'package:core/utils/size_utils.dart';
import 'package:core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:core/utils/validation_functions.dart';
import 'package:core/config/widgets/background/mf_gradient_background.dart';
import 'package:core/config/widgets/custom_buttons/mf_custom_elevated_button.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:profile/config/profile_constant.dart';
import 'package:profile/config/routes/route.dart';
import 'package:profile/data/models/my_profile_model_response.dart';
import 'package:profile/data/models/name_match_req.dart';
import 'package:profile/data/models/update_pan_request.dart';
import 'package:profile/data/models/validate_pan_request.dart';
import 'package:profile/data/models/validate_pan_response.dart';
import 'package:profile/presentation/cubit/profile_cubit.dart';
import 'package:common/config/routes/route.dart' as common_routes;
import 'package:common/features/search/data/model/search_response.dart';
import 'package:profile/utils/utils.dart';
import 'package:common/features/rate_us/utils/helper/constant_data.dart';
import 'package:intl/intl.dart';

class AddPanCard extends StatefulWidget {
  final ServicesNavigationRequest? data;

  const AddPanCard({super.key, @required this.data});

  @override
  State<AddPanCard> createState() => _AddPanCardState();
}

class _AddPanCardState extends State<AddPanCard> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _pancardController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _enterDOBController = TextEditingController();
  bool enableCheckbox = false;
  List<DateTime?> _singleDatePickerValueWithDefaultValue = [
    DateTime.now().add(const Duration(days: 1)),
  ];

  @override
  void dispose() {
    _pancardController.dispose();
    super.dispose();
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
              context.pop(context);
            },
            actions: [
              HelpCommonWidget(categoryval: HelpConstantData.subCategoryProfile,subCategoryval: HelpConstantData.categoryUpdatePan,)
            ]),
        body: BlocListener<rate_us.RateUsCubit, rate_us.RateUsState>(
            listener: (context, state) {
              if (state is rate_us.RateUsSuccessState) {
                if (state.response.code == AppConst.codeSuccess) {
                  if (state.response.rateUsStatus ?? false) {
                    showRateUsPopup(context, ConstantData.panUpdate);
                  } else {
                    Navigator.of(context).popUntil(
                        ModalRoute.withName(common_routes.Routes.home.name));
                    context.pushNamed(Routes.myProfileData.name);
                  }
                } else {
                  toastForFailureMessage(
                      context: context,
                      msg: getString(state.response.responseCode ??
                          msgSomethingWentWrong));
                }
              } else if (state is rate_us.RateUsFailureState) {
                showSnackBar(
                    context: context,
                    message: getFailureMessage(state.failure));
              }
            },
            child: BlocConsumer<ProfileCubit, ProfileState>(
              listener: (context, state) {
                if (state is ValidatePANSuccessState) {
                  if (state.response.code == AppConst.codeFailure) {
                    toastForFailureMessage(
                      context: context,
                      msg: getString(
                          state.response.responseCode ?? lblProfileErrorGeneric),
                    );
                  } else {
                    checkCriteria(state.response.pANStatusDetails!.first);
                  }
                } else if (state is UpdatePANSuccessState) {
                  if (state.response.code == AppConst.codeFailure) {
                    displayAlertSingleAction(
                        context, getString(
                        state.response.responseCode ?? lblProfileErrorGeneric),
                        btnLbl: getString(lblProfileOk), btnTap: () {
                      Navigator.of(context).popUntil(ModalRoute.withName(
                          Routes.myProfileData.name));
                    });
                  } else {
                    toastForSuccessMessage(
                        context: context, msg: getString(msgProfilePanUpdateSuccess));
                    Navigator.of(context).popUntil(
                        ModalRoute.withName(common_routes.Routes.home.name));
                    context.pushNamed(Routes.myProfileData.name);
                  }
                } else if (state is ValidatePANFailureState) {
                  toastForFailureMessage(
                      context: context, msg: getFailureMessage(state.failure));
                } else if (state is UpdatePANFailureState) {
                  toastForFailureMessage(
                      context: context, msg: getFailureMessage(state.failure));
                } else if (state is NameMatchFailureState) {
                  toastForFailureMessage(
                      context: context, msg: getFailureMessage(state.failure));
                } else if (state is NameMatchSuccessState) {
                  if (state.response.code == AppConst.codeFailure) {
                    context
                        .pushNamed(Routes.myProfileNameMismatch.name, extra: {
                      "errorTitle": getString(lblSorryAuthenticateDetail),
                      "errorMessage": getString(errPanNameMismatch)
                    });
                  } else {
                    if (state.response.score! >= ProfileConst.nameMatchScore) {
                      BlocProvider.of<ProfileCubit>(context)
                          .updatePAN(UpdatePanRequest(
                        pan: _pancardController.text,
                        name: _fullNameController.text,
                        dob: _enterDOBController.text,
                        consentFlag: "true",
                        source: AppConst.source,
                        ucic: getUCIC(),
                        superAppId: getSuperAppId(),
                      ));
                    } else {
                      context
                          .pushNamed(Routes.myProfileNameMismatch.name, extra: {
                        "errorTitle": getString(lblSorryAuthenticateDetail),
                        "errorMessage": getString(errPanNameMismatch)
                      });
                    }
                  }
                } else if (state is ProfileLoadingState) {
                  if (state.isloading) {
                    showLoaderDialog(context, getString(lblLoginLoading));
                  } else {
                    Navigator.of(context, rootNavigator: true).pop();
                  }
                }
              },
              builder: (context, state) {
                if (state is PANConsentState) {
                  enableCheckbox = state.isPANConsent;
                }
                return _buildWidget(widget.data?.myProfileResponse, context);
              },
            )));
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
              getString(lblAddPan),
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontSize: 20),
            ),
            SizedBox(height: 20.v),
            _buildEnterPAN(),
            _panExampleText(),
            SizedBox(height: 16.v),
            _buildFirstName(),
            SizedBox(height: 20.v),
            _buildEnterDOB(),
            SizedBox(height: 20.v),
            _buildCustomCheck(blocContext),
            const Spacer(),
            MfCustomButton(
                outlineBorderButton: false,
                isDisabled: !enableCheckbox,
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    BlocProvider.of<ProfileCubit>(context)
                        .validatePAN(ValidatePANRequest(
                      pan: _pancardController.text,
                      name: _fullNameController.text,
                      dob: _enterDOBController.text,
                      ucic: getUCIC(),
                      source: AppConst.source,
                      superAppId: getSuperAppId(),
                    ));
                  }
                },
                text: getString(lblProfileContinue)),
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
      text: getString(lblPANConsent),
      value: enableCheckbox,
      textStyle: Theme.of(context).textTheme.labelSmall,
      onChange: (value) {
        blocContext.read<ProfileCubit>().updatePANConsent(value);
      },
    );
  }

  MfCustomFloatingTextField _buildEnterDOB() {
    return MfCustomFloatingTextField(
      controller: _enterDOBController,
      hintText: "dd/mm/yyyy",
      textInputType: TextInputType.datetime,
      suffix: InkWell(
        child:
            Icon(Icons.calendar_month, color: Theme.of(context).primaryColor),
        onTap: () {
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
            var data = DateFormat('dd/MM/yyyy')
                .format(DateTime.parse(value.first.toString()));
            _enterDOBController.text = data;
          });
        },
      ),
      onChange: (value) {},
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9/]')),
        LengthLimitingTextInputFormatter(10),
        DateInputFormatter(),
      ],
      textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontSize: 14,
          color: setColorBasedOnTheme(
            context: context,
            lightColor: AppColors.primaryLight,
            darkColor: AppColors.secondaryLight5,
          )),
      labelStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontSize: 14,
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
            return getString(lblLoginEnterValidDob);
          }
        }
        return null;
      },
    );
  }

  Widget _panExampleText() {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: Text(getString(lblLoginPanCardEx),
          style:
              Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 14)),
    );
  }

  Widget _buildEnterPAN() {
    return MfCustomFloatingTextField(
      onChange: (value) {},
      textCapitalization: TextCapitalization.characters,
      controller: _pancardController,
      inputFormatters: [
        PanCardInputFormatter(),
      ],
      labelText: getString(lblProfileEnterPAN),
      textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontSize: 16,
          color: setColorBasedOnTheme(
            context: context,
            lightColor: AppColors.primaryLight,
            darkColor: AppColors.secondaryLight5,
          )),
      labelStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontSize: 14,
          color: setColorBasedOnTheme(
            context: context,
            lightColor: AppColors.primaryLight,
            darkColor: AppColors.secondaryLight5,
          )),
      validator: (value) {
        if (value != null) {
          if (!isValidPanCardNo(value) || value.isEmpty) {
            return getString(enterValidPAN);
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

  Widget _buildFirstName() {
    return MfCustomFloatingTextField(
      onChange: (value) {},
      controller: _fullNameController,
      labelText: getString(lblEnterNameAsPerPan),
      textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontSize: 14,
          color: setColorBasedOnTheme(
            context: context,
            lightColor: AppColors.primaryLight,
            darkColor: AppColors.secondaryLight5,
          )),
      labelStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontSize: 14,
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

  checkCriteria(PANStatusDetails panResponse) {
    if (panResponse.panStatus == "E") {
      if (panResponse.nameMatchingStatus == "Y" &&
          panResponse.dobMatchingStatus == "Y") {
        BlocProvider.of<ProfileCubit>(context).updatePAN(UpdatePanRequest(
          pan: _pancardController.text,
          name: _fullNameController.text,
          dob: _enterDOBController.text,
          ucic: getUCIC(),
          source: AppConst.source,
          superAppId: getSuperAppId(),
        ));
      } else if (panResponse.nameMatchingStatus == "N" &&
          panResponse.dobMatchingStatus == "Y") {
        BlocProvider.of<ProfileCubit>(context).validateNameMatch(NameMatchReq(
          sourceName: _fullNameController.text,
          targetName: widget.data?.myProfileResponse?.customerName,
          ucic: getUCIC(),
          superAppId: getSuperAppId(),
        ));
      } else if ((panResponse.nameMatchingStatus == "N" &&
              panResponse.dobMatchingStatus == "N") ||
          (panResponse.nameMatchingStatus == "Y" &&
              panResponse.dobMatchingStatus == "N")) {
        context.pushNamed(Routes.myProfileNameMismatch.name, extra: {
          "errorTitle": getString(lblSorryAuthenticateDetail),
          "errorMessage": getString(errPanNameMismatch)
        });
      }
    } else {
      context.pushNamed(Routes.myProfileNameMismatch.name, extra: {
        "errorTitle": getString(lblSorryAuthenticateDetail),
        "errorMessage": getString(msgInactivePan)
      });
    }
  }

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
          child: RateUsDialogBox(
            featureType,
            onTap: (BuildContext dialogContex) {
              Navigator.of(dialogContex).pop();
              Navigator.of(context).popUntil(
                  ModalRoute.withName(common_routes.Routes.home.name));
              context.pushNamed(Routes.myProfileData.name);
            },
          ),
        );
      },
    );
  }
}
