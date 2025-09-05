import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/resources/app_dimens.dart';
import 'package:core/config/resources/custom_elevated_button.dart';
import 'package:core/config/resources/custom_outline_button.dart';
import 'package:core/config/resources/images.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/config/widgets/background/mf_gradient_background.dart';
import 'package:core/config/widgets/mf_appbar.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:core/utils/size_utils.dart';
import 'package:faq/config/routes/route.dart' as faq_routes;
import 'package:common/config/routes/route.dart' as common_routes;
import 'package:loan/config/routes/route.dart';
import 'package:service_ticket/config/routes/route.dart' as service_routes;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:loan/features/loan_cancellation/data/models/fetch_sr_response.dart';

class LoanCancellationFailureScreen extends StatelessWidget {
  final bool isNotPl;
  final bool isNotFlp;
  final OpenStatusSrForLc? srDetails;
  const LoanCancellationFailureScreen({
    super.key,
    required this.isNotPl,
    required this.isNotFlp,
    this.srDetails,
  });

  @override
  Widget build(BuildContext context) {
    // context
    //     .read<LoanCancellationCubit>()
    //     .checkProductStatus(CheckProductStatusRequest());
    return Scaffold(
        appBar: customAppbar(
          context: context,
          title: "",
          leading: const SizedBox.shrink(),
          onPressed: () {},
        ),
        body: MFGradientBackground(
            child: ScrollConfiguration(
          behavior: const MaterialScrollBehavior().copyWith(overscroll: false),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.error_outline,
                color: setColorBasedOnTheme(
                    context: context,
                    lightColor: AppColors.secondaryLight,
                    darkColor: AppColors.secondaryLight5),
                size: 60,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                child: Text(
                  // _getTitle(state.response),

                  srDetails != null
                      ? getString(lblLoanCanelInProgress)
                      : (isNotPl)
                          ? getString(msgVisitBranchLoanCancellation)
                          : getString(lblRequestCannotBeProcessed),
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ),
              // _getScreen(state.response, context)
              srDetails != null
                  ? _serviceTicketCard(context, srDetails!)
                  : (isNotPl)
                      ? Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(8)),
                              child: Column(
                                children: [
                                  customerSupportWidget(
                                      context,
                                      Icons.phone_android,
                                      "Contact customer care"),
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 7),
                                    child: Divider(
                                      thickness: 1,
                                      color: Theme.of(context).dividerColor,
                                    ),
                                  ),
                                  customerSupportWidget(context,
                                      Icons.email_outlined, "Email us"),
                                ],
                              ),
                            ),
                            _offerCardWidget(context),
                          ],
                        )
                      : Column(
                          children: [
                            tryAgainLaterWidget(context),
                            Container(
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(8)),
                              child: Column(
                                children: [
                                  customerSupportWidget(
                                      context,
                                      Icons.phone_android,
                                      "Contact customer care"),
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 7),
                                    child: Divider(
                                      thickness: 1,
                                      color: Theme.of(context).dividerColor,
                                    ),
                                  ),
                                  customerSupportWidget(context,
                                      Icons.email_outlined, "Email us"),
                                ],
                              ),
                            ),
                          ],
                        )
            ],
          ),
        )
            // }
            // return Container();
            // },
            // ),
            ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Column(
            mainAxisSize: MainAxisSize.min,
            children: srDetails != null
                ? [
                    CustomOutlinedButton(
                      height: 48.v,
                      text: getString(lblTrackSR),
                      margin: EdgeInsets.only(right: 15.h, left: 15.h),
                      buttonStyle: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: Theme.of(context).highlightColor,
                          width: 1,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.h),
                        ),
                      ),
                      buttonTextStyle: TextStyle(
                          fontSize: AppDimens.titleSmall,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.1,
                          color: Theme.of(context).highlightColor),
                      onPressed: () {
                        context.pushNamed(
                            service_routes.Routes.serviceRequest.name);
                      },
                    ),
                    SizedBox(
                      height: 15.v,
                    ),
                    CustomElevatedButton(
                      height: 48.v,
                      text: getString(lblHome),
                      margin: EdgeInsets.only(left: 15.h, right: 15.h),
                      buttonStyle: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).highlightColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.h),
                        ),
                      ),
                      onPressed: () {
                        while (context.canPop()) {
                          context.pop();
                        }
                        context.pushReplacementNamed(
                          common_routes.Routes.home.name,
                        );
                      },
                    ),
                  ]
                : [
                    CustomElevatedButton(
                      height: 48.v,
                      text: getString(lblGoToHelpFAQs),
                      margin: EdgeInsets.only(left: 15.h, right: 15.h),
                      buttonStyle: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).highlightColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.h),
                        ),
                      ),
                      onPressed: () {
                        context.pushNamed(faq_routes.Routes.faq.name);
                        // Routes.faq.name
                      },
                    ),
                    SizedBox(
                      height: 15.v,
                    ),
                    CustomOutlinedButton(
                      height: 48.v,
                      text: getString(lblBackToHome),
                      margin: EdgeInsets.only(right: 15.h, left: 15.h),
                      buttonStyle: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: Theme.of(context).highlightColor,
                          width: 1,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.h),
                        ),
                      ),
                      buttonTextStyle: TextStyle(
                          fontSize: AppDimens.titleSmall,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.1,
                          color: Theme.of(context).highlightColor),
                      onPressed: () {
                        while (context.canPop()) {
                          context.pop();
                        }
                        context.pushReplacementNamed(
                          common_routes.Routes.home.name,
                        );
                      },
                    )
                  ])
        // }
        // return Container();
        // },
        // ),
        );
  }

  Container tryAgainLaterWidget(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).cardColor),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: getString(msgTryAgain20Mins),
              style: Theme.of(context).textTheme.labelSmall,
            ),
            TextSpan(
              text: getString(msgNearbyBranch),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: setColorBasedOnTheme(
                        context: context,
                        lightColor: AppColors.secondaryLight,
                        darkColor: AppColors.secondaryLight5),
                  ),
            ),
            TextSpan(
              text: getString(msgForHelp),
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),
      ),
    );
  }

  Container _serviceTicketCard(
      BuildContext context, OpenStatusSrForLc srDetails) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            getString(msgExistingServiceTicket),
            style: Theme.of(context).textTheme.titleSmall,
          ),
          Container(
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.only(top: 8, bottom: 15),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Theme.of(context).dividerColor),
            child: Row(
              children: [
                Icon(
                  Icons.schedule,
                  color: Theme.of(context).primaryColor,
                  size: 20,
                ),
                SizedBox(
                  width: 5.h,
                ),
                Text(
                    getString(msgServiceTicketCreated) +
                        srDetails.caseCreatedAt.toString(),
                    style: Theme.of(context)
                        .textTheme
                        .labelSmall
                        ?.copyWith(fontSize: 11))
              ],
            ),
          ),
          Wrap(
              runAlignment: WrapAlignment.spaceBetween,
              spacing: 80,
              runSpacing: 16,
              children: [
                ticketDetailsWidget(context, getString(lblSrTicketNo),
                    srDetails.caseNumber.toString()),
                ticketDetailsWidget(context, getString(lblQuery),
                    srDetails.category.toString()),
                ticketDetailsWidget(
                    context, getString(lblStatus), srDetails.status.toString()),
              ])
        ],
      ),
    );
  }

  Column ticketDetailsWidget(BuildContext context, String title, String desc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        Text(
          desc,
          style: Theme.of(context).textTheme.labelSmall,
        ),
      ],
    );
  }

  Widget _offerCardWidget(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(Routes.loanCancelOffersScreen.name);
      },
      child: Container(
        margin: const EdgeInsets.only(top: 30),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(8)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(getString(msgPreApprovedOffer),
                  style: Theme.of(context).textTheme.titleSmall),
              Text(
                getString(msgCongratulationsEligibleForOffer),
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: setColorBasedOnTheme(
                        context: context,
                        lightColor: AppColors.primaryLight,
                        darkColor: AppColors.white)),
              ),
              SizedBox(
                height: 16.v,
              ),
              Row(children: [
                Text(
                  getString(lbllcAvailNow),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: setColorBasedOnTheme(
                          context: context,
                          lightColor: AppColors.secondaryLight,
                          darkColor: AppColors.secondaryLight5)),
                ),
                Icon(
                  Icons.chevron_right,
                  color: setColorBasedOnTheme(
                      context: context,
                      lightColor: AppColors.secondaryLight,
                      darkColor: AppColors.secondaryLight5),
                )
              ]),
            ]),
            Image.asset(
              Images.offersImage,
              fit: BoxFit.fill,
              height: 85.v,
              width: 114.h,
            )
          ],
        ),
      ),
    );
  }

  Row customerSupportWidget(BuildContext context, IconData icon, String title) {
    return Row(
      children: [
        Icon(icon,
            color: setColorBasedOnTheme(
                context: context,
                lightColor: AppColors.secondaryLight,
                darkColor: AppColors.secondaryLight5)),
        SizedBox(
          width: 8.h,
        ),
        Text(
          title,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: setColorBasedOnTheme(
                  context: context,
                  lightColor: AppColors.secondaryLight,
                  darkColor: AppColors.secondaryLight5)),
        ),
      ],
    );
  }
}
