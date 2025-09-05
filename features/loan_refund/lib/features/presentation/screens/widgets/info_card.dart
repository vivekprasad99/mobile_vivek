import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/resources/image_constant.dart';
import 'package:core/config/string_resource/Strings.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:core/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class InfoCard extends StatelessWidget {
  const InfoCard(
      {super.key, required this.infoMessage, this.height, this.width});

  final String infoMessage;
  final double? height, width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 65,
      child: Card(
        color: setColorBasedOnTheme(
            context: context,
            lightColor: AppColors.cardLight,
            darkColor: AppColors.cardDark),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 0,
                child: Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: SvgPicture.asset(
                    ImageConstant.info,
                    height: 19.h,
                    width: 19.v,
                    colorFilter: ColorFilter.mode(
                        Theme.of(context).primaryColor, BlendMode.srcIn),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  getString(infoMessage),
                  maxLines: 3,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w400,
                      fontSize: 15.0),
                  // overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
