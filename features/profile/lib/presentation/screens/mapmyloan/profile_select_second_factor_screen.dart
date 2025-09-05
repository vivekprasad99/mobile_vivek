import 'package:auth/features/login_and_registration/presentation/login/auth_enum.dart';
import 'package:auth/features/login_and_registration/presentation/login/second_factor_auth_header.dart';
import 'package:common/features/startup/data/models/validate_device_response.dart';
import 'package:core/config/string_resource/Strings.dart';
import 'package:core/config/widgets/background/mf_gradient_background.dart';
import 'package:core/utils/size_utils.dart';
import 'package:core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:help/features/utils/constant_help.dart';
import 'package:help/features/utils/help_common_widget.dart';
import 'package:profile/config/routes/route.dart';
import 'package:profile/presentation/screens/mapmyloan/profile_second_factor_arg.dart';

import '../../../data/models/my_profile_model_response.dart';

class ProfileChooseSecondFactorScreen extends StatelessWidget {
  final Profiles? currentProfile;
  final ProfileInfo? profileInfo;
  const ProfileChooseSecondFactorScreen({super.key, this.currentProfile, this.profileInfo});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 64.h,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        leading: IconButton(
            icon: Icon(Icons.arrow_back,
                color: Theme.of(context).highlightColor),
            onPressed: () {
              context.pop();
            }),
        actions:  [
          HelpCommonWidget(categoryval: HelpConstantData.subCategoryProfile,subCategoryval: HelpConstantData.subcategoryProfileSecondFactor,)
        ],
      ),
      body: MFGradientBackground(
        horizontalPadding: 16.h,
        verticalPadding: 16.v,
        child: Column(
          children: [
            SecondFactorAuthHeader(
              headerTitle: getString(lblVerification),
              headerDesc: getString(msgChoosePanAccount),
              titleTextStyle: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 20),
              descTextStyle: Theme.of(context).textTheme.labelMedium,

            ),
            SizedBox(height: 12.v),
            InkWell(onTap: (){
              var arg= ProfileSecondFactorArg(isMultipleUCIC: false, prePopulatedAuthNumber: "", headerDesc: "", currentProfile: currentProfile, profileInfo: profileInfo);
              context.pushNamed(Routes.profilesecondfactor.name,pathParameters: {'authType': AuthType.pan.value.toString(), 'mobileNumber': getPhoneNumber()}, extra: arg);
            },child: Container(
              margin: const EdgeInsets.only(top: 10),
              width: 328.v,
              height: 60.h,
              decoration:  BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: const BorderRadius.all(Radius.circular(8))),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 8.0),
                child:  Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                      textAlign: TextAlign.left,
                      getString(lblPanCard),
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(fontSize: 15)
                  ),
                ),
              ),
            )),

            SizedBox(height: 25.h),

      InkWell(onTap: () {
        var arg= ProfileSecondFactorArg(isMultipleUCIC: false, prePopulatedAuthNumber: "",headerDesc: "", currentProfile: currentProfile, profileInfo: profileInfo);
        context.pushNamed(Routes.profilesecondfactor.name,
                      pathParameters: {'authType': AuthType.account.value.toString(), 'mobileNumber': getPhoneNumber()},
                      extra: arg);
                }, child:  Container(
              margin: const EdgeInsets.only(top: 10),
              width: 328.v,
              height: 60.h,
              decoration:  BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: const BorderRadius.all(Radius.circular(8))),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 8.0),
                child:  Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                      textAlign: TextAlign.left,
                      getString(lblAccountNumber2),
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(fontSize: 15)
                  ),
                ),
              ),
            )),

          ],
        ),
      ),
    );
  }
}
