import 'package:core/config/resources/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../locate_us.dart';
import '../utils/image_constants.dart';

class LocateUsStateCityLocationWidget extends StatelessWidget {
  const LocateUsStateCityLocationWidget({
    super.key,
    required this.text,
    this.isElevated = false,
  });

  final String text;
  final bool isElevated;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(Routes.locateUsSearch.name);
      },
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8.r),
          boxShadow: isElevated
              ? [
                  BoxShadow(
                      offset: const Offset(0, 1),
                      blurRadius: 2,
                      color: AppColors.black.withOpacity(0.25))
                ]
              : null,
        ),
        child: Row(
          children: [
            const SizedBox(width: 12),
            SvgPicture.asset(
              ImageConstant.location,
              colorFilter: const ColorFilter.mode(
                AppColors.primaryLight,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                text,
                style: Theme.of(context).textTheme.labelMedium,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
