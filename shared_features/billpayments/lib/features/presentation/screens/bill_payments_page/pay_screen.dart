import 'package:core/config/resources/custom_image_view.dart';
import 'package:core/config/widgets/mf_custom_elevated_button.dart';
import 'package:core/config/widgets/mf_toast.dart';
import 'package:core/utils/const.dart';
import 'package:payment_gateway/features/data/models/webview_data_model.dart';
import 'package:billpayments/features/presentation/cubit/bill_payments_cubit.dart';
import 'package:billpayments/features/presentation/screens/bill_payments_page/widget/bill_and_recharges_card.dart';
import 'package:billpayments/features/presentation/screens/bill_payments_page/widget/upcoming_payments.dart';
import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/resources/image_constant.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:core/utils/size_utils.dart';
import 'package:core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:go_router/go_router.dart';
import 'package:payment_gateway/config/routes/route.dart' as payment_routes;
import 'package:product_details/data/models/active_loan_list_request.dart';
import 'package:product_details/data/models/active_loan_list_response.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';

class PayScreen extends StatefulWidget {
  const PayScreen({super.key});

  @override
  State<PayScreen> createState() => _PayScreenState();
}

class _PayScreenState extends State<PayScreen> {
  @override
  void initState() {
    if (isCustomer()) {
      BlocProvider.of<BillPaymentsCubit>(context)
          .getActiveLoansList(ActiveLoanListRequest(ucic: getUCIC()));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Brightness brightness = Theme.of(context).brightness;
    return BlocConsumer<BillPaymentsCubit, BillPaymentsState>(
      listener: (context, state) {
        if (state is GetBbpsUrlSuccessState) {
          if (state.response.status == AppConst.codeSuccess) {
            WebViewDataModel webViewDataModel = WebViewDataModel(
                url: state.response.linkToRedirect,
                onOverrideUrlLoading:
                    (inAppWebViewController, navigationAction) async {
                  onUpiPaymentTap(inAppWebViewController, navigationAction);
                },
                onUpdateVisitedHistory: (inAppWebViewController, weburl, isReload) {
                  onPaymentSuccess(inAppWebViewController, weburl, isReload, context);
                });
            context.push(payment_routes.Routes.paymentWebview.path,
                extra: webViewDataModel);
          }else {
            toastForFailureMessage(
                context: context,
                msg: getString(
                    state.response.responseCode ?? msgSomethingWentWrong));
          }
        } else if (state is GetBbpsUrlFailureState) {
          showSnackBar(
              context: context, message: getFailureMessage(state.failure));
        }
      },
      builder: (context, state) {
        if (state is LoadingState && state.isloading) {
          return Align(
            alignment: Alignment.bottomCenter,
            child: Center(
                child: CircularProgressIndicator(
              color: Theme.of(context).indicatorColor,
              strokeWidth: 2,
            )),
          );
        }
        return _buildBody(context, brightness);
      },
    );
  }

  Widget _buildBody(BuildContext context, Brightness brightness) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.v),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isCustomer())
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(getString(lblUpcomingPayments),
                        style: Theme.of(context).textTheme.titleMedium),
                    SizedBox(height: 20.h),
                    _buildUpcomingPaymentsCards(),
                    //TODO - FSD peding uncomment when need to develop this feature.
                    // SizedBox(
                    //   height: 24.h,
                    // ),
                    // _buildPaymentsNotification(context, brightness),
                    // SizedBox(height: 20.h),
                    // Text(getString(lblAutoPay),
                    //     style: Theme.of(context).textTheme.titleMedium),
                    // SizedBox(height: 4.h),
                    // Text(getString(msgMandateSet),
                    //     style: Theme.of(context).textTheme.labelSmall),
                    // SizedBox(height: 12.h),
                    // _buildAutoPay(context, brightness),
                    // SizedBox(height: 12.h),
                  ],
                ),
              ),
            ),
          const BillAndRechargesCard(),
          if (!isCustomer()) ...[
            SizedBox(
              height: 40.v,
            ),
            MfCustomButton(
              onPressed: () {},
              text: getString(lblExploreButton),
              width: MediaQuery.of(context).size.width,
              outlineBorderButton: false,
            ),
          ]
        ],
      ),
    );
  }

  Widget _buildUpcomingPaymentsCards() {
    return BlocBuilder<BillPaymentsCubit, BillPaymentsState>(
      buildWhen: (previous, current) =>
          current is GetActiveLoansListSuccessState,
      builder: (context, state) {
        if (state is GetActiveLoansListSuccessState) {
          List<ActiveLoanData> data = state.response.loanList ?? [];
          return data.isNotEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return UpcomingPaymentsCards(
                          data: data[index],
                          totalPaybleAmount: context
                              .read<BillPaymentsCubit>()
                              .upcomingPaymentViewModel
                              .getTotalPayableAmount(data[index]),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return Opacity(
                          opacity: 0.5,
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 7.0.v),
                          ),
                        );
                      },
                    ),
                  ],
                )
              : Container(
                  margin: EdgeInsets.only(bottom: 16.v, top: 10.v),
                  child: Row(
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
                      Text(getString(lblYouHaveNoDue))
                    ],
                  ));
        }
        return Center(
          child: Container(
              margin: EdgeInsets.only(bottom: 16.v, top: 10.v),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.error_outline,
                      size: 50.adaptSize,
                      color: setColorBasedOnTheme(
                          context: context,
                          lightColor: AppColors.primaryLight,
                          darkColor: AppColors.backgroundDarkGradient6)),
                  SizedBox(
                    width: 15.v,
                  ),
                  Flexible(
                      child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          getString(msgWeAreFacingSomeIssues),
                        )),
                  ))
                ],
              )),
        );
      },
    );
  }


  Future<NavigationActionPolicy> onUpiPaymentTap(
      InAppWebViewController inAppWebViewController,
      NavigationAction navigationAction) async {
    final uri = navigationAction.request.url!;
    if (["phonepe", "upi", "gpay"].contains(uri.scheme) ||
        uri.toString().contains("upi")) {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
        return NavigationActionPolicy.CANCEL;
      }
    }
    return NavigationActionPolicy.ALLOW;
  }

  void onPaymentSuccess(InAppWebViewController inAppWebViewController,
      WebUri? weburl, bool? isReload, BuildContext context) {
    if (weburl.toString().contains("success")) {
      Future.delayed(const Duration(seconds: 10), () {
        context.pop();
      });
    }
  }
}
