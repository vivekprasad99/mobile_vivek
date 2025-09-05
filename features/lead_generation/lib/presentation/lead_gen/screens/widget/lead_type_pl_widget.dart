import 'package:auth/features/login_and_registration/presentation/login_wireframe/widgets/custom_elevated_button.dart';
import 'package:auth/features/login_and_registration/presentation/login_wireframe/widgets/custom_floating_text_field.dart';
import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/config/widgets/action_buttons/sticky_floating_action_button.dart';
import 'package:core/config/widgets/background/mf_gradient_background.dart';
import 'package:core/config/widgets/mf_appbar.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:core/config/widgets/mf_toast.dart';
import 'package:core/utils/const.dart';
import 'package:core/utils/size_utils.dart';
import 'package:core/utils/utils.dart';
import 'package:core/utils/validation_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lead_generation/config/lead_type.dart';
import 'package:lead_generation/config/routes/route.dart';
import 'package:lead_generation/data/models/create_lead_generation_request.dart';
import 'package:lead_generation/data/models/get_state_city_req.dart';
import 'package:lead_generation/data/models/get_state_city_resp.dart';
import 'package:lead_generation/presentation/cubit/lead_generation_cubit.dart';
import 'package:lead_generation/presentation/cubit/lead_generation_state.dart';
import 'package:help/features/utils/constant_help.dart';
import 'package:help/features/utils/help_common_widget.dart';

class LeadTypePlWidget extends StatefulWidget {
  const LeadTypePlWidget({super.key});

  @override
  State<LeadTypePlWidget> createState() => _LeadTypePlWidgetState();
}

