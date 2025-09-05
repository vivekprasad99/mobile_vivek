import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/widgets/mf_theme_check.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FDSelectTile extends StatelessWidget {
  final String? title;
  final bool isSelected;
  const FDSelectTile({
    super.key,
    this.onTap,
    this.isSelected = false,
    this.title,
  });

  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: const BorderRadius.all(
                Radius.circular(8),
              ),
              border: isSelected
                  ? Border.all(
                      color: setColorBasedOnTheme(
                          context: context,
                          lightColor: AppColors.primaryLight4,
                          darkColor: AppColors.borderSelectedDark),
                    )
                  : null),
          child: Padding(
            padding:
                EdgeInsets.only(left: 8.h, top: 4.h, bottom: 11.h, right: 4.h),
            child: Column(
              children: [
                isSelected
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(Icons.check_circle_outline,
                              size: 8.h, color: Theme.of(context).primaryColor),
                        ],
                      )
                    : SizedBox(
                        height: 8.h,
                      ),
                Row(
                  children: [
                    Text(title ?? "",
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium
                            ?.copyWith(fontWeight: FontWeight.w500, fontSize: 15)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}











