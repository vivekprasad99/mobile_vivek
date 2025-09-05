import 'package:billpayments/features/presentation/cubit/bill_payments_cubit.dart';
import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/resources/custom_outlined_button.dart';
import 'package:core/config/resources/image_constant.dart';
import 'package:core/config/string_resource/Strings.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:core/utils/size_utils.dart';
import 'package:core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:product_details/data/models/active_loan_list_request.dart';
import 'package:product_details/data/models/active_loan_list_response.dart';
import 'package:product_details/utils/Constants.dart';
import 'package:product_details/utils/date_time_convert.dart';
import 'package:product_details/config/routes/route.dart' as product_details;


class UpcomingPaymentsCards extends StatelessWidget {
  const UpcomingPaymentsCards(
      {super.key, required this.data, required this.totalPaybleAmount});
  final ActiveLoanData data;
  final double totalPaybleAmount;
  @override
  Widget build(BuildContext context) {
    String dueDate = '';
    data.totalPayableAmount = totalPaybleAmount;
    if((data.totalAmountOverdue ?? 0) > 0){
     dueDate = ConvertDateTime.convert(DateFormat('yyyy-MM-dd').format(DateTime.now()));
    }else{
     dueDate = ConvertDateTime.convert(data.nextDuedate ?? '');
    }
    final Brightness brightness = Theme.of(context).brightness;
    return Container(
      padding: const EdgeInsets.only(left: 16.0, bottom: 8.0, right: 16.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            8.h,
          ),
          color: Theme.of(context).cardColor),
      child: ListTile(
        contentPadding: const EdgeInsets.only(left: 0.0, right: 0.0),
        onTap: () {
          //TODO: Add Functionality for Add new payment
        },
        leading: SvgPicture.asset(
          brightness == Brightness.light
              ? ImageConstant.imgVehicleLoanIconLight
              : ImageConstant.imgVehicleLoanIconDark,
        ),
        title: Text("${data.productCategory} | ${data.loanNumber}",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  letterSpacing: 0.16,
                  overflow: TextOverflow.ellipsis,
                )),
        subtitle: Text("${getString(lblDueOn)} $dueDate",
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  letterSpacing: 0.4,
                )),
        trailing: SizedBox(
          height: 52,
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              CustomOutlinedButton(
                height: 40.v,
                width: MediaQuery.of(context).size.width * 0.3,
                text:
                    " ${getString(lblPay)} ${RupeeFormatter(totalPaybleAmount).inRupeesFormat()}",
                margin: EdgeInsets.zero,
                buttonStyle: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: setColorBasedOnTheme(
                        context: context,
                        lightColor: AppColors.secondaryLight,
                        darkColor: AppColors.secondaryLight5),
                    width: 1,
                  ),
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.h),
                  ),
                ),
                buttonTextStyle:
                    Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 11,
                        color: setColorBasedOnTheme(
                          context: context,
                          lightColor: AppColors.secondaryLight,
                          darkColor: AppColors.secondaryLight5,
                        )),
                onPressed: () {
                  context
                      .pushNamed(
                          product_details
                              .Routes.productsPaymentsDetailPage.name,
                          extra: data)
                      .then((value) {
                      if (value == PaymentConstants.resetLoanList) {
                      context.read<BillPaymentsCubit>().getActiveLoansList(
                          ActiveLoanListRequest(ucic: getUCIC()));
                    }
                  });
                },
              ),
              if ((data.totalAmountOverdue ?? 0) > 0)
                Positioned(
                  top: 0,
                  child: Container(
                    height: 22,
                    width: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: AppColors.secondaryLight3.withOpacity(1),
                    ),
                    child: Center(
                        child: Text(
                      getString(lblOverdue),
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(fontSize: 11, color: AppColors.white),
                    )),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
