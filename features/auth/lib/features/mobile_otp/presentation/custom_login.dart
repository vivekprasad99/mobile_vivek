import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/config/widgets/common_widgets/mf_custom_text_field.dart';
import 'package:core/utils/size_utils.dart';
import 'package:core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:auth/config/routes/route.dart';

import '../../login_and_registration/presentation/login_wireframe/widgets/custom_elevated_button.dart';

class CustomLoginWidget extends StatelessWidget {
  final TextEditingController _ucicController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _tokenController = TextEditingController();

  CustomLoginWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MfCustomFloatingTextField(
          controller: _ucicController,
          autofocus: true,
          hintText: 'ucic',
        ),
        SizedBox(
          height: 10.h,
        ),
        MfCustomFloatingTextField(
          controller: _phoneNumberController,
          hintText: 'phone number',
          autofocus: true,
        ),
        SizedBox(
          height: 10.h,
        ),
        MfCustomFloatingTextField(
          controller: _tokenController,
          hintText: 'token',
          autofocus: true,
        ),
        SizedBox(
          height: 10.h,
        ),
        CustomElevatedButton(
          height: 48.v,
          text: getString(lblLogin),
          buttonStyle: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).highlightColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.h),
            ),
          ),
          buttonTextStyle: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: AppColors.white),
          onPressed: () {
            setUCIC(_ucicController.text);
            setPhoneNumber(_phoneNumberController.text);
            setAccessToken(_tokenController.text);
            showSnackBar(context: context, message: 'credentials updated!');
            context.goNamed(Routes.home.name);
          },
        ),
      ],
    );
  }
}
