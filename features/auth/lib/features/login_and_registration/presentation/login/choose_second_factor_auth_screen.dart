import 'package:auth/config/routes/route.dart';
import 'package:auth/features/login_and_registration/presentation/login/auth_enum.dart';
import 'package:auth/features/login_and_registration/presentation/login/second_factor_argument.dart';
import 'package:auth/features/login_and_registration/presentation/login/second_factor_auth_header.dart';
import 'package:common/features/startup/data/models/validate_device_response.dart';
import 'package:core/config/string_resource/Strings.dart';
import 'package:core/config/widgets/background/mf_gradient_background.dart';
import 'package:core/utils/pref_utils.dart';
import 'package:core/utils/size_utils.dart';
import 'package:core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'widget/exit_pop.dart';

class ChooseSecondFactorAuthScreen extends StatelessWidget {
  final Profiles? currentProfile;
  const ChooseSecondFactorAuthScreen({super.key, this.currentProfile});


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
              if(PrefUtils.getInt(PrefUtils.keyAuthNavFlow, AuthNavFlow.register.value) == AuthNavFlow.register.value){
                showExitPopUp(context, () {
                  context.goNamed(Routes.mobileOtp.name);
                });
              } else {
                PrefUtils.removeData(PrefUtils.keyAuthNavFlow);
                context.pop();
              }
            }),
        actions:  [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.help_outline,
                  size: 16.h,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(
                  width: 5.0,
                ),
                Text(
                   getString(lblHelp),
                  style: Theme.of(context).textTheme.titleSmall,
                ),

              ],
            ),
          )
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
              SecondFactorAuthArg arg= SecondFactorAuthArg(isMultipleUCIC: false, prePopulatedAuthNumber: "", headerDesc: "", currentProfile: currentProfile);
              context.pushNamed(Routes.secondfactorauth.name,pathParameters: {'authType': AuthType.pan.value.toString(), 'mobileNumber': getPhoneNumber()}, extra: arg);
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
        SecondFactorAuthArg arg= SecondFactorAuthArg(isMultipleUCIC: false, prePopulatedAuthNumber: "",headerDesc: "", currentProfile: currentProfile);
        context.pushNamed(Routes.secondfactorauth.name,pathParameters: {'authType': AuthType.account.value.toString(), 'mobileNumber': getPhoneNumber()}, extra: arg);
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
