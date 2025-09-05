import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:core/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:product_details/presentation/screens/widget/custom_image_view.dart';

// ignore: must_be_immutable
class AppbarLeadingImage extends StatelessWidget {
  AppbarLeadingImage({
    super.key,
    this.imagePath,
    this.margin,
    this.onTap,
  });

  String? imagePath;

  EdgeInsetsGeometry? margin;

  Function? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap?.call();
      },
      child: Padding(
        padding: margin ?? EdgeInsets.zero,
        child: CustomImageView(
          imagePath: imagePath,
          height: 24.adaptSize,
          width: 24.adaptSize,
          fit: BoxFit.contain,
          color: setColorBasedOnTheme(
              context: context,
              lightColor: AppColors.primaryLight,
              darkColor: AppColors.white),
        ),
      ),
    );
  }
}
