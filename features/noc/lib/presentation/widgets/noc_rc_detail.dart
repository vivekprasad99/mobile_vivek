import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:core/utils/date_time_utils.dart';
import 'package:core/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:noc/data/models/noc_details_resp.dart';

class NocRcDetail extends StatelessWidget {
  final NocData nocData;
  final bool rcUpdate;
  const NocRcDetail({super.key, required this.nocData,required this.rcUpdate});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if ((nocData.registrationNo == null&&rcUpdate)||(nocData.registrationNo?.isEmpty==true&&rcUpdate))
          Row(
            children: [
              Text(
                getString(lblNocVehicleRegNo),
                style: Theme.of(context).textTheme.bodySmall,
              ),
              SizedBox(
                width: 12.v,
              ),
              Icon(
                Icons.error_outline,
                size: 12.67.v,
                color: setColorBasedOnTheme(
                    context: context,
                    lightColor: AppColors.primaryLight,
                    darkColor: Colors.white),
              )
            ],
          )
        else
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        getString(lblVehicleRegNo),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        nocData.registrationNo ?? "",
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ],
                  ),
                  if (nocData.nocStatus == null || nocData.nocStatus!.isEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          getString(lblLoanEndDate),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(
                          nocData.endDate != null
                              ? DateTime.parse(nocData.endDate!)
                                  .format(pattern: 'dd MMM yyyy')
                                  .toString()
                              : "",
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ],
                    )
                  else
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          getString(lblNocFeatureNocStatus),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(
                          nocData.displayNocStatus ?? "",
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ],
                    ),
                ],
              ),
              SizedBox(
                height: 12.h,
              ),
              if (nocData.nocStatus == null || nocData.nocStatus!.isEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      getString(lblNocFeatureNocStatus),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      nocData.displayNocStatus ?? "",
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                ),
            ],
          )
      ],
    );
  }
}
