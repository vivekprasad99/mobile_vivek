import 'package:common/features/rate_us/presentation/cubit/rate_us_cubit.dart';
import 'package:core/services/di/injection_container.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:locate_us/presentation/cubit/locate_us_cubit.dart';
import 'package:noc/config/routes/route.dart';
import 'package:noc/data/models/noc_details_req.dart';
import 'package:noc/data/models/noc_service_req_params.dart';
import 'package:noc/presentation/cubit/noc_cubit.dart';
import 'package:noc/presentation/screen/delivery_success_screen.dart';
import 'package:noc/presentation/screen/noc_details_screen.dart';
import 'package:noc/presentation/screen/noc_loan_list.dart';
import 'package:noc/presentation/screen/noc_rc_list.dart';
import 'package:noc/presentation/screen/service_exists.dart';
import 'package:noc/presentation/screen/service_request.dart';
import 'package:noc/presentation/screen/sowething_went_wrong.dart';
import 'package:noc/presentation/screen/visit_nearest_branch.dart';
import 'package:profile/presentation/cubit/profile_cubit.dart';
import 'package:service_ticket/features/data/models/dedupe_response.dart';
import 'package:service_ticket/features/presentation/cubit/service_request_cubit.dart';

final List<GoRoute> nocRoutes = [
  GoRoute(
    path: Routes.nocDetails.path,
    name: Routes.nocDetails.name,
    builder: (context, state) => MultiBlocProvider(
      providers: [
        BlocProvider<NocCubit>(create: (context) => di<NocCubit>()),
        BlocProvider<ProfileCubit>(create: (context) => di<ProfileCubit>()),
        BlocProvider<LocateUsCubit>(create: (context) => di<LocateUsCubit>()),
        BlocProvider<RateUsCubit>(create: (context) => di<RateUsCubit>()),
      ],
      child: NocDetailsScreen(
        nocDetailsReq: state.extra as NocDetailsReq,
      ),
    ),
  ),
  GoRoute(
    path: Routes.nocLoanList.path,
    name: Routes.nocLoanList.name,
    builder: (_, state) => BlocProvider<NocCubit>(
      create: (_) => di<NocCubit>(),
      child: NocLoanList(
        selectQuery: state.extra as String,
      ),
    ),
  ),
  GoRoute(
    path: Routes.visitBranch.path,
    name: Routes.visitBranch.name,
    builder: (_, state) => BlocProvider<NocCubit>(
      create: (_) => di<NocCubit>(),
      child: const VisitNearestBranch(),
    ),
  ),
  GoRoute(
    path: Routes.servicerequestscreen.path,
    name: Routes.servicerequestscreen.name,
    builder: (_, state) => MultiBlocProvider(
      providers: [
        BlocProvider<NocCubit>(create: (_) => di<NocCubit>()),
        BlocProvider<ServiceRequestCubit>(
          create: (context) => di<ServiceRequestCubit>(),
        )
      ],
      child: ServiceRequesScreent(
        data: state.extra as NocServiceReqParams,
      ),
    ),
  ),
  GoRoute(
    path: Routes.serviceexists.path,
    name: Routes.serviceexists.name,
    builder: (_, state) => MultiBlocProvider(
      providers: [
        BlocProvider<NocCubit>(
          create: (context) => di<NocCubit>(),
        ),
        BlocProvider<ServiceRequestCubit>(
          create: (context) => di<ServiceRequestCubit>(),
        )
      ],
      child: ServiceRequestExist(
        dedupeResponse: state.extra as DedupeResponse,
      ),
    ),
  ),
  GoRoute(
    path: Routes.rcList.path,
    name: Routes.rcList.name,
    builder: (_, state) => BlocProvider<NocCubit>(
      create: (_) => di<NocCubit>(),
      child: const RCList(),
    ),
  ),
  GoRoute(
    path: Routes.deliverysuccess.path,
    name: Routes.deliverysuccess.name,
    builder: (_, state) => BlocProvider<NocCubit>(
      create: (_) => di<NocCubit>(),
      child: BlocProvider<RateUsCubit>(
        create: (context) => di<RateUsCubit>(),
        child: DeliverySuccessScreen(
          isFromBranch: state.extra as bool?,
        ),
      ),
    ),
  ),
  GoRoute(path: Routes.somethingWentWrongScreen.path,
  name: Routes.somethingWentWrongScreen.name,
    builder: (_, state) => BlocProvider<NocCubit>(
      create: (_) => di<NocCubit>(),
      child: const SomethingWentWrongScreen(),
    ),

  )
];
