import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/string_resource/strings.dart';

import 'package:core/config/widgets/mf_theme_check.dart';

import 'package:core/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:noc/data/models/noc_details_resp.dart';
import 'package:noc/presentation/widgets/noc_rc_detail.dart';

class NocDetailCard extends StatelessWidget {
  final NocData nocData;
  final bool rcUpdate;
  const NocDetailCard({super.key, required this.nocData,required this.rcUpdate});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.v),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: setColorBasedOnTheme(
            context: context,
            lightColor: Colors.white,
            darkColor: AppColors.cardDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: setColorBasedOnTheme(
                        context: context,
                        lightColor: AppColors.primaryLight6,
                        darkColor: AppColors.shadowDark),
                    borderRadius: BorderRadius.circular(8)),
                child: Icon(
                  Icons.directions_car_outlined,
                  size: 17.h,
                  color: setColorBasedOnTheme(
                      context: context,
                      lightColor: AppColors.primaryLight,
                      darkColor: Colors.white),
                ),
              ),
              SizedBox(
                width: 12.v,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${(nocData.productCategory ?? getString(lblNocVehicleLoan))} | ${(nocData.loanAccountNumber ?? "")}",
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(fontWeight: FontWeight.w500),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    nocData.model ?? "",
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 12.v,
          ),
          Divider(
            color: Theme.of(context).dividerColor,
          ),
          SizedBox(
            height: 12.v,
          ),
          NocRcDetail(
            nocData: nocData,
            rcUpdate:rcUpdate,
          )
        ],
      ),
    );
  }
}
