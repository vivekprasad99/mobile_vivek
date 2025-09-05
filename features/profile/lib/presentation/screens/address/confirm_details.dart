import 'package:auth/features/mobile_otp/data/models/validate_aadhaar_otp_res.dart';
import 'package:common/features/rate_us/data/models/rate_us_request.dart';
import 'package:common/features/rate_us/presentation/widget/rate_us_dialog_box.dart';
import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/config/widgets/mf_progress_bar.dart';
import 'package:help/features/utils/constant_help.dart';
import 'package:help/features/utils/help_common_widget.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:core/config/widgets/mf_toast.dart';
import 'package:core/services/di/injection_container.dart';
import 'package:core/utils/const.dart';
import 'package:core/utils/pref_utils.dart';
import 'package:core/utils/utils.dart';
import 'package:flutter/material.dart';

import 'package:core/config/widgets/mf_appbar.dart';

import 'package:core/utils/size_utils.dart';
import 'package:core/config/widgets/action_buttons/sticky_floating_action_button.dart';
import 'package:core/config/widgets/background/mf_gradient_background.dart';
import 'package:core/config/widgets/custom_buttons/mf_custom_elevated_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:profile/config/routes/route.dart';
import 'package:profile/data/models/update_address_license_request.dart';
import 'package:profile/data/models/validate_driving_license_details.dart';
import 'package:profile/presentation/cubit/profile_cubit.dart';
import 'package:profile/utils/utils.dart';

import '../../../data/models/update_address_by_aadhaar_req.dart';
import 'package:common/config/routes/route.dart' as common_routes;

import 'package:common/features/rate_us/presentation/cubit/rate_us_cubit.dart'
    as rate_us;
import 'package:common/features/rate_us/utils/helper/constant_data.dart';


class ConfirmDetails extends StatefulWidget {
  final ConfirmDetailScreenType confirmScreenType;
  final ValidateDrivingLicenseDetail licenseDetail;
  final ValidateAadhaarOtpRes? aadhaarInfo;
  final AddressType? addressType;

  const ConfirmDetails(
      {required this.confirmScreenType,
      required this.licenseDetail,
      required this.aadhaarInfo,
      required this.addressType,
      super.key});

  @override
  State<ConfirmDetails> createState() => _ConfirmDetailsState();
}

