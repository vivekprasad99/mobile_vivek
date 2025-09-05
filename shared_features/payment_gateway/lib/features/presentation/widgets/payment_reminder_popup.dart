import 'package:auth/features/login_and_registration/presentation/login_wireframe/widgets/custom_elevated_button.dart';
import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/resources/app_dimens.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/utils/size_utils.dart';
import 'package:flutter/material.dart';

Future<dynamic> paymentRemainderDialogue(BuildContext context) {
  return showDialog(
      context: context,
      builder: (ctx) => Dialog(
          elevation: 0.0,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: AppColors.backgroundLight5,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16)),
                        color: AppColors.primaryLight6),
                    // height: 70.h,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 24.0, horizontal: 12.0),
                      child: Row(
                        children: [
                          Icon(
                            Icons.notifications_active_outlined,
                            color: Theme.of(context).primaryColor,
                          ),
                          SizedBox(
                            width: 08.h,
                          ),
                          Text(
                            getString(lblPaymentReminder),
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ],
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 16.v,
                      ),
                      Text(
                        "Hi Sunny!",
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      SizedBox(
                        height: 16.v,
                      ),
                      Text(
                          "Your payment of ₹24,450 for your vehicle loan A/c 1245789829868 is due on 2 May 2024",
                          style: Theme.of(context).textTheme.titleSmall),
                      SizedBox(
                        height: 24.v,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: CustomElevatedButton(
                              // height: 42.v,
                              // width: 144.h,
                              text: getString(lblLater),
                              buttonStyle: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  side: BorderSide(
                                    color: Theme.of(context).highlightColor,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.h),
                                  )),
                              buttonTextStyle: TextStyle(
                                fontSize: AppDimens.labelMedium,
                                fontFamily: "Quicksand",
                                letterSpacing: 0.1,
                                fontWeight: FontWeight.w700,
                                color: AppColors.secondaryLight,
                              ),
                              onPressed: () {},
                            ),
                          ),
                          SizedBox(
                            width: 16.v,
                          ),
                          Expanded(
                            child: CustomElevatedButton(
                              // height: 42.h,
                              // width: 144,
                              text: getString(lblPayNow),
                              buttonStyle: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).highlightColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.h),
                                  )),
                              buttonTextStyle:
                                  Theme.of(context).textTheme.titleMedium,
                              onPressed: () {},
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 24.v,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )));
}
