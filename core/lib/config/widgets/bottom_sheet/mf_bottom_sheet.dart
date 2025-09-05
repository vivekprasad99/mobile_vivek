import 'package:core/utils/size_utils.dart';
import 'package:flutter/material.dart';

showMFFormBottomSheet(BuildContext context,
    {required String title, required Widget content}) {
  showModalBottomSheet<void>(
    backgroundColor: Theme.of(context).cardColor,
    isScrollControlled: true,
    context: context,
    builder: (BuildContext context) {
      return SizedBox(
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
              content,
              SizedBox(
                height: 16.v,
              ),
            ],
          ),
        ),
      );
    },
  );
}
