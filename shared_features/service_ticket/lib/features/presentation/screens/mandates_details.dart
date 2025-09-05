import 'package:core/config/resources/image_constant.dart';
import 'package:core/config/widgets/background/mf_gradient_background.dart';
import 'package:core/config/widgets/custom_buttons/mf_custom_elevated_button.dart';
import 'package:core/config/widgets/mf_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:help/features/utils/constant_help.dart';
import 'package:help/features/utils/help_common_widget.dart';

class MandatesDetails extends StatelessWidget {
  const MandatesDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(
          context: context, title: "Mandate details", onPressed: () {},
          actions: [
            HelpCommonWidget(categoryval: HelpConstantData.categoryServiceReq,subCategoryval: HelpConstantData.subCategoryMandateDetails,)
          ]),
      body: MFGradientBackground(
        horizontalPadding: 12,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: Container(
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      child: SvgPicture.asset(
                          ImageConstant.imgVehicleLoanIconLight),
                    ),
                    title: Text("Vehicle Loan | VL728392",
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            letterSpacing: 0.5, fontWeight: FontWeight.w500)),
                    subtitle: Text("MH 01 AB 4604",
                        style: Theme.of(context).textTheme.bodyMedium),
                    trailing: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: const Color.fromRGBO(237, 224, 227, 1),
                          borderRadius: BorderRadius.circular(4)),
                      child: Text("Active",
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(fontSize: 11)),
                    ),
                  ),
                  Divider(
                    color: Theme.of(context).dividerColor,
                  ),
                  buildRow(context, "Start date", "12/12/2023", "End date",
                      "12/12/2023"),
                  buildRow(context, "Frequency", "Monthly",
                      "Bank a/c holder name", "Mahesh Bhat"),
                  buildRow(context, "Bank Name", "ICICI bank", "Bank a/c no.",
                      "8283020183010"),
                  buildRow(
                      context, "Branch name", "Worli", "UMRN no.", "09009"),
                ],
              ),
            ),
            const Spacer(),
            MfCustomButton(
                onPressed: () {},
                text: "Update mandate",
                outlineBorderButton: true),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "Cancel mandate",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Theme.of(context).highlightColor),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildRow(BuildContext context, String title, String subtitle,
      String title2, String subtitle2) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Text(subtitle, style: Theme.of(context).textTheme.labelSmall),
              ],
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title2,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Text(subtitle2, style: Theme.of(context).textTheme.labelSmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
