import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/resources/image_constant.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/config/widgets/background/mf_gradient_background.dart';
import 'package:core/config/widgets/custom_buttons/mf_custom_elevated_button.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:core/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:common/config/routes/route.dart' as common_route;
import 'package:service_ticket/config/routes/route.dart' as ticket;
import 'package:service_ticket/features/data/models/dedupe_response.dart';

class ServiceRequestExist extends StatelessWidget {
  final DedupeResponse dedupeResponse;

  const ServiceRequestExist({required this.dedupeResponse, super.key});

  @override
  Widget build(BuildContext context) {
    var serviceTicketNumber = dedupeResponse.data?.first.toString();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      body: MFGradientBackground(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 50.v),
            SvgPicture.asset(
              ImageConstant.imgCongratulationIcon,
              height: 88.v,
              width: 48.h,
              colorFilter: ColorFilter.mode(
                  setColorBasedOnTheme(
                      context: context,
                      lightColor: AppColors.secondaryLight,
                      darkColor: AppColors.primaryLight5),
                  BlendMode.srcIn),
            ),
            SizedBox(height: 17.v),
            Text(
              getString(msgServiceRequestExist),
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            SizedBox(height: 17.v),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: const BorderRadius.all(Radius.circular(8))),
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 8.0, top: 16.0, bottom: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          "${getString(serviceTicketNo)} ${serviceTicketNumber ?? ""} ",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Icon(
                          Icons.copy,
                          color: setColorBasedOnTheme(
                              context: context,
                              lightColor: AppColors.primaryLight,
                              darkColor: AppColors.primaryLight5),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      getString(youTicketRaised),
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MfCustomButton(
                    onPressed: () {
                      context.pushNamed(
                          ticket.Routes.serviceRequestDetailScreen.name,
                          extra: false);
                    },
                    text: getString(trackRequest),
                    outlineBorderButton: true),
                const SizedBox(
                  height: 20,
                ),
                MfCustomButton(
                    onPressed: () {
                      context.pushNamed(common_route.Routes.home.name);
                    },
                    text: getString(home),
                    outlineBorderButton: false),
              ],
            )
          ],
        ),
      ),
    );
  }
}
