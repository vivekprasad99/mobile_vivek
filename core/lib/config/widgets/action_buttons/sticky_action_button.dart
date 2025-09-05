import 'package:core/config/widgets/action_buttons/quick_action_icon.dart';
import 'package:flutter/material.dart';

import '../../resources/image_constant.dart';

class StickyMenuActionButton extends StatefulWidget {
  const StickyMenuActionButton(
      {super.key,
      required this.open,
      required this.close,
      required this.isOpen,
      required this.backgroundColor});

  final Function() open;
  final Function() close;
  final bool isOpen;
  final Color backgroundColor;

  @override
  State<StickyMenuActionButton> createState() => _StickyMenuActionButtonState();
}

class _StickyMenuActionButtonState extends State<StickyMenuActionButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (!widget.isOpen) {
          widget.open();
        } else {
          widget.close();
        }
      },
      child: QuickActionIcon(
          backgroundColor: Colors.transparent,
          child: Image.asset(width: 40, height: 40, ImageConstant.stickyImage)),
    );
  }
}
