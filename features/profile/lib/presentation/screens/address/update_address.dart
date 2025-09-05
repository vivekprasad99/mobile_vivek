import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/widgets/action_buttons/custom_switch_button.dart';
import 'package:core/config/widgets/common_widgets/mf_custom_checkbox_button.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:core/utils/pref_utils.dart';
import 'package:flutter/material.dart';
import 'package:help/features/utils/constant_help.dart';
import 'package:help/features/utils/help_common_widget.dart';
import 'package:core/config/widgets/mf_appbar.dart';
import 'package:core/utils/size_utils.dart';
import 'package:core/config/widgets/action_buttons/sticky_floating_action_button.dart';
import 'package:core/config/widgets/background/mf_gradient_background.dart';
import 'package:core/config/widgets/custom_buttons/mf_custom_elevated_button.dart';
import 'package:core/config/string_resource/Strings.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:profile/config/routes/route.dart';
import 'package:profile/presentation/cubit/profile_cubit.dart';
import 'package:profile/utils/utils.dart';
import 'package:common/features/search/data/model/search_response.dart';

class UpdateAddress extends StatefulWidget {
  final ServicesNavigationRequest data;
  const UpdateAddress(
      {required this.data, super.key});

  @override
  State<UpdateAddress> createState() => _UpdateAddressState();
}

class _UpdateAddressState extends State<UpdateAddress> {
  bool _sameAddress = false;
  bool enableCheckbox = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: const StickyFloatingActionButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
        body: _buildWidget());
  }

  Widget _buildWidget() {
    return MFGradientBackground(
      horizontalPadding: 16.h,
      child: BlocBuilder<ProfileCubit, ProfileState>(
        
        builder: (context, state) {
          if (state is AddressUpdateConsentState) {
            enableCheckbox = state.isAddressConsent;
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                getString(lblUpdateAddress),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: 20.v),
              _buildaddressBox(),
              SizedBox(height: 20.v),
              _buildAddressSwitch(),
              const Spacer(),
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
                child: _buildCustomCheck()),
              SizedBox(height: 12.v),
              MfCustomButton(
                  outlineBorderButton: false,
                  isDisabled: !enableCheckbox,
                  onPressed: () {
                    PrefUtils.saveBool(PrefUtils.isAddressSameAsCurrent,_sameAddress );
                    context.pushNamed(Routes.myProfileUpdateAddressAuth.name,
                        extra: {
                          "addressType": widget.data.addressType,
                          "profileData": widget.data.myProfileResponse
                        });
                  },
                  text: getString(lblContinue)),
            ],
          );
        }
      ),
    );
  }

  Container _buildaddressBox() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 15.h,
        vertical: 6.v,
      ),
      decoration: BoxDecoration(
          color: setColorBasedOnTheme(
            context: context,
            lightColor: AppColors.white,
            darkColor: AppColors.cardDark,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(8))),
      child: Row(
        children: [
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.data.addressType == AddressType.permanent
                    ? getString(lblPermanentAddress)
                    : getString(lblCurrentAddress),
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Text(
                widget.data.addressType == AddressType.permanent
                    ? widget.data.myProfileResponse?.permanentAddr?.fullAddress ?? ""
                    : widget.data.myProfileResponse?.communicationAddr?.fullAddress ?? "",
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ],
          )),
        ],
      ),
    );
  }

  Widget _buildAddressSwitch() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(getString(lblSameAddressConsent),
              style: Theme.of(context).textTheme.bodyLarge),
        ),
        CustomSwitchButton(
          value: _sameAddress,
          onChanged: (bool? val) {
            _sameAddress = val!;
            setState(() {});
          },
        ),
      ],
    );
  }

  MfCustomCheckboxButton _buildCustomCheck() {
    return MfCustomCheckboxButton(
      activeColor: Theme.of(context).primaryColor,
      checkColor: Theme.of(context).scaffoldBackgroundColor,
      textAlignment: TextAlign.start,
      isExpandedText: true,
      alignment: Alignment.center,
      text: getString(lblUpdateAddressConsent),
      value: enableCheckbox,
      textStyle: Theme.of(context).textTheme.labelSmall?.copyWith(
        fontSize: 12.5,
        letterSpacing: 0.4
      ),
      onChange: (value) {
        context.read<ProfileCubit>().updateAddressConsent(value);
      },
    );
  }
}
