import 'dart:convert';

import 'package:common/features/rate_us/data/models/rate_us_request.dart';
import 'package:common/features/rate_us/presentation/cubit/rate_us_cubit.dart';
import 'package:common/features/rate_us/utils/helper/constant_data.dart';
import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:core/utils/pref_utils.dart';
import 'package:core/utils/size_utils.dart';
import 'package:core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:noc/data/models/noc_details_resp.dart';
import 'package:noc/data/models/rc_attempt_model.dart';
import 'package:noc/presentation/cubit/noc_cubit.dart';
import 'package:noc/presentation/widgets/out_of_attempts_bottomsheet.dart';
import 'package:noc/presentation/widgets/update_rc_bottomsheet.dart';
import 'package:noc/config/util/flag_enums.dart';
import 'package:payment_gateway/config/routes/route.dart' as payment_routes;
import 'package:payment_gateway/features/domain/models/payment_model.dart';
import 'package:payment_gateway/features/domain/models/payment_params/payment_product_type.dart';
import 'package:payment_gateway/features/domain/models/payment_params/payment_source_system.dart';
import 'package:payment_gateway/features/domain/models/payment_params/payment_type.dart';

class NocMsgContainer extends StatelessWidget {
  final NocData data;
  final bool rcUpdate;
  const NocMsgContainer({
    super.key,
    required this.data,
    required this.rcUpdate,
  });

  @override
  Widget build(BuildContext context) {
    if (data.nocStatus?.contains("2") == true ||
        data.nocStatus?.equalsIgnoreCase(nocStatusString.print.value) == true) {
      return Container();
    }
    if (data.registrationNo == null || rcUpdate) {
    return Container(
      padding: EdgeInsets.all(12.v),
      decoration: BoxDecoration(
        color: setColorBasedOnTheme(
            context: context,
            lightColor: AppColors.primaryLight6,
            darkColor: AppColors.shadowDark),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.notifications_active_outlined,
            size: 21.h,
            color: setColorBasedOnTheme(
                context: context,
                lightColor: AppColors.primaryLight,
                darkColor: Colors.white),
          ),
          Flexible(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.v),
              child: Text(
                getString(lblMsgUpdateRcNo),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ),
          GestureDetector(
            onTap: () async{
              List<String>? rcAttemptsListdencoded =
                  PrefUtils.getStringList(PrefUtils.rcAttempts);
              List<RcAttempt>? rcAttemptsList = rcAttemptsListdencoded
                  .map((item) => RcAttempt.fromJson(jsonDecode(item)))
                  .toList();
              if (rcAttemptsList
                  .map((e) => e.loanNumber)
                  .toList()
                  .contains(data.loanAccountNumber)) {
                RcAttempt rcAttempt = rcAttemptsList.firstWhere(
                    (element) => element.loanNumber == data.loanAccountNumber);
                int attempts = rcAttempt.attempts;
                if (attempts < 2) {
                await  showModalBottomSheet(
                    context: context,
                    builder: (_) => BlocProvider.value(
                      value: BlocProvider.of<NocCubit>(context),
                      child: UpdateRcBottomsheet(
                        loanNumber: data.loanAccountNumber ?? "",
                        data: data,
                      ),
                    ),
                  );
                  if(context.mounted){
                 checkLastRatingDate(context,ConstantData.nocSuccessfulRcUpdate);
                  }
                } else {
                  showModalBottomSheet(
                      context: context,
                      builder: (_) => BlocProvider.value(
                            value: BlocProvider.of<NocCubit>(context),
                            child: OutOfAttemptsBottomsheet(data: data),
                          ));
                }
              }
              else{
                 showModalBottomSheet(
                    context: context,
                    builder: (_) => BlocProvider.value(
                      value: BlocProvider.of<NocCubit>(context),
                      child: UpdateRcBottomsheet(
                        loanNumber: data.loanAccountNumber ?? "",
                        data: data,
                      ),
                    ),
                  );
              }
            },
            child: Text(
              getString(lblNocFeatureUpdate),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: setColorBasedOnTheme(
                        context: context,
                        lightColor: AppColors.secondaryLight,
                        darkColor: AppColors.secondaryLight5),
                  ),
            ),
          )
        ],
      ),
    );
    }
    if (data.netSettlementAmt != null &&
        data.netSettlementAmt!.isNotEmpty &&
        !data.netSettlementAmt!.contains("-")) {
      return Container(
        padding: EdgeInsets.all(12.v),
        decoration: BoxDecoration(
          color: setColorBasedOnTheme(
              context: context,
              lightColor: AppColors.primaryLight6,
              darkColor: AppColors.shadowDark),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              Icons.notifications_active_outlined,
              size: 21.h,
              color: setColorBasedOnTheme(
                  context: context,
                  lightColor: AppColors.primaryLight,
                  darkColor: Colors.white),
            ),
            Flexible(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.v),
                child: Text(
                  getString(lblPayNoc).replaceAll(
                      "pay_amount",
                      RupeeFormatter(double.parse(data.netSettlementAmt ?? "0"))
                          .inRupeesFormat()),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                context.pushNamed(
                  payment_routes.Routes.choosePaymentMode.name,
                  extra: PaymentModel(
                      productType: PaymentProductType.vl,
                      sourceSystem: data.sourceSystem == "Autofin"
                          ? PaymentSourceSystem.autofin
                          : PaymentSourceSystem.finone,
                      productNumber: data.loanAccountNumber ?? "",
                      paymentType: PaymentType.noc,
                      totalPaybleAmount: data.netSettlementAmt!,
                      description: ''),
                );
              },
              child: Text(
                getString(lblNocFeaturePayNow),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: setColorBasedOnTheme(
                          context: context,
                          lightColor: AppColors.secondaryLight,
                          darkColor: AppColors.secondaryLight5),
                    ),
              ),
            )
          ],
        ),
      );
    }
    if (data.nocStatus==null&&
      (DateTime.tryParse(data.endDate ?? DateTime.now().toIso8601String()) ??
                DateTime.now())
            .difference(DateTime.now())
            .inDays <=
        30) {
      return Container(
        padding: EdgeInsets.all(12.v),
        decoration: BoxDecoration(
          color: setColorBasedOnTheme(
              context: context,
              lightColor: AppColors.primaryLight6,
              darkColor: AppColors.shadowDark),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              Icons.notifications_active_outlined,
              size: 21.h,
              color: setColorBasedOnTheme(
                  context: context,
                  lightColor: AppColors.primaryLight,
                  darkColor: Colors.white),
            ),
            Flexible(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.v),
                child: Text(
                  getString(msgNearingNocClosure),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ),
          ],
        ),
      );
    }
    return Container();
  }

  void checkLastRatingDate(BuildContext context, String featureType) async {
    RateUsRequest rateUsRequest =
    RateUsRequest(superAppId: getSuperAppId(), feature: featureType);
    BlocProvider.of<RateUsCubit>(context).getRateUs(rateUsRequest);
  }
}