class _LeadTypePlWidgetState extends State<LeadTypePlWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController =
      TextEditingController(text: getUserName());
  final TextEditingController _pinCodeController = TextEditingController();
  final TextEditingController _phoneNumberController =
      TextEditingController(text: getPhoneNumber());
  bool value = true;
  String stateCityText = '';
  StateCityList? _stateCity;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: const StickyFloatingActionButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        resizeToAvoidBottomInset: false,
        appBar: customAppbar(
          actions: [
            HelpCommonWidget(categoryval: HelpConstantData.categoryLeadGen,subCategoryval: HelpConstantData.subCategoryUserDetail,)
          ],
          context: context,
          title: getString(lblLeadGenPersonalLoan),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        body: BlocConsumer<LeadGenerationCubit, LeadGenerationState>(
            listener: (BuildContext context, LeadGenerationState state) {
          if (state is LeadGenerationSuccessState) {
            if (state.response.code == AppConst.codeSuccess) {
              context.goNamed(Routes.acknowledge.name);
            } else {
              toastForFailureMessage(
                  context: context,
                  msg: getString(
                      state.response.responseCode ?? leadgenMsgSomethingWentWrong));
            }
          } else if (state is LeadGenerationFailureState) {
            showSnackBar(
                context: context, message: getFailureMessage(state.error));
          }
          if (state is FetchPinCodeSuccessState &&
              state.response.code == AppConst.codeFailure) {
            toastForFailureMessage(
                context: context, msg: getString(state.response.responseCode));
          }
        }, builder: (context, state) {
          return MFGradientBackground(
            horizontalPadding: 16.h,
            showLoader: state is LoadingState && state.isLoading,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    getString(msgTitleLead),
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontSize: 20),
                  ),
                  SizedBox(height: 20.v),
                  _buildPhoneNumber(),
                  SizedBox(height: 20.v),
                  _buildFirstName(),
                  SizedBox(height: 20.v),
                  _buildPinCode(),
                  SizedBox(height: 5.v),
                  _buildStateCityWidget(),
                  SizedBox(height: 8.v),
                  const Spacer(),
                  _buildSubmit(context, state),
                  SizedBox(height: 8.v),
                ],
              ),
            ),
          );
        }),
        // center
      ),
    );
  }

  Widget _buildStateCityWidget() {
    return BlocBuilder<LeadGenerationCubit, LeadGenerationState>(
        buildWhen: (context, state) {
      return state is FetchPinCodeSuccessState;
    }, builder: (context, state) {
      if (state is FetchPinCodeSuccessState &&
          state.response.stateCityList.isNotEmpty) {
        stateCityText =
            '${state.response.stateCityList[0].stateName.trim().toTitleCase()}, ${state.response.stateCityList[0].cityName.trim().toTitleCase()}';
        _stateCity = state.response.stateCityList[0];
      }
      return Padding(
        padding: const EdgeInsets.only(left: 12.0),
        child: Text(
          _pinCodeController.text.isEmpty
              ? getString(lblPleaseEnterSixPincode)
              : stateCityText,
          style: Theme.of(context).textTheme.labelSmall,
        ),
      );
    });
  }

  Widget _buildPhoneNumber() {
    return CustomFloatingTextField(
      isReadOnly: true,
      controller: _phoneNumberController,
      labelText: getString(lblMobileNo),
      prefixText: "+91 ",
      prefixStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
          fontSize: 16,
          color: setColorBasedOnTheme(
              context: context,
              lightColor: AppColors.disabledTextColor,
              darkColor: AppColors.indicatorDark)),
      textStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
          fontSize: 16,
          color: setColorBasedOnTheme(
              context: context,
              lightColor: AppColors.disabledTextColor,
              darkColor: AppColors.indicatorDark)),
      labelStyle: Theme.of(context)
          .textTheme
          .bodySmall
          ?.copyWith(color: AppColors.primaryLight5),
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
        if (!isValidPhone(value)) {
          return getString(enterValidNumber);
        }
        return null;
      },
    );
  }

  Widget _buildFirstName() {
    return CustomFloatingTextField(
      onChange: (value) {
        value.isEmpty || _pinCodeController.text.length != 6
            ? BlocProvider.of<LeadGenerationCubit>(context).validateInput(false)
            : BlocProvider.of<LeadGenerationCubit>(context).validateInput(true);
      },
      controller: _fullNameController,
      labelText: getString(labelFirstName),
      textStyle:
          Theme.of(context).textTheme.labelMedium?.copyWith(fontSize: 16),
      labelStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: setColorBasedOnTheme(
            context: context,
            lightColor: AppColors.primaryLight,
            darkColor: AppColors.secondaryLight5,
          )),
      validator: (value) {
        if (!isValidName(value)) {
          return getString(enterValidText);
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

  Widget _buildPinCode() {
    return CustomFloatingTextField(
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly
      ],
      onChange: (value) {
        stateCityText = getString(lblPleaseEnterSixPincode);
        if (value.length == 6 && _fullNameController.text.isNotEmpty) {
          BlocProvider.of<LeadGenerationCubit>(context).validateInput(true);
        } else {
          BlocProvider.of<LeadGenerationCubit>(context).validateInput(false);
        }
        if (value.length == 6) {
          stateCityText = getString(lblPleaseEnterSixPincode);
          _stateCity = null;
          FocusScope.of(context).requestFocus(FocusNode());
          BlocProvider.of<LeadGenerationCubit>(context)
              .getStateCity(GetStateCityReq(pinCode: int.parse(value)));
        }
      },
      maxLength: 6,
      controller: _pinCodeController,
      labelText: getString(labelEnterPinCode2),
      textStyle:
          Theme.of(context).textTheme.labelMedium?.copyWith(fontSize: 16),
      labelStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: setColorBasedOnTheme(
            context: context,
            lightColor: AppColors.primaryLight,
            darkColor: AppColors.secondaryLight5,
          )),
      textInputType: TextInputType.number,
      validator: (value) {
        if (!isNumeric(value)) {
          return getString(lblPleaseEnterSixPincode);
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

  Widget _buildSubmit(BuildContext context, LeadGenerationState state) {
    return BlocBuilder<LeadGenerationCubit, LeadGenerationState>(
      buildWhen: (context, state) {
        return state is ValidateState;
      },
      builder: (context, state) {
        if (state is ValidateState) {
          value = !state.isValid;
        }
        return CustomElevatedButton(
            text: getString(labelLeadgenSubmit),
            rightIcon: Container(
              margin: EdgeInsets.only(left: 24.h),
            ),
            buttonStyle: ElevatedButton.styleFrom(
                backgroundColor: !value
                    ? Theme.of(context).highlightColor
                    : Theme.of(context).disabledColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.h),
                )),
            buttonTextStyle: !value
                ? Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: AppColors.white)
                : Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Theme.of(context).unselectedWidgetColor),
            onPressed: () {
              if (_pinCodeController.text.isNotEmpty &&
                  _fullNameController.text.isNotEmpty) {
                BlocProvider.of<LeadGenerationCubit>(context)
                    .submitActionPressed(
                        leadGenerationRequest: LeadGenerationRequest(
                  customerId: getUCIC(),
                  name: _fullNameController.text,
                  pinCode: _pinCodeController.text,
                  mobileNumber: _phoneNumberController.text,
                  leadType: LeadType.pl.value,
                  state: _stateCity?.stateCode.toString(),
                  city: _stateCity?.cityCode.toString(),
                  superAppId: getSuperAppId(),
                ));
              } else {}
            });
      },
    );
  }
}
