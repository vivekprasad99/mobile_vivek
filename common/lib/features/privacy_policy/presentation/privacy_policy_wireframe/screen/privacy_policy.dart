import 'package:auth/config/routes/route.dart';
import 'package:auth/features/login_and_registration/presentation/login_wireframe/widgets/mobile_otp_exit_popup.dart';
import 'package:common/features/privacy_policy/data/models/get_privacy_policy_request.dart';
import 'package:common/features/privacy_policy/presentation/cubit/privacy_policy_cubit.dart';
import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/string_resource/config.dart';
import 'package:core/config/widgets/background/mf_gradient_background.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:core/utils/size_utils.dart';
import 'package:core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:product/presentation/widgets/custom_button.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../startup/data/models/validate_device_response.dart';
import '../../cubit/privacy_policy_state.dart';
import 'package:flutter_html/flutter_html.dart';

// ignore: must_be_immutable
class PrivacyPolicyScreen extends StatelessWidget {
  bool? isFromSideMenu;

  PrivacyPolicyScreen({super.key,this.isFromSideMenu});

  @override
  Widget build(BuildContext context) {
    GetPrivacyPolicyRequest request = GetPrivacyPolicyRequest();
    BlocProvider.of<PrivacyPolicyCubit>(context).getPrivacyPolicy(request);
    return Scaffold(
        bottomNavigationBar: isFromSideMenu ?? false
            ? null
            : Container(
                width: double.infinity,
                color: Theme.of(context).cardColor,
                padding: const EdgeInsets.all(16),
                child: CustomButton(
                    width: 328.h,
                    height: 42.h,
                    borderColor: Theme.of(context).highlightColor,
                    borderRadius: 8.h,
                    buttonColor: Theme.of(context).highlightColor,
                    onPressed: () {
                      var userStatus = getUserRegisterStatus();
                      if (userStatus == UserRegStatus.pan || userStatus == UserRegStatus.customer) {
                        context.goNamed(Routes.mpin.name, extra: Profiles());
                      } else {
                        context.goNamed(Routes.userInfo.name);
                      }
                    },
                    text: getString(lblAccept),),
              ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          leadingWidth: 38,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: setColorBasedOnTheme(
                context: context,
                lightColor: AppColors.secondaryLight,
                darkColor: AppColors.backgroundLight5,),
            onPressed: () {
              isFromSideMenu ?? false? context.pop() : _showExitPopUp(context);
            },
          ),
          elevation: 0.0,
          title: Text(getString(lblPrivacyPolicy),
              style: Theme.of(context).textTheme.titleLarge,),
        ),
        body: MFGradientBackground(
          horizontalPadding: 4.h,
          child: BlocBuilder<PrivacyPolicyCubit, PrivacyPolicyState>(
              builder: (context, state) {
            if (state is LoadingState && state.isLoading) {
              return Align(
                alignment: Alignment.bottomCenter,
                child: Center(
                    child: CircularProgressIndicator(
                  color: Theme.of(context).indicatorColor,
                  strokeWidth: 2,
                ),),
              );
            }
            if (state is PrivacyPolicySuccessState) {
              var htmlData = state.response.data ?? "";
              return SingleChildScrollView(
                scrollDirection: Axis.vertical, //.horizontal
                child: Html(
                  key: UniqueKey(),
                  data: htmlData,
                  onLinkTap: (url, attributes, element) async{
                    var urlN= Uri.parse(url!);
                    if (await canLaunchUrl(urlN)) {
                      await launchUrl(
                        urlN,
                      );
                    } else {
                      throw 'Could not launch $url';
                    }
                    },
                  style: {
                    "h2": Style(
                      fontSize: FontSize(24),
                      fontWeight: FontWeight.bold,
                    ),
                    "h3": Style(
                      fontSize: FontSize(20),
                      fontWeight: FontWeight.bold,
                    ),
                    "p": Style(
                      fontSize: FontSize(16),
                    ),
                    "ul": Style(
                      fontSize: FontSize(16),

                    ),
                    "li": Style(
                      padding: HtmlPaddings.symmetric(vertical: 5),
                    ),
                    "a": Style(
                      color: Colors.red,
                      textDecoration: TextDecoration.none,
                    ),
                    "img": Style(
                      margin: Margins.symmetric(vertical: 10),
                    ),
                  },
                ),
              );
            }
            return const Text(msgSomethingWentWrong);
          },),
        ),);
  }

  _showExitPopUp(BuildContext context) {
    showModalBottomSheet<void>(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return const MobileOTPExitPopup();
      },
    );
  }
}
