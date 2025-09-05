import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/resources/image_constant.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/config/widgets/background/mf_gradient_background.dart';
import 'package:core/config/widgets/custom_buttons/mf_custom_elevated_button.dart';
import 'package:core/config/widgets/mf_progress_bar.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:core/config/widgets/mf_toast.dart';
import 'package:core/utils/const.dart';
import 'package:core/utils/size_utils.dart';
import 'package:core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:common/config/routes/app_route.dart';
import 'package:common/config/routes/route.dart' as common_routes;
import 'package:service_ticket/features/data/models/sr_details_request.dart';
import 'package:service_ticket/features/presentation/cubit/service_request_cubit.dart';
import 'package:service_ticket/features/presentation/cubit/service_request_state.dart';
import '../../../config/routes/route.dart';
import '../../data/models/service_request_response.dart';


class ServiceRequestAcknowledgeScreen extends StatelessWidget {
  final ServiceRequestResponse response;
   const ServiceRequestAcknowledgeScreen({super.key, required this.response});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false,),
      body: MFGradientBackground(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 50.v),
            SvgPicture.asset(
              ImageConstant.imgCongratulationIcon,
              height: 88.v,
              width: 48.h,
              colorFilter: ColorFilter.mode(
                  setColorBasedOnTheme(
                      context: context,
                      lightColor: AppColors.secondaryLight,
                      darkColor: AppColors.primaryLight5),
                  BlendMode.srcIn),
            ),
            SizedBox(height: 17.v),
            Text(getString(serviceRequestRaised),
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            SizedBox(height: 17.v),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: const BorderRadius.all(Radius.circular(8))),
              child: Padding(
                padding:
                const EdgeInsets.only(left: 8.0, top: 16.0, bottom: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          "${getString(serviceTicketNo)} ${response.data?.serviceTicketNumber}",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        InkWell(
                          onTap: () async {
                            await Clipboard.setData(ClipboardData(
                                text:
                                "${getString(serviceTicketNo)} ${response.data?.serviceTicketNumber}",));
                            // copied successfully
                          },
                          child: Icon(
                            Icons.copy,
                            color: setColorBasedOnTheme(
                                context: context,
                                lightColor: AppColors.primaryLight,
                                darkColor: AppColors.primaryLight5),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      getString(serviceBureauCustomer),
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            BlocConsumer<ServiceRequestCubit, ServiceRequestState>(
              listener: (BuildContext context, ServiceRequestState state) {
                if (state is SrDetailsSuccessState) {
                  if (state.response.code == AppConst.codeSuccess) {
                    context.goNamed(Routes.serviceRequestDetailScreen.name,
                        extra: state.response.data?.first);

                  }else {
                    toastForFailureMessage(
                        context: context,
                        msg: getString(
                            state.response.responseCode ??
                                msgSomethingWentWrong));
                  }
                }else if (state is SrDetailsFailureState) {
                  showSnackBar(
                      context: context, message: getFailureMessage(state.error));
                }else if (state is ServiceRequestLoadingState) {
                  if (state.isLoading) {
                    showLoaderDialog(context, getString(lblLoading));
                  } else {
                    Navigator.of(context, rootNavigator: true).pop();
                  }
                }
              },
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MfCustomButton(
                        onPressed: () {
                          SRDetailsRequest srDetailsReq = SRDetailsRequest(
                              caseNumber: response.data?.serviceTicketNumber);
                          context
                              .read<ServiceRequestCubit>()
                              .srDetailsByNumber(srDetailsReq);
                        },
                        text: getString(trackRequest),
                        outlineBorderButton: true),
                    const SizedBox(
                      height: 20,
                    ),
                    MfCustomButton(
                        onPressed: () {
                          while (AppRoute.router.canPop()) {
                            AppRoute.router.pop();
                          }
                          AppRoute.router.pushReplacementNamed(
                            common_routes.Routes.home.name,
                          );
                        },
                        text: getString(home),
                        outlineBorderButton: false),
                  ],
                );
              },
            ),

          ],
        ),
      ),
    );
  }
}

