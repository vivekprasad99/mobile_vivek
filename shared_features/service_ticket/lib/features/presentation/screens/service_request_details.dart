import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/resources/image_constant.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import '../../../config/routes/route.dart';
import '../../../config/utils.dart';
import '../../data/models/view_sr_response.dart';

class ServiceRequestDetailsWidget extends StatelessWidget {
  final ServiceRequest? serviceRequest;
  final Function() onCompletion;
  const ServiceRequestDetailsWidget(
    this.serviceRequest, {
      required this.onCompletion,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final Brightness brightness = Theme.of(context).brightness;
    return serviceRequest != null
        ? GestureDetector(
            onTap: () async {
              var result = await context.pushNamed(
                      Routes.serviceRequestDetailScreen.name,
                      extra: serviceRequest);
              if (result != null) {
                onCompletion();
              }
            },
            child: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(
                      8.h,
                    ),
                    border: Border.all(color: AppColors.borderLight)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      leading: Container(
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                        child: serviceRequest!.productName!
                                .toLowerCase()
                                .contains('vehicle loan')
                            ? SvgPicture.asset(
                                brightness == Brightness.light
                                    ? ImageConstant.imgVehicleLoanIconLight
                                    : ImageConstant.imgVehicleLoanIconDark,
                              )
                            : SvgPicture.asset(
                                brightness == Brightness.light
                                    ? ImageConstant.imgPersonalLoanRupeeLight
                                    : ImageConstant.imgPersonalLoanRupeeDark,
                              ),
                      ),
                      title: Text(getString(lblServiceRequestNo),
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                  letterSpacing: 0.5,
                                  fontWeight: FontWeight.w500)),
                      subtitle: Text(serviceRequest?.caseNumber ?? "",
                          style: Theme.of(context).textTheme.bodyMedium),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: Theme.of(context).primaryColor,
                        size: 16.h,
                      ),
                    ),
                    Divider(
                      color: Theme.of(context).dividerColor,
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 16, bottom: 16, top: 16),
                      child: Row(
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
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  getString(labelProduct),
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                Text(serviceRequest?.productName ?? "",
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16, bottom: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  getString(lblCreatedOn),
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                Text(
                                    convertDateTime(
                                        serviceRequest?.caseCreatedAt ?? ""),
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  getString(lblLastUpdated),
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                Text(
                                    convertDateTime(
                                        serviceRequest?.caseUpdatedAt ?? ""),
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
          )
        : Container();
  }
}
