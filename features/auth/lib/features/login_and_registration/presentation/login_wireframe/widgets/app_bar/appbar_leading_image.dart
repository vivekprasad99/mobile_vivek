import 'package:core/utils/size_utils.dart';
import 'package:flutter/material.dart';

import '../custom_image_view.dart';

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
        onTap!.call();
      },
      child: Padding(
        padding: margin ?? EdgeInsets.zero,
        child: CustomImageView(
          imagePath: imagePath,
          height: 19.v,
          width: 20.h,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
