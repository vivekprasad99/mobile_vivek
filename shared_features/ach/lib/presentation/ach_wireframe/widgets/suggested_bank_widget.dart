import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:core/utils/size_utils.dart';
import 'package:flutter/material.dart';
import '../../../data/models/get_bank_list_resp.dart';

class SuggestedItemWidget extends StatelessWidget {
  const SuggestedItemWidget({
    super.key,
    this.onSelectedChipView,
    this.bank,
    required this.isSelected,
  });

   final Bank? bank;
 final  bool isSelected;

 final  Function(bool)? onSelectedChipView;

  @override
  Widget build(BuildContext context) {
    return RawChip(
      padding: EdgeInsets.symmetric(
        horizontal: 12.h,
        vertical: 12.v,
      ),
      showCheckmark: false,
      labelPadding: EdgeInsets.zero,
      label: Text(
        bank?.bankName ?? "",
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: isSelected?setColorBasedOnTheme(
              context: context,
              lightColor: AppColors.white,
              darkColor: AppColors.white)
        :setColorBasedOnTheme(
          context: context,
          lightColor: AppColors.secondaryLight,
          darkColor: AppColors.secondaryLight5),

        )
      ),
      selected: (isSelected),
      selectedColor: setColorBasedOnTheme(
          context: context,
          lightColor: AppColors.secondaryLight,
          darkColor: AppColors.secondaryLight),
      shape: (isSelected)
          ? RoundedRectangleBorder(
              side: BorderSide(
                color:setColorBasedOnTheme(
                    context: context,
                    lightColor: AppColors.secondaryLight,
                    darkColor: AppColors.secondaryLight),
                
              ),
              borderRadius: BorderRadius.circular(
                20.h,
              ),
            )
          : RoundedRectangleBorder(
              side: BorderSide(
                color: setColorBasedOnTheme(
                    context: context,
                    lightColor: AppColors.secondaryLight,
                    darkColor: AppColors.secondaryLight5),
               
              ),
              borderRadius: BorderRadius.circular(
                20.h,
              ),
            ),
      onSelected: (value) {
        onSelectedChipView?.call(value);
      },
    );
  }
}
