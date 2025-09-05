import 'package:core/config/widgets/action_buttons/custom_switch_button.dart';
import 'package:core/config/widgets/action_buttons/sticky_floating_action_button.dart';
import 'package:core/config/widgets/background/mf_gradient_background.dart';
import 'package:core/config/widgets/mf_appbar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/utils/size_utils.dart';

class NotificationPrefScreen extends StatefulWidget {
  const NotificationPrefScreen({super.key});

  @override
  State<NotificationPrefScreen> createState() => _NotificationPrefScreenState();
}

class _NotificationPrefScreenState extends State<NotificationPrefScreen> {
  bool _payment = false;
  bool _service = false;
  bool _offer = false;

  void _onSwitchChanged(String type, bool value) {
    switch (type) {
      case 'payment':
        _payment = value;
        break;
      case 'service':
        _service = value;
        break;
      case 'offer':
        _offer = value;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: const StickyFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      resizeToAvoidBottomInset: false,
      appBar: customAppbar(
          context: context,
          title: getString(lblPushNotificationsPref),
          onPressed: () {
            context.pop();
          },),
      body: MFGradientBackground(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSwitchListTile(
              context: context,
              title: getString(lblPayments),
              value: _payment,
              onChanged: (value) => _onSwitchChanged('payment', value),
            ),
            Divider(height: 1.h, color: AppColors.sliderColor),
            _buildSwitchListTile(
              context: context,
              title: getString(services),
              value: _service,
              onChanged: (value) => _onSwitchChanged('service', value),
            ),
            Divider(height: 1.h, color: AppColors.sliderColor),
            _buildSwitchListTile(
              context: context,
              title: getString(lblOfferDrawer),
              value: _offer,
              onChanged: (value) => _onSwitchChanged('offer', value),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchListTile({
    required BuildContext context,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      dense: false,
      title: Align(
        alignment: Alignment.centerLeft,
        child: Text(title, style: Theme.of(context).textTheme.bodyLarge),
      ),
      trailing: CustomSwitchButton(
        value: value,
        onChanged: (bool val) {
        },
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
      visualDensity: VisualDensity.compact,
    );
  }
}
