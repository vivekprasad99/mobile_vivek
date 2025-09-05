import 'package:core/config/string_resource/Strings.dart';
import 'package:core/config/widgets/action_buttons/sticky_floating_action_button.dart';
import 'package:core/config/widgets/background/mf_gradient_background.dart';
import 'package:core/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:product/data/models/product_feature_detail_request.dart';
import 'package:product/presentation/cubit/product_feature_cubit.dart';
import 'package:product/presentation/cubit/product_feature_state.dart';
import 'package:product/presentation/screens/loans_detail_page/loans_detail_page.dart';
import 'package:product/presentation/widgets/custom_button.dart';
import 'package:lead_generation/config/routes/route.dart' as lead_gen;
import 'package:core/utils/extensions/string.dart';
import 'package:common/features/search/data/model/search_response.dart';
import 'package:faq/config/routes/route.dart' as faq_routes;

class LoansTabBar extends StatefulWidget {
  const LoansTabBar({this.data, super.key});

  final LoansTabBarArguments? data;

  @override
  LoansTabBarState createState() => LoansTabBarState();
}

class LoansTabBarState extends State<LoansTabBar>
    with TickerProviderStateMixin {
  late ScrollController scrollController;

  BuildContext? tabContext;

  List<GlobalKey> tabCategories = [];

  @override
  void initState() {
    if (widget.data?.isFromSearch ?? false) {
      BlocProvider.of<ProductFeatureCubit>(context).productFeatureDetailAPI(
          productFeatureRequest: ProductFeatureDetailRequest(
              productSubType: widget.data?.productSubType,
              productType: widget.data?.productType));
    }
    addGlobalKey();
    super.initState();
  }

  void scrollToIndex(int index) async {
    scrollController.removeListener(animateToTab);
    final categories = tabCategories[index].currentContext;
    await Scrollable.ensureVisible(
      categories!,
      duration: const Duration(milliseconds: 100),
    );
    scrollController.addListener(animateToTab);
  }

  void addGlobalKey() {
    widget.data?.loanTypeData?.loanTabs?.forEach((element) {
      tabCategories.add(GlobalKey());
    });
    scrollController = ScrollController();
    scrollController.addListener(animateToTab);
  }

  void animateToTab() {
    late RenderBox box;

    for (var i = 0; i < tabCategories.length; i++) {
      box = tabCategories[i].currentContext!.findRenderObject() as RenderBox;
      Offset position = box.localToGlobal(Offset.zero);

      if (scrollController.offset >= position.dy) {
        DefaultTabController.of(tabContext!).animateTo(
          i,
          duration: const Duration(milliseconds: 100),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          floatingActionButton: const StickyFloatingActionButton(),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: BlocBuilder<ProductFeatureCubit, ProductFeatureState>(
            buildWhen: (previous, current) =>
                current is SetProductDetailFromSearch,
            builder: (context, state) {
              if (state is LoadingState) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is SetProductDetailFromSearch) {
                widget.data?.loanTypeData = state.loanType;
                addGlobalKey();
                return Stack(
                  children: [
                    DefaultTabController(
                        length:
                            (widget.data?.loanTypeData?.loanTabs ?? []).length,
                        child: Builder(builder: (BuildContext context) {
                          tabContext = context;
                          return Scaffold(
                              appBar: AppBar(
                                centerTitle: false,
                                title: Text(
                                    '${widget.data?.loanTypeData?.typeTitle.toString()} ${getString(loan)}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                            color: Theme.of(context)
                                                .primaryColor)),
                                bottom: TabBar(
                                  isScrollable: true,
                                  tabAlignment: TabAlignment.start,
                                  indicatorColor:
                                      Theme.of(context).highlightColor,
                                  labelColor: Theme.of(context).highlightColor,
                                  unselectedLabelColor:
                                      Theme.of(context).primaryColor,
                                  indicatorWeight: 3.0,
                                  tabs: (widget.data?.loanTypeData?.loanTabs ??
                                          [])
                                      .map((e) {
                                    return Tab(text: e.tabTitle);
                                  }).toList(),
                                  onTap: (int index) => scrollToIndex(index),
                                ),
                              ),
                              body: MFGradientBackground(
                                child: SingleChildScrollView(
                                  controller: scrollController,
                                  child: Column(
                                    children: List<Widget>.generate(
                                      (widget.data?.loanTypeData!.loanTabs ?? [])
                                          .length,
                                      (index) {
                                        return LoansDetailPage(
                                            loanTab: widget.data?.loanTypeData
                                                    ?.loanTabs ??
                                                [],
                                            position: index,
                                            categoryKey: tabCategories[index]);
                                      },
                                    ).toList(),
                                  ),
                                ),
                              ));
                        })),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          color: Theme.of(context).cardColor,
                          height: MediaQuery.of(context).size.height * 0.1,
                          padding: const EdgeInsets.all(22),
                          width: MediaQuery.of(context).size.width,
                          child: CustomButton(
                              borderColor: Theme.of(context).highlightColor,
                              borderRadius: 8,
                              buttonColor: Theme.of(context).highlightColor,
                              onPressed: () {
                                context.pushNamed(
                                    lead_gen.Routes.leadGeneration.name,
                                    extra: widget.data?.loanTypeData?.vertical,
                                    pathParameters: {
                                      'leadType': widget.data?.loanTypeData
                                              ?.productSubType ??
                                          'common'
                                    });
                              },
                              text: getString(lblProductFeatureApplyNow)),
                        ))
                  ],
                );
              }
              return Stack(
                children: [
                  DefaultTabController(
                      length:
                          (widget.data?.loanTypeData?.loanTabs ?? []).length,
                      child: Builder(builder: (BuildContext context) {
                        tabContext = context;
                        return Scaffold(
                            appBar: AppBar(
                              centerTitle: false,
                              title: Text(
                                  '${widget.data?.loanTypeData?.typeTitle?.toTitleCase()} ${widget.data?.loanTypeData?.productSubType == "balance_transfer" ? "" : widget.data?.loanTypeData?.typeTitle?.equalsIgnoreCase("home") == true || widget.data?.loanTypeData?.typeTitle?.equalsIgnoreCase("personal") == true ? getString(loan) : ""}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                          color:
                                              Theme.of(context).primaryColor)),
                              bottom: TabBar(
                                isScrollable: true,
                                tabAlignment: TabAlignment.start,
                                indicatorColor:
                                    Theme.of(context).highlightColor,
                                labelColor: Theme.of(context).highlightColor,
                                unselectedLabelColor:
                                    Theme.of(context).primaryColor,
                                indicatorWeight: 3.0,
                                tabs:
                                    (widget.data?.loanTypeData?.loanTabs ?? [])
                                        .map((e) {
                                  return Tab(text: e.tabTitle);
                                }).toList(),
                                onTap: (int index) => scrollToIndex(index),
                              ),
                              actions: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          context.pushNamed(
                                              faq_routes.Routes.faq.name);
                                        },
                                        child: Row(
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
                                              getString(lblProductFeatureHelp),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            body: MFGradientBackground(
                              child: SingleChildScrollView(
                                controller: scrollController,
                                child: Column(
                                  children: List<Widget>.generate(
                                    (widget.data?.loanTypeData?.loanTabs ?? [])
                                        .length,
                                    (index) {
                                      return LoansDetailPage(
                                          loanTab: widget
                                                  .data?.loanTypeData?.loanTabs ??
                                              [],
                                          position: index,
                                          categoryKey: tabCategories[index]);
                                    },
                                  ).toList(),
                                ),
                              ),
                            ));
                      })),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        color: Theme.of(context).cardColor,
                        height: MediaQuery.of(context).size.height * 0.1,
                        padding: const EdgeInsets.all(22),
                        width: MediaQuery.of(context).size.width,
                        child: CustomButton(
                            borderColor: Theme.of(context).highlightColor,
                            borderRadius: 8,
                            buttonColor: Theme.of(context).highlightColor,
                            onPressed: () {
                              context.pushNamed(
                                  lead_gen.Routes.leadGeneration.name,
                                  extra: widget.data?.loanTypeData?.vertical,
                                  pathParameters: {
                                    'leadType': widget.data?.loanTypeData
                                            ?.productSubType ??
                                        'common',
                                  });
                            },
                            text: getString(lblProductFeatureApplyNow)),
                      ))
                ],
              );
            },
          )),
    );
  }
}
