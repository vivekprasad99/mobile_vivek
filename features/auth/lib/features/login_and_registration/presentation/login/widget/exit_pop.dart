import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/string_resource/config.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:core/utils/helper/theme_helper.dart';
import 'package:core/utils/size_utils.dart';
import 'package:flutter/material.dart';

showExitPopUp(BuildContext context, Function()? onPressed) {
  showModalBottomSheet<void>(
    isScrollControlled: true,
    context: context,
    builder: (BuildContext context) {
      return SizedBox(
        height: 230.h,
        child: Center(
          child: _buildExitPopup(context, onPressed),
        ),
      );
    },
  );
}

Widget _buildExitPopup(BuildContext context, Function()? onPressed) {
  return Container(
    width: double.maxFinite,
    padding: EdgeInsets.symmetric(
      horizontal: 14.h,
      vertical: 16.v,
    ),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          28.h,
        ),
        color: Theme.of(context).cardColor),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Opacity(
          opacity: 0.4,
          child: Container(
            height: 4.v,
            width: 32.h,
            decoration: BoxDecoration(
              color: appTheme.gray600.withOpacity(0.49),
              borderRadius: BorderRadius.circular(
                2.h,
              ),
            ),
          ),
        ),
        SizedBox(height: 19.v),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 1.h),
            child: Text(
              getString(warnBackBtnTitle),
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
        ),
        SizedBox(height: 20.v),
        Expanded(
            child: Text(
          getString(warnBackBtnDesc),
          style:
          Theme.of(context).textTheme.titleSmall?.copyWith(
            color: setColorBasedOnTheme(context: context, 
            lightColor: AppColors.textLight, 
            darkColor: AppColors.themeText)
          ),
        )),
        SizedBox(height: 12.v),
        _buildBottomButton(context, onPressed)
      ],
    ),
  );
}

Widget _buildBottomButton(BuildContext context, Function()? onPressed) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 3.h),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 166.v,
          height: 42.h,
            child:  ElevatedButton(

              onPressed:onPressed,
              style: ButtonStyle(
                  backgroundColor:
                  MaterialStateProperty.all(Theme.of(context).cardColor),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          side: BorderSide(
                              color: Theme.of(context).highlightColor)))),
              child: Text(getString(lblBack),
                  style: TextStyle(
                      fontSize: 14, color: Theme.of(context).highlightColor)),
              //  margin: EdgeInsets.symmetric(horizontal: 3.h),
            ),),
        SizedBox(
         // width: 166.v,
          height: 42.h,
            child:  ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      Theme.of(context).highlightColor),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          side: BorderSide(
                              color: Theme.of(context).highlightColor)))),
              child: Text(getString(lblStay),
                  textAlign: TextAlign.start,
                  maxLines: 1,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.white)),
              //  margin: EdgeInsets.symmetric(horizontal: 3.h),
            ),),
      ],
    ),
  );
}
