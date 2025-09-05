import 'package:core/config/resources/app_colors.dart';
import 'package:flutter/material.dart';

class QuickAction {
  const QuickAction(
      {required this.child,
      this.backgroundColor = AppColors.white,
      required this.onTap});
  final Widget child;
  final Color backgroundColor;
  final Function() onTap;
}
