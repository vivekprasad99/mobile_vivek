import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/config/widgets/custom_buttons/mf_custom_elevated_button.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:core/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:common/config/routes/route.dart';
import 'package:go_router/go_router.dart';

class ExploreWidget extends StatefulWidget {
  const ExploreWidget({super.key});

  @override
  State<ExploreWidget> createState() => _ExploreWidgetState();
}

class _ExploreWidgetState extends State<ExploreWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: setColorBasedOnTheme(
          context: context,
          lightColor: AppColors.white,
          darkColor: AppColors.cardDark,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            child: SvgPicture.asset(
              "assets/images/svg/clear_Space.svg",
              height: 100.adaptSize,
              fit: BoxFit.fill,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10.h),
              Text(
                getString(lblExploreConsent),
                style: Theme.of(context).textTheme.bodySmall,
              ),
               SizedBox(height: 10.h),
              Text(
                getString(lblExploreTitle),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: 20.v),
              Align(
                alignment: Alignment.centerRight,
                child: MfCustomButton(
                  onPressed: () {
                    context.pushNamed(Routes.home.name, extra: 1);
                  },
                  text: getString(lblLandingPageExploreButton),
                  width: MediaQuery.of(context).size.height * 0.12,
                  outlineBorderButton: false,
                ),
              ),
              SizedBox(height: 5.v),
            ],
          ),
        ],
      ),
    );
  }
}
