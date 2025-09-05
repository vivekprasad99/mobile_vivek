import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/resources/image_constant.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/config/widgets/mf_custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../mf_theme_check.dart';

class BuildLoanIntro extends StatelessWidget {
  const BuildLoanIntro({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double adaptSize(double value) => value * (size.width / 375);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: size.height * 0.13),
            child: Text(
              getString(lblActiveProduct),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: size.height * 0.01),
            padding: EdgeInsets.symmetric(
                horizontal: adaptSize(10), vertical: adaptSize(14)),
            decoration: BoxDecoration(
              color: setColorBasedOnTheme(
                context: context,
                lightColor: AppColors.white,
                darkColor: AppColors.cardDark,
              ),
              borderRadius: BorderRadius.all(Radius.circular(adaptSize(8))),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      getString(msgCarLoan),
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Text(
                      '₹${getString(msgAmount)}',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: Theme.of(context).textTheme.bodyLarge,
                    )
                  ],
                ),
                Text(
                  getString(msgAVehicleNumber),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                SizedBox(height: adaptSize(12)),
                Text(
                  getString(msgAmountDue),
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '₹${getString(msgAmountDueValue)}',
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                          Text(
                            getString(msgDueDateValue),
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        ],
                      ),
                    ),
                    MfCustomButton(
                      onPressed: () {},
                      text: getString(lblPayButton),
                      width: size.height * 0.14,
                      outlineBorderButton: false,
                    ),
                  ],
                ),
                Center(
                  child: Container(
                    margin: EdgeInsets.all(adaptSize(5)),
                    child: SizedBox(
                      height: adaptSize(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(3, (index) {
                          return Container(
                            width: adaptSize(10),
                            height: adaptSize(6),
                            margin: EdgeInsets.symmetric(horizontal: adaptSize(3)),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: index == 0
                                  ? AppColors.primaryLight
                                  : AppColors.primaryLight4,
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(adaptSize(8)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  ImageConstant.imageArrow5,
                  height: adaptSize(45),
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
                Text(
                  getString(msgAccessAllYourProduct),
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
      ),
    );
  }
}