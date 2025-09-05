import 'package:core/config/flavor/feature_flag/feature_flag.dart';
import 'package:core/config/flavor/feature_flag/feature_flag_keys.dart';
import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/resources/image_constant.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/config/widgets/background/mf_gradient_background.dart';
import 'package:core/config/widgets/mf_progress_bar.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:core/config/widgets/mf_toast.dart';
import 'package:core/utils/const.dart';
import 'package:core/utils/size_utils.dart';
import 'package:core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:profile/utils/utils.dart';
import 'package:service_ticket/config/routes/route.dart';
import 'package:profile/data/models/my_profile_model_response.dart';
import 'package:service_ticket/config/utils.dart';
import 'package:service_ticket/features/presentation/screens/widgets/common_bottom_sheet.dart';
import 'package:profile/presentation/cubit/profile_cubit.dart';
import 'package:profile/data/models/my_profile_model_request.dart';
import 'package:profile/config/routes/route.dart' as profile_route;
import 'package:profile/utils/utils.dart' as profile_utils;
import 'package:product_details/config/routes/route.dart' as product_route;
import 'package:common/features/search/data/model/search_response.dart';
import 'package:loan/config/routes/route.dart' as loan_route;
import 'package:loan_refund/config/routes/route.dart' as refund_route;
import 'package:noc/config/routes/route.dart' as noc_route;
import 'package:service_request/config/routes/route.dart' as services_route;
import 'package:service_ticket/features/presentation/screens/widgets/noc_bottom_sheet.dart';
import 'package:appstatus/config/routes/route.dart' as appstatus_route;

import '../helper/services_type.dart';

class ServiceRequestScreen extends StatefulWidget {
  const ServiceRequestScreen({super.key});

  @override
  State<ServiceRequestScreen> createState() => _ServiceRequestScreenState();
}

