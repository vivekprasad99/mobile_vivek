import 'dart:ui';
import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/widgets/action_buttons/quick_action.dart';
import 'package:core/config/widgets/action_buttons/quick_action_button.dart';
import 'package:core/config/widgets/action_buttons/sticky_action_button.dart';
import 'package:core/features/presentation/bloc/sticky_action_button/sticky_action_button_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../features/presentation/bloc/sticky_action_button/cubit/sticky_action_button_cubit.dart';

class QuickActionMenu extends StatefulWidget {
  const QuickActionMenu(
      {super.key, required this.backgroundColor, required this.actions})
      : assert(actions.length == 3);

  final Color backgroundColor;
  final List<QuickAction> actions;

  @override
  State<QuickActionMenu> createState() => _QuickActionMenuState();
}

class _QuickActionMenuState extends State<QuickActionMenu> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuickActionCubit, QuickActionState>(
      builder: (context, state) {
        return Stack(
          alignment: Alignment.bottomRight,
          children: [
            IgnorePointer(
              ignoring: state != OpenState(isOpen: false),
              child: AnimatedOpacity(
                opacity: state == OpenState(isOpen: false) ? 1 : 0,
                duration: const Duration(microseconds: 150),
                child: InkWell(
                  onTap: () => Future.sync(
                      () => context.read<QuickActionCubit>().closed()),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                    child: Container(
                      color: AppColors.actionButtonBvg,
                    ),
                  ),
                ),
              ),
            ),
            ...widget.actions.map((action) => QuickActionButton(action,
                isOpen: state == OpenState(isOpen: false),
                index: widget.actions.indexOf(action),
                close: () => Future.sync(
                    () => context.read<QuickActionCubit>().closed()))),
            Padding(
              padding: const EdgeInsets.only(right: 8, bottom: 85),
              child: StickyMenuActionButton(
                backgroundColor: widget.backgroundColor,
                open: () =>
                    Future.sync(() => context.read<QuickActionCubit>().open()),
                close: () => Future.sync(
                    () => context.read<QuickActionCubit>().closed()),
                isOpen: state == OpenState(isOpen: false),
              ),
            )
          ],
        );
      },
    );
  }
}
