import 'package:core/config/string_resource/strings.dart';
import 'package:core/services/di/injection_container.dart';
import 'package:core/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_ticket/features/presentation/screens/open_service_request_screen.dart';
import 'package:service_ticket/features/presentation/screens/service_request_screen.dart';
import '../cubit/service_request_cubit.dart';
import 'close_service_request_screen.dart';
import 'package:profile/presentation/cubit/profile_cubit.dart';
class ServicesTabScreen extends StatefulWidget {
  const ServicesTabScreen({super.key});

  @override
  ServicesTabScreenState createState() => ServicesTabScreenState();
}

class ServicesTabScreenState extends State<ServicesTabScreen>
    with TickerProviderStateMixin {
  late TabController tabviewController;

  @override
  void initState() {
    super.initState();
    tabviewController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        children: [
          _buildTabview(context),
          Expanded(
            child: TabBarView(
              controller: tabviewController,
              children: [
                BlocProvider(
                  create: (context) => di<ProfileCubit>(),
                  child: const ServiceRequestScreen(),
                ),
                BlocProvider(
                  create: (context) => di<ServiceRequestCubit>(),
                  child: const OpenServiceRequestScreen(),
                ),
                BlocProvider(
                  create: (context) => di<ServiceRequestCubit>(),
                  child: const CloseServiceRequestScreen(),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildTabview(BuildContext context) {
    return SizedBox(
      height: 40.v,
      width: double.maxFinite,
      child: TabBar(
        controller: tabviewController,
        isScrollable: false,
        labelPadding: EdgeInsets.zero,
        labelColor: Theme.of(context).highlightColor,
        labelStyle: Theme.of(context).textTheme.titleSmall,
        unselectedLabelColor: Theme.of(context).primaryColor,
        unselectedLabelStyle: Theme.of(context).textTheme.titleSmall,
        indicatorColor: Theme.of(context).highlightColor,
        tabs: [
          Tab(
            child: Text(
              getString(labelServices),
            ),
          ),
          Tab(
            child: Text(
              getString(labelOpenRequests),
            ),
          ),
          Tab(
            child: Text(
              getString(labelClosedRequests),
            ),
          )
        ],
      ),
    );
  }
}
