import 'package:core/utils/size_utils.dart';
import 'package:flutter/material.dart';

import '../../resources/app_colors.dart';
import '../mf_theme_check.dart';

showMFFormBottomSheetWithButton(BuildContext context,
    {required String title, required String message, required leftBtnLbl,  required rightBtnLbl, required Function() leftBtnOnPressed, required Function() rightBtnOnPressed}) {
  showModalBottomSheet<void>(
    backgroundColor: Theme.of(context).cardColor,
    isScrollControlled: true,
    context: context,
    builder: (BuildContext context) {
      return SizedBox(
        height: 400.v,
        child: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(28.0))),
          width: double.maxFinite,

          padding: EdgeInsets.symmetric(
            horizontal: 16.h,
            vertical: 24.v,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(
                height: 16.v,
              ),
              Expanded(
                  child: Text(
                    message,
                    style: Theme.of(context).textTheme.labelMedium,
                  )),
              SizedBox(height: 12.v),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                        width: 166.v,
                        height: 42.h,
                        child: ElevatedButton(
                            onPressed: leftBtnOnPressed,
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Theme.of(context).cardColor),
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8.0),
                                        side: BorderSide(
                                            color: setColorBasedOnTheme(
                                              context: context,
                                              lightColor: AppColors.secondaryLight,
                                              darkColor: AppColors.secondaryLight5,
                                            ))))),
                            child: Text(leftBtnLbl,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: setColorBasedOnTheme(
                                      context: context,
                                      lightColor: AppColors.secondaryLight,
                                      darkColor: AppColors.secondaryLight5,
                                    )))
                          //  margin: EdgeInsets.symmetric(horizontal: 3.h),
                        )),
                    SizedBox(
                      width: 166.v,
                      height: 42.h,
                      child: ElevatedButton(
                          onPressed: rightBtnOnPressed,
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  Theme.of(context).highlightColor),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      side: BorderSide(
                                          color: Theme.of(context).highlightColor)))),
                          child: Text(rightBtnLbl,
                              textAlign: TextAlign.start,
                              maxLines: 1,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: AppColors.white))),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
