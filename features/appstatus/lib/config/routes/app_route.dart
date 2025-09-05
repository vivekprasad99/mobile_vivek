import 'package:appstatus/config/routes/route.dart';
import 'package:appstatus/feature/presentation/application_status_screen.dart';
import 'package:appstatus/feature/presentation/cubit/application_status_cubit.dart';
import 'package:core/services/di/injection_container.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

final List<GoRoute> applicationstatusRoutes = [
  GoRoute(
      path: Routes.applicationstatus.path,
      name: Routes.applicationstatus.name,
      builder: (context, state) => BlocProvider<ApplicationStatusCubit>(
          create: (context) => di<ApplicationStatusCubit>(),
          child: ApplicationStatusScreen(
              isFromSideMenu: state.extra as bool?))),
];
