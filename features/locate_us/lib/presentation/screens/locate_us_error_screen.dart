import 'package:common/config/routes/route.dart';
import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/resources/image_constant.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/config/widgets/background/mf_gradient_background.dart';
import 'package:core/config/widgets/mf_appbar.dart';
import 'package:core/config/widgets/mf_custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class LocateUsErrorScreen extends StatelessWidget {
  const LocateUsErrorScreen({
    super.key,
    required this.msg,
  });

  final String msg;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(
        context: context,
        title: '',
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      body: MFGradientBackground(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgPicture.asset(
              ImageConstant.errorIcon,
              height: 45,
              width: 45,
              colorFilter: const ColorFilter.mode(
                AppColors.secondaryLight,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              msg,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const Spacer(),
            MfCustomButton(
              onPressed: () {
                context.pop();
              },
              text: getString(lblLoUsRetry),
              outlineBorderButton: false,
            ),
            const SizedBox(height: 16),
            MfCustomButton(
              onPressed: () {
                context.go(Routes.home.path);
              },
              text: getString(lblLoUsHome),
              outlineBorderButton: true,
            ),
          ],
        ),
      ),
    );
  }
}
