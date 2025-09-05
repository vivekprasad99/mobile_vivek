import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/resources/custom_elevated_button.dart';
import 'package:core/config/resources/custom_image_view.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/config/widgets/mf_progress_bar.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:core/config/widgets/mf_toast.dart';
import 'package:core/services/di/injection_container.dart';
import 'package:core/utils/const.dart';
import 'package:core/utils/size_utils.dart';
import 'package:core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:noc/data/models/dl_noc_req.dart';
import 'package:noc/data/models/gc_validate_req.dart';
import 'package:noc/data/models/get_loan_list_resp.dart';
import 'package:noc/data/models/noc_details_req.dart';
import 'package:noc/presentation/cubit/noc_cubit.dart';
import 'package:product/data/models/product_feature_request.dart';
import 'package:product/data/models/product_feature_response.dart';
import 'package:product/presentation/widgets/product_offers_slider.dart';
import 'package:product_details/config/routes/route.dart';
import 'package:product_details/data/models/active_loan_detail_response.dart';
import 'package:product_details/data/models/active_loan_list_response.dart';
import 'package:product_details/presentation/cubit/product_details_cubit.dart';
import 'package:product_details/presentation/screens/activeloandetailscreen/widgets/convert_to_pdf.dart';
import 'package:product_details/presentation/screens/theme/custom_text_style.dart';
import 'package:product_details/presentation/screens/theme/theme_helper.dart';
import 'package:product_details/utils/constants.dart';
import 'package:product_details/utils/date_time_convert.dart';
import 'package:product_details/utils/enum_download_file_name.dart';
import 'package:core/config/resources/image_constant.dart';
import 'package:badges/badges.dart' as badges;
import 'package:noc/config/routes/route.dart' as noc_routes;
import 'package:intl/intl.dart';

// ignore_for_file: must_be_immutable
class LoanDetailsWidgetPage extends StatefulWidget {
  LoanDetailsWidgetPage(this.basicDetailsResponse, this.loanDetails,
      {super.key});

  BasicDetailsResponse? basicDetailsResponse;


  // RemindersDetails? remindersDetails;
  ActiveLoanData? loanDetails;

  @override
  ActiveVehicleLoanDetailsWidgetemiPageState createState() =>
      ActiveVehicleLoanDetailsWidgetemiPageState();
}

