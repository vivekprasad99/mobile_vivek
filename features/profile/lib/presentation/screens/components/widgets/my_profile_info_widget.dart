// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:core/config/resources/app_colors.dart';

import 'package:core/config/widgets/mf_theme_check.dart';

import 'package:flutter/material.dart';

class MyProfileInfoWidget extends StatefulWidget {
  final String heading;
  final String subheading;
 final VoidCallback? onTap;

  final bool isEdit;
  const MyProfileInfoWidget({
    super.key,
    required this.onTap,
    required this.isEdit,
    required this.heading,
    required this.subheading,
  });

  @override
  State<MyProfileInfoWidget> createState() => _MyProfileInfoWidgetState();
}

class _MyProfileInfoWidgetState extends State<MyProfileInfoWidget> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
        contentPadding: const EdgeInsets.only(left: 0.0, right: 0.0),
        title: Text(widget.heading,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  letterSpacing: 0.16,
                  overflow: TextOverflow.ellipsis,
                )),
        subtitle: Text(widget.subheading,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                letterSpacing: 0.4,
                color: setColorBasedOnTheme(
                    context: context,
                    lightColor: AppColors.primaryLight,
                    darkColor: AppColors.primaryLight5))),
        trailing: widget.isEdit
            ? IconButton(
                iconSize: 20,
                icon: const Icon(Icons.mode_edit_outlined),
                color: setColorBasedOnTheme(
                    context: context,
                    lightColor: AppColors.primaryLight,
                    darkColor: AppColors.primaryLight5),
                onPressed: widget.onTap
              )
            : const SizedBox());
  }
}
