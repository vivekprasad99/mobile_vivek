import 'package:auth/features/login_and_registration/presentation/login_wireframe/widgets/custom_elevated_button.dart';
import 'package:auth/features/login_and_registration/presentation/login_wireframe/widgets/custom_floating_text_field.dart';
import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/resources/custom_dropdown_button.dart';
import 'package:core/config/resources/custom_text_form_field.dart';
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
import 'package:lead_generation/config/routes/route.dart';
import 'package:lead_generation/data/models/create_lead_generation_request.dart';
import 'package:lead_generation/data/models/get_dealer_req.dart';
import 'package:lead_generation/data/models/get_dealer_resp.dart';
import 'package:lead_generation/data/models/get_make_model_req.dart';
import 'package:lead_generation/data/models/get_make_model_resp.dart';
import 'package:lead_generation/data/models/get_state_city_req.dart';
import 'package:lead_generation/data/models/get_state_city_resp.dart';
import 'package:lead_generation/presentation/cubit/lead_generation_cubit.dart';
import 'package:lead_generation/presentation/cubit/lead_generation_state.dart';
import '../../../../config/lead_type.dart';
import 'package:help/features/utils/constant_help.dart';
import 'package:help/features/utils/help_common_widget.dart';

class LeadTypeVehicleWidget extends StatefulWidget {
  final String? title;
  final String? altText;
  final String? vertical;
  final String vehicleType;
  const LeadTypeVehicleWidget({
    super.key,
    this.title,
    this.altText,
    this.vertical,
    required this.vehicleType,
  });

  @override
  State<LeadTypeVehicleWidget> createState() => _LeadTypeCommonWidgetState();
}

class _LeadTypeCommonWidgetState extends State<LeadTypeVehicleWidget> {
  final TextEditingController _fullNameController =
      TextEditingController(text: getUserName());
  final TextEditingController _pinCodeController = TextEditingController();
  final TextEditingController _phoneNumberController =
      TextEditingController(text: getPhoneNumber());

  bool value = true;
  String stateCityText = '';

  StateCityList? _stateCity;
  MakeModelData? selectedModel;
  DealersData? dealersData;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<LeadGenerationCubit>(context)
        .getMakeModel(GetMakeModelReq(assetClass: widget.vehicleType));
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _pinCodeController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  String? selectLeadFor;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: const StickyFloatingActionButton(),
        // floatingActionButton: _buildSubmit(context),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        resizeToAvoidBottomInset: true,
        bottomNavigationBar: _buildSubmit(context),
        appBar: customAppbar(
          actions: [
            HelpCommonWidget(categoryval: HelpConstantData.categoryLeadGen,subCategoryval: HelpConstantData.subCategoryUserDetail,)
          ],
          context: context,
          title: widget.title ?? getString(labelCarLoan),
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
          if (state is LeadGenerationSuccessState &&
              state.response.code == AppConst.codeFailure) {
            toastForFailureMessage(
                context: context,
                msg: getString(
                    state.response.responseCode ?? leadgenMsgSomethingWentWrong));
          }
          if (state is FetchPinCodeSuccessState &&
              state.response.code == AppConst.codeFailure) {
            toastForFailureMessage(
                context: context, msg: getString(state.response.responseCode));
          }
          if (state is GetMakeModelSuccessState &&
              state.response.code == AppConst.codeFailure) {
            toastForFailureMessage(
                context: context,
                msg: getString(
                    state.response.responseCode ?? leadgenMsgSomethingWentWrong));
          }
          if (state is GetDealersSuccessState &&
              state.response.code == AppConst.codeFailure) {
            toastForFailureMessage(
                context: context,
                msg: getString(
                    state.response.responseCode ?? leadgenMsgSomethingWentWrong));
          }
        }, builder: (context, state) {
          return MFGradientBackground(
            horizontalPadding: 16.h,
            showLoader: state is LoadingState && state.isLoading,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    // getString(msgTitleLead),
                    widget.altText ?? getString(msgTitleLead),
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
                  // SizedBox(height: 20.v),
                  if (widget.title == (getString(lblbalancetransfer)))
                    CustomDropDownButton(
                      items: [
                        DropdownMenuEntry(
                            label: getString(lblNewCar),
                            value: getString(lblNewCar)),
                        DropdownMenuEntry(
                            label: getString(lblUsedCar),
                            value: getString(lblUsedCar)),
                        DropdownMenuEntry(
                            label: getString(lblLeadGenPersonalLoan),
                            value: getString(lblLeadGenPersonalLoan)),
                      ],
                      isExpanded: true,
                      hintText: getString(lblLoanFor),
                      onChanged: (String? value) {
                        setState(() {
                          selectLeadFor = value;
                        });
                      },
                      value: selectLeadFor,
                    ),

                  SizedBox(height: 20.v),
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(text: getString(lblVehicleDetails)),
                          const TextSpan(text: " "),
                          TextSpan(
                              text: getString(labelOptional),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(fontWeight: FontWeight.w400))
                        ],
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  ),

