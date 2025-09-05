import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:core/utils/helper/theme_helper.dart';
import 'package:core/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:product_details/data/models/active_loan_detail_response.dart';
import 'package:product_details/presentation/screens/widget/custom_image_view.dart';
import 'package:core/config/resources/image_constant.dart';

// ignore_for_file: must_be_immutable
class OpenManageReminderBottomsheet extends StatefulWidget {
  OpenManageReminderBottomsheet(this.remindersDetails, {super.key});

  RemindersDetails? remindersDetails;

  @override
  State<OpenManageReminderBottomsheet> createState() =>
      _OpenManageReminderBottomsheetState();
}

class _OpenManageReminderBottomsheetState
    extends State<OpenManageReminderBottomsheet> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Brightness brightness = Theme.of(context).brightness;
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(
        horizontal: 16.h,
        vertical: 24.v,
      ),
      decoration: BoxDecoration(
        color: setColorBasedOnTheme(
            context: context,
            lightColor: AppColors.backgroundLight5,
            darkColor: AppColors.cardDark),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28.h),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 2.v),
          Text(
            getString(lblManageReminderProductDetail),
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          SizedBox(height: 17.v),
          ListView.separated(
              itemCount: widget.remindersDetails!.reminder!.length,
              shrinkWrap: true,
              separatorBuilder: (BuildContext context, int index) =>
                  Divider(height: 30.v, color:  AppColors.primaryLight6),
              itemBuilder: (BuildContext contexts, int index) {
                return Row(
                  children: [
                    CustomImageView(
                      imagePath: ImageConstant.imgNotifications,
                      height: 18.adaptSize,
                      width: 18.adaptSize,
                      color: setColorBasedOnTheme(
                        context: context,
                        lightColor: AppColors.primaryLight,
                        darkColor: AppColors.backgroundLight,
                      ),
                      margin: EdgeInsets.symmetric(vertical: 2.v),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 13.h,
                        top: 5.v,
                        bottom: 4.v,
                      ),
                      child: Text(
                          "${widget.remindersDetails!.reminder![index]
                                  .reminderDurationType} prior",
                          style: Theme.of(context).textTheme.bodySmall),
                    ),
                    const Spacer(),
                    CustomImageView(
                      imagePath: ImageConstant.imgEdit,
                      height: 24.adaptSize,
                      width: 24.adaptSize,
                      color: setColorBasedOnTheme(
                        context: context,
                        lightColor: AppColors.primaryLight,
                        darkColor: AppColors.backgroundLight,
                      ),
                      margin: EdgeInsets.symmetric(vertical: 2.v),
                      onTap: () {},
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 15.h),
                      child: SizedBox(
                        height: 28.v,
                        child: VerticalDivider(
                          width: 1.h,
                          thickness: 1.v,
                          color: appTheme.gray50,
                        ),
                      ),
                    ),
                    CustomImageView(
                      imagePath: ImageConstant.imgThumbsUp,
                      height: 24.adaptSize,
                      width: 24.adaptSize,
                      color: setColorBasedOnTheme(
                        context: context,
                        lightColor: AppColors.primaryLight,
                        darkColor: AppColors.backgroundLight,
                      ),
                      margin: EdgeInsets.only(
                        left: 13.h,
                        top: 2.v,
                        bottom: 2.v,
                      ),
                    ),
                  ],
                );
              }),
          SizedBox(height: 21.v),
          Row(
            children: [
              CustomImageView(
                imagePath: ImageConstant.imgPlus,
                height: 24.adaptSize,
                width: 24.adaptSize,
                color: setColorBasedOnTheme(
                  context: context,
                  lightColor: AppColors.secondaryLight,
                  darkColor: AppColors.secondaryLight5,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: 15.h,
                  top: 2.v,
                  bottom: 3.v,
                ),
                child: Text(
                  getString(lbl_add_new),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: brightness == Brightness.light
                          ? AppColors.secondaryLight
                          : AppColors.secondaryLight5),
                ),
              ),
            ],
          ),
          SizedBox(height: 33.v),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Theme.of(context).cardColor),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    side: BorderSide(
                                        color: brightness == Brightness.light
                                            ? AppColors.secondaryLight
                                            : AppColors.secondaryLight5)))),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(getString(lblCancel),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: brightness == Brightness.light
                                ? AppColors.secondaryLight
                                : AppColors.secondaryLight5))),
              ),
              SizedBox(
                width: 16.v,
              ),
              Expanded(
                child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Theme.of(context).highlightColor),
                        shape: MaterialStateProperty
                            .all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                side: BorderSide(
                                    color: Theme.of(context).highlightColor)))),
                    onPressed: () {},
                    child: Text(getString(lblContinue),
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: AppColors.white))),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