class ActiveVehicleLoanDetailsWidgetemiPageState
    extends State<LoanDetailsWidgetPage>
    with AutomaticKeepAliveClientMixin<LoanDetailsWidgetPage> {
  @override
  bool get wantKeepAlive => true;
  String activeStatus = 'active';

  @override
  void initState() {
    if (widget.loanDetails != null) {
      widget.loanDetails!.totalPayableAmount =
          widget.loanDetails!.installmentAmount;
    }

    if (widget.loanDetails!.loanStatus!.equalsIgnoreCase('active') &&
        widget.loanDetails != null) {
      BlocProvider.of<ProductDetailsCubit>(context).productFeature(
          productFeatureRequest: ProductFeatureRequest(ucic: getUCIC()));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final Brightness brightness = Theme
        .of(context)
        .brightness;
    return SingleChildScrollView(
      child: Column(children: [
        buildLoansDetail(brightness),
        const SizedBox(
          height: 12,
        ),
        (widget.loanDetails!.loanStatus!.equalsIgnoreCase(activeStatus) &&
            widget.loanDetails != null)
            ? BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
          buildWhen: (context, state) {
            return state is ProductDetailBannerSuccessState;
          },
          builder: (context, state) {
            List<ProductBanner> productBanners = [];
            if (state is ProductDetailBannerSuccessState) {
              productBanners = state.response.productBanner!;
            }
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ProductOffersSlider(
                productBanner: productBanners,
              ),
            );
          },
        )
            : const SizedBox.shrink()
      ]),
    );
  }

  buildLoansDetail(Brightness brightness) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildActive(context, brightness),
        SizedBox(height: 16.v),
        _buildPayNow(context, brightness),
        SizedBox(height: 16.v),
        _buildStartDate(context, brightness),
        SizedBox(height: 15.v),
        // _buildEightyNine(context, brightness),
        SizedBox(height: 18.v),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16.v),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(getString(overDueChargesProductDetail),
                          style: Theme
                              .of(context)
                              .textTheme
                              .bodyMedium),
                      Text(
                          PaymentConstants.rupeeSymbol +
                              widget.basicDetailsResponse!.chargesOverdue
                                  .toString(),
                          style: Theme
                              .of(context)
                              .textTheme
                              .labelMedium),
                    ],
                  ),
                  SizedBox(height: 17.v),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(getString(emiOverdueProductDetail),
                          style: Theme
                              .of(context)
                              .textTheme
                              .bodyMedium),
                      SizedBox(height: 1.v),
                      Text(
                          PaymentConstants.rupeeSymbol +
                              widget.basicDetailsResponse!.installmentOverdue
                                  .toString(),
                          style: Theme
                              .of(context)
                              .textTheme
                              .labelMedium),
                    ],
                  ),
                  SizedBox(height: 17.v),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${getString(emiAmountProductDetail)}      ",
                          style: Theme
                              .of(context)
                              .textTheme
                              .bodyMedium),
                      SizedBox(height: 2.v),
                      Text(
                          PaymentConstants.rupeeSymbol +
                              widget.basicDetailsResponse!.instalmentAmount
                                  .toString(),
                          style: Theme
                              .of(context)
                              .textTheme
                              .labelMedium),
                    ],
                  ),
                  SizedBox(height: 17.v),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 0.h),
                        child: Text(getString(repaymentModeProductDetail),
                            style: Theme
                                .of(context)
                                .textTheme
                                .bodyMedium),
                      ),
                      SizedBox(height: 1.v),
                      Padding(
                        padding: EdgeInsets.only(left: 0.h),
                        child: Text(
                            widget.basicDetailsResponse!.rePaymentMode
                                .toString(),
                            style: Theme
                                .of(context)
                                .textTheme
                                .labelMedium),
                      ),
                    ],
                  )
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(getString(amountOverDueProductDetail),
                          style: Theme
                              .of(context)
                              .textTheme
                              .bodyMedium),
                      SizedBox(height: 1.v),
                      Text(
                          PaymentConstants.rupeeSymbol +
                              widget.basicDetailsResponse!.totalAmountOverdue
                                  .toString(),
                          style: Theme
                              .of(context)
                              .textTheme
                              .labelMedium),
                    ],
                  ),
                  SizedBox(height: 17.v),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(getString(intrestRateProductDetail),
                          style: Theme
                              .of(context)
                              .textTheme
                              .bodyMedium),
                      SizedBox(height: 1.v),
                      Text("${widget.basicDetailsResponse!.interestRate}%",
                          style: Theme
                              .of(context)
                              .textTheme
                              .labelMedium),
                    ],
                  ),
                  SizedBox(height: 17.v),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(getString(frequencyProductDetail),
                          style: Theme
                              .of(context)
                              .textTheme
                              .bodyMedium),
                      SizedBox(height: 2.v),
                      Text(widget.basicDetailsResponse!.frequency.toString(),
                          style: Theme
                              .of(context)
                              .textTheme
                              .labelMedium),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  /// Section Widget
  Widget _buildActive(BuildContext context, Brightness brightness) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(
        horizontal: 16.h,
        vertical: 12.v,
      ),
      decoration: BoxDecoration(
        color: brightness == Brightness.light
            ? AppColors.backgroundLight5
            : AppColors.cardDark,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: setColorBasedOnTheme(
                  context: context,
                  lightColor: AppColors.backgroundDarkGradient4,
                  darkColor: AppColors.shadowDark,
                )),
            padding: const EdgeInsets.all(10),
            child: CustomImageView(
              imagePath: ImageConstant.imgCar,
              height: 30.adaptSize,
              width: 30.adaptSize,
              color: setColorBasedOnTheme(
                context: context,
                lightColor: AppColors.primaryLight,
                darkColor: AppColors.backgroundDarkGradient6,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                left: 8.h,
                top: 2.v,
                bottom: 1.v,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      ("${getString(registrationNoProductDetail)}: ${widget
                          .basicDetailsResponse!.vehicleRegistrationNumber}")
                          .toString(),
                      style: Theme
                          .of(context)
                          .textTheme
                          .bodySmall),
                  SizedBox(height: 7.v),
                  Row(
                    children: [
                      Text(
                          '${getString(lblLoanNoProductDetail)}: ${widget.basicDetailsResponse
                              ?.loanId}',
                          style: Theme
                              .of(context)
                              .textTheme
                              .bodyMedium),
                      const SizedBox(
                        width: 8,
                      ),
                      InkWell(
                          onTap: () {
                            copyToClipboard(context,
                                widget.basicDetailsResponse?.loanId ?? '');
                          },
                          child: Icon(
                            Icons.copy_rounded,
                            color: setColorBasedOnTheme(
                                context: context,
                                lightColor: AppColors.primaryLight,
                                darkColor: AppColors.white),
                            size: 20,
                          )),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 24.v,
            padding: EdgeInsets.only(left: 10.v, right: 10.v),
            decoration: BoxDecoration(
                color: setColorBasedOnTheme(
                  context: context,
                  lightColor: AppColors.backgroundDarkGradient4,
                  darkColor: AppColors.shadowDark,
                ),
                borderRadius: BorderRadius.circular(4.h)),
            alignment: Alignment.center,
            margin: EdgeInsets.only(bottom: 19.v),
            child: Text(
              widget.loanDetails!.loanStatus!.equalsIgnoreCase('Active')
                  ? getString(lblActiveProductDetail)
                  : getString(lblCompletedProductDetail),
              style: Theme
                  .of(context)
                  .textTheme
                  .bodySmall,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPayNow(BuildContext context, Brightness brightness) {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: 1.v,
                bottom: 5.v,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(getString(loanAmountProductDetail),
                      style: Theme
                          .of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(
                          color: setColorBasedOnTheme(
                            context: context,
                            lightColor: AppColors.primaryLight,
                            darkColor: AppColors.backgroundLight,
                          ))),
                  SizedBox(height: 5.v),
                  Text(
                      PaymentConstants.rupeeSymbol +
                          widget.basicDetailsResponse!.financedAmount
                              .toString(),
                      style: Theme
                          .of(context)
                          .textTheme
                          .bodyMedium),
                  SizedBox(height: 18.v),
                  Text(getString(totalOustAmountProductDetail),
                      style: Theme
                          .of(context)
                          .textTheme
                          .bodyMedium),
                  SizedBox(height: 4.v),
                  Text(
                      PaymentConstants.rupeeSymbol +
                          widget.basicDetailsResponse!.totalOutstandingAmount
                              .toString(),
                      style: Theme
                          .of(context)
                          .textTheme
                          .bodyMedium),
                  SizedBox(height: 18.v),
                  Text(
                    getString(noOfEmiPaidProductDetail),
                  ),
                  SizedBox(height: 4.v),
                  Text(
                      "${widget.basicDetailsResponse!
                          .numberOfPaidInstallments}/${widget
                          .basicDetailsResponse!.loanTenure}",
                      style: Theme
                          .of(context)
                          .textTheme
                          .bodyMedium),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: brightness == Brightness.light
                    ? widget.loanDetails!.loanStatus?.toLowerCase() ==
                    'active'
                    ? AppColors.primaryLight6
                    : Colors.white
                    : AppColors.shadowDark,
                borderRadius:BorderRadius.circular(
                  15.h,
                ),),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(
                      height: widget.loanDetails!.loanStatus?.toLowerCase() ==
                          'active'
                          ? 8.v
                          : 0.v),
                  InkWell(
                    onTap: () {
                      // TODO: implement later
                      // widget.remindersDetails!.reminder!.isEmpty
                      //     ? onTapBottomSheetSetReminder(
                      //         context,
                      //         OptionTenBottomsheet(
                      //             basicDetailsResponse:
                      //                 widget.basicDetailsResponse))
                      //     : onTapBottomSheetManageReminder(
                      //         context,
                      //         OpenManageReminderBottomsheet(
                      //             widget.remindersDetails));
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 0.v, vertical: 5.v),
                      child: widget.loanDetails!.loanStatus?.toLowerCase() ==
                          'active'
                          ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          badges.Badge(
                            position: badges.BadgePosition.custom(
                                isCenter: false,
                                bottom: 12.v,
                                start: 8.v),
                            badgeContent: Container(),
                            badgeStyle: const badges.BadgeStyle(
                                badgeColor: Colors.transparent),
                            child: CustomImageView(
                              imagePath:
                              ImageConstant.imgNotificationsActive,
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
                          Padding(
                            padding: EdgeInsets.only(
                              left: 8.h,
                              top: 3.v,
                              bottom: 5.v,
                            ),
                            child: Text(getString(lblSetReminderProductDetail),
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .bodySmall),
                          ),
                          CustomImageView(
                            imagePath:
                            ImageConstant.imgArrowRightPink900,
                            height: 24.adaptSize,
                            width: 24.adaptSize,
                            color: setColorBasedOnTheme(
                              context: context,
                              lightColor: AppColors.primaryLight,
                              darkColor: AppColors.backgroundLight,
                            ),
                            margin: EdgeInsets.only(left: 15.h),
                          )
                        ],
                      )
                          : Container(
                        color: Colors.green,
                      ),
                    ),
                  ),
                  SizedBox(height: 6.v),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.h,
                      vertical: widget.loanDetails!.loanStatus!.equalsIgnoreCase('active')
                          ? 9.v
                          : 18.v,
                    ),
                    decoration: BoxDecoration(
                      color: brightness == Brightness.light
                          ? AppColors.backgroundLight5
                          : AppColors.cardDark,
                      borderRadius:  BorderRadius.vertical(
                        bottom: Radius.circular(15.h),
                      )
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                            widget.loanDetails!.loanStatus?.toLowerCase() ==
                                'active'
                                ? getString(installmentAmountProductDetail)
                                : widget.loanDetails?.productCategory
                                ?.equalsIgnoreCase(
                                "personal loan") ==
                                true
                                ? getString(lblNocStatusProductDetail)
                                : getString(lblNocStatusProductDetail),
                            style: Theme
                                .of(context)
                                .textTheme
                                .bodySmall),
                        SizedBox(height: 5.v),
                        Text(
                            widget.loanDetails!.loanStatus?.toLowerCase() ==
                                'active'
                                ? PaymentConstants.rupeeSymbol +
                                widget.basicDetailsResponse!
                                    .totalAmountOverdue
                                    .toString()
                                : "Available",
                            style: Theme
                                .of(context)
                                .textTheme
                                .bodyLarge),
                        SizedBox(height: 9.v),
                        BlocProvider(
                          create: (context) => di<NocCubit>(),
                          child: BlocConsumer<NocCubit, NocState>(
                            listener: (context, state) {
                              if (state is DownloadNocLoading) {
                                showLoaderDialog(
                                    context, getString(lblLoadingProductDetail));
                              }
                              if (state is GreenChannelLoading) {
                                showLoaderDialog(
                                    context, getString(lblLoadingProductDetail));
                              }
                              if (state is DownloadNocSuccessState) {
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                                if (state.response.code ==
                                    AppConst.codeFailure) {
                                  toastForFailureMessage(
                                      context: context,
                                      msg: getString(msgSomethingWentWrongProductDetail));
                                }
                                if (state.response.code ==
                                    AppConst.codeSuccess) {
                                  final pdfConverter = ConvertToPdf();
                                  pdfConverter.downloadPdfFile(
                                      context,
                                      state.response.data.docContent,
                                      DownloadsName.noc);
                                }
                              }
                              if (state
                              is GreenChannelValidationSuccessState) {
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                                if (state.response.code ==
                                    AppConst.codeFailure) {
                                  toastForFailureMessage(
                                      context: context,
                                      msg: getString(msgSomethingWentWrongProductDetail));
                                }
                                if (state.response.data?.errorCodes == null ||
                                    state.response.data?.errorCodes
                                        ?.isEmpty ==
                                        true) {
                                  context.pushNamed(
                                    noc_routes.Routes.nocDetails.name,
                                    extra: NocDetailsReq(
                                        loanNumber:
                                        state.data.loanAccountNumber,
                                        ucic: state.data.ucic,
                                        productCategory:
                                        state.data.productCategory,
                                        productName: state.data.productName,
                                        endDate: state.data.endDate
                                            ?.toIso8601String(),
                                        mobileNumber: state.data.mobileNumber,
                                        lob: state.data.lob,
                                        sourceSystem: state.data.sourceSystem,
                                        nocStatus: state.data.nocStatus,
                                        containsRc: false),
                                  );
                                } else if (state.response.data?.errorCodes
                                    ?.map((e) => e.errorCode)
                                    .toList()
                                    .contains("2") ==
                                    true ||
                                    state.response.data?.errorCodes
                                        ?.map((e) => e.errorCode)
                                        .toList()
                                        .contains("8") ==
                                        true ||
                                    state.response.data?.errorCodes
                                        ?.map((e) => e.errorCode)
                                        .toList()
                                        .contains("9") ==
                                        true ||
                                    state.response.data?.errorCodes
                                        ?.map((e) => e.errorCode)
                                        .toList()
                                        .contains("10") ==
                                        true ||
                                    state.response.data?.errorCodes
                                        ?.map((e) => e.errorCode)
                                        .toList()
                                        .contains("11") ==
                                        true ||
                                    state.response.data?.errorCodes
                                        ?.map((e) => e.errorCode)
                                        .toList()
                                        .contains("12") ==
                                        true ||
                                    state.response.data?.errorCodes
                                        ?.map((e) => e.errorCode)
                                        .toList()
                                        .contains("18") ==
                                        true ||
                                    state.response.data?.errorCodes?.map((
                                        e) => e.errorCode).toList().contains(
                                        "13") == true ||
                                    state.response.data?.errorCodes?.map((
                                        e) => e.errorCode).toList().contains(
                                        "14") == true ||
                                    state.response.data?.errorCodes?.map((
                                        e) => e.errorCode).toList().contains(
                                        "16") == true ||
                                    state.response.data?.errorCodes?.map((
                                        e) => e.errorCode).toList().contains(
                                        "17") == true) {
                                  context.pushNamed(
                                    noc_routes.Routes.visitBranch.name,
                                  );
                                } else {
                                  context.pushNamed(
                                    noc_routes.Routes.nocDetails.name,
                                    extra: NocDetailsReq(
                                        loanNumber:
                                        state.data.loanAccountNumber,
                                        ucic: state.data.ucic,
                                        productCategory:
                                        state.data.productCategory,
                                        productName: state.data.productName,
                                        endDate: state.data.endDate
                                            ?.toIso8601String(),
                                        mobileNumber: state.data.mobileNumber,
                                        lob: state.data.lob,
                                        sourceSystem: state.data.sourceSystem,
                                        nocStatus: state.data.nocStatus,
                                        containsRc: state
                                            .response.data?.errorCodes
                                            ?.map((e) => e.errorCode)
                                            .toList()
                                            .contains("7") ==
                                            true),
                                  );
                                }
                              }
                            },
                            builder: (context, state) {
                              return CustomElevatedButton(
                                width: 136.h,
                                text: widget.loanDetails!.loanStatus
                                    ?.toLowerCase() ==
                                    'active'
                                    ? getString(lblPayNowProductDetail)
                                    : widget.loanDetails?.productCategory
                                    ?.equalsIgnoreCase(
                                    "personal loan") ==
                                    true
                                    ? getString(lblDownloadNocProductDetail)
                                    : getString(viewNocProductDetail),
                                buttonStyle: ElevatedButton.styleFrom(
                                  backgroundColor:
                                  Theme
                                      .of(context)
                                      .highlightColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.h),
                                  ),
                                ),
                                onPressed: () {
                                  if (widget.loanDetails!.loanStatus
                                      ?.toLowerCase() ==
                                      'active') {
                                    widget.loanDetails!.totalPayableAmount =
                                        widget.loanDetails!.totalAmount;
                                    context.pushNamed(
                                        Routes
                                            .productsPaymentsDetailPage.name,
                                        extra: widget.loanDetails!);
                                  } else {
                                    if (widget.loanDetails?.productCategory
                                        ?.equalsIgnoreCase(
                                        "personal loan") ==
                                        true) {
                                      context.read<NocCubit>().downloadNoc(
                                          DlNocReq(
                                              finReference: widget.loanDetails
                                                  ?.loanNumber ??
                                                  ""));
                                    } else if (widget
                                        .loanDetails?.productCategory
                                        ?.equalsIgnoreCase(
                                        "vehicle loan") ==
                                        true) {
                                      context
                                          .read<NocCubit>()
                                          .greenChannelValidationtails(
                                          GcValidateReq(
                                              loanAccountNumber: widget
                                                  .loanDetails
                                                  ?.loanNumber),
                                          LoanData.fromJson(widget
                                              .loanDetails!
                                              .toJson()));
                                    } else {
                                      context.pushNamed(
                                          Routes.productsPaymentsDetailPage
                                              .name,
                                          extra: widget.loanDetails);
                                    }
                                  }
                                },
                                buttonTextStyle:
                                CustomTextStyles.titleSmallWhiteA700,
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 2.v),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildStartDate(BuildContext context, Brightness brightness) {
    String dueDate = '';

    if ((widget.loanDetails!.totalAmountOverdue ?? 0) > 0) {
      dueDate = ConvertDateTime.convert(
          DateFormat('yyyy-MM-dd').format(DateTime.now()));
    } else {
      dueDate = ConvertDateTime.convert(widget.loanDetails!.nextDuedate ?? '');
    }
    return Align(
      alignment: Alignment.center,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 14.h),
        width: MediaQuery
            .of(context)
            .size
            .width,
        padding: EdgeInsets.all(12.h),
        decoration: BoxDecoration(
          color: brightness == Brightness.light
              ? AppColors.primaryLight6
              : AppColors.shadowDark,
          borderRadius: BorderRadius.circular(9),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 2.v),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(getString(startDateProductDetail),
                        style: Theme
                            .of(context)
                            .textTheme
                            .bodySmall),
                  ),
                  SizedBox(height: 5.v),
                  Text(
                      ConvertDateTime.convert(
                          widget.basicDetailsResponse!.endDate.toString()),
                      style: Theme
                          .of(context)
                          .textTheme
                          .bodySmall),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 24.h),
              child: SizedBox(
                height: 41.v,
                child: VerticalDivider(
                  width: 1.h,
                  thickness: 1.v,
                  color: appTheme.gray400,
                  indent: 4.h,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 24.h,
                bottom: 2.v,
              ),
              child: Column(
                children: [
                  Text(getString(endDateProductDetail),
                      style: Theme
                          .of(context)
                          .textTheme
                          .bodySmall),
                  SizedBox(height: 5.v),
                  Text(
                      ConvertDateTime.convert(
                          widget.basicDetailsResponse!.startDate.toString()),
                      style: Theme
                          .of(context)
                          .textTheme
                          .bodySmall),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 25.h),
              child: SizedBox(
                height: 41.v,
                child: VerticalDivider(
                  width: 1.h,
                  thickness: 1.v,
                  color: appTheme.gray400,
                  indent: 4.h,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 17.h,
                right: 6.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(  getString(nextDueDateProductDetail),
                      style: Theme
                          .of(context)
                          .textTheme
                          .bodySmall),
                  SizedBox(height: 7.v),
                  Padding(
                    padding: EdgeInsets.only(left: 5.h),
                    child: Text(widget.loanDetails!.loanStatus?.toLowerCase() ==
                        'active'?dueDate:"-",
                        style: Theme
                            .of(context)
                            .textTheme
                            .bodySmall),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onTapBottomSheetSetReminder(BuildContext context,
      Widget className,) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      clipBehavior: Clip.antiAlias,
      isScrollControlled: true,
      builder: (context) {
        return className;
      },
    );
  }

  void onTapBottomSheetManageReminder(BuildContext context,
      Widget className,) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      clipBehavior: Clip.antiAlias,
      isScrollControlled: true,
      builder: (context) {
        return className;
      },
    );
  }
}

void copyToClipboard(BuildContext context, String text) {
  String updatedText = text;
  Clipboard.setData(ClipboardData(text: updatedText));
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(getString(lblcopyMSGProductDetail)),
    ),
  );
}