                  SizedBox(height: 20.v),
                  if (selectLeadFor == null ||
                      selectLeadFor?.equalsIgnoreCase("Personal Loan") == false)
                    _buildModelDropDown(),
                  SizedBox(height: 20.v),
                  if (selectedModel != null) _buildDealerShipDropDown(),

                  SizedBox(height: 8.v),
                ],
              ),
            ),
          );
        }),
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
          _pinCodeController.text.isEmpty || _stateCity == null
              ? getString(lblPleaseEnterSixPincode)
              : stateCityText,
          style: Theme.of(context).textTheme.labelSmall,
        ),
      );
    });
  }

  Widget _buildDealerShipDropDown() {
    return BlocConsumer<LeadGenerationCubit, LeadGenerationState>(
      listener: (context, state) {
      },
      buildWhen: (context, state) {
        return state is GetDealersSuccessState;
      },
      builder: (context, state) {
        return state is GetDealersSuccessState &&
                state.response.data != null &&
                state.response.data!.isNotEmpty
            ? _buildDealshipDropdown(context, state.response.data!)
            : Container();
      },
    );
  }

  Widget _buildDealshipDropdown(
      BuildContext context, List<DealersData> response) {
    return AutocompleteDealershipTextField(
      dealershipList: response,
      callback: (val) {
        setState(() {
          dealersData = val;
        });
      },
    );
    // return CustomDropDownButton(
    // icon: Center(
    //     child: Icon(
    //   Icons.search_outlined,
    //   color: Theme.of(context).primaryColor,
    // )),
    // borderDecoration: UnderlineInputBorder(
    //   borderRadius: BorderRadius.zero,
    //   borderSide: BorderSide(
    //     color: setColorBasedOnTheme(
    //       context: context,
    //       lightColor: AppColors.primaryLight,
    //       darkColor: AppColors.secondaryLight5,
    //     ),
    //     width: 1,
    //   ),
    // ),

    //   hintText: getString(lblDealership),
    //   items: dealershipList
    //       .map(
    //         (e) => DropdownMenuEntry<String>(label: e.toString(), value: e),
    //       )
    //       .toList(),
    //   onChanged: (value) {},
    // );
  }

  Widget _buildModelDropDown() {
    return BlocConsumer<LeadGenerationCubit, LeadGenerationState>(
      listener: (context, state) {
      },
      buildWhen: (context, state) {
        return state is GetMakeModelSuccessState;
      },
      builder: (context, state) {
        return state is GetMakeModelSuccessState
            ? _buildMakeModelDropdown(context, state.response.data!)
            : Container();
      },
    );
  }

  Widget _buildMakeModelDropdown(
      BuildContext context, List<MakeModelData> response) {
    return AutocompleteMakeModelTextField(
      dealershipList: response,
      callback: (val) {
        setState(() {
          selectedModel = val;
        });
        BlocProvider.of<LeadGenerationCubit>(context)
            .getDealers(GetDealerReq(assetCode: selectedModel?.assetCode ?? 0));
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
      textInputAction: TextInputAction.done,
      controller: _fullNameController,
      labelText: getString(labelFirstName),
      textStyle:
          Theme.of(context).textTheme.labelMedium?.copyWith(fontSize: 16),
      labelStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
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
      textInputAction: TextInputAction.done,
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
      labelStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
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

  Widget _buildPhoneNumber() {
    return CustomFloatingTextField(
      isReadOnly: true,
      controller: _phoneNumberController,
      labelText: getString(lblMobileNo),
      // prefixText: "+91",
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

  Widget _buildSubmit(BuildContext context) {
    return BlocBuilder<LeadGenerationCubit, LeadGenerationState>(
      buildWhen: (context, state) {
        return state is ValidateState;
      },
      builder: (context, state) {
        if (state is ValidateState) {
          value = !state.isValid;
        }
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: CustomElevatedButton(
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
                  : Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).unselectedWidgetColor),
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
                    leadType: widget.title != (getString(lblbalancetransfer))
                        ? LeadType.vl.value
                        : selectLeadFor!.equalsIgnoreCase("Personal Loan")
                            ? LeadType.pl.value
                            : LeadType.vl.value,
                    subCategory: widget.title == (getString(lblbalancetransfer))
                        ?"BRE"
                        : widget.vertical,
                    state: _stateCity?.stateCode.toString(),
                    city: _stateCity?.cityCode.toString(),
                    assetCode: selectedModel?.assetCode.toString(),
                    entityCode: dealersData?.dealerCode,
                    superAppId: getSuperAppId(),
                  ));
                } else {}
              }),
        );
      },
    );
  }
}

