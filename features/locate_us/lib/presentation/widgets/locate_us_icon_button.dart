import 'package:core/config/resources/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../locate_us.dart';
import '../utils/image_constants.dart';

class LocateUsButton extends StatelessWidget {
  const LocateUsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      style: IconButton.styleFrom(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
      onPressed: () {
        LocateUsServices.triggerFromDeny(context);
      },
      icon: SvgPicture.asset(
        ImageConstant.myLocation,
      ),
    );
  }
}
