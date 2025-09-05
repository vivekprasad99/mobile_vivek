import 'package:core/config/string_resource/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:help/config/routes/route.dart';
import 'package:help/features/data/models/help_model.dart';

class HelpCommonWidget extends StatefulWidget {
  final String categoryval;
  final String subCategoryval;
  const HelpCommonWidget(
      {super.key, required this.categoryval, required this.subCategoryval});

  @override
  State<HelpCommonWidget> createState() => _HelpCommonWidgetState();
}

class _HelpCommonWidgetState extends State<HelpCommonWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        HelpCatSub help = HelpCatSub(
            category: widget.categoryval, subCategory: widget.subCategoryval);
        context.pushNamed(Routes.help.name, extra: help);
      },
      child: Padding(
        padding: EdgeInsets.only(right: 8.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.help_outline,
              size: 8.h,
              color: Theme.of(context).primaryColor,
            ),
            SizedBox(
              width: 2.h,
            ),
            Text(
              getString(lblHelp),
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ],
        ),
      ),
    );
  }
}
