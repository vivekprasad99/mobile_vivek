import 'package:ach/presentation/cubit/ach_cubit.dart';
import 'package:auth/config/routes/app_route.dart';
import 'package:auth/features/login_and_registration/presentation/cubit/auth_result_cubit.dart';
import 'package:auth/features/login_and_registration/presentation/login/register_status.dart';
import 'package:billpayments/config/routes/app_routes.dart';
import 'package:common/features/home/presentation/cubit/landing_page_cubit.dart';
import 'package:common/features/home/presentation/screens/preaApproved/offer_details_screen.dart';
import 'package:common/features/home/presentation/screens/preaApproved/preapproved_offer.dart';
import 'package:common/features/home/presentation/widgets/navigation_tab_bar/custom_navigation_bar.dart';
import 'package:common/features/language_selection/presentation/cubit/select_language_cubit.dart';
import 'package:common/features/language_selection/presentation/widgets/select_language_screen.dart';
import 'package:common/features/notification_prefrence/notification_pref.dart';
import 'package:common/features/privacy_policy/presentation/cubit/privacy_policy_cubit.dart';
import 'package:common/features/search/presentation/cubit/search_cubit.dart';
import 'package:common/features/search/presentation/screen/search_screen.dart';
import 'package:common/features/settings/presentation/settings.dart';
import 'package:common/features/startup/presentation/cubit/validate_device_cubit.dart';
import 'package:common/features/terms_conditions/presentation/cubit/terms_conditions_cubit.dart';
import 'package:core/config/managers/firebase/analytics_manager.dart';
import 'package:core/routes/app_route_cubit.dart';
import 'package:core/routes/app_route_state.dart';
import 'package:common/features/terms_conditions/presentation/terms_conditions/screen/term_condition.dart';
import 'package:core/services/di/injection_container.dart';
import 'package:faq/config/routes/app_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:help/config/routes/app_route.dart';
import 'package:lead_generation/config/routes/app_route.dart';
import 'package:loan/config/routes/app_route.dart';
import 'package:appstatus/config/routes/app_route.dart';
import 'package:go_router/go_router.dart';
import 'package:locate_us/config/routes/app_route.dart';
import 'package:noc/config/routes/app_route.dart';
import 'package:loan_refund/config/routes/app_routes.dart';
import 'package:payment_gateway/config/routes/app_route.dart';
import 'package:payment_webview/config/routes/app_route.dart';
import 'package:product/config/routes/app_route.dart';
import 'package:ach/config/routes/app_route.dart';
import 'package:product/presentation/cubit/product_feature_cubit.dart';
import 'package:product/presentation/screens/products_features.dart';
import '../../features/home/presentation/cubit/home_cubit.dart';
import 'package:profile/config/routes/app_route.dart';
import 'package:product_details/config/routes/app_route.dart';
import 'package:service_ticket/config/routes/app_route.dart';
import '../../features/privacy_policy/presentation/privacy_policy_wireframe/screen/privacy_policy.dart';
import 'package:service_request/config/routes/app_route.dart';
import '../../features/startup/presentation/startup_screen.dart';
import 'package:product_details/presentation/cubit/product_details_cubit.dart';
import 'package:product_details/presentation/screens/active_loans_tabs_screen/active_loans_tabs.dart';
import 'route.dart';


class AppRoute {
  static late BuildContext context;

  AppRoute.setStream(BuildContext ctx) {
    context = ctx;
  }