class _ServiceRequestScreenState extends State<ServiceRequestScreen> {
  MyProfileResponse? myProfileResponse;
  ProfileScreenName? profileScreenName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocListener<ProfileCubit, ProfileState>(
            listener: (context, state) {
              if (state is MyProfileSuccessState) {
                if (state.response.code == AppConst.codeFailure) {
                  toastForFailureMessage(
                    context: context,
                    msg: getString(
                        state.response.responseCode ?? lblErrorGeneric),
                  );
                } else {
                  myProfileResponse = state.response;
                  switch (profileScreenName) {
                    case ProfileScreenName.pan:
                      context.pushNamed(
                          profile_route.Routes.myProfileAddPanData.name,
                          extra: ServicesNavigationRequest(myProfileResponse:  myProfileResponse?.data ?? ProfileInfo()).toJson());
                      break;

                    case ProfileScreenName.email:
                      context.pushNamed(
                          profile_route.Routes.myProfileUpdateEmailID.name,
                          extra: ServicesNavigationRequest(myProfileResponse:  myProfileResponse?.data ?? ProfileInfo()).toJson());
                      break;

                    case ProfileScreenName.mobile:
                      context.pushNamed(profile_route.Routes.myProfileUpdateMobileNumber.name,
                          pathParameters: {'updateOperationType': Operation.updatePhoneNumber.value},
                          extra: ServicesNavigationRequest(myProfileResponse: myProfileResponse?.data ?? ProfileInfo())
                              .toJson());
                      break;

                    case ProfileScreenName.addressPermanent:
                      context.pushNamed(
                          profile_route.Routes.myProfileUpdateAddress.name,
                          extra:ServicesNavigationRequest(addressType: profile_utils.AddressType.permanent,myProfileResponse:  myProfileResponse?.data ?? ProfileInfo()).toJson()
                          );
                      break;

                    case ProfileScreenName.addressCurrent:
                      context.pushNamed(
                          profile_route.Routes.myProfileUpdateAddress.name,
                          extra:ServicesNavigationRequest(addressType: profile_utils.AddressType.current,myProfileResponse:  myProfileResponse?.data ?? ProfileInfo()).toJson()
                          );
                      break;

                    default:
                  }
                }
              } else if (state is MyProfileFailureState) {
                toastForFailureMessage(
                  context: context,
                  msg: lblErrorGeneric,
                );
              } else if (state is ProfileLoadingState) {
                if (state.isloading) {
                  showLoaderDialog(context, getString(lblLoading));
                } else {
                  Navigator.of(context, rootNavigator: true).pop();
                }
              }
            },
            child: MFGradientBackground(
                child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if(isCustomer())
                  ...[_buildLoansRelatedSection(context),
                  const SizedBox(
                    height: 20,
                  ),
                  Divider(
                    color: Theme.of(context).dividerColor,
                  ),
                  _buildSection(
                      context,
                      getString(lblPaymentChargesRelated),
                      [
                        const SizedBox(
                          height: 20,
                        ),
                        _buildRow(
                            context,
                            ImageConstant.paymentOrUpdateIcon,
                            getString(lblPaymentNotUpdated),
                            ImageConstant.disputeUpdateIcon,
                            getString(lblDisputeCharges), () {
                          context.pushNamed(Routes.raiseRequest.name,
                              extra: {'type': Services.paymentAndChargesRelated.value, 'id': '1'});
                          }, () {
                          context.pushNamed(Routes.raiseRequest.name,
                              extra: {'type': Services.paymentAndChargesRelated.value, 'id': '2'});
                        }),
                      ],
                      true),
                  Divider(
                    color: Theme.of(context).dividerColor,
                  ),],
                  if(isFeatureEnabled(featureName: featureServiceProfile))
                  _buildSection(
                      context,
                      getString(lblProfileRelated),
                      [
                        const SizedBox(
                          height: 20,
                        ),
                        _buildRow(
                            context,
                            ImageConstant.updateMobileIcon,
                            getString(lblUpdateMobileNo),
                            ImageConstant.updateEmailIcon,
                            getString(lblUpdateEmailAddress), () {
                          callProfile(context);
                          profileScreenName = ProfileScreenName.mobile;
                        }, () {
                          callProfile(context);
                          profileScreenName = ProfileScreenName.email;
                        }),
                        const SizedBox(
                          height: 10,
                        ),
                        _buildRow(
                            context,
                            ImageConstant.updatePanIcon,
                            getString(lblUpdatePAN),
                            ImageConstant.updateParmanentAddIcon,
                            getString(lblUpdatePermanentAddress),
                                () {
                          callProfile(context);
                          profileScreenName = ProfileScreenName.pan;
                        }, () {
                          callProfile(context);
                          profileScreenName =
                              ProfileScreenName.addressPermanent;
                        }),
                        const SizedBox(
                          height: 10,
                        ),
                        if(isCustomer())
                        Align(
                          alignment: Alignment.topLeft,
                          child: InkWell(
                            onTap: () {
                              callProfile(context);
                              profileScreenName =
                                  ProfileScreenName.addressCurrent;
                            },
                            child: Container(
                              height: 62.v,
                              width: 158.h,
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SvgPicture.asset(
                                      ImageConstant.updateCurrentAddIcon,
                                      colorFilter: ColorFilter.mode(
                                        setColorBasedOnTheme(
                                          context: context,
                                          lightColor: AppColors.primaryLight,
                                          darkColor: AppColors.white,
                                        ),
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Flexible(
                                      child: Text(
                                        getString(lblUpdateCurrentAddress),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                      true),
                  if(isCustomer())
                  ...[Divider(
                    color: Theme.of(context).dividerColor,
                  ),
                  _buildSection(context, getString(lblMiscellaneous), [], false,
                      () {
                    openLoanDetailsBottomSheet(context, getString(lblMiscellaneous));
                  }),
                  Divider(
                    color: Theme.of(context).dividerColor,
                  ),]
                ],
              ),
            ))));
  }

  /// Section Widget
  Widget _buildLoansRelatedSection(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        iconColor: Theme.of(context).highlightColor,
        initiallyExpanded: true,
        childrenPadding: EdgeInsets.zero,
        dense: true,
        collapsedShape: const ContinuousRectangleBorder(),
        title: Text(getString(labelLoanRelated),
            style: Theme.of(context).textTheme.titleMedium),
        children: [
          _buildRow(
              context,
              ImageConstant.loanDetailsIcon,
              getString(lblLoanDetails),
              ImageConstant.documentsIcon,
              getString(lblDocuments), () {
            context.pushNamed(
                product_route.Routes.activeProductsLoanListPage.name,
                extra: ServicesNavigationRequest(isFromSearch: true).toJson());
          }, () {
            openLoanDetailsBottomSheet(context, "loan");
          }),
          const SizedBox(height: 20),
          _buildRow(
              context,
              ImageConstant.eMandateIcon,
              getString(lblEMandates),
              ImageConstant.nocIcon,
              getString(lblNOC), () {
            openLoanDetailsBottomSheet(context, "eMandates");
          }, () {
            showModalBottomSheet(
              context: context,
              builder: (_) => const NocBottomSheet(),
            );
          }),
          const SizedBox(height: 20),
          _buildRow(context, ImageConstant.bureauIcon, getString(lblBureau),
              ImageConstant.cancellationIcon, getString(lblCancellation), () {
            context.pushNamed(services_route.Routes.bureau.name);
          }, () {
            context.pushNamed(loan_route.Routes.loanCancelList.name);
          }),
          const SizedBox(height: 20),
          _buildRow(
              context,
              ImageConstant.forclousreIcon,
              getString(lblForeclosure),
              ImageConstant.reFundsIcon,
              getString(lblRefund), () {
            context.pushNamed(loan_route.Routes.loansList.name, extra: true);
          }, () {
            context.pushNamed(refund_route.Routes.loanRefund.name);
          }),
          const SizedBox(height: 20),
          _buildRow(
              context,
              ImageConstant.rcUpdatesIcon,
              getString(lblRcUpdate),
              ImageConstant.trackdetails,
              getString(lblTrackApplicationstatus), () {
            context.pushNamed(noc_route.Routes.rcList.name,
                    extra: getString(lblServiceViewTrack));
          }, () {
            context.pushNamed(appstatus_route.Routes.applicationstatus.name,
             extra: true);
          }),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, String name, List<Widget> children,
      bool initiallyExpanded,
      [VoidCallback? onTap]) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        iconColor: Theme.of(context).highlightColor,
        initiallyExpanded: initiallyExpanded,
        childrenPadding: EdgeInsets.zero,
        dense: true,
        collapsedShape: const ContinuousRectangleBorder(),
        title: InkWell(
            onTap: onTap,
            child: Text(name, style: Theme.of(context).textTheme.titleMedium)),
        children: children,
      ),
    );
  }

  Widget _buildRow(
    BuildContext context,
    String imageName,
    String title,
    String imageName2,
    String title2,
    VoidCallback onTap,
    VoidCallback onTap2,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      showServiceTile(title)
            ? Expanded(
          child:InkWell(
            onTap: onTap,
            child: Container(
              height: 62.v,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SvgPicture.asset(
                      imageName,
                      colorFilter: ColorFilter.mode(
                        setColorBasedOnTheme(
                          context: context,
                          lightColor: AppColors.primaryLight,
                          darkColor: AppColors.white,
                        ),
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Text(
                        title,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
              )
            : const SizedBox(),
        const SizedBox(
          width: 20,
        ),
      showServiceTile(title2)
            ? Expanded(
          child:(title2 == getString(lblUpdatePermanentAddress) && !(isCustomer()))?  Container() : InkWell(
            onTap: onTap2,
            child: Container(
              height: 62.v,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SvgPicture.asset(
                      imageName2,
                      colorFilter: ColorFilter.mode(
                        setColorBasedOnTheme(
                          context: context,
                          lightColor: AppColors.primaryLight,
                          darkColor: AppColors.white,
                        ),
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Text(
                        title2,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ) ,
        )
            : Container(),
      ],
    );
  }

  void openLoanDetailsBottomSheet(BuildContext context, String titleName) {
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return LoanDetailsBottomWidget(cardName: titleName);
        });
  }

  callProfile(BuildContext context) {
    BlocProvider.of<ProfileCubit>(context).getMyProfile(MyProfileRequest(
        ucic: getUCIC(), superAppId: getSuperAppId(), source: AppConst.source));
  }


  bool showServiceTile(String title) {
    if (title.equalsIgnoreCase(getString(lblLoanDetails)) &&
        isFeatureEnabled(featureName: featureLoanDetails)) {
      return true;
    } else if (title.equalsIgnoreCase(getString(lblDocuments)) &&
        isFeatureEnabled(featureName: featureDocuments)) {
      return true;
    } else if (title.equalsIgnoreCase(getString(lblEMandates)) &&
        isFeatureEnabled(featureName: featureAchMandate)) {
      return true;
    } else if (title.equalsIgnoreCase(getString(lblNoc)) &&
        isFeatureEnabled(featureName: featureNoc)){
      return true;
        }
    else if (title.equalsIgnoreCase(getString(lblBureau)) &&
        isFeatureEnabled(featureName: featureBureau)) {
      return true;
    } else if (title.equalsIgnoreCase(getString(lblCancellation)) &&
        isFeatureEnabled(featureName: featureLoanCancellations)) {
      return true;
    } else if (title.equalsIgnoreCase(getString(lblForeclosure)) &&
        isFeatureEnabled(featureName: featureForeclosure)) {
      return true;
    } else if (title.equalsIgnoreCase(getString(lblRefund)) &&
        isFeatureEnabled(featureName: featureRefund)) {
      return true;
    } else if (title.equalsIgnoreCase(getString(lblRcUpdate)) &&
        isFeatureEnabled(featureName: featureRcUpdate)) {
      return true;
    } else if (title.equalsIgnoreCase(getString(lblTrackApplicationstatus)) &&
        isFeatureEnabled(featureName: featureAppStatus)) {
      return true;
    } else if (title.equalsIgnoreCase(getString(lblUpdateMobileNo)) &&
        isFeatureEnabled(featureName: featureServiceProfile)) {
      return true;
    } else if (title.equalsIgnoreCase(getString(lblUpdateEmailAddress)) &&
        isFeatureEnabled(featureName: featureServiceProfile)) {
      return true;
    } else if (title.equalsIgnoreCase(getString(lblUpdatePAN)) &&
        isFeatureEnabled(featureName: featureServiceProfile)) {
      return true;
    }else if (title.equalsIgnoreCase(getString(lblUpdatePermanentAddress)) &&
        isFeatureEnabled(featureName: featureServiceProfile)) {
      return true;
    }else if (title.equalsIgnoreCase(getString(lblDisputeCharges)) &&
        isFeatureEnabled(featureName: featureServicePayment)) {
      return true;
    }else if (title.equalsIgnoreCase(getString(lblPaymentNotUpdated)) &&
        isFeatureEnabled(featureName: featureServicePayment)) {
      return true;
    }

    return false;
  }
}
