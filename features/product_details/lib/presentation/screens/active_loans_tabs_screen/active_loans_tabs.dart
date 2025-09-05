import 'package:appstatus/feature/presentation/application_status_screen.dart';
import 'package:appstatus/feature/presentation/cubit/application_status_cubit.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/config/widgets/background/mf_gradient_background.dart';
import 'package:core/services/di/injection_container.dart';
import 'package:core/utils/size_utils.dart';
import 'package:core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product/presentation/cubit/product_feature_cubit.dart';
import 'package:product/presentation/screens/products_features.dart';
import 'package:product_details/presentation/cubit/product_details_cubit.dart';
import 'package:product_details/presentation/screens/activeloanlistscreen/active_loan_list_screen.dart';
import 'package:product_details/presentation/screens/completedtabscreen/completed_tab_screen.dart';
import 'package:product_details/presentation/screens/theme/theme_helper.dart';
import 'package:product_details/utils/tab_value_singleton.dart';

class ProductDetailsActiveLoanScreen extends StatefulWidget {
  const ProductDetailsActiveLoanScreen({super.key});

  @override
  ProductDetailsActiveLoanScreenState createState() =>
      ProductDetailsActiveLoanScreenState();
}

class ProductDetailsActiveLoanScreenState
    extends State<ProductDetailsActiveLoanScreen>
    with TickerProviderStateMixin {
  late TabController tabviewController;

  GlobalKey<NavigatorState> navigatorKey = GlobalKey();


  @override
  void initState() {
    super.initState();
    tabviewController =
        TabController(length: isCustomer() ? 4 : 2, vsync: this);
    if (TabValueSingleton.instance.getSavedValue() == 2) {
      tabviewController.animateTo(2);
    } else if(TabValueSingleton.instance.getSavedValue() == 3){
      tabviewController.animateTo(3);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductDetailsCubit, ProductDetailsState>(
      listener: (context, state) {},
      builder: (context, state) {
        return SafeArea(
          child: Scaffold(
            body: SizedBox(
              width: double.maxFinite,
              child: Column(
                children: [
                  Expanded(
                    child: SizedBox(
                      width: double.maxFinite,
                      child: MFGradientBackground(
                        horizontalPadding: 0,
                        verticalPadding: 0,
                        child: Column(
                          children: [
                            _buildTabview(context),
                            Container(
                              color: appTheme.gray300,
                              width: MediaQuery.of(context).size.width,
                              height: 0.1,
                            ),
                            Expanded(
                              child: SizedBox(
                                child: TabBarView(
                                  controller: tabviewController,
                                  children: [
                                    BlocProvider(
                                      create: (context) =>
                                          di<ProductFeatureCubit>(),
                                      child: const ProductFeaturesScreen(),
                                    ),
                                    BlocProvider(
                                      create: (context) =>
                                          di<ApplicationStatusCubit>(),
                                      child: ApplicationStatusScreen(
                                          isFromSideMenu: false,
                                          tabnavigation: (val) {
                                            tabviewController.animateTo(
                                                val == "active" ? 2 : 1);
                                          }),
                                    ),
                                    ProductDetailLoanListScreen("active"),
                                    CompletedLoanListScreen("completed"),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTabview(BuildContext context) {
    return SizedBox(
      height: 48.v,
      child: TabBar(
        controller: tabviewController,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        unselectedLabelColor: Theme.of(context).primaryColor,
        labelColor: Theme.of(context).indicatorColor,
        indicatorColor: Theme.of(context).highlightColor,
        tabs: [
          Tab(
            child: Text(getString(lblExplore),
                style: Theme.of(context).textTheme.bodyMedium),
          ),
          Tab(
            child: Text(getString(lblInProgress),
                style: Theme.of(context).textTheme.bodyMedium),
          ),
          if (isCustomer()) ...[
            Tab(
              child: Text(getString(lblActive),
                  style: Theme.of(context).textTheme.bodyMedium),
            ),
            Tab(
              child: Text(getString(lblcompleted),
                  style: Theme.of(context).textTheme.bodyMedium),
            )
          ]
        ],
      ),
    );
  }
}
