import 'package:core/config/string_resource/strings.dart';
import 'package:core/utils/helper/theme_helper.dart';
import 'package:core/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../config/routes/route.dart';

class MobileOTPExitPopup extends StatelessWidget {
  const MobileOTPExitPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 230.h,
      child: Center(
        child: _buildExitPopup(context),
      ),
    );
  }

  Widget _buildExitPopup(BuildContext context) {
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
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
          ),
          SizedBox(height: 20.v),
          Expanded(
              child: Text(
            getString(warnBackBtnDesc),
            style: Theme.of(context).textTheme.titleSmall,
          )),
          SizedBox(height: 12.v),
          _buildBottomButton(context)
        ],
      ),
    );
  }

  Widget _buildBottomButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 3.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              width: 166.v,
              height: 42.h,
              child: ElevatedButton(
                onPressed: () {
                  context.goNamed(Routes.mobileOtp.name);
                },
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
              )),
          SizedBox(
              width: 166.v,
              height: 42.h,
              child: ElevatedButton(
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
                    style: Theme.of(context).textTheme.titleMedium),
              ))
        ],
      ),
    );
  }
}
