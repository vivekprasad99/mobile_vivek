import 'package:core/config/error/failure.dart';
import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/resources/image_constant.dart';
import 'package:core/config/widgets/action_buttons/sticky_floating_action_button.dart';
import 'package:core/config/widgets/background/mf_gradient_background.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:core/utils/pref_utils.dart';
import 'package:core/utils/utils.dart';
import 'package:faq/config/routes/route.dart';
import 'package:faq/features/data/models/faq_request.dart';
import 'package:faq/features/presentation/screen/faq_search_screen.dart';
import 'package:faq/features/presentation/widgets/common_widgets/email_footer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:faq/features/data/models/faq_response.dart';
import 'package:faq/features/presentation/cubit/faq_cubit.dart';
import 'package:faq/features/presentation/cubit/faq_state.dart';
import 'package:faq/features/presentation/widgets/tabs/general_tab.dart';
import 'package:faq/features/presentation/widgets/tabs/how_to.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../widgets/faq_tab_container.dart';
import '../widgets/tabs/product_tab.dart';
import 'package:core/config/string_resource/strings.dart';

class FAQScreen extends StatefulWidget {
  const FAQScreen({super.key});

  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  List<Categories>? categories;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<FAQCubit>(context).getFAQ(request: FAQRequest());
    String langCode = PrefUtils.getString(PrefUtils.keySelectedLanguage, "");
    return SafeArea(
        child: Scaffold(
      floatingActionButton: const StickyFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomSheet: emailFooter(context),
      appBar: AppBar(
          title: Text(
        getString(lblFAQ),
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: setColorBasedOnTheme(
              context: context,
              lightColor: AppColors.primaryLight,
              darkColor: AppColors.white,
            )),
      )),
      body: BlocBuilder<FAQCubit, FAQState>(
        builder: (context, state) {
          if (state is LoadingState && state.isLoading) {
            return Center(
                child: CircularProgressIndicator(
              color: Theme.of(context).indicatorColor,
            ));
          } else if (state is FAQSuccessState) {
            if (state.response.data != null) {
              categories = state.response.data?.categories;
              _tabController =
                  TabController(length: categories!.length, vsync: this);
            }
            List<String?> tabTitleList =
                categories!.map((e) => e.title).toList();
            return MFGradientBackground(
              verticalPadding: 0,
              horizontalPadding: 0,
              child: Column(
                children: [
                  langCode == "en" ?
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: GestureDetector(
                          onTap: () {
                            context.pushNamed(Routes.faqSearchScreen.name,
                            extra: FAQsAgruments(false, state.response.data));
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            decoration: BoxDecoration(
                                color: setColorBasedOnTheme(
                                  context: context,
                                  lightColor:
                                      AppColors.primaryLight6.withOpacity(0.6),
                                  darkColor: AppColors.cardDark,
                                ),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(12))),
                            margin: const EdgeInsets.symmetric(vertical:6.0,horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      ImageConstant.searchIcon,
                                      colorFilter: ColorFilter.mode(
                                          Theme.of(context).primaryColor,
                                          BlendMode.srcIn),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      getString(msgFaqSearchHint),
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium
                                          ?.copyWith(
                                              color: setColorBasedOnTheme(
                                                context: context,
                                                lightColor: AppColors.primaryLight3,
                                                darkColor: AppColors.white,
                                              ),
                                              fontSize: 16),
                                    ),
                                  ],
                                ),
                                GestureDetector(
                                    onTap: () {
                                      context.pushNamed(Routes.faqSearchScreen.name,
                                          extra: FAQsAgruments(true, state.response.data));
                                    },
                                    child: Icon(Icons.mic,
                                        color: Theme.of(context).primaryColor))
                              ],
                            ),
                          ),
                        ),
                  ) :
                  const SizedBox.shrink(),
                  FAQTabContainerPage(tabTitleList, _tabController),
                  tabBarBody(categories!)
                ],
              ),
            );
          } else if (state is NoDataFailure) {
            showSnackBar(context: context, message: getString(lblErrorGeneric));
          }
          return Container();
        },
      ),
    ));
  }

  Widget tabBarBody(List<Categories> categories) {
    return Expanded(
      child: TabBarView(
        controller: _tabController,
        children: getTabBarViewList(categories),
      ),
    );
  }

  List<Widget> getTabBarViewList(List<Categories> categories) {
    var tabBarList = <Widget>[];

    for (int i = 0; i < categories.length; i++) {
      if (categories[i].productTypes != null) {
        List<ProductTypes> productTypes = categories[i].productTypes!;
        tabBarList.add(ProductTab(productTypes));
      }
      if (categories[i].generalTypes != null) {
        List<GeneralTypes> generalTypes = categories[i].generalTypes!;
        tabBarList.add(GeneralTab(generalTypes));
      }
      if (categories[i].videoTypes != null) {
        List<VideoTypes> videoTypes = categories[i].videoTypes!;
        tabBarList.add(HowToTab(videoTypes));
      }
    }
    return tabBarList;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
