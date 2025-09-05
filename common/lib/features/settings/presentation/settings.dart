import 'package:auth/config/routes/route.dart' as home;
import 'package:common/config/routes/route.dart' as common;
import 'package:common/config/routes/route.dart';
import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/config/widgets/action_buttons/custom_switch_button.dart';
import 'package:core/config/widgets/action_buttons/sticky_floating_action_button.dart';
import 'package:core/config/widgets/background/mf_gradient_background.dart';
import 'package:core/config/widgets/mf_appbar.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:core/utils/pref_utils.dart';
import 'package:core/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:core/config/resources/image_constant.dart' as svgcore;
import 'package:permission_handler/permission_handler.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool _biometric = PrefUtils.getBool(PrefUtils.keyActiveBioMetric, false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
         floatingActionButton: const StickyFloatingActionButton(),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.centerDocked,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: _buildAppBar(context),
      body: MFGradientBackground(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildChangePinTile(context),
            _buildDivider(context),
            Visibility(visible : PrefUtils.getInt(PrefUtils.keyProfileCount, 0) > 1 ? false : true , child: _buildBiometricSwitch(context)),
            _buildDivider(context),
            _buildLanguagePreferencesTile(context),
            _buildDivider(context),
            _buildPushNotificationsTile(context),
            _buildDivider(context),
            // TODO need to uncomment code once whatsApp feauture will be enable
            // _buildWhatsAppOptInSwitch(context),
            // _buildDivider(context),
            _buildAppPermissionsTile(context),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return customAppbar(context: context, title: getString(lblSetting), onPressed: () {
      context.pop();
    },);

  }

  ListTile _buildChangePinTile(BuildContext context) {
    return ListTile(
      dense: true,
       contentPadding: const EdgeInsets.symmetric(horizontal: 0),
      onTap: () {
        context.pushNamed(home.Routes.changeLoginPin.name);
      },
      leading:  SvgPicture.asset(
        svgcore.ImageConstant.imgKeyVertical,
        height: 24.adaptSize,
        width: 24.adaptSize,
        colorFilter: ColorFilter.mode(
          setColorBasedOnTheme(
            context: context,
            lightColor: AppColors.primaryLight2,
            darkColor: AppColors.white,
          ),
          BlendMode.srcIn,
        ),
      ),
      title: Text(
        getString(lblChangePin),
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).primaryColor,
            ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        size: 24.h,
        color: setColorBasedOnTheme(
          context: context,
          lightColor: AppColors.secondaryLight,
          darkColor: AppColors.secondaryLight5,
        ),
      ),
    );
  }

  Divider _buildDivider(BuildContext context) {
    return Divider(
      height: 1.h,
      color: setColorBasedOnTheme(
        context: context,
        lightColor: AppColors.primaryLight6,
        darkColor: AppColors.shadowDark,
      ),
    );
  }

  ListTile _buildBiometricSwitch(BuildContext context) {
  return ListTile(
    dense: true,
    contentPadding: const EdgeInsets.symmetric(horizontal: 0),
    leading: Icon(
      Icons.fingerprint,
      size: 24.h,
      color: Theme.of(context).primaryColor,
    ),
    title: Text(
      getString(lblBiometrics),
      style: Theme.of(context).textTheme.bodyLarge,
    ),
    trailing: CustomSwitchButton(
      value: _biometric,
      onChanged: (bool? value) async {
        _biometric = value ?? false;
        if (_biometric) {
          if (PrefUtils.getBool(PrefUtils.keyEnableBioMetric, false)) {
            PrefUtils.saveBool(PrefUtils.keyActiveBioMetric, value ?? false);
            setState(() {});
          } else {
            bool? needRefresh = await context.pushNamed(home.Routes.biometric.name, extra: true);
            if (needRefresh == true) {
              setState(() {});
            }
          }
        } else {
          PrefUtils.saveBool(PrefUtils.keyActiveBioMetric, value ?? false);
          setState(() {});
        }
      },
    ),
  );
}


  ListTile _buildLanguagePreferencesTile(BuildContext context) {
    return ListTile(
      dense: true,
       contentPadding: const EdgeInsets.symmetric(horizontal: 0),
      onTap: () async{
         context.pushNamed(common.Routes.languageSelection.name, extra: true);
        },
      leading: Icon(
        Icons.translate,
        color: Theme.of(context).primaryColor,
        size: 24.h,
      ),
      title: Text(
        getString(lblLanguagePreferences),
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).primaryColor,
            ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        size: 24.h,
        color: setColorBasedOnTheme(
          context: context,
          lightColor: AppColors.secondaryLight,
          darkColor: AppColors.secondaryLight5,
        ),
      ),
    );
  }

  ListTile _buildPushNotificationsTile(BuildContext context) {
    return ListTile(
      dense: true,
       contentPadding: const EdgeInsets.symmetric(horizontal: 0),
      onTap: () {
        context.pushNamed(Routes.notificationPref.name);
      },
      leading: Icon(
        Icons.notifications_active_outlined,
        color: Theme.of(context).primaryColor,
        size: 24.h,
      ),
      title: Text(
        getString(lblPushNotificationsPref),
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).primaryColor,
            ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        size: 24.h,
        color: setColorBasedOnTheme(
          context: context,
          lightColor: AppColors.secondaryLight,
          darkColor: AppColors.secondaryLight5,
        ),
      ),
    );
  }


  ListTile _buildAppPermissionsTile(BuildContext context) {
    return ListTile(
      dense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 0),
      leading: Icon(
        Icons.mobile_friendly,
        color: Theme.of(context).primaryColor,
        size: 24.h,
      ),
      title: Text(
        getString(lblAppPermissions),
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).primaryColor,
            ),
      ),
      onTap: _openAppSettings,
      trailing: Icon(
        Icons.chevron_right,
        size: 24.h,
        color: setColorBasedOnTheme(
          context: context,
          lightColor: AppColors.secondaryLight,
          darkColor: AppColors.secondaryLight5,
        ),
      ),
    );
  }
}

Future<void> _openAppSettings() async {
  await openAppSettings();
}
