import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/config/widgets/custom_buttons/mf_custom_elevated_button.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:common/features/search/data/model/search_response.dart';

import '../../../../config/routes/route.dart';
import '../../helper/services_type.dart';

class LoanDetailsBottomWidget extends StatelessWidget {
  final String cardName;

  const LoanDetailsBottomWidget({required this.cardName, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(28),
        topRight: Radius.circular(28),
      )),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 20,
            ),
            Text(
              cardName == "loan"
                  ? getString(lblLoanRelatedDoc)
                  : cardName == getString(lblMiscellaneous)
                      ? getString(lblMiscellaneous)
                      : getString(lblEMandates),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(
              height: 20,
            ),
            cardName == "loan"
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildRow(context, getString(lblRepaymentSchedule), () {
                        context.pop();
                        context.pushNamed(Routes.selectDetailsPage.name,
                            extra: ServicesNavigationRequest(
                              cardName: cardName,
                              cardType: 'Repayment schedule'
                            ).toJson());
                      }),
                      Divider(
                        color: Theme.of(context).dividerColor,
                      ),
                      buildRow(context, getString(lbl_statementOfAcount), () {
                        context.pushNamed(Routes.selectDetailsPage.name,
                            extra: ServicesNavigationRequest(
                              cardName: cardName,
                              cardType: 'Statement Of Account'
                            ).toJson());
                      }),
                      Divider(
                        color: Theme.of(context).dividerColor,
                      ),
                      buildRow(context, getString(lblKeyFactStatement), () {
                        context.pushNamed(Routes.selectDetailsPage.name,
                        extra: ServicesNavigationRequest(
                              cardName: cardName,
                              cardType: 'Key fact statement'
                            ).toJson());
                      }),
                    ],
                  )
                : cardName == getString(lblMiscellaneous)
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildRow(context, getString(labelVehicleInsurance),
                              () {
                            context.pop();
                            context.pushNamed(Routes.raiseRequest.name, extra: {'type': Services.miscellaneous.value, 'id': '1'});
                          }),
                          Divider(
                            color: Theme.of(context).dividerColor,
                          ),
                          buildRow(context, getString(lblOthers), () {
                            context.pop();
                            context.pushNamed(Routes.raiseRequest.name, extra: {'type': Services.miscellaneous.value, 'id': '2'});
                          }),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildRow(context, getString(lblCreate), () {
                            context.pop();
                            context.pushNamed(Routes.selectDetailsPage.name,
                                extra: ServicesNavigationRequest(
                                cardName: cardName,
                                cardType: 'Create'
                            ).toJson());
                          }),
                          Divider(
                            color: Theme.of(context).dividerColor,
                          ),
                          buildRow(context, getString(lblModify), () {
                            context.pop();
                            context.pushNamed(Routes.selectDetailsPage.name,
                                extra: ServicesNavigationRequest(
                                cardName: cardName,
                                cardType: 'Modify'
                            ).toJson());
                          }),
                        ],
                      ),
            Divider(
              color: Theme.of(context).dividerColor,
            ),
            const SizedBox(
              height: 20,
            ),
            MfCustomButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                text: getString(lblBack),
                outlineBorderButton: true),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildRow(BuildContext context, String title, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          IconButton(
              onPressed: onPressed,
              icon: Icon(
                Icons.arrow_forward_ios,
                color: setColorBasedOnTheme(
                    context: context,
                    lightColor: AppColors.primaryLight,
                    darkColor: AppColors.white),
              ))
        ],
      ),
    );
  }
}

class BuildBottomsheetRow extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  const BuildBottomsheetRow(
      {super.key, required this.title, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          IconButton(
            onPressed: onPressed,
            icon: Icon(
              Icons.arrow_forward_ios,
              color: setColorBasedOnTheme(
                  context: context,
                  lightColor: AppColors.primaryLight,
                  darkColor: AppColors.white),
            ),
          )
        ],
      ),
    );
  }
}
