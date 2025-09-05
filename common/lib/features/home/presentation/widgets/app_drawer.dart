import 'package:auth/features/login_and_registration/presentation/cubit/auth_result_cubit.dart';
import 'package:common/features/home/presentation/widgets/theme_switch_button.dart';
import 'package:core/config/flavor/feature_flag/feature_flag.dart';
import 'package:common/features/home/data/models/update_theme_request.dart';
import 'package:common/features/home/presentation/cubit/home_cubit.dart';
import 'package:common/features/home/presentation/cubit/home_state.dart';
import 'package:core/config/flavor/feature_flag/feature_flag_keys.dart';
import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/config/widgets/background/mf_gradient_background.dart';
import 'package:core/config/widgets/custom_buttons/mf_custom_elevated_button.dart';
import 'package:core/config/widgets/mf_appbar.dart';
import 'package:core/config/widgets/mf_progress_bar.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:core/config/widgets/mf_toast.dart';
import 'package:core/features/presentation/bloc/theme/theme_bloc.dart';
import 'package:core/utils/const.dart';
import 'package:core/utils/pref_utils.dart';
import 'package:core/utils/size_utils.dart';
import 'package:core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:common/config/routes/route.dart' as common_route;
import 'package:faq/config/routes/route.dart' as faq_route;
import 'package:profile/config/routes/route.dart' as profile_route;
import 'package:core/config/resources/image_constant.dart';
import '../../../../config/routes/route.dart';
import '../../../startup/data/models/validate_device_response.dart';
import '../../../startup/presentation/cubit/validate_device_cubit.dart';
import '../../../startup/presentation/cubit/validate_device_state.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> with RouteAware {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  late bool isDarkTheme;
  String selectedItem = '';

  @override
  void initState() {
    super.initState();
    isDarkTheme = PrefUtils.isDarkTheme();
  }

  void handleDrawerClose(BuildContext context) {
    context.read<HomeCubit>().resetSelectedTab();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget buildListTile(
      {required String title,
      IconData? icon,
      required VoidCallback onTap,
      required String itemKey,
      String? svgPath,}) {
    return BlocBuilder<HomeCubit, HomeState>(buildWhen: (previous, current) {
      return current is UpdateSelectedTab;
    }, builder: (context, state) {
      if (state is UpdateSelectedTab) {
        selectedItem = state.selectedItem;
      }
      return ListTile(
        dense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 0),
        leading: svgPath == null
            ? Icon(
                icon,
                color: itemKey == selectedItem
                    ? setColorBasedOnTheme(
                        context: context,
                        lightColor: AppColors.secondaryLight,
                        darkColor: AppColors.secondaryLight5,)
                    : setColorBasedOnTheme(
                        context: context,
                        lightColor: AppColors.primaryLight3,
                        darkColor: AppColors.disableTextDark,),
                size: 24.h,
              )
            : SvgPicture.asset(
                svgPath,
                height: 24.adaptSize,
                width: 24.adaptSize,
                colorFilter: ColorFilter.mode(
                  setColorBasedOnTheme(
                    context: context,
                    lightColor: AppColors.primaryLight2,
                    darkColor: AppColors.disableTextDark,
                  ),
                  BlendMode.srcIn,
                ),
              ),
        title: Text(getString(title),
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: itemKey == selectedItem
                    ? setColorBasedOnTheme(
                        context: context,
                        lightColor: AppColors.secondaryLight,
                        darkColor: AppColors.secondaryLight5,)
                    : setColorBasedOnTheme(
                        context: context,
                        lightColor: AppColors.primaryLight,
                        darkColor: AppColors.background,),),),
        onTap: () {
          onTap();
        },
      );
    },);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        width: double.infinity,
        shadowColor: AppColors.themeText,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        child: MultiBlocListener(
          listeners: [
            BlocListener<ValidateDeviceCubit, ValidateDeviceState>(
                listener: (context, state) {
              if (state is PreLoginTokenSuccessState) {
                PrefUtils.saveString(
                    PrefUtils.keyToken, state.response.accessToken ?? "",);
                context.read<AuthResultCubit>().setResult(success: false);
                context.goNamed(Routes.login.name, extra: <Profiles>[]);
              } else if (state is PreLoginTokenFailureState) {
                displayAlert(context, getFailureMessage(state.error));
              } else if (state is LoadingDialogState) {
                if (state.isValidateDeviceLoading) {
                  showLoaderDialog(context, getString(lblLoading));
                } else {
                  Navigator.of(context, rootNavigator: true).pop();
                }
              }
            },),
            BlocListener<HomeCubit, HomeState>(listener: (context, state) {
              if (state is UpdateThemeSuccess) {
                if (state.response.code == AppConst.codeSuccess) {
                  BlocProvider.of<ThemeBloc>(context).add(ThemeSwitchEvent());
                  PrefUtils.setDarkTheme(isDarkTheme);
                } else {
                  toastForFailureMessage(
                      context: context,
                      msg: state.response.message ?? "",
                      bottomPadding: 80.v,);
                }
              } else if (state is UpdateThemeFailure) {
                toastForFailureMessage(
                    context: context,
                    msg: getFailureMessage(state.error),
                    bottomPadding: 80.v,);
              } else if (state is LoadingState) {
                if (state.isLoading) {
                  showLoaderDialog(context, getString(lblLoading));
                } else {
                  Navigator.of(context, rootNavigator: true).pop();
                }
              } else if (state is LogoutResSuccessState) {
                if (state.resp.status == AppConst.statusRevoke) {
                  BlocProvider.of<ValidateDeviceCubit>(context)
                      .getPreLoginToken();
                } else {
                  toastForFailureMessage(
                      context: context, msg: getString(lblLoginTryAfterSometime),);
                }
              } else if (state is LogoutResFailureState) {
                toastForFailureMessage(
                    context: context, msg: getFailureMessage(state.error),);
              }
            },),
          ],
          child: Scaffold(
            key: scaffoldKey,
            appBar: customAppbar(
                context: context,
                title: '',
                onPressed: () {
                  Navigator.pop(context);
                },),
            body: GestureDetector(
              onTap: () {
                context.read<HomeCubit>().resetSelectedTab();
                Navigator.pop(context);
              },
              child: MFGradientBackground(
                child: ListView(
                  children: [
                    GestureDetector(
                      onTap: () {
                        context
                            .pushNamed(profile_route.Routes.myProfileData.name);
                      },
                      child: Builder(
                        builder: (context) {
                          var r = 30.adaptSize;
                          return SizedBox(
                            height: r*2,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: r,
                                  backgroundColor: AppColors.primaryLight6,
                                  child: Text(
                                    getInitials(getUserName()),
                                    style: const TextStyle(
                                      color: AppColors.primaryLight,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                 SizedBox(
                                  width: 20.adaptSize,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      getUserName().toTitleCase(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(
                                              letterSpacing: 0.16,
                                              color: setColorBasedOnTheme(
                                                context: context,
                                                  lightColor: AppColors.primaryDark,
                                                  darkColor:
                                                      AppColors.backgroundLight4,),),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }
                      ),
                    ),
                     SizedBox(
                      height: 30.adaptSize,
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: BlocBuilder<HomeCubit, HomeState>(
                        builder: (context, state) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ThemeSwitchButton(
                                value: isDarkTheme,
                                onChanged: (bool value) async {
                                  UpdateThemeRequest request =
                                      UpdateThemeRequest(
                                          superAppId: getSuperAppId(),
                                          theme: value
                                              ? AppTheme.dark.value
                                              : AppTheme.light.value,
                                          source: AppConst.source,);
                                  await BlocProvider.of<HomeCubit>(context)
                                      .updateThemeDetail(request);
                                  isDarkTheme = value;
                                },
                              ),
                               SizedBox(
                                height: 10.adaptSize,
                              ),
                              Text(
                                  getString(isDarkTheme
                                      ? lblDarkMode
                                      : lblLightMode,),
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall
                                      ?.copyWith(
                                          color: setColorBasedOnTheme(
                                              context: context,
                                              lightColor:
                                                  AppColors.lightModeTextColor,
                                              darkColor: AppColors.primary,),),),
                            ],
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    buildListTile(
                      title: lblProfileDrawer,
                      icon: Icons.person_2_outlined,
                      onTap: () {
                        context
                            .pushNamed(profile_route.Routes.myProfileData.name);
                      },
                      itemKey: 'profile',
                    ),
                    buildListTile(
                      title: lblOfferDrawer,
                      svgPath: ImageConstant.imgOffer,
                      onTap: () {
                        context.pushNamed(Routes.preapprovedOffer.name);
                      },
                      itemKey: 'offer',
                    ),
                    if (isFeatureEnabled(featureName: featureFAQ))
                      buildListTile(
                        title: faq,
                        icon: Icons.live_help_outlined,
                        onTap: () {
                          context.pushNamed(faq_route.Routes.faq.name);
                        },
                        itemKey: 'faq',
                      ),
                    buildListTile(
                      title: labelRateUs,
                      svgPath: ImageConstant.imgRate,
                      onTap: () async {
                        final InAppReview inAppReview = InAppReview.instance;
                        if (await inAppReview.isAvailable()) {
                          inAppReview.requestReview();
                        }
                      },
                      itemKey: 'rate_us',
                    ),
                    buildListTile(
                      title: lblSetting,
                      icon: Icons.settings_outlined,
                      onTap: () {
                        context.pop();
                        context.pushNamed(Routes.settings.name);
                      },
                      itemKey: 'settings',
                    ),
                    buildListTile(
                      title: lblTermsCondition1,
                      icon: Icons.assignment_outlined,
                      onTap: () {
                        context.pushNamed(
                            common_route.Routes.termsConditions.name,
                            extra: true,);
                      },
                      itemKey: 'terms_conditions',
                    ),
                    buildListTile(
                      title: lblPrivacyPolicy,
                      svgPath: ImageConstant.imgKPrivacy,
                      onTap: () {
                        context.pushNamed(
                            common_route.Routes.privacyPolicy.name,
                            extra: true,);
                      },
                      itemKey: 'privacy_policy',
                    ),
                    buildListTile(
                      title: lblLogout,
                      icon: Icons.power_settings_new,
                      onTap: () {
                        logOutBottomSheet(context);
                      },
                      itemKey: 'logout',
                    ),
                    if (isFeatureEnabled(featureName: featureEnableLogs))
                      buildListTile(
                        title: 'get Log File',
                        icon: Icons.filter_3,
                        onTap: () {
                          exportLogToDownloadFile(context);
                        },
                        itemKey: 'other',
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),);
  }
}

Future<dynamic> logOutBottomSheet(BuildContext mContext) {
  return showModalBottomSheet(
    context: mContext,
    backgroundColor: Theme.of(mContext).cardColor,
    builder: (context) {
      return Container(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              getString(lblLogoutDrawer),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(
              height: 40.adaptSize,
            ),
            Row(
              children: [
                Expanded(
                  child: MfCustomButton(
                    borderRadius: 10,
                    text: getString(lblNo),
                    outlineBorderButton: true,
                    isDisabled: false,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                SizedBox(
                  width: 22.adaptSize,
                ),
                Expanded(
                  child: MfCustomButton(
                    borderRadius: 10,
                    text: getString(lblYes),
                    outlineBorderButton: false,
                    isDisabled: false,
                    onPressed: () {
                      Navigator.pop(context);
                      mContext.read<HomeCubit>().logOut();
                    },
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10.adaptSize,
            ),
          ],
        ),
      );
    },
  );
}

getInitials(String name) {
    if (name.isEmpty) {
      return name;
    }
    List<String> words = name.split(' ');
    String firstInitial = words.first[0].toUpperCase();
    String lastInitial = words.last[0].toUpperCase();
    return firstInitial + lastInitial;
  }
