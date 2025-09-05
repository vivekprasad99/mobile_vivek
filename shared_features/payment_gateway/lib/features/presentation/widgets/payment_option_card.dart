import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/resources/image_constant.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:core/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../cubit/payment_cubit.dart';
import '../utils/payment_mode_enum.dart';
// ignore_for_file: must_be_immutable
class PaymentOptionCardWidget extends StatelessWidget {
  PaymentOptionCardWidget({
    super.key,
    required this.title,
    required this.subTitle,
    this.showRecommended = false,
    required this.leadingIconPath,
    required this.paymentMode,
  });

  final String title;
  final String subTitle;
  // final bool showTrailWidget;
  final String leadingIconPath;
  final PaymentModeEnum paymentMode;
   bool showRecommended;

  PaymentModeEnum _selectedPaymentMode = PaymentModeEnum.upi;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.read<PaymentGatewayCubit>().setPaymentMode(paymentMode);
      },
      child: BlocBuilder<PaymentGatewayCubit, PaymentGatewayState>(
        buildWhen: (previous, current) => current is ChoosePaymentModeState,
        builder: (context, state) {
          if (state is ChoosePaymentModeState) {
            _selectedPaymentMode = state.paymentMode;
          }
          final bool lightTheme =
              Theme.of(context).brightness == Brightness.light;
          return Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                  color: _selectedPaymentMode == paymentMode
                      ? lightTheme
                          ? AppColors.primaryLight4
                          : AppColors.white
                      : Theme.of(context).cardColor,
                  width: 1),
              boxShadow: _selectedPaymentMode == paymentMode
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.4),
                        offset: const Offset(1.0, 1.0), //(x,y)
                        blurRadius: 3.0,
                      ),
                    ]
                  : null,
            ),
            child: ListTile(
                leading: SvgPicture.asset(
                  leadingIconPath,
                  height: 24.h,
                  width: 24.v,
                  colorFilter: ColorFilter.mode(
                      Theme.of(context).primaryColor, BlendMode.srcIn),
                ),
                title: Text(title,
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium
                        ?.copyWith(fontWeight: FontWeight.w500)),
                subtitle: Text(
                  subTitle,
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                contentPadding: const EdgeInsets.only(left: 12, right: 12),
                trailing: (showRecommended && _selectedPaymentMode != paymentMode) ? 
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: setColorBasedOnTheme(context: context, lightColor: AppColors.primaryLight6, darkColor: AppColors.shadowDark)
                          ),
                          height: 24,width: 95,
                          child:  Center(child: Text(getString(lblRecommended), style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 11, color: Theme.of(context).hintColor),)),),
                      ),
                    ],
                  )
                : Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: SizedBox(
                    width: 80,
                    height: double.maxFinite,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                       const SizedBox(),
                        _selectedPaymentMode == paymentMode
                            ? SvgPicture.asset(
                                ImageConstant.checkCircle,
                                height: 16.h,
                                width: 16.v,
                                colorFilter: ColorFilter.mode(
                                    Theme.of(context).primaryColor,
                                    BlendMode.srcIn),
                              )
                            : const SizedBox.shrink(),
                      ],
                    ),
                  ),
                )
                ),
          );
        },
      ),
    );
  }
}