  static final GoRouter router = GoRouter(
    observers: [
      AnalyticsManager.getNavigatorObserver(),
    ],
    routes: [
      GoRoute(
          path: Routes.startup.path,
          name: Routes.startup.name,
        builder: (context, state) => BlocProvider<SelectLanguageCubit>(
          create: (context) => di<SelectLanguageCubit>(),
          child: const AppLaunchScreen(),
        ),
      ),
      GoRoute(
        path: Routes.register.path,
        name: Routes.register.name,
        builder: (_, __) => RegisterStatus(),
      ),
      GoRoute(
          path: Routes.languageSelection.path,
          name: Routes.languageSelection.name,
          builder: (context, state) => BlocProvider<SelectLanguageCubit>(
                create: (context) => di<SelectLanguageCubit>(),
                child: SelectLanguageScreen(
                  isFromSetting: state.extra as bool?,
                ),
              ),),
      GoRoute(
          path: Routes.privacyPolicy.path,
          name: Routes.privacyPolicy.name,
          builder: (context, state) => BlocProvider<PrivacyPolicyCubit>(
                create: (context) => di<PrivacyPolicyCubit>(),
                child:
                    PrivacyPolicyScreen(isFromSideMenu: state.extra as bool?),
              ),),
      GoRoute(
          path: Routes.termsConditions.path,
          name: Routes.termsConditions.name,
          builder: (context, state) => BlocProvider<TermsConditionsCubit>(
                create: (context) => di<TermsConditionsCubit>(),
                child:
                    TermsConditionScreen(isFromSideMenu: state.extra as bool?),
              ),),
      GoRoute(
        path: Routes.home.path,
        name: Routes.home.name,
        builder: (context, state) => MultiBlocProvider(
          providers: [
            BlocProvider<HomeCubit>(
              create: (context) => di<HomeCubit>(),
            ),
            BlocProvider<ValidateDeviceCubit>(
              create: (context) => di<ValidateDeviceCubit>(),
            ),
          ],
          child: HomeScreen(tabIndex: state.extra as int?),
        ),
      ),
      GoRoute(
          path: Routes.productFeatures.path,
          name: Routes.productFeatures.name,
          builder: (_, __) => BlocProvider(
                create: (context) => di<ProductFeatureCubit>(),
                child: const ProductFeaturesScreen(),
              ),),
      GoRoute(
        path: Routes.productDetails.path,
        name: Routes.productDetails.name,
        builder: (context, state) => MultiBlocProvider(
          providers: [
            BlocProvider<ProductDetailsCubit>(
              create: (context) => di<ProductDetailsCubit>(),
            ),
            BlocProvider<AchCubit>(
              create: (context) => di<AchCubit>(),
            ),
          ],
          child: const ProductDetailsActiveLoanScreen(),
        ),
      ),
      GoRoute(
        path: Routes.settings.path,
        name: Routes.settings.name,
        builder: (context, state) => MultiBlocProvider(
          providers: [
            BlocProvider<HomeCubit>(
              create: (context) => di<HomeCubit>(),
            ),
            BlocProvider<SelectLanguageCubit>(
              create: (context) => di<SelectLanguageCubit>(),
            ),
          ],
          child: const SettingScreen(),
        ),
      ),
      GoRoute(
          path: Routes.notificationPref.path,
          name: Routes.notificationPref.name,
          builder: (_, __) => const NotificationPrefScreen(),),
      GoRoute(
          path: Routes.preapprovedOffer.path,
          name: Routes.preapprovedOffer.name,
          builder: (context, state) => BlocProvider(
                create: (context) => di<LandingPageCubit>(),
                child: const MyOffersScreen(),
              ),),
      GoRoute(
          path: Routes.searchScreen.path,
          name: Routes.searchScreen.name,
          builder: (context, state) => BlocProvider(
                create: (context) => di<SearchCubit>(),
                child: SearchScreen(
                  isMicClicked: state.extra as bool?,
                ),
              ),),
      GoRoute(
          path: Routes.preapprovedOfferDetails.path,
          name: Routes.preapprovedOfferDetails.name,
          builder: (context, state) => BlocProvider(
                create: (context) => di<LandingPageCubit>(),
                child: OfferDetailPage(
                    data: state.extra as OfferDetailPageArguments?,),
              ),),
      ...loginRoutes,
      ...productFeatureRoutes,
      ...loanRoutes,
      ...achRoutes,
      ...leadGenerationRoutes,
      ...faqRoutes,
      ...paymentRoutes,
      ...applicationstatusRoutes,
      ...billPaymentsRoutes,
      ...loanRefundRoutes,
      ...productDetailsRoutes,
      ...serviceTicketRoutes,
      ...serviceRequestRoutes,
      ...nocRoutes,
      ...locateUsRoutes,
      ...paymentWebViewRoutes,
      ...profileFeatureRoutes,
      ...helpRoutes

    ],
    initialLocation: Routes.startup.path,
    routerNeglect: true,
    debugLogDiagnostics: kDebugMode,
    redirect: (context, state) {
      final loginStatus = context.read<AuthResultCubit>().state;
      final appRouteStatus = context.read<AppRouteCubit>().state;
      if (loginStatus == AuthResultState.success &&
          state.fullPath == '/auth/login') {
        return Routes.home.path;
      } else if (appRouteStatus is AppRouteHomePageNavigation &&
          state.fullPath == appRouteStatus.pathFrom) {
        return Routes.home.path;
      }
      return state.matchedLocation;
    },
  );
}