class _ConfirmDetailsState extends State<ConfirmDetails> {
  // bool _sameAddress = false;
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
      child: BlocListener<rate_us.RateUsCubit, rate_us.RateUsState>(
        listener: (context, state) {
          if (state is rate_us.RateUsSuccessState) {
            if (state.response.code == AppConst.codeSuccess) {
              if (state.response.rateUsStatus ?? false) {
                showRateUsPopup(context, ConstantData.addressUpdate);
              } else {
                _navigateToProfile();
              }
            } else {
              toastForFailureMessage(
                  context: context,
                  msg: getString(
                      state.response.responseCode ?? msgSomethingWentWrong));
            }
          } else if (state is rate_us.RateUsFailureState) {
            showSnackBar(
                context: context, message: getFailureMessage(state.failure));
          }
        },
        child: BlocListener<ProfileCubit, ProfileState>(
          listener: (context, state) {
            if (state is UpdateLicenseAddressSuccessState) {
              if (state.response.code == AppConst.codeFailure) {
                displayAlertSingleAction(
                    context, getString(state.response.responseCode ?? lblErrorGeneric),
                    btnLbl: getString(lblOk), btnTap: () {
                  Navigator.of(context).popUntil(ModalRoute.withName(
                      Routes.myProfileData.name));
                });
              } else {
                toastForSuccessMessage(
                    context: context, msg: getString(state.response.responseCode ?? lblErrorGeneric));
                checkLastRatingDate(context, ConstantData.addressUpdate);
              }
            } else if (state is UpdateLicenseAddressFailureState) {
              displayAlertSingleAction(
                  context, getFailureMessage(state.failure),
                  btnLbl: getString(lblOk), btnTap: () {
                Navigator.of(context).popUntil(ModalRoute.withName(
                    Routes.myProfileData.name));
              });
            } else if (state is UpdateAddressByAadhaarSuccessState) {
              if (state.response.code == AppConst.codeSuccess) {
                toastForSuccessMessage(
                    context: context, msg: getString(state.response.responseCode ?? lblErrorGeneric));
                checkLastRatingDate(context, ConstantData.addressUpdate);
              } else {
                displayAlertSingleAction(
                    context, getString(state.response.responseCode ?? lblErrorGeneric),
                    btnLbl: getString(lblOk), btnTap: () {
                  Navigator.of(context).popUntil(ModalRoute.withName(
                      Routes.myProfileData.name));
                });
              }
            } else if (state is UpdateAddressByAadhaarFailureState) {
              displayAlertSingleAction(
                  context, getFailureMessage(state.failure),
                  btnLbl: getString(lblOk), btnTap: () {
                Navigator.of(context).popUntil(ModalRoute.withName(
                    Routes.myProfileData.name));
              });
            } else if (state is ProfileLoadingState) {
              if (state.isloading) {
                showLoaderDialog(context, getString(lblMandateLoading));
              } else {
                Navigator.of(context, rootNavigator: true).pop();
              }
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                getString(lblConfirmYourDetails),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Text(
                widget.confirmScreenType ==
                        ConfirmDetailScreenType.addressDrivingLicenseDetails
                    ? getString(lblDlFetch)
                    : getString(lblAadhaarFetch),
                style: Theme.of(context).textTheme.labelMedium,
              ),
              SizedBox(height: 20.v),
              widget.confirmScreenType ==
                      ConfirmDetailScreenType.addressDrivingLicenseDetails
                  ? _buildDlInfo(
                      widget.licenseDetail.address?.completeAddress ?? "",
                      widget.licenseDetail.custName ?? "",
                      widget.licenseDetail.drivingLicenseNo ?? "",
                      ConfirmDetailScreenType
                          .addressDrivingLicenseDetails.value)
                  : _buildDlInfo(
                      widget.aadhaarInfo?.aadhaarAddress?.combinedAddress ?? "",
                      widget.aadhaarInfo?.inputName ?? "",
                      "",
                      ConfirmDetailScreenType.aadhaarDetails.value),
              SizedBox(height: 20.v),
              const Spacer(),
              MfCustomButton(
                  outlineBorderButton: false,
                  isDisabled: false,
                  onPressed: () {
                    switch (widget.confirmScreenType) {
                      case ConfirmDetailScreenType.addressDrivingLicenseDetails:
                        BlocProvider.of<ProfileCubit>(context)
                            .updateAddressLicense(UpdateAddressLicenseRequest(
                                consentFlag: true.toString(),
                                source: AppConst.source,
                                superAppId: getSuperAppId(),
                                ucic: getUCIC(),
                                addrType: widget.addressType?.value,
                                city: widget.licenseDetail.address?.district,
                                combinedAddress: widget
                                    .licenseDetail.address?.completeAddress,
                                country: widget.licenseDetail.address?.country,
                                pincode:
                                    widget.licenseDetail.address?.postalCode,
                                postOfficeName: "",
                                sameAsMainAddress: PrefUtils.getBool(
                                        PrefUtils.isAddressSameAsCurrent, false)
                                    .toString(),
                                state: widget.licenseDetail.address?.state));
                        break;

                      case ConfirmDetailScreenType.aadhaarDetails:
                        var request = UpdateAddressByAadhaarReq(
                            consentFlag: true.toString(),
                            source: AppConst.source,
                            superAppId: getSuperAppId(),
                            ucic: getUCIC(),
                            addrType: widget.addressType?.value,
                            city: widget.aadhaarInfo?.aadhaarAddress?.district,
                            combinedAddress: widget
                                .aadhaarInfo?.aadhaarAddress?.combinedAddress,
                            country:
                                widget.aadhaarInfo?.aadhaarAddress?.country,
                            pincode:
                                widget.aadhaarInfo?.aadhaarAddress?.pincode,
                            postOfficeName:
                                widget.aadhaarInfo?.aadhaarAddress?.postOffice,
                            sameAsMainAddress: PrefUtils.getBool(
                                    PrefUtils.isAddressSameAsCurrent, false)
                                .toString(),
                            state: widget.aadhaarInfo?.aadhaarAddress?.state);
                        context
                            .read<ProfileCubit>()
                            .updateAddressByAadhaar(request);
                        break;
                      default:
                    }
                  },
                  text: getString(lblConfirm)),
            ],
          ),
        ),
      ),
    );
  }

  Container _buildDlInfo(
      String address, String name, String license, String confirmScreenType) {
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
              Visibility(
                  visible: confirmScreenType.equalsIgnoreCase(
                          ConfirmDetailScreenType
                              .addressDrivingLicenseDetails.value)
                      ? true
                      : false,
                  child: Text(
                    getString(lblDlNumber),
                    style: Theme.of(context).textTheme.bodySmall,
                  )),
              Visibility(
                  visible: confirmScreenType.equalsIgnoreCase(
                          ConfirmDetailScreenType
                              .addressDrivingLicenseDetails.value)
                      ? true
                      : false,
                  child: Text(
                    license ,
                    style: Theme.of(context).textTheme.labelSmall,
                  )),
              SizedBox(height: 10.v),
              Text(
                getString(lblName),
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Text(
                name,
                style: Theme.of(context).textTheme.labelSmall,
              ),
              SizedBox(height: 10.v),
              Text(
                getString(lblAddress),
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Text(
                address,
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ],
          )),
        ],
      ),
    );
  }

  _navigateToProfile() {
    Navigator.of(context)
        .popUntil(ModalRoute.withName(common_routes.Routes.home.name));
    context.pushNamed(Routes.myProfileData.name);
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
              _navigateToProfile();
            },
          ),
        );
      },
    );
  }
}
