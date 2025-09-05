import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/resources/image_constant.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../mf_theme_check.dart';

class BuildMenuIntro extends StatelessWidget {
  const BuildMenuIntro({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 5.adaptSize),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      padding: EdgeInsets.all(10.adaptSize),
                      decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius:
                              BorderRadius.all(Radius.circular(12.adaptSize))),
                      child: Column(
                        children: [
                          Icon(
                            Icons.menu,
                            size: 30.adaptSize,
                            color: AppColors.primaryLight,
                          ),
                        ],
                      )),
                  Padding(
                    padding:
                        EdgeInsets.only(left: 25.adaptSize, top: 10.adaptSize),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SvgPicture.asset(
                          ImageConstant.imageArrow6,
                          height: 50.adaptSize,
                          width: 48.adaptSize,
                          colorFilter: ColorFilter.mode(
                            setColorBasedOnTheme(
                              context: context,
                              lightColor: AppColors.white,
                              darkColor: AppColors.white,
                            ),
                            BlendMode.srcIn,
                          ),
                        ),
                        Text(
                          getString(msgYouCanAccess),
                          maxLines: 3,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: AppColors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}

