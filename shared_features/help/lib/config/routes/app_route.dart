import 'package:core/services/di/injection_container.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:help/config/routes/route.dart';
import 'package:help/features/data/models/help_model.dart';
import 'package:help/features/presentation/cubit/help_cubit.dart';
import 'package:help/features/presentation/help_screen.dart';

final List<GoRoute> helpRoutes = [
  GoRoute(
    path: Routes.help.path,
    name: Routes.help.name,
    builder: (context, state) => BlocProvider(
      create: (context) => di<HelpCubit>(),
      child: HelpScreen(
      helpCatSub: state.extra as HelpCatSub,
      ),
    ),
  ),
];
