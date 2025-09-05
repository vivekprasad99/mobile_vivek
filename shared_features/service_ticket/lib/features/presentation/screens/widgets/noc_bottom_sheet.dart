import 'package:core/config/string_resource/strings.dart';
import 'package:core/config/widgets/custom_buttons/mf_custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:service_ticket/features/presentation/screens/widgets/common_bottom_sheet.dart';
import 'package:noc/config/routes/route.dart' as noc_route;

class NocBottomSheet extends StatelessWidget {
  const NocBottomSheet({super.key});

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
              getString(lblNoc),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(
              height: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BuildBottomsheetRow(
                    title: getString(lblServiceViewTrack),
                    onPressed: () {
                      context.pop();
                      context.pushNamed(noc_route.Routes.nocLoanList.name,
                          extra: getString(lblServiceViewTrack));
                    }),
                Divider(
                  color: Theme.of(context).dividerColor,
                ),
                BuildBottomsheetRow(
                    title: getString(lblServiceNotDelivered),
                    onPressed: () {
                      context.pop();
                      context.pushNamed(noc_route.Routes.nocLoanList.name,
                          extra: getString(lblServiceNotDelivered));
                    }),
                Divider(
                  color: Theme.of(context).dividerColor,
                ),
                BuildBottomsheetRow(
                    title: getString(lblServiceDuplicateLostNoc),
                    onPressed: () {
                      context.pop();
                      context.pushNamed(noc_route.Routes.nocLoanList.name,
                          extra: getString(lblServiceDuplicateLostNoc));
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
}
