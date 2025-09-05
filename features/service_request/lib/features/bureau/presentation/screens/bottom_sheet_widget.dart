import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

void showBottomWidget({
  required BuildContext context,
  required Function() onCameraUpload,
  required Function() onImageUpload,
  required Function() onFileUpload
}) {
  showModalBottomSheet(
    showDragHandle: false,
    backgroundColor: Theme.of(context).cardColor,
    context: context,
    builder: (_) => Padding(
      padding: const EdgeInsets.only(left: 18.0, right: 18.0, top: 18.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                getString(lblBureauUploadDocument),
                style: const TextStyle(fontSize: 27),
              ),
              TextButton(
                child: Text(
                  getString(lblBureauCancel),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: setColorBasedOnTheme(
                          context: context,
                          lightColor: AppColors.secondaryLight,
                          darkColor: AppColors.secondaryLight5,
                        ),
                      ),
                ),
                onPressed: () {
                  context.pop();
                },
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () async {
                    onCameraUpload();
                  },
                  child: Column(
                    children: [
                      Icon(
                        Icons.photo_camera_outlined,
                        size: 48,
                        color: setColorBasedOnTheme(
                          context: context,
                          lightColor: AppColors.primaryLight,
                          darkColor: AppColors.primaryLight5,
                        ),
                      ),
                      Text(getString(lblBureauCamera)),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    onImageUpload();
                  },
                  child: Column(
                    children: [
                      Icon(
                        Icons.image_outlined,
                        size: 48,
                        color: setColorBasedOnTheme(
                          context: context,
                          lightColor: AppColors.primaryLight,
                          darkColor: AppColors.primaryLight5,
                        ),
                      ),
                      Text(getString(lblBureauGallery)),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    onFileUpload();
                  },
                  child: Column(
                    children: [
                      Icon(
                        Icons.description_outlined,
                        size: 48,
                        color: setColorBasedOnTheme(
                          context: context,
                          lightColor: AppColors.primaryLight,
                          darkColor: AppColors.primaryLight5,
                        ),
                      ),
                      Text(getString(lblBureauFile)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),
        ],
      ),
    ),
  );
}
