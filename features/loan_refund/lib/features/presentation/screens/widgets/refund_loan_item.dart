import 'package:ach/config/ach_const.dart';
import 'package:ach/data/models/get_ach_loans_response.dart';
import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/resources/custom_image_view.dart';
import 'package:core/config/resources/image_constant.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/config/widgets/background/mf_gradient_background.dart';
import 'package:core/config/widgets/custom_buttons/mf_custom_elevated_button.dart';
import 'package:core/config/widgets/mf_progress_bar.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:core/config/widgets/mf_toast.dart';
import 'package:core/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:loan_refund/features/presentation/cubit/loan_refund_cubit.dart';
import 'package:loan_refund/features/presentation/cubit/loan_refund_state.dart';
import '../../../../config/refund_util.dart';
import '../../../../config/routes/route.dart';
import '../../../data/models/loan_refund_params/refund_status_type.dart';

class RefundLoanItem extends StatefulWidget {
  const RefundLoanItem({
    super.key,
    this.widgetVisibility,
  });

  final bool? widgetVisibility;

  @override
  State<RefundLoanItem> createState() => _RefundLoanItemState();
}

int selectedIndex = -1;

class _RefundLoanItemState extends State<RefundLoanItem> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoanRefundCubit, LoanRefundState>(
      builder: (context, state) {
        if (state is LoanRefundLoadingState &&  state.isLoading){
          return  Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Theme.of(context).primaryColor,
              ));
        }
        else if (state is RefundLoanListSuccessState) {
          List<LoanData> loanList = state.response.data ?? [];
          if (loanList.isNotEmpty) {
            return MFGradientBackground(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(getString(lblSelectLoanAccount),
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 18.0)),
                Expanded(
                  child: ListView.separated(
                    shrinkWrap: true,
                    separatorBuilder: (
                      context,
                      index,
                    ) {
                      return Opacity(
                        opacity: 0.5,
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 7.0.v),
                        ),
                      );
                    },
                    itemCount: loanList.length,
                    itemBuilder: (context, index) {
                      return buildLoanItem(context, loanList[index],
                          selectedLoan: index);
                    },
                  ),
                ),
                if (loanList.isNotEmpty)
                  _buildRefundButton(context, selectedIndex, loanList),
              ],
            ));
          }
          return buildEmptyWidget();
        }
        else if(state is LoanRefundFailureState) {
          toastForFailureMessage(context: context, msg: getString(msgSomethingWentWrong));
        }
        return Container();
      },
    );
  }

  Widget buildLoanItem(BuildContext context, LoanData loanData,
      {int? selectedLoan}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: InkWell(
        onTap: () {
          setState(() {
            selectedIndex = selectedLoan!;
          });
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
                Padding(
                  padding: const EdgeInsets.only(left: 16, bottom: 16, top: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${loanData.productCategory ?? ""} | ${loanData.loanAccountNumber ?? ""}",
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            Text(
                                loanData.productCategory ==
                                        LoanType.personalLoan.value
                                    ? '₹${loanData.totalAmount.toString()}'
                                    : loanData.vehicleRegistration ?? "",
                                style: Theme.of(context).textTheme.labelMedium),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 80.0, top: 15.0, bottom: 15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Container(
                                  height: 24.0,
                                  width: 60.0,
                                  decoration: BoxDecoration(
                                      color: setColorBasedOnTheme(
                                          context: context,
                                          lightColor: AppColors.shadowLight,
                                          darkColor: AppColors.shadowDark),
                                      borderRadius: BorderRadius.circular(4)),
                                  child: Center(
                                    child: Text(
                                      loanData.loanStatus ?? "-",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                              color: setColorBasedOnTheme(
                                                  context: context,
                                                  lightColor:
                                                      AppColors.textLight,
                                                  darkColor: AppColors.white),
                                              fontWeight: FontWeight.w400,
                                              fontSize: 11.0),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: SvgPicture.asset(
                          ImageConstant.checkCircle,
                          height: 16.h,
                          width: 16.v,
                          colorFilter: selectedIndex == selectedLoan
                              ? ColorFilter.mode(Theme.of(context).primaryColor,
                                  BlendMode.srcIn)
                              : ColorFilter.mode(
                                  Theme.of(context).disabledColor,
                                  BlendMode.srcIn),
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
                              getString(lblEmisPaid),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            Text(
                                getString(
                                    "${loanData.totalEmiPaid}/${loanData.loanTenure}"),
                                style: Theme.of(context).textTheme.labelMedium),
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
                              getString(lblUpcomingEMI),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            Text(
                                _showUpcomingEMI(loanData)
                                    ? (loanData.installmentAmount ?? 0)
                                        .toString()
                                    : '-',
                                style: Theme.of(context).textTheme.labelMedium),
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
                              getString(lblExcessAmount),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            Text(loanData.excessAmount.toString(),
                                style: Theme.of(context).textTheme.labelMedium),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }

  bool _showUpcomingEMI(LoanData loanData) {
    context.read<LoanRefundCubit>().loanRefundViewModel.selectedLoan = loanData;
    return context
        .read<LoanRefundCubit>()
        .loanRefundViewModel
        .showUpcomingEMI();
  }

  Widget _buildRefundButton(
      BuildContext context, int selectedIndex, List<LoanData> loanList) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Visibility(
        visible: selectedIndex != -1 ? true : false,
        child: MfCustomButton(
          onPressed: () {
            var refundViewModel =
                context.read<LoanRefundCubit>().loanRefundViewModel;
            refundViewModel.setSelectedLoan(loanList[selectedIndex]);

            if (refundViewModel.isExcessAmount()) {
              if (refundViewModel.isRefundApplicable()) {
                context.pushNamed(
                  Routes.raiseRefund.name,
                  extra: {
                    'loanList': loanList,
                    'loanData': loanList[selectedIndex],
                    'refundAmount': refundViewModel.getRefundAmount()
                  },
                );
              } else {
                //scenario 8
                context.pushNamed(Routes.adjustPreviewScreen.name, extra: {
                  'loanData': loanList[selectedIndex],
                  'is_sr_required': true,
                  'sr_desc':
                      "scenario no 8 - SR is required for adjustment with other loans due",
                  'isDues': true,
                  'loanList': loanList,
                  'refundStatus': RefundStatusType.adjustment.value
                });
              }
            } else {
              context.pushNamed(Routes.navigateToLoanRefundRaiseQuery.name);
            }
          },
          text: getString(lblGetRefund),
          outlineBorderButton: false,
          textStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: const Color(0xffFFFFFF),
              fontWeight: FontWeight.w400,
              fontSize: 14.0),
        ),
      ),
    );
  }

  String getMandateStatus(String mandateStatus) {
    if (mandateStatus == AchConst.nullMandateStatus) {
      return getString(lblCreateMandate);
    } else if (mandateStatus == AchConst.activeMandateStatus) {
      return getString(lblUpdateMandate);
    }
    return getString(lblCreateMandate);
  }

  SvgPicture getLoanImage(String productCategory) {
    if (productCategory == LoanType.personalLoan.value) {
      return SvgPicture.asset(ImageConstant.imgPersonalLoanRupeeLight);
    } else if (productCategory == LoanType.vehicleLoan.value) {
      return SvgPicture.asset(ImageConstant.imgVehicleLoanIconLight);
    }
    return SvgPicture.asset(ImageConstant.imgVehicleLoanIconLight);
  }

  buildEmptyWidget() {
    return Container(
        margin: EdgeInsets.only(bottom: 16.v, top: 10.v),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomImageView(
                    imagePath: ImageConstant.vector,
                    height: 50.adaptSize,
                    width: 50.adaptSize,
                    color: setColorBasedOnTheme(
                        context: context,
                        lightColor: AppColors.primaryLight,
                        darkColor: AppColors.backgroundDarkGradient6)),
                SizedBox(
                  width: 15.v,
                ),
                Text(getString(NOC010))
              ],
            )
          ],
        ));
  }
}
