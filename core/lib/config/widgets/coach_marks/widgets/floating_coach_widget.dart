import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/resources/image_constant.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../mf_theme_check.dart';

class BuildFloatingScreen extends StatelessWidget {
  const BuildFloatingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    double adaptSize(double size) {
      return size * (screenWidth / 375); 
    }
    double adaptHeight(double size) {
      return size * (screenHeight / 812);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: EdgeInsets.only(right: adaptSize(20)),
          child: Text(
            getString(msgForAssistanceThrough),
            maxLines: 3,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: AppColors.white),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: adaptSize(120), top: adaptSize(10)),
          child: SvgPicture.asset(
            ImageConstant.imageArrow1,
            height: adaptHeight(55),
            colorFilter: ColorFilter.mode(
              setColorBasedOnTheme(
                context: context,
                lightColor: AppColors.white,
                darkColor: AppColors.white,
              ),
              BlendMode.srcIn,
            ),
          ),
        ),
        Row(
          children: [
            Column(
              children: [
                Transform.translate(
                  offset: const Offset(-2.0, 18.0),
                  child: CircleAvatar(
                    backgroundColor: AppColors.white,
                    radius: adaptSize(27),
                    child: Padding(
                      padding: EdgeInsets.all(adaptSize(10.0)),
                      child: Column(
                        children: [
                          SvgPicture.asset(
                            ImageConstant.imgChat,
                            height: adaptHeight(14),
                          ),
                           SizedBox(
                            height: adaptHeight(5),
                          ),
                          Text(
                            getString(chat),
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  color: setColorBasedOnTheme(
                                    context: context,
                                    lightColor: AppColors.primaryLight,
                                    darkColor: AppColors.primaryLight,
                                  ),
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Transform.translate(
                  offset: const Offset(8.0, 26.0),
                  child: CircleAvatar(
                    backgroundColor: AppColors.white,
                    radius: adaptSize(27),
                    child: Padding(
                      padding: EdgeInsets.all(adaptSize(7.0)),
                      child: Column(
                        children: [
                          SvgPicture.asset(
                            ImageConstant.imgLocation,
                            height: adaptHeight(15),
                          ),
                           SizedBox(
                            height: adaptHeight(7),
                          ),
                          Text(
                            getString(locate),
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  color: setColorBasedOnTheme(
                                    context: context,
                                    lightColor: AppColors.primaryLight,
                                    darkColor: AppColors.primaryLight,
                                  ),
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    right: adaptSize(11),
                    bottom: adaptSize(21),
                  ),
                  child: CircleAvatar(
                    backgroundColor: AppColors.white,
                    radius: adaptSize(27),
                    child: Padding(
                      padding:EdgeInsets.all(adaptSize(8.0)),
                      child: Column(
                        children: [
                          SvgPicture.asset(
                            ImageConstant.imgMobile,
                            height: adaptHeight(18),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            getString(call),
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  color: setColorBasedOnTheme(
                                    context: context,
                                    lightColor: AppColors.primaryLight,
                                    darkColor: AppColors.primaryLight,
                                  ),
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: adaptSize(12),
                ),
                Transform.translate(
                  offset: const Offset(-4, -25),
                  child: SvgPicture.asset(
                   ImageConstant.imgFloatingAction,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
