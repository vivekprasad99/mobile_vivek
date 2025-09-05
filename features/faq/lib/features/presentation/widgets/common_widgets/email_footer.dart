import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/resources/image_constant.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

Widget emailFooter(BuildContext context) {
  return InkWell(
    onTap: () async {
      final Uri params = Uri(
        scheme: 'mailto',
        path: 'service.mmfsl@mahindra.com',
      );

      var url = params.toString();
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      } else {
        throw 'Could not launch $url';
      }
    },
    child: Container(
      decoration: BoxDecoration(
        color: setColorBasedOnTheme(
          context: context,
          lightColor: AppColors.white,
          darkColor: AppColors.primaryDark,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.5),
            spreadRadius: 0,
            blurRadius: 4,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(14.0),
      child: Row(children: [
        SvgPicture.asset(
          ImageConstant.emailIcon,
          colorFilter: ColorFilter.mode(
              setColorBasedOnTheme(
                  context: context,
                  lightColor: AppColors.primaryLight,
                  darkColor: AppColors.primaryLight6),
              BlendMode.srcIn),
        ),
        const SizedBox(
          width: 10,
        ),
        Row(
          children: [
            Text(getString(lblYouCanMail),style: Theme.of(context).textTheme.bodySmall,),
            Text(
              "service.mmfsl@mahindra.com",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: setColorBasedOnTheme(
                      context: context,
                      lightColor: AppColors.secondaryLight,
                      darkColor: AppColors.secondaryLight2)),
            )
          ],
        )
      ]),
    ),
  );
}
