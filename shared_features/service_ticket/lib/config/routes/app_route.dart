import 'package:ach/presentation/cubit/ach_cubit.dart';
import 'package:core/services/di/injection_container.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:loan/features/foreclosure/presentation/cubit/foreclosure_cubit.dart';
import 'package:service_ticket/features/data/models/service_request_response.dart';
import 'package:service_ticket/features/presentation/cubit/service_request_cubit.dart';
import 'package:service_ticket/features/presentation/screens/close_service_request_screen.dart';
import 'package:service_ticket/features/presentation/screens/details_page.dart';
import 'package:service_ticket/features/presentation/screens/open_service_request_screen.dart';
import 'package:service_ticket/features/presentation/screens/raise_request_screen.dart';
import 'package:service_ticket/features/presentation/screens/service_request_acknowledge_screen.dart';
import 'package:service_ticket/features/presentation/screens/service_request_detail_screen.dart';
import 'package:service_ticket/features/presentation/screens/service_request_screen.dart';
import 'package:service_ticket/features/presentation/screens/service_tab_screen.dart';
import 'package:service_ticket/features/presentation/screens/service_upload_document.dart';
import 'package:service_ticket/features/presentation/screens/widgets/service_ticket_exist.dart';
import 'package:profile/presentation/cubit/profile_cubit.dart';
import '../../features/data/models/view_sr_response.dart';
import '../../features/presentation/screens/document_details.dart';
import 'package:common/features/search/data/model/search_response.dart';
import 'route.dart';

final List<GoRoute> serviceTicketRoutes = [
  GoRoute(
      path: Routes.serviceRequest.path,
      name: Routes.serviceRequest.name,
       builder: (_, __) => MultiBlocProvider(
            providers: [
              BlocProvider<ServiceRequestCubit>(
                create: (context) => di<ServiceRequestCubit>(),
              ),
              BlocProvider<ProfileCubit>(
                create: (context) => di<ProfileCubit>(),
              ),
            ],
          child: const ServiceRequestScreen())),

  GoRoute(
    path: Routes.serviceUploadDocument.path,
    name: Routes.serviceUploadDocument.name,
    builder: (context, state) => BlocProvider(
      create: (context) => di<ServiceRequestCubit>(),
      child: ServiceUploadDocument(imagePath: state.extra as String),
    ),
  ),
  GoRoute(
      path: Routes.raiseRequest.path,
      name: Routes.raiseRequest.name,
      builder: (context, state) => MultiBlocProvider(
            providers: [
              BlocProvider<ServiceRequestCubit>(
                create: (context) => di<ServiceRequestCubit>(),
              ),
              BlocProvider<ForeclosureCubit>(
                create: (context) => di<ForeclosureCubit>(),
              ),
            ],
            child: RaiseRequestScreen(requestMap: state.extra as Map<String,String>),
          )),
  GoRoute(
    path: Routes.requestAcknowledgeScreen.path,
    name: Routes.requestAcknowledgeScreen.name,
    builder: (context, state) => BlocProvider(
        create: (context) => di<ServiceRequestCubit>(),
        child: ServiceRequestAcknowledgeScreen(
          response: state.extra as ServiceRequestResponse,
        )),
  ),
  GoRoute(
      path: Routes.servicesTabScreen.path,
      name: Routes.servicesTabScreen.name,
      builder: (_, __) => const ServicesTabScreen()),
  GoRoute(
      path: Routes.openServiceRequestScreen.path,
      name: Routes.openServiceRequestScreen.name,
      builder: (_, __) => BlocProvider<ServiceRequestCubit>(
          create: (context) => di<ServiceRequestCubit>(),
          child: const OpenServiceRequestScreen())),
  GoRoute(
      path: Routes.closeServiceRequestScreen.path,
      name: Routes.closeServiceRequestScreen.name,
      builder: (_, __) => BlocProvider<ServiceRequestCubit>(
          create: (context) => di<ServiceRequestCubit>(),
          child: const CloseServiceRequestScreen())),
  GoRoute(
      path: Routes.serviceRequestDetailScreen.path,
      name: Routes.serviceRequestDetailScreen.name,
      builder: (context, state) => BlocProvider<ServiceRequestCubit>(
          create: (context) => di<ServiceRequestCubit>(),
          child: ServiceRequestDetailScreen(
              serviceRequest: state.extra as ServiceRequest))),
  GoRoute(
      path: Routes.selectDetailsPage.path,
      name: Routes.selectDetailsPage.name,
      builder: (context, state) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<ForeclosureCubit>(
              create: (context) => di<ForeclosureCubit>(),
            ),
            BlocProvider<AchCubit>(
              create: (context) => di<AchCubit>(),
            )
          ],
          child: SelectDetailsPage(
              selectDetailParam: ServicesNavigationRequest.fromJson(state.extra as Map<dynamic,dynamic>)),
        );
      }),

  GoRoute(
      path: Routes.documentDetailsScreen.path,
      name: Routes.documentDetailsScreen.name,
      builder: (context, state) => BlocProvider<ServiceRequestCubit>(
          create: (context) => di<ServiceRequestCubit>(),
          child: DocumentDetailsScreen(paramType: state.extra as Map<String,dynamic>))),

  GoRoute(
      path: Routes.serviceTicketExist.path,
      name: Routes.serviceTicketExist.name,
      builder: (context, state) => BlocProvider<ServiceRequestCubit>(
          create: (context) => di<ServiceRequestCubit>(),
          child:  ServiceTicketExist(
              serviceRequestResponse: state.extra as ServiceRequestResponse))),
];
