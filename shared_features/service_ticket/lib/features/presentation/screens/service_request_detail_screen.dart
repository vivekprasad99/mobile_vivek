import 'package:auth/config/routes/route.dart';
import 'package:core/config/resources/image_constant.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/config/widgets/background/mf_gradient_background.dart';
import 'package:core/config/widgets/custom_buttons/mf_custom_elevated_button.dart';
import 'package:core/config/widgets/mf_appbar.dart';
import 'package:core/services/di/injection_container.dart';
import 'package:core/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:service_ticket/features/presentation/screens/widgets/re_open_request.dart';
import '../../data/models/view_sr_response.dart';
import '../cubit/service_request_cubit.dart';

class ServiceRequestDetailScreen extends StatelessWidget {
  final ServiceRequest? serviceRequest;
  const ServiceRequestDetailScreen({super.key, this.serviceRequest});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: customAppbar(
            context: context,
            title: getString(labelRequestDetails),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        body: MFGradientBackground(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(getString( lblServiceRequestNo),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    serviceRequest?.caseNumber ?? "",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  SvgPicture.asset(
                    height: 30,
                    ImageConstant.imgCopyAll,
                    colorFilter: ColorFilter.mode(
                        Theme.of(context).primaryColor, BlendMode.srcIn),
                  ),
                ],
              ),
              SizedBox(height: 5.v),
              Text(
                'Created on ${serviceRequest?.caseCreatedAt ?? ""}',
                style: Theme.of(context).textTheme.labelSmall,
              ),
              SizedBox(height: 10.v),
              Divider(
                color: Theme.of(context).dividerColor,
              ),
              SizedBox(height: 10.v),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          getString(labelStatus),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(
                          serviceRequest?.srStatus ?? "",
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          getString(lblLastUpdatedOn),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(serviceRequest?.caseUpdatedAt ?? "",
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.v),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          getString(lblCategory),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(serviceRequest?.category ?? "",
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(getString(labelProduct),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(serviceRequest?.productName ?? "",
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15.v),
              Text(
                getString(labelQuery),
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Text(
                serviceRequest?.feedbacks?.isNotEmpty == true
                    ? serviceRequest!.feedbacks![0]
                    : "No feedback available",  // Fallback text if feedbacks is null or empty
                style: Theme.of(context).textTheme.labelSmall,
              ),
              const Spacer(),
              serviceRequest?.srStatus == 'Close'
                  ? Text(
                getString(messageSatisfied),
                style: Theme.of(context).textTheme.bodyMedium,
              )
                  : const SizedBox.shrink(),
              SizedBox(height: 15.v),
              serviceRequest?.srStatus == 'Close'
                  ? Row(
                children: [
                  Expanded(
                    child: MfCustomButton(
                        onPressed: () {
                          openReOpenBottomSheet(context);
                        },
                        text: getString(labelNoReopen),
                        outlineBorderButton: true),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: MfCustomButton(
                        onPressed: () {},
                        text: "Yes",
                        outlineBorderButton: false),
                  ),
                ],
              )
                  : MfCustomButton(
                  onPressed: () {
                    context.goNamed(Routes.home.name);
                  },
                  text: getString(lblHome),
                  outlineBorderButton: false)
            ],
          ),
        ),
      ),
    );
  }

  void openReOpenBottomSheet(BuildContext context) async {
   showModalBottomSheet<void>(
        context: context,
        builder: (_) {
          return BlocProvider<ServiceRequestCubit>(
            create: (context)=> di<ServiceRequestCubit>(),
            child: ReOpenRequestWidget(serviceRequest: serviceRequest),
          );
        });
  }
}
