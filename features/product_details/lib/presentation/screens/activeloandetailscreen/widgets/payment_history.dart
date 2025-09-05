import 'package:ach/config/ach_util.dart';
import 'package:ach/data/models/fetch_applicant_name_req.dart';
import 'package:ach/presentation/cubit/ach_cubit.dart';
import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:core/utils/const.dart';
import 'package:core/utils/size_utils.dart';
import 'package:core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_details/data/models/active_loan_list_response.dart';
import 'package:product_details/data/models/payment_request.dart';
import 'package:product_details/data/models/payment_response.dart';
import 'package:product_details/presentation/cubit/product_details_cubit.dart';
import 'package:product_details/presentation/screens/widget/custom_image_view.dart';
import 'package:product_details/utils/constants.dart';
import 'package:product_details/utils/date_time_convert.dart';
import 'package:product_details/utils/enmum_active_loan.dart';
import 'package:core/config/resources/image_constant.dart';
import 'package:ach/config/routes/route.dart' as ach_mandate;
import 'package:go_router/go_router.dart';
import 'package:product_details/utils/utils.dart';
import 'package:product_details/presentation/cubit/product_details_cubit.dart'
    as product_detail;

import '../../../cubit/product_details_cubit.dart';

// ignore_for_file: must_be_immutable
class PaymentHistoryWidgetPage extends StatefulWidget {
  PaymentHistoryWidgetPage({super.key, required this.loanDetails});

  ActiveLoanData? loanDetails;

  @override
  ActiveVehicleLoanDetailsWidgetemiPageState createState() =>
      ActiveVehicleLoanDetailsWidgetemiPageState();
}

