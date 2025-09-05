import 'package:core/services/di/injection_container.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/cubit/lead_generation_cubit.dart';
import '../../presentation/lead_gen/screens/widget/acknowledgement_widget.dart';
import '../../presentation/lead_gen/screens/lead_generation_screen.dart';
import 'package:lead_generation/config/routes/route.dart' as route;

final List<GoRoute> leadGenerationRoutes = [
  GoRoute(
      path: route.Routes.leadGeneration.path,
      name: route.Routes.leadGeneration.name,
      builder: (context, state) => BlocProvider<LeadGenerationCubit>(
          create: (context) => di<LeadGenerationCubit>(),
          child: LeadGenerationScreen(
              leadType: state.pathParameters['leadType'].toString(),
              vertical: state.extra as String?))),
  GoRoute(
      path: route.Routes.acknowledge.path,
      name: route.Routes.acknowledge.name,
      builder: (_, __) => const AcknowledgementWidget()),
];