class AutocompleteMakeModelTextField extends StatelessWidget {
  final List<MakeModelData> dealershipList;
  final void Function(MakeModelData val)? callback;
  const AutocompleteMakeModelTextField(
      {super.key, required this.dealershipList, required this.callback});

  static String _displayStringForOption(MakeModelData option) =>
      option.assetName ?? "";

  @override
  Widget build(BuildContext context) {
    // MakeModelData? dealership;
    return LayoutBuilder(
      builder: (context, constraints) => RawAutocomplete<MakeModelData>(
        displayStringForOption: _displayStringForOption,
        optionsViewBuilder: (context, onSelected, options) => Align(
          alignment: Alignment.topLeft,
          child: Material(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(8.0)),
            ),
            child: SizedBox(
              height: 52.0 * options.length,
              width: constraints.biggest.width, // <-- Right here !
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: options.length,
                shrinkWrap: false,
                itemBuilder: (BuildContext context, int index) {
                  final MakeModelData option = options.elementAt(index);
                  return InkWell(
                    splashColor: AppColors.primaryLight5,
                    onTap: () => onSelected(option),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(option.assetName ?? ""),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        fieldViewBuilder: (BuildContext context,
            TextEditingController textEditingController,
            FocusNode focusNode,
            VoidCallback onFieldSubmitted) {
          return BlocBuilder<LeadGenerationCubit, LeadGenerationState>(
            buildWhen: (prev, curr) {
              return curr is SelectMakeModelState ||
                  curr is GetMakeModelSuccessState;
            },
            builder: (context, state) {
              return CustomTextFormField(
                suffix: GestureDetector(
                  onTap: () {
                    context
                        .read<LeadGenerationCubit>()
                        .selectNewMakeModel(null);
                    textEditingController.text = "";
                    if (state is SelectMakeModelState &&
                        state.makeModel == null) {
                      FocusScope.of(context).requestFocus(focusNode);
                    }
                  },
                  child: Icon(
                    state is SelectMakeModelState && state.makeModel != null
                        ? Icons.clear
                        : Icons.search_outlined,
                    color: setColorBasedOnTheme(
                        context: context,
                        lightColor: AppColors.primaryLight,
                        darkColor: AppColors.primaryLight5),
                  ),
                ),
                contentPadding: EdgeInsets.fromLTRB(10.h, 0, 16.h, 0),
                labelText: getString(lblMakeModel),
                textStyle: Theme.of(context)
                    .textTheme
                    .labelMedium
                    ?.copyWith(fontSize: 16),
                labelStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: setColorBasedOnTheme(
                      context: context,
                      lightColor: AppColors.primaryLight,
                      darkColor: AppColors.secondaryLight5,
                    )),
                textInputAction: TextInputAction.done,
                controller: textEditingController,
                focusNode: focusNode,
                onChanged: (value) {
                  if (state is SelectMakeModelState) {
                    if (value.toLowerCase() != state.makeModel?.assetName) {
                      context
                          .read<LeadGenerationCubit>()
                          .selectNewMakeModel(null);
                    }
                  }
                },
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
              );
            },
          );
        },
        optionsBuilder: (TextEditingValue textEditingValue) {
          if (textEditingValue.text.isEmpty) {
            return const Iterable<MakeModelData>.empty();
          }
          return dealershipList.where(
            (MakeModelData option) {
              return option.assetName!
                  .toLowerCase()
                  .toString()
                  .contains(textEditingValue.text.toLowerCase());
            },
          );
        },
        onSelected: (option) {
          context.read<LeadGenerationCubit>().selectNewMakeModel(option);
          callback!(option);
        },
      ),
    );
  }
}

class AutocompleteDealershipTextField extends StatelessWidget {
  final List<DealersData> dealershipList;
  final void Function(DealersData val)? callback;
  const AutocompleteDealershipTextField(
      {super.key, required this.dealershipList, required this.callback});

  static String _displayStringForOption(DealersData option) =>
      option.dealerName ?? "";

  @override
  Widget build(BuildContext context) {
    // DealersData? dealership;
    return LayoutBuilder(
      builder: (context, constraints) => RawAutocomplete<DealersData>(
        displayStringForOption: _displayStringForOption,
        optionsViewBuilder: (context, onSelected, options) => Align(
          alignment: Alignment.topLeft,
          child: Material(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(8.0)),
            ),
            child: SizedBox(
              height: 52.0 * options.length,
              width: constraints.biggest.width, // <-- Right here !
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: options.length,
                shrinkWrap: false,
                itemBuilder: (BuildContext context, int index) {
                  final DealersData option = options.elementAt(index);
                  return InkWell(
                    splashColor: AppColors.primaryLight5,
                    onTap: () => onSelected(option),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(option.dealerName ?? ""),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        fieldViewBuilder: (BuildContext context,
            TextEditingController textEditingController,
            FocusNode focusNode,
            VoidCallback onFieldSubmitted) {
          return BlocBuilder<LeadGenerationCubit, LeadGenerationState>(
            buildWhen: (prev, curr) {
              return curr is SelectDealerShipState;
            },
            builder: (context, state) {
              return CustomTextFormField(
                suffix: GestureDetector(
                  onTap: () {
                    context.read<LeadGenerationCubit>().selectNewDealer(null);
                    textEditingController.text = "";
                    if (state is SelectDealerShipState &&
                        state.dealer == null) {
                      FocusScope.of(context).requestFocus(focusNode);
                    }
                  },
                  child: Icon(
                    state is SelectDealerShipState && state.dealer != null
                        ? Icons.clear
                        : Icons.search_outlined,
                    color: setColorBasedOnTheme(
                        context: context,
                        lightColor: AppColors.primaryLight,
                        darkColor: AppColors.primaryLight5),
                  ),
                ),
                contentPadding: EdgeInsets.fromLTRB(10.h, 0, 16.h, 0),
                labelText: getString(lblDealership),
                textStyle: Theme.of(context)
                    .textTheme
                    .labelMedium
                    ?.copyWith(fontSize: 16),
                labelStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: setColorBasedOnTheme(
                      context: context,
                      lightColor: AppColors.primaryLight,
                      darkColor: AppColors.secondaryLight5,
                    )),
                textInputAction: TextInputAction.done,
                controller: textEditingController,
                focusNode: focusNode,
                onChanged: (value) {
                  if (state is SelectDealerShipState) {
                    if (value.toLowerCase() != state.dealer?.dealerName) {
                      context.read<LeadGenerationCubit>().selectNewDealer(null);
                    }
                  }
                },
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
              );
            },
          );
        },
        optionsBuilder: (TextEditingValue textEditingValue) {
          if (textEditingValue.text == '') {
            return const Iterable<DealersData>.empty();
          }

          return dealershipList.where(
            (DealersData option) {
              return option.dealerName!
                  .toLowerCase()
                  .toString()
                  .contains(textEditingValue.text.toLowerCase());
            },
          );
        },
        onSelected: (option) {
          context.read<LeadGenerationCubit>().selectNewDealer(option);
          callback!(option);
        },
      ),
    );
  }
}