class ActiveVehicleLoanDetailsWidgetemiPageState
    extends State<PaymentHistoryWidgetPage>
    with AutomaticKeepAliveClientMixin<PaymentHistoryWidgetPage> {
  int length = 1;

  @override
  void initState() {
    BlocProvider.of<ProductDetailsCubit>(context).getPaymentHistory(
        PaymentRequest(
            loanNumber: widget.loanDetails!.loanNumber,
            sourceSystem: widget.loanDetails!.sourceSystem));
    super.initState();
  }

  int buildLength(List<PaymentHistory> paymentData) {
    int length = 0;
    if (paymentData.length > PaymentConstants.length) {
      length = 3;
    } else {
      length = paymentData.length;
    }
    return length;
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final Brightness brightness = Theme.of(context).brightness;
    return BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
      buildWhen: (context, state) {
        return state is GetPaymentHistorySuccessState;
      },
      builder: (context, state) {
        if (state is product_detail.LoadingState && state.isloading) {
          return   Align(
            alignment: Alignment.bottomCenter,
            child: Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).highlightColor,
              ),
            ),
          );
        }
        if(state is GetPaymentHistoryFailureState){
        return  Center(child: Text(getString(lblErrorGeneric)));
        }
        if (state is GetPaymentHistorySuccessState) {
          return state.response.paymentHistory!.isNotEmpty? Column(
            children: [
              _buildLastTransactions(
                  context, brightness, state.response.paymentHistory!),
              isActiveMandate(widget.loanDetails!.mandateStatus.toString())
                  ? Container()
                  : Visibility(visible: !widget.loanDetails!.loanStatus.toString().equalsIgnoreCase("Closed") ,child: _buildSetMandateForPaymentHistory(context)),
            ],
          ):buildEmptyWidget(state.response);


        }
        return Center(child: Text(getString(lblErrorGeneric)));
      },
    );
  }

  Widget _buildLastTransactions(BuildContext context, Brightness brightness,
      List<PaymentHistory> paymentData) {
    buildLength(paymentData);
    return  Align(
      alignment: Alignment.center,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.h),
        padding: EdgeInsets.all(12.h),
        decoration: BoxDecoration(
          color: brightness == Brightness.light
              ? AppColors.backgroundLight5
              : AppColors.cardDark,
          borderRadius: BorderRadius.circular(9),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(getString(lastTenTransactionProductDetail),
                  style: Theme.of(context).textTheme.labelMedium),
            ),
            SizedBox(height: 18.v),
            Padding(
              padding: EdgeInsets.only(right: 2.h),
              child: ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                separatorBuilder: (
                  context,
                  index,
                ) {
                  return SizedBox(
                    height: 16.v,
                  );
                },
                itemCount: buildLength(paymentData),
                itemBuilder: (context, index) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomImageView(
                        imagePath: ImageConstant.imgArrowOutward,
                        height: 16.adaptSize,
                        width: 16.adaptSize,
                        color: setColorBasedOnTheme(
                          context: context,
                          lightColor: AppColors.secondaryLight,
                          darkColor: AppColors.backgroundLight,
                        ),
                        margin: EdgeInsets.only(
                          top: 2.v,
                          bottom: 15.v,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 13.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(getString(lblRepaymentProductDetail),
                                style: Theme.of(context).textTheme.bodyMedium),
                            SizedBox(height: 4.v),
                            Text(
                                ConvertDateTime.convertDateTime(
                                    paymentData[index].date.toString()),
                                style: Theme.of(context).textTheme.labelMedium),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: EdgeInsets.only(
                          top: 6.v,
                          bottom: 12.v,
                        ),
                        child: Text(
                            PaymentConstants.rupeeSymbol +
                                paymentData[index].instalmentAmount.toString(),
                            style: Theme.of(context).textTheme.bodySmall),
                      ),
                    ],
                  );
                },
              ),
            ),
            SizedBox(height: 7.v),
            BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
              builder: (context, state) {
                if (state is UpdateSeeMoreState) {
                  return paymentData.length > state.length!
                      ? InkWell(
                          onTap: () {
                            context
                                .read<product_detail.ProductDetailsCubit>()
                                .updateSeeMore(paymentData.length);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                  top: 2.v,
                                  bottom: 2.v,
                                ),
                                child: Text(
                                  getString(seeMoreProductDetail),
                                  style: TextStyle(
                                      color: setColorBasedOnTheme(
                                    context: context,
                                    lightColor: AppColors.secondaryLight,
                                    darkColor: AppColors.secondaryLight5,
                                  )),
                                ),
                              ),
                              CustomImageView(
                                imagePath: ImageConstant.imgCheckmark,
                                height: 24.adaptSize,
                                width: 24.adaptSize,
                                margin: EdgeInsets.only(left: 1.h),
                                color: setColorBasedOnTheme(
                                  context: context,
                                  lightColor: AppColors.secondaryLight,
                                  darkColor: AppColors.secondaryLight5,
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container();
                }
                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSetMandateForPaymentHistory(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10.h, vertical: 16.h),
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(12.h),
        decoration: BoxDecoration(
          color: setColorBasedOnTheme(
              context: context,
              lightColor: AppColors.primaryLight6,
              darkColor: AppColors.shadowDark),
          borderRadius: BorderRadius.circular(9),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 2.v),
              child: CustomImageView(
                imagePath: ImageConstant.imgNotificationsActive,
                height: 25.v,
                color: setColorBasedOnTheme(
                  context: context,
                  lightColor: AppColors.primaryLight,
                  darkColor: AppColors.backgroundLight,
                ),
                margin: EdgeInsets.only(
                  top: 3.v,
                  bottom: 5.v,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 16.h, right: 10.h),
                child: Text(getString(msgNeverPayLateEmi),
                    style: Theme.of(context).textTheme.bodyMedium),
              ),
            ),
            InkWell(
              onTap: () {
                if (!isMandateDisable(
                    widget.loanDetails?.mandateStatus ?? "", widget.loanDetails?.sourceSystem ?? "")) {
                  var loanData = mappingLoanData(widget.loanDetails ?? ActiveLoanData());
                  if (widget.loanDetails!.mandateStatus == ActiveLoanStatus.active.name) {
                    context.pushNamed(ach_mandate.Routes.mandateDetailsScreen.name, extra: {"loanData": loanData});
                  } else {
                    BlocProvider.of<AchCubit>(context).fetchApplicantName(
                        FetchApplicantNameReq(
                            loanNumber: loanData.loanAccountNumber ?? "",
                            ucic: loanData.ucic ?? "",
                            cif: loanData.cif ?? "",
                            sourceSystem: loanData.sourceSystem ?? "",
                            superAppId: getSuperAppId(),
                            source: AppConst.source),
                        loanData);
                  }
                }
              },
              child: Opacity(opacity: isMandateDisable(widget.loanDetails?.mandateStatus ?? "", widget.loanDetails?.sourceSystem ?? "") ? 0.4 : 1.0, child: Padding(
                padding: EdgeInsets.only(right: 5.h),
                child: Text(
                    isActiveMandate(
                        widget.loanDetails!.mandateStatus.toString())
                        ? getString(lblUpdateMandate)
                        : getString(lblSetMandate),
                    style: Theme.of(context).textTheme.labelMedium!.copyWith(
                        color: setColorBasedOnTheme(
                          context: context,
                          lightColor: AppColors.secondaryLight,
                          darkColor: AppColors.secondaryLight5,
                        ))),
              )),
            )
          ],
        ),
      ),
    );
  }

  buildEmptyWidget(PaymentResponse response) {
    return  Container(
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
            ),
            isActiveMandate(
                widget.loanDetails!.mandateStatus.toString())
                ? Container()
                : Visibility(visible: !widget.loanDetails!.loanStatus.toString().equalsIgnoreCase("Closed") ,child: _buildSetMandateForPaymentHistory(context))
          ],
        ));
  }
}
