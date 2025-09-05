import 'package:auth/config/routes/route.dart' as auth;
import 'package:common/config/routes/app_route.dart';
import 'package:common/features/language_selection/data/models/app_label_request.dart';
import 'package:common/features/language_selection/data/models/language_response.dart';
import 'package:common/features/language_selection/data/models/update_device_lang_request.dart';
import 'package:core/config/error/failure.dart';
import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/config/widgets/background/mf_gradient_background.dart';
import 'package:core/config/widgets/custom_buttons/mf_custom_elevated_button.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:core/config/widgets/mf_toast.dart';
import 'package:core/utils/const.dart';
import 'package:core/utils/size_utils.dart';
import 'package:core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:help/features/utils/constant_help.dart';
import 'package:help/features/utils/help_common_widget.dart';

import '../cubit/select_language_cubit.dart';
import '../cubit/select_language_state.dart';
import 'grid_item_widget.dart';

class SelectLanguageScreen extends StatefulWidget {
  final bool? isFromSetting;
  const SelectLanguageScreen({required this.isFromSetting, super.key});

  @override
  State<SelectLanguageScreen> createState() => _SelectLanguageScreenState();
}

class _SelectLanguageScreenState extends State<SelectLanguageScreen> {
  Language? isLangIndex; // Track the selected index

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<SelectLanguageCubit>(context).getAppLanguages();
    return SafeArea(
        child: Scaffold(

      body: MFGradientBackground(
        child: Column(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                    if(widget.isFromSetting==true)  InkWell(
                        child: Icon(
                          Icons.arrow_back,
                          color: setColorBasedOnTheme(
                              context: context,
                              lightColor: AppColors.secondaryLight,
                              darkColor: AppColors.white,),
                        ),
                        onTap: (){
                          context.pop();
                        },
                      ),
                      if(widget.isFromSetting==true)  const SizedBox(width: 5),
                      Text(
                        getString(msgChooseYourLang),
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const Spacer(),
                      HelpCommonWidget(categoryval: HelpConstantData.categoryLogin,subCategoryval: HelpConstantData.subCategoryLanguageSelection),
                    ],
                  ),
                  SizedBox(height: 40.v),
                  _buildChooseLanguageGrid(context),
                ],
              ),
            ),
            BlocConsumer<SelectLanguageCubit, SelectLanguageState>(
              listener: (context, state) {
                if (state is AppLabelSuccess) {
                  setSelectedLanguage(isLangIndex!.langCode!);
                  if (widget.isFromSetting == true) {
                    while (AppRoute.router.canPop()) {
                      AppRoute.router.pop();
                    }
                    context.pushReplacementNamed(auth.Routes.home.name);

                  } else {
                    context.goNamed(auth.Routes.mobileOtp.name, extra: false);
                  }
                } else if (state is AppLabelFailure) {
                  toastForFailureMessage(
                      context: context,
                      msg: getFailureMessage(state.error),
                      bottomPadding: 40.v,);
                } else if (state is SelectLanguageSuccess) {
                  isLangIndex ??= state.response.data?.languages?.firstWhere(
                    (language) => language.isSelected,
                    orElse: () => state.response.data!.languages![0],
                  );
                } else if (state is UpdateDeviceLangSuccess) {
                  if(state.response.code == AppConst.codeSuccess){
                    AppLabelRequest appLabelRequest = AppLabelRequest(langCode: isLangIndex!.langCode);
                    context.read<SelectLanguageCubit>().getAppLabels(appLabelRequest);
                  } else {
                    toastForFailureMessage(context: context, msg: getString(state.response.responseCode ?? lblErrorGeneric));
                  }
                } else if (state is UpdateDeviceLangFailure) {
                 toastForFailureMessage(context: context, msg: getFailureMessage(state.error));
                }
              },
              builder: (BuildContext context, SelectLanguageState state) {
                return MfCustomButton(
                  leftIcon: (state is AppLabelLoadingState && state.isloading)
                      ? true
                      : false,
                  text: widget.isFromSetting == true
                      ? getString(lblLangUpdate)
                      : getString(lblLangContinue),
                  outlineBorderButton: false,
                  isDisabled: false,
                  onPressed: () {
                    setSelectedLanguage(isLangIndex!.langCode);
                    if (widget.isFromSetting == true) {
                        var request = UpdateUserLangRequest(
                            superAppId: getSuperAppId(), source: AppConst.source, languageCode: isLangIndex!.langCode);
                        context.read<SelectLanguageCubit>().updateUserLanguage(request);
                      } else {
                        AppLabelRequest appLabelRequest = AppLabelRequest(langCode: isLangIndex!.langCode);
                        context.read<SelectLanguageCubit>().getAppLabels(appLabelRequest);
                      }
                    },
                );
              },
            ),
          ],
        ),
      ),
    ),);
  }

  /// Section Widget
  Widget _buildChooseLanguageGrid(BuildContext context) {
    return BlocBuilder<SelectLanguageCubit, SelectLanguageState>(
        buildWhen: (prev, curr) {
      return curr is SelectLanguageSuccess;
    }, builder: (context, state) {
      if (state is SelectLanguageInitial) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else if (state is SelectLanguageSuccess) {
        return GridView.builder(
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisExtent: 80,
            crossAxisCount: 2,
            mainAxisSpacing: 16.0,
            crossAxisSpacing: 16.0,
          ),
          physics: const NeverScrollableScrollPhysics(),
          itemCount: state.response.data?.languages?.length ?? 0,
          itemBuilder: (context, index) {
            return BlocBuilder<SelectLanguageCubit, SelectLanguageState>(
                builder: (context, state2) {
              return state.response.data?.languages == null
                  ? Container()
                  : GridItemWidget(state.response.data!.languages![index],
                      isLangIndex == state.response.data!.languages![index],
                      onTap: () {
                      BlocProvider.of<SelectLanguageCubit>(context)
                          .getSelectedIndex(
                              state.response.data!.languages![index],);
                      isLangIndex = state.response.data?.languages![index];
                    },);
            },);
          },
        );
      } else if (state is SelectLanguageFailure) {
        String errorMessage = (state.error as ServerFailure).message.toString();
        return Center(child: Text(errorMessage));
      } else {
        return Center(
            child: Text(
          getString(lblLangTryAfterSometime),
        ),);
      }
    },);
  }
}
