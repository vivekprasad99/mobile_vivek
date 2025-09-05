

import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/resources/image_constant.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:core/utils/size_utils.dart';
import 'package:flutter/widgets.dart';
import 'package:product_details/presentation/screens/widget/custom_image_view.dart';

Widget genericErrorWidget(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomImageView(
              imagePath: ImageConstant.vector,
              height: 50.adaptSize,
              width: 50.adaptSize,
              color: setColorBasedOnTheme(
                  context: context,
                  lightColor: AppColors.primaryLight,
                  darkColor: AppColors.backgroundDarkGradient6)),
          SizedBox(
            width: 12.v,
          ),
          Flexible(child: Text(getString(lblErrorGeneric))),
        ],
      ),
    );
  }