import 'package:core/config/config.dart';
import 'package:core/config/resources/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oktoast/oktoast.dart';

ToastFuture customShowToast({Color? containerColor, String? msg,IconData? icon,Color? iconColor,double? bottomPadding}) {
  return showToastWidget(
      Container(
        padding:  EdgeInsets.symmetric(horizontal: 15.w,vertical: 10.h),
        margin:  EdgeInsets.fromLTRB(20, 0, 20, bottomPadding ?? 45),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10))
        ),
        width: double.maxFinite,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon,color:iconColor,size: AppDimens.titleLarge),
            SizedBox(width: 5.h,),
            Expanded(child: Text(msg ?? ""))
          ],
        ),
      ),
      position: ToastPosition.bottom
  );
}

ToastFuture toastForFailureMessage({
  required BuildContext context,
  required String msg,
  double? bottomPadding,
  Duration duration = const Duration(seconds: 3)
}) {
  return showToastWidget(
      duration: duration,
      Container(
        padding:  EdgeInsets.symmetric(horizontal: 15.w,vertical: 10.h),
        margin:  EdgeInsets.fromLTRB(20, 0, 20, bottomPadding ?? 40.h),
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: const BorderRadius.all(Radius.circular(10))
        ),
        width: double.maxFinite,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.error_outline_outlined,color:AppColors.textFieldErrorColor,size: AppDimens.titleLarge),
            SizedBox(width: 5.h,),
            Expanded(child: Text(msg, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Theme.of(context).colorScheme.error),))
          ],
        ),
      ),
      position: ToastPosition.bottom
  );
}

ToastFuture toastForSuccessMessage({required BuildContext context, required String msg,double? bottomPadding, Duration duration = const Duration(seconds: 3)}) {
  return showToastWidget(
      duration: duration,
      Container(
        padding:  EdgeInsets.symmetric(horizontal: 15.w,vertical: 10.h),
        margin:  EdgeInsets.fromLTRB(20, 0, 20, bottomPadding ?? 45.h),
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: const BorderRadius.all(Radius.circular(10))
        ),
        width: double.maxFinite,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.check_circle_outline,color:AppColors.successGreenColor,size: AppDimens.titleLarge),
            SizedBox(width: 5.h,),
            Expanded(child: Text(msg, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Theme.of(context).colorScheme.error),))
          ],
        ),
      ),
      position: ToastPosition.bottom
  );
}