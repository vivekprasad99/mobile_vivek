import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/resources/image_constant.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../mf_theme_check.dart';
class BuildCalculatorService extends StatelessWidget {
  const BuildCalculatorService({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(left: width * 0.63),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(width * 0.025),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          getString(msgPayRaiseAService),
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: AppColors.white),
                        ),
                        SvgPicture.asset(
                          ImageConstant.imageArrow4,
                          height: width * 0.2,
                          width: width * 0.1,
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
                        width: width * 0.20,
                        height: width * 0.16,
                        padding: EdgeInsets.all(width * 0.02),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.all(
                            Radius.circular(width * 0.03),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              ImageConstant.imgNavServices,
                              height: width * 0.06,
                              width: width * 0.06,
                              colorFilter: ColorFilter.mode(
                                setColorBasedOnTheme(
                                    context: context,
                                    lightColor: AppColors.customUnSelectLight,
                                    darkColor: AppColors.disableTextDark),
                                BlendMode.srcIn,
                              )
                            ),
                            Transform.translate(
                              offset: Offset(0, width * 0.01),
                              child: Text(
                                getString(lblServices),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color:  setColorBasedOnTheme(
                                    context: context,
                                    lightColor: AppColors.customUnSelectLight,
                                    darkColor: AppColors.disableTextDark),
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: width * 0.01),
                    ],
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
