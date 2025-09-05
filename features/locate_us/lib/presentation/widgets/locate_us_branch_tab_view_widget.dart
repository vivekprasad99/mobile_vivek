import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../config/routes/route.dart';
import '../../data/models/get_branches_res.dart';
import 'locate_us_branch_tab_view.dart';
import 'locate_us_cash_collection_point_tab_view.dart';
// ignore_for_file: must_be_immutable
class LocateUsBranchTabViewWidget extends StatefulWidget {
  LocateUsBranchTabViewWidget({
    super.key,
    this.scrollController,
    required this.isForMap,
    required this.branches,
    required this.dealers,
    required this.saved,
    this.whenDealersFetch,
    this.whenDealersUnoFocused,
  });

  final bool isForMap;
  final ScrollController? scrollController;
  void Function()? whenDealersFetch;
  void Function()? whenDealersUnoFocused;
  List<Branch> branches;
  List<Branch> dealers;
  List<Branch> saved;

  @override
  State<LocateUsBranchTabViewWidget> createState() =>
      _LocateUsBranchTabViewWidgetState();
}

class _LocateUsBranchTabViewWidgetState
    extends State<LocateUsBranchTabViewWidget>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  final tabs = [
    Tab(text: getString(lblLoUsBranches)),
    Tab(text: getString(lblLoUsDealers)),
    Tab(text: getString(lblLoUsCPP)),
    Tab(text: getString(lblLoUsSaved)),
  ];

  @override
  void initState() {
    tabController = TabController(length: tabs.length, vsync: this);
    tabController.addListener(_handleTabChange);
    super.initState();
  }

  void _handleTabChange() async {
    if (tabController.index == 1) {
      widget.whenDealersFetch?.call();
    } else {
      if (tabController.previousIndex == 1) {
        widget.whenDealersUnoFocused?.call();
      }
    }
    if (!tabController.indexIsChanging) {
      if (widget.isForMap &&
          tabController.index == 1 &&
          widget.dealers.isEmpty) {
        _pushToManualSearch();
      }
    }
  }

  void _pushToManualSearch() async {
    final dealers = await context.pushNamed<GetBranchesResponse>(
      Routes.locateUsSearch.name,
      extra: true,
    );
    if (dealers?.branchList != null) {
      setState(() {
        widget.dealers = dealers!.branchList!;
        widget.whenDealersFetch?.call();
      });
    }
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final list = [
      //? Tab Bar
      TabBar(
        controller: tabController,
        labelStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: AppColors.secondaryLight,
              fontWeight: FontWeight.w700,
            ),
        indicatorColor: AppColors.secondaryLight,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        dividerHeight: 1,
        padding: const EdgeInsets.only(right: 22),
        dividerColor: const Color.fromRGBO(0, 0, 0, 0.05),
        tabs: tabs,
      ),

      const SizedBox(height: 16),

      //? Tab view
      Expanded(
        child: TabBarView(
          controller: tabController,
          children: [
            //? Branch
            BranchTabView(
              branches: widget.branches,
            ),

            //? Dealers
            BranchTabView(
              emptyView: widget.isForMap
                  ? TextButton(
                      onPressed: _pushToManualSearch,
                      child: Text(
                        getString(msgLoUsEnterPincodeForDealers),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    )
                  : null,
              branches: widget.dealers,
            ),

            //? Cash Collection Points
            const CashCollectionPointsTabView(),

            //? Saved
            BranchTabView(
              branches: widget.saved,
            ),
          ],
        ),
      ),
    ];
    return Column(children: list);
  }
}
