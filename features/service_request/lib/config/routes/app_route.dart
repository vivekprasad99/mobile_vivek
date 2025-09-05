import 'package:core/services/di/injection_container.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:service_request/features/bureau/data/models/service_data.dart';
import 'package:service_request/features/bureau/presentation/cubit/bureau_cubit.dart';
import 'package:service_request/features/bureau/presentation/screens/bureau_screen.dart';
import 'package:service_request/features/bureau/presentation/screens/bureau_upload_document.dart';
import 'package:service_request/features/bureau/presentation/screens/service_ticket_bureau_exist.dart';
import 'package:service_request/features/bureau/presentation/screens/service_ticket_raised.dart';
import 'package:service_request/features/bureau/presentation/screens/upload_doc_screen.dart';
import 'package:service_ticket/features/data/models/service_request_response.dart';
import 'package:service_ticket/features/presentation/cubit/service_request_cubit.dart';
import 'route.dart';

final List<GoRoute> serviceRequestRoutes = [

   //Bureau Routes
  GoRoute(
      path: Routes.bureau.path,
      name: Routes.bureau.name,
      builder: (context, state) => BlocProvider<BureauCubit>(
          create: (context) => di<BureauCubit>(),
          child: const BureauScreen())),
  GoRoute(
      path: Routes.serviceRequestBureauExist.path,
      name: Routes.serviceRequestBureauExist.name,
    builder: (context, state) => MultiBlocProvider(
        providers: [
          BlocProvider<BureauCubit>(
            create: (context) => di<BureauCubit>(),
          ),
          BlocProvider<ServiceRequestCubit>(
            create: (context) => di<ServiceRequestCubit>(),
          ),
        ],
        child: ServiceRequestExist(
          serviceRequestResponse:
          state.extra as ServiceRequestResponse,
        )),),
  GoRoute(
    path: Routes.serviceRequestBureauRaised.path,
    name: Routes.serviceRequestBureauRaised.name,
    builder: (context, state) => MultiBlocProvider(
        providers: [
          BlocProvider<BureauCubit>(
            create: (context) => di<BureauCubit>(),
          ),
          BlocProvider<ServiceRequestCubit>(
            create: (context) => di<ServiceRequestCubit>(),
          ),
        ],
        child: ServiceRequestRaised(
          serviceRequestResponse:
          state.extra as ServiceRequestResponse,
        )),
  ),
  GoRoute(
    path: Routes.serviceBureauUploadDocuments.path,
    name: Routes.serviceBureauUploadDocuments.name,
    builder: (context, state) => MultiBlocProvider(
        providers: [
          BlocProvider<BureauCubit>(
            create: (context) => di<BureauCubit>(),
          ),
          BlocProvider<ServiceRequestCubit>(
            create: (context) => di<ServiceRequestCubit>(),
          ),
        ],
        child: ServiceBureauUploadDocuments(
          dataModel: state.extra as ServiceDataModel,
        )),
  ),
  GoRoute(
    path: Routes.uploadDocScreen.path,
    name: Routes.uploadDocScreen.name,
    builder: (context, state) => BlocProvider(
      create: (context) => di<BureauCubit>(),
      child: UploadDocScreen(uploadDataModel: state.extra as UploadDataModel),
    ),
  ),
];
