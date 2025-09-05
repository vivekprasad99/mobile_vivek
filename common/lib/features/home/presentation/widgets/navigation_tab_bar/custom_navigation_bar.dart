import 'package:billpayments/features/presentation/cubit/bill_payments_cubit.dart';
import 'package:ach/presentation/cubit/ach_cubit.dart';
import 'package:billpayments/features/presentation/screens/bill_payments_page/pay_screen.dart';
import 'package:common/features/home/presentation/cubit/landing_page_cubit.dart';
import 'package:core/config/widgets/coach_marks/coach_mark.dart';
import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/string_resource/Strings.dart';
import 'package:core/config/widgets/action_buttons/sticky_floating_action_button.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:core/features/presentation/bloc/theme/theme_bloc.dart';
import 'package:core/services/di/injection_container.dart';
import 'package:core/utils/pref_utils.dart';
import 'package:core/utils/size_utils.dart';
import 'package:core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:product/presentation/utils/image_constant.dart';
import 'package:core/config/resources/image_constant.dart' as svgcore;
import 'package:profile/config/routes/route.dart';
import 'package:product_details/presentation/cubit/product_details_cubit.dart';
import 'package:product_details/presentation/screens/active_loans_tabs_screen/active_loans_tabs.dart';
import 'package:service_ticket/features/presentation/screens/service_tab_screen.dart';
import '../../screens/landingPage/home.dart';
import '../app_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.tabIndex});

  final int? tabIndex;

  @override
  State<StatefulWidget> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    _selectedIndex = widget.tabIndex ?? 0;
    showCoachMark();
    BlocProvider.of<ThemeBloc>(context).add(ThemeSwitchEvent());
    super.initState();
  }

  int _selectedIndex = 0;

  static final List<Widget> _widgets = <Widget>[
    BlocProvider(
      create: (context) => di<LandingPageCubit>(),
      child: const Home(),
    ),
    MultiBlocProvider(
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
    BlocProvider(
        create: (context) => di<BillPaymentsCubit>(), child: const PayScreen(),),
    BlocProvider(
        create: (context) => di<BillPaymentsCubit>(),
        child: const ServicesTabScreen(),),
  ];

  static final List<String> _titles = <String>[
    'Home',
    '',
    '',
    '',
  ];

  @override
  Widget build(BuildContext context) {
    final Brightness brightness = Theme.of(context).brightness;
    return Scaffold(
      floatingActionButton: const StickyFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarBrightness: brightness == Brightness.dark
              ? Brightness.dark
              : Brightness.light,
          statusBarIconBrightness: brightness == Brightness.dark
              ? Brightness.light
              : Brightness.dark,
        ),
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        title: _selectedIndex == 0
            ? brightness == Brightness.dark
                ? SvgPicture.asset(
                    svgcore.ImageConstant.imgAppLogoDark,
                    height: 27.h,
                  )
                : SvgPicture.asset(
                    svgcore.ImageConstant.imgAppLogo,
                    height: 27.h,
                  )
            : Text(
          _titles[_selectedIndex],
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Theme.of(context).primaryColor,),
              ),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () {
              context.pushNamed(Routes.myProfileData.name);
            },
            child: Container(
              height: 32.v,
              width: 32.v,
              margin: EdgeInsets.only(right: 15.v),
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.all(Radius.circular(32)),
              ),
              child: Padding(
                padding: EdgeInsets.only(top: 0.h, right: 0.h),
                child: Text(
                  getInitials(getUserName()),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: AppColors.nameInitialsColorLight,
                      ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: _widgets[_selectedIndex],
      drawer: const AppDrawer(),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 8,

        type: BottomNavigationBarType.fixed,
        selectedItemColor: setColorBasedOnTheme(
            context: context,
            lightColor: AppColors.secondaryLight,
            darkColor: AppColors.white),
        selectedLabelStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: setColorBasedOnTheme(
                  context: context,
                  lightColor: AppColors.secondaryLight,
                  darkColor: AppColors.white),
              fontWeight: FontWeight.w500,
            ),
        unselectedLabelStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: setColorBasedOnTheme(
                  context: context,
                  lightColor: AppColors.customUnSelectLight,
                  darkColor: AppColors.disableTextDark),
              fontWeight: FontWeight.w500,
            ),
        currentIndex: _selectedIndex,
        onTap: (value) {
          setState(
            () {
              _selectedIndex = value;
            },
          );
        },

        items: [
          BottomNavigationBarItem(

            icon: Padding(
              padding: EdgeInsets.only(top: 8.v, bottom: 5.v),
              child: SvgPicture.asset(
                ImageConstant.imgNavHome,
                height: 24.adaptSize,
                width: 24.adaptSize,
                colorFilter: ColorFilter.mode(
                  setColorBasedOnTheme(
                      context: context,
                      lightColor: AppColors.customUnSelectLight,
                      darkColor: AppColors.disableTextDark),
                  BlendMode.srcIn,
                ),
              ),
            ),
            activeIcon: Padding(
              padding: EdgeInsets.only(top: 8.v, bottom: 5.v),
              child: SvgPicture.asset(
                colorFilter: ColorFilter.mode(
                  setColorBasedOnTheme(
                    context: context,
                    lightColor: AppColors.secondaryLight,
                    darkColor: AppColors.white,
                  ),
                  BlendMode.srcIn,
                ),
                ImageConstant.imgNavHome,
                height: 24.adaptSize,
                width: 24.adaptSize,
              ),
            ),
            label: getString(home),
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(top: 8.v, bottom: 5.v),
              child: SvgPicture.asset(
                ImageConstant.imgNavProducts,
                height: 23.adaptSize,
                width: 23.adaptSize,
                colorFilter: ColorFilter.mode(
                  setColorBasedOnTheme(
                      context: context,
                      lightColor: AppColors.customUnSelectLight,
                      darkColor: AppColors.disableTextDark),
                  BlendMode.srcIn,
                ),
              ),
            ),
            activeIcon: Padding(
              padding: EdgeInsets.only(top: 8.v, bottom: 5.v),
              child: SvgPicture.asset(
                colorFilter: ColorFilter.mode(
                  setColorBasedOnTheme(
                    context: context,
                    lightColor: AppColors.secondaryLight,
                    darkColor: AppColors.white,
                  ),
                  BlendMode.srcIn,
                ),
                ImageConstant.imgNavProducts,
                height: 23.adaptSize,
                width: 23.adaptSize,
              ),
            ),
            label: getString(products),
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(top: 8.v, bottom: 5.v),
              child: SvgPicture.asset(
                ImageConstant.imgNavPay,
                height: 24.adaptSize,
                width: 24.adaptSize,
                colorFilter: ColorFilter.mode(
                  setColorBasedOnTheme(
                      context: context,
                      lightColor: AppColors.customUnSelectLight,
                      darkColor: AppColors.disableTextDark),
                  BlendMode.srcIn,
                ),
              ),
            ),
            activeIcon: Padding(
              padding: EdgeInsets.only(top: 8.v, bottom: 5.v),
              child: SvgPicture.asset(
                colorFilter: ColorFilter.mode(
                  setColorBasedOnTheme(
                    context: context,
                    lightColor: AppColors.secondaryLight,
                    darkColor: AppColors.white,
                  ),
                  BlendMode.srcIn,
                ),
                ImageConstant.imgNavPay,
                height: 24.adaptSize,
                width: 24.adaptSize,
              ),
            ),
            label: getString(lblPay),
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(top: 8.v, bottom: 5.v),
              child: SvgPicture.asset(
                ImageConstant.imgNavServices,
                height: 24.adaptSize,
                width: 24.adaptSize,
                colorFilter: ColorFilter.mode(
                  setColorBasedOnTheme(
                      context: context,
                      lightColor: AppColors.customUnSelectLight,
                      darkColor: AppColors.disableTextDark),
                  BlendMode.srcIn,
                ),
              ),
            ),
            activeIcon: Padding(
              padding: EdgeInsets.only(top: 8.v, bottom: 5.v),
              child: SvgPicture.asset(
                colorFilter: ColorFilter.mode(
                  setColorBasedOnTheme(
                    context: context,
                    lightColor: AppColors.secondaryLight,
                    darkColor: AppColors.white,
                  ),
                  BlendMode.srcIn,
                ),
                ImageConstant.imgNavServices,
                height: 24.adaptSize,
                width: 24.adaptSize,
              ),
            ),
            label: getString(services),
          ),
        ],
      ),
    );
  }

  void showCoachMark() async {
    bool tutorialShown = PrefUtils.getBool(PrefUtils.keyIsTutorialShown, false);
    if (!tutorialShown) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showIntro(context);
      });
      await PrefUtils.saveBool(PrefUtils.keyIsTutorialShown, true);
    }
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
}

OverlayEntry? overlayEntry;

void _showIntro(BuildContext context) {
  OverlayState overlayState = Overlay.of(context);

  overlayEntry = OverlayEntry(
    builder: (context) => Center(
      child: IntroScreen(
        onTap: () {
          closeOverLay();
        },
      ),
    ),
  );
  overlayState.insert(overlayEntry!);
}

void closeOverLay() {
  overlayEntry?.remove();
}
