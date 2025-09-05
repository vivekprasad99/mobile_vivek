import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/resources/image_constant.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../mf_theme_check.dart';
class BuildProductPayScreen extends StatelessWidget {
   const BuildProductPayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final screenHeight = constraints.maxHeight;
        double adaptSize(double size) => size * (screenWidth / 375);
        double adaptHeight(double size) => size * (screenHeight / 667);

        return Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(left: adaptSize(100)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(adaptSize(8.0)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          getString(msgExploreOurWideRange),
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: AppColors.white),
                        ),
                        SvgPicture.asset(
                     ImageConstant.imageArrow1,
                          height: adaptHeight(80),
                          width: adaptSize(48),
                          colorFilter: ColorFilter.mode(
                            setColorBasedOnTheme(
                              context: context,
                              lightColor: AppColors.white,
                              darkColor: AppColors.white,
                            ),
                            BlendMode.srcIn,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(adaptSize(8)),
                        width: adaptSize(70),
                        height: adaptSize(62),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.all(
                            Radius.circular(adaptSize(12)),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              ImageConstant.imgNavProducts,
                              height: adaptSize(22),
                              width: adaptSize(22),
                               colorFilter: ColorFilter.mode(
                                setColorBasedOnTheme(
                                    context: context,
                                    lightColor: AppColors.customUnSelectLight,
                                    darkColor: AppColors.disableTextDark),
                                BlendMode.srcIn,
                              )
                            ),
                            Transform.translate(
                              offset: const Offset(0, 6),
                              child: Text(
                                getString(products),
                                textAlign: TextAlign.end,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: setColorBasedOnTheme(
                                          context: context,
                                          lightColor: AppColors.primaryLight3,
                                          darkColor: AppColors.disableTextDark,
                                        ),
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: adaptSize(25),
                      ),
                      Container(
                        padding: EdgeInsets.all(adaptSize(8)),
                        width: adaptSize(70),
                        height: adaptSize(62),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.all(
                            Radius.circular(adaptSize(12)),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              ImageConstant.imgNavPay,
                              height: adaptSize(24),
                              width: adaptSize(24),
                              colorFilter: ColorFilter.mode(
                                setColorBasedOnTheme(
                                    context: context,
                                    lightColor: AppColors.customUnSelectLight,
                                    darkColor: AppColors.disableTextDark),
                                BlendMode.srcIn,
                              ),
                            ),
                            Transform.translate(
                              offset: const Offset(0, 6),
                              child: Text(
                                getString(lblPay),
                                textAlign: TextAlign.end,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: setColorBasedOnTheme(
                                    context: context,
                                    lightColor: AppColors.customUnSelectLight,
                                    darkColor: AppColors.disableTextDark),
                                    ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              top: adaptSize(55),
              left: adaptSize(160),
              child: Column(
                children: [
                  SizedBox(
                    width: adaptSize(200),
                    child: Text(
                      getString(msgPayYourUpcomingEmi),
                      maxLines: 3,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: AppColors.white),
                    ),
                  ),
                  SvgPicture.asset(
                  ImageConstant.imageArrow2,
                    height: adaptHeight(38),
                    width: adaptSize(48),
                    colorFilter: ColorFilter.mode(
                      setColorBasedOnTheme(
                        context: context,
                        lightColor: AppColors.white,
                        darkColor: AppColors.white,
                      ),
                      BlendMode.srcIn,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
