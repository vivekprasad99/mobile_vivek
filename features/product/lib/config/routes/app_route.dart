import 'package:core/services/di/injection_container.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:product/config/routes/route.dart';
import 'package:product/presentation/cubit/product_feature_cubit.dart';
import 'package:product/presentation/screens/loans_tab_bar/loans_tab_bar.dart';
import 'package:common/features/search/data/model/search_response.dart';

final List<GoRoute> productFeatureRoutes = [
  GoRoute(
      path: Routes.productFeaturesOneTabContainerScreen.path,
      name: Routes.productFeaturesOneTabContainerScreen.name,
      builder: (context, state) {
        return BlocProvider<ProductFeatureCubit>(
            create: (context) => di<ProductFeatureCubit>(),
            child: LoansTabBar(data:LoansTabBarArguments.fromJson(state.extra as Map<dynamic,dynamic>)),
          );
      }),
];
