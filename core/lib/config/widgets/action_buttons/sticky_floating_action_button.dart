import 'package:core/config/flavor/app_config.dart';
import 'package:core/config/managers/quick_action_manager.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/config/widgets/action_buttons/quick_action.dart';
import 'package:core/config/widgets/action_buttons/quick_action_menu.dart';
import 'package:core/features/presentation/bloc/sticky_action_button/cubit/sticky_action_button_cubit.dart';
import 'package:core/features/presentation/bloc/sticky_action_button/sticky_action_button_state.dart';
import 'package:core/utils/pref_utils.dart';
import 'package:core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ymchat_flutter/ymchat_flutter.dart';

import '../../resources/app_colors.dart';
import '../../resources/image_constant.dart';

class StickyFloatingActionButton extends StatefulWidget {
  const StickyFloatingActionButton({super.key});

  @override
  State<StickyFloatingActionButton> createState() =>
      _StickyFloatingActionButtonState();
}

class _StickyFloatingActionButtonState
    extends State<StickyFloatingActionButton> {

String superAppId = getSuperAppId();
String botId = AppConfig.shared.botId;  
Map<String, Object> payload = {"integration": "Flutter"};
  
  @override
  void initState() {
    super.initState();
    initilizeChatbot();
  }

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<QuickActionCubit>(context).getTollFreeNum();
    return BlocBuilder<QuickActionCubit, QuickActionState>(
        buildWhen: (previous, current) {
      return current is StickyAtionButtonSuccessState;
    }, builder: (context, state) {
      if (state is StickyAtionButtonSuccessState) {
        PrefUtils.saveString(
            PrefUtils.tollFreeNum, state.response.tollFreeNumber.toString());
      }
      return Theme(
        data: Theme.of(context).copyWith(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent),
        child: QuickActionMenu(
          actions: [
            QuickAction(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(ImageConstant.locateIcon),
                  Text(
                    getString(locate),
                    style: Theme.of(context)
                        .textTheme
                        .labelSmall
                        ?.copyWith(color: AppColors.primaryLight),
                  )
                ],
              ),
              onTap: () {
                QuickActionManager().triggerLocateUs(context);
              },
            ),
            QuickAction(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(ImageConstant.chatIcon),
                    Text(
                      getString(chat),
                      style: Theme.of(context)
                          .textTheme
                          .labelSmall
                          ?.copyWith(color: AppColors.primaryLight),
                    )
                  ],
                ),
                onTap: () {
                  YmChat.startChatbot();
                }),
            QuickAction(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(ImageConstant.mobileIcon),
                    Text(
                      getString(call),
                      style: Theme.of(context)
                          .textTheme
                          .labelSmall
                          ?.copyWith(color: AppColors.primaryLight),
                    )
                  ],
                ),
                onTap: () {
                  QuickActionManager().makePhoneCall(
                      PrefUtils.getString(PrefUtils.tollFreeNum, ""), context);
                })
          ],
          backgroundColor: AppColors.background,
        ),
      );
    });
  }

  void initilizeChatbot() {
    YmChat.setBotId(botId);
    YmChat.setPayload(payload);
    YmChat.showCloseButton(true);
    YmChat.setEnableSpeech(true);
    YmChat.setVersion(2);
    YmChat.useLiteVersion(false);
    YmChat.useSecureYmAuth(true);
    YmChat.setAuthenticationToken(superAppId);
  }
}
