import 'package:core/utils/size_utils.dart';
import 'package:flutter/material.dart';

class QuickActionIcon extends StatelessWidget {
  const QuickActionIcon(
      {super.key, required this.child, required this.backgroundColor});

  final Widget child;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60.adaptSize,
      height: 60.adaptSize,
      decoration: BoxDecoration(color: backgroundColor, shape: BoxShape.circle),
      clipBehavior: Clip.hardEdge,
      child: Center(
        child: child,
      ),
    );
  }
}
