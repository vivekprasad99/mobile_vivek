import 'package:core/services/di/injection_container.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../data/models/get_branches_res.dart';
import '../../locate_us.dart';
import '../../presentation/cubit/locate_us_cubit.dart';
import '../../presentation/screens/locate_us_branch_list_screen.dart';
import '../../presentation/screens/locate_us_map_screen.dart';

final List<GoRoute> locateUsRoutes = [
  GoRoute(
    path: Routes.locateUsSearch.path,
    name: Routes.locateUsSearch.name,
    builder: (_, state) => BlocProvider(
      create: (ctx) => di<LocateUsCubit>(),
      child: LocateUsSearchScreen(
        isForDealer: (state.extra as bool?) ?? false,
      ),
    ),
  ),
  GoRoute(
    path: Routes.locateUsBranches.path,
    name: Routes.locateUsBranches.name,
    builder: (_, state) => BlocProvider(
      create: (ctx) => di<LocateUsCubit>(),
      child: LocateUsBranchListScreen(
        res: state.extra as List<GetBranchesResponse>,
      ),
    ),
  ),
  GoRoute(
    path: Routes.locateUsMap.path,
    name: Routes.locateUsMap.name,
    builder: (_, __) => BlocProvider(
      create: (ctx) => di<LocateUsCubit>(),
      child: const LocateUsMapScreen(),
    ),
  ),
];
