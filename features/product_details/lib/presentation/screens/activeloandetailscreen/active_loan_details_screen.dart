import 'package:ach/config/ach_util.dart';
import 'package:ach/config/source.dart';
import 'package:ach/data/models/fetch_applicant_name_req.dart';
import 'package:ach/data/models/fetch_bank_account_req.dart';
import 'package:ach/data/models/update_mandate_info.dart';
import 'package:ach/presentation/cubit/ach_cubit.dart';
import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/resources/image_constant.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/config/widgets/background/mf_gradient_background.dart';
import 'package:core/config/widgets/mf_progress_bar.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:core/config/widgets/mf_toast.dart';
import 'package:core/utils/const.dart';
import 'package:core/utils/size_utils.dart';
import 'package:core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:product_details/data/models/active_loan_detail_request.dart';
import 'package:product_details/data/models/active_loan_detail_response.dart';
import 'package:product_details/data/models/active_loan_list_response.dart';
import 'package:product_details/data/models/doucments_request.dart';
import 'package:product_details/presentation/cubit/product_details_cubit.dart'
    as product_detail;
import 'package:product_details/presentation/screens/activeloandetailscreen/widgets/assets_details.dart';
import 'package:product_details/presentation/screens/activeloandetailscreen/widgets/bank_details.dart';
import 'package:product_details/presentation/screens/activeloandetailscreen/widgets/basic_details.dart';
import 'package:product_details/presentation/screens/activeloandetailscreen/widgets/charges.dart';
import 'package:product_details/presentation/screens/activeloandetailscreen/widgets/documents.dart';
import 'package:product_details/presentation/screens/activeloandetailscreen/widgets/insurance.dart';
import 'package:product_details/presentation/screens/activeloandetailscreen/widgets/loan_details.dart';
import 'package:product_details/presentation/screens/activeloandetailscreen/widgets/payment_history.dart';
import 'package:product_details/presentation/screens/widget/app_bar/appbar_leading_image.dart';
import 'package:product_details/presentation/screens/widget/app_bar/appbar_title.dart';
import 'package:product_details/presentation/screens/widget/custom_image_view.dart';
import 'package:ach/config/routes/route.dart' as ach_mandate;
import 'package:product_details/utils/services.dart';

import '../../../config/routes/route.dart';
import '../../../utils/enmum_active_loan.dart';
import '../../../utils/utils.dart';
import '../../cubit/product_details_cubit.dart';
import 'package:help/features/utils/help_common_widget.dart';
import 'package:help/features/utils/constant_help.dart';



class ActiveLoanDetailsTabContainerScreen extends StatefulWidget {
  const ActiveLoanDetailsTabContainerScreen({
    super.key,
    this.loanDetails,
  });

  final ActiveLoanData? loanDetails;

  @override
  ActiveLoanDetailsTabContainerScreenState createState() =>
      ActiveLoanDetailsTabContainerScreenState();
}

class ActiveLoanDetailsTabContainerScreenState
    extends State<ActiveLoanDetailsTabContainerScreen>
    with TickerProviderStateMixin {
  List<GlobalKey> jewelleryCategories = [
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
  ];

  late ScrollController scrollController;
  BuildContext? tabContext;
  late TabController tabviewController;
  bool showBackToTopButton = false;

  @override
  void initState() {
    BlocProvider.of<product_detail.ProductDetailsCubit>(context)
        .getActiveLoansDetails(ActiveLoanDetailRequest(
            ucic: widget.loanDetails!.ucic,
            loanNumber: widget.loanDetails!.loanNumber,
            cifId: widget.loanDetails!.cif,
            sourceSystem: widget.loanDetails!.sourceSystem));

    scrollController = ScrollController();
    scrollController.addListener(animateToTab);
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        bool isBottom = scrollController.position.pixels != 0;
        context
            .read<product_detail.ProductDetailsCubit>()
            .updateBottomToTop(isBottom);
      }
    });
    super.initState();
  }

  void scrollToTop() {
    scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void animateToTab() {
    late RenderBox box;
    if (jewelleryCategories.isNotEmpty) {
      for (var i = 0; i < jewelleryCategories.length; i++) {
        box = jewelleryCategories[i].currentContext!.findRenderObject()
            as RenderBox;
        Offset position = box.localToGlobal(Offset.zero);
        if (scrollController.offset >= position.dy) {
          DefaultTabController.of(jewelleryCategories[i].currentContext!)
              .animateTo(
            i,
            duration: const Duration(milliseconds: 100),
          );
        }
      }
    }
  }

  void scrollToIndex(int index) async {
    scrollController.removeListener(animateToTab);
    await Scrollable.ensureVisible(
      jewelleryCategories[index].currentContext!,
      duration: const Duration(milliseconds: 100),
    );
    scrollController.addListener(animateToTab);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocListener(
          listeners: [
            BlocListener<AchCubit, AchState>(listener: (context, state) {
              if (state is FetchBankAccountSuccessState) {
                if (state.response.code == AppConst.codeSuccess) {
                  if (state.response.data != null &&
                      state.response.data!.isNotEmpty) {
                    context.pushNamed(ach_mandate.Routes.addedBanksScreen.name,
                        extra: {
                          "loanData": state.loanItem,
                          "bankData": state.response.data,
                          "updateMandateInfo": UpdateMandateInfo()
                        });
                  } else {
                    context.pushNamed(ach_mandate.Routes.selectBankScreen.name,
                        extra: {
                          "loanData": state.loanItem,
                          "selectedApplicant": "",
                          "updateMandateInfo": UpdateMandateInfo(),
                          "source": Source()
                        });
                  }
                } else {
                  toastForFailureMessage(
                      context: context, msg: getString(msgSomethingWentWrongProductDetail));
                }
              } else if (state is FetchBankAccountFailureState) {
                toastForFailureMessage(
                    context: context, msg: getString(msgSomethingWentWrongProductDetail));
              } else if (state is FetchApplicantNameSuccessState) {
                if (state.response.code == AppConst.codeSuccess) {
                  var loanData = state.loanData;
                  loanData?.applicantName =
                      state.response.data?.applicantName ?? "";
                  loanData?.coApplicantName =
                      state.response.data?.coApplicantName ?? "";
                  BlocProvider.of<AchCubit>(context).fetchBankAccount(
                      FetchBankAccountRequest(
                          loanAccountNumber: loanData?.loanAccountNumber ?? "",
                          ucic: loanData?.ucic ?? "",
                          cif: loanData?.cif ?? "",
                          superAppId: getSuperAppId(),
                          source: AppConst.source),
                      loanData);
                } else {
                  toastForFailureMessage(
                      context: context, msg: getString(msgSomethingWentWrongProductDetail));
                }
              } else if (state is FetchApplicantNameFailureState) {
                toastForFailureMessage(
                    context: context, msg: getString(msgSomethingWentWrongProductDetail));
              } else if (state is LoadingDialogState) {
                if (state.isloading) {
                  showLoaderDialog(context, getString(lblLoadingProductDetail));
                } else {
                  Navigator.of(context, rootNavigator: true).pop();
                }
              }
            })
          ],
          child: BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
            buildWhen: (context, state) {
              if(state is GetActiveLoansDetailsSuccessState || state is GetActiveLoansDetailsFailureState){
                return true;
              }else{
                return false;
              }
            },
            builder: (context, state) {
              if (state is product_detail.LoadingState && state.isloading) {
                return  Align(
                        alignment: Alignment.bottomCenter,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Theme.of(context).highlightColor,
                          ),
                        ),
                      );
              }
              if (state is GetActiveLoansDetailsSuccessState) {
                return (state.response.basicChargeDetails != null)
                    ? DefaultTabController(
                  length: getLength(state.response),
                  child: Builder(
                    builder: (BuildContext context) {
                      return Scaffold(
                        appBar: _buildAppBar(state.response),
                        body: MFGradientBackground(
                          verticalPadding: 0,
                          horizontalPadding: 0,
                          child: SingleChildScrollView(
                            controller: scrollController,
                            child: Column(
                              children: [
                                _buildCategoryTitle("", 0),
                                LoanDetailsWidgetPage(
                                    state.response.basicDetailsResponse!,
                                    widget.loanDetails),
                                SizedBox(height: 16.v),
                                _buildCategoryTitle(
                                    getString(paymentHistoryProductDetail), 1),
                                SizedBox(height: 16.v),
                                // buildPaymentHistoryWidgets(),
                                PaymentHistoryWidgetPage(
                                    loanDetails: widget.loanDetails),
                                SizedBox(height: 0.v),
                                _buildCategoryTitle(
                                    getString(documentsProductDetail), 2),
                                SizedBox(height: 16.v),
                                DocumentsWidgetPage(
                                  loanDetails: widget.loanDetails,
                                  basicDetails: state.response,
                                ),
                                SizedBox(height: 16.v),
                                buildCharges(
                                    state.response.basicChargeDetails!),
                                _buildDvider(),
                                SizedBox(height: 16.v),
                                buildBasicDetail(
                                    state.response.basicCustomerDetails!),
                                _buildDvider(),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: _buildCategoryTitle(
                                          getString(bankDetailsProductDetail), 5),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 16.v),
                                state.response.isBasicBankDetailsEmpty()
                                    ? Visibility(
                                    visible: !widget
                                        .loanDetails!.loanStatus
                                        .toString()
                                        .equalsIgnoreCase("Closed"),
                                    child: _buildSetMandateForPayment(
                                        context))
                                    : BankDetailsWidgetPage(
                                    state.response.bankDetails!),
                                state.response.basicAssetDetails != null
                                    ? _buildDvider()
                                    : Container(),
                                state.response.basicAssetDetails != null
                                    ? _buildCategoryTitle(
                                    getString(assetsDetailsProductDetail), 6)
                                    : Container(),
                                SizedBox(height: 16.v),
                                state.response.basicAssetDetails != null
                                    ? state.response.basicAssetDetails!
                                    .isEmpty()
                                    ? _buildEmptyAssetsDetails(
                                    context)
                                    : AssetsDetailsWidgetPage(state
                                    .response.basicAssetDetails!)
                                    : Container(),
                                _buildDvider(),
                                _buildCategoryTitle(
                                    getString(insuranceDetailsProductDetail),
                                    state.response.basicAssetDetails !=
                                        null
                                        ? 7
                                        : 6),
                                SizedBox(height: 16.v),
                                state.response.insuranceDetails!.isEmpty()
                                    ? _buildInsuranceExplore(context)
                                    : InsuranceDetailsWidgetPage(
                                    state.response.insuranceDetails!),
                                const SizedBox(
                                  height: 15,
                                ),
                                BlocBuilder<ProductDetailsCubit,
                                    ProductDetailsState>(
                                  builder: (context, state) {
                                    if (state is BottomToTopState) {
                                      return InkWell(
                                        onTap: scrollToTop,
                                        child: Row(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            Text(getString(lblBackOnTopProductDetail),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.copyWith(
                                                    color: Theme.of(
                                                        context)
                                                        .highlightColor)),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            const Icon(
                                                Icons.arrow_upward),
                                          ],
                                        ),
                                      );
                                    }
                                    return Container();
                                  },
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )
                    : Center(
                    child: AlertDialog(
                      title: Text(
                        getString(lblErrorGenericProductDetail),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(getString(labelOkayProductDetail),
                              style: Theme.of(context).textTheme.bodyMedium),
                        ),
                      ],
                    ));
              }
              if (state is product_detail.GetActiveLoansDetailsFailureState) {
                return Center(
                    child: AlertDialog(
                      title: Text(
                        getString(lblErrorGenericProductDetail),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(getString(labelOkayProductDetail),
                              style: Theme.of(context).textTheme.bodyMedium),
                        ),
                      ],
                    ));
              }
              return Center(child: Text(getString(lblErrorGenericProductDetail)));
            },
          )),
    );
  }

  Widget _buildSetMandateForPayment(BuildContext context) {
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
                child: Text(getString(msgNeverPayLateEmiProductDetail),
                    style: Theme.of(context).textTheme.bodyMedium),
              ),
            ),
            InkWell(
              onTap: () {
                if (!isMandateDisable(widget.loanDetails?.mandateStatus ?? "",
                    widget.loanDetails?.sourceSystem ?? "")) {
                  var loanData =
                      mappingLoanData(widget.loanDetails ?? ActiveLoanData());
                  if (isActiveMandate(
                      widget.loanDetails!.mandateStatus ?? "")) {
                    context.pushNamed(
                        ach_mandate.Routes.mandateDetailsScreen.name,
                        extra: {"loanData": loanData});
                  } else if (isSetMandate(
                      widget.loanDetails!.mandateStatus ?? "")) {
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
              child: Opacity(
                  opacity: isMandateDisable(
                          widget.loanDetails?.mandateStatus ?? "",
                          widget.loanDetails?.sourceSystem ?? "")
                      ? 0.4
                      : 1.0,
                  child: Padding(
                    padding: EdgeInsets.only(right: 5.h),
                    child: Text(getString(lblSetMandateProductDetail),
                        style:
                            Theme.of(context).textTheme.labelMedium!.copyWith(
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

  Widget _buildInsuranceExplore(BuildContext context) {
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
                imagePath: ImageConstant.errorIimage,
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
                child: Text(getString(msgInsuranceExploreProductDetail),
                    style: Theme.of(context).textTheme.bodyMedium),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 5.h),
              child: Text(getString(lblExploreNowProductDetail),
                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                          color: setColorBasedOnTheme(
                        context: context,
                        lightColor: AppColors.secondaryLight,
                        darkColor: AppColors.secondaryLight5,
                      ))),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyAssetsDetails(BuildContext context) {
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
                imagePath: ImageConstant.update,
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
                child: Text(getString(msgUpdateVehicleProductDetail),
                    style: Theme.of(context).textTheme.bodyMedium),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 5.h),
              child: Text(getString(lblUpdateProductDetail),
                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                          color: setColorBasedOnTheme(
                        context: context,
                        lightColor: AppColors.secondaryLight,
                        darkColor: AppColors.secondaryLight5,
                      ))),
            )
          ],
        ),
      ),
    );
  }

  List<Tab> tabs = [];

  AppBar _buildAppBar(ActiveLoanDetailResponse response) {
    return AppBar(
        leading: AppbarLeadingImage(
          imagePath: ImageConstant.imgArrowDown,
          margin: const EdgeInsets.only(
            top: 16,
            bottom: 15,
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        actions: [HelpCommonWidget(categoryval: HelpConstantData.categoryProductDetails,subCategoryval: HelpConstantData.subCategoryLoanDetails)],
        title: AppbarTitle(
          text: widget.loanDetails!.productCategory.toString(),
          margin: const EdgeInsets.only(left: 0),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: TabBar(
            // controller: tabviewController,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            unselectedLabelColor: Theme.of(context).primaryColor,
            labelColor: Theme.of(context).highlightColor,
            indicatorColor: Theme.of(context).highlightColor,
            labelStyle: const TextStyle(
              fontSize: 14,
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.w700,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 14,
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.w600,
            ),
            tabs: buildTabs(response),
            onTap: (int index) => scrollToIndex(index),
          ),
        ));
  }

  Widget _buildCategoryTitle(String title, int index) {
    return Padding(
      key: jewelleryCategories[index],
      padding: EdgeInsets.only(right: 16.v, left: 16.v),
      child: title.isNotEmpty
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    index == 1
                        ? BlocConsumer<ProductDetailsCubit,
                            ProductDetailsState>(
                            listener: (context, state) {
                              if (state is product_detail.LoadingState &&
                                  state.isloading) {
                                const Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Center(
                                      child: CircularProgressIndicator(
                                    color: Colors.black,
                                    strokeWidth: 2,
                                  )),
                                );
                              }
                            },
                            builder: (context, state) {
                              return InkWell(
                                onTap: () {
                                  if (widget.loanDetails?.sourceSystem
                                          ?.toLowerCase() ==
                                      'pennant') {
                                    BlocProvider.of<ProductDetailsCubit>(
                                            context)
                                        .getDocuments(DocumentsRequest(
                                            loanNumber:
                                                widget.loanDetails?.loanNumber,
                                            sourceSystem: widget
                                                .loanDetails?.sourceSystem,
                                            docFlag: 'soa'));
                                  } else if (widget.loanDetails?.sourceSystem
                                          ?.toLowerCase() ==
                                      'finnone') {
                                    BlocProvider.of<ProductDetailsCubit>(
                                            context)
                                        .getDocuments(DocumentsRequest(
                                            loanNumber:
                                                widget.loanDetails?.loanNumber,
                                            sourceSystem: widget
                                                .loanDetails?.sourceSystem,
                                            docFlag: 'soa'));
                                  } else {
                                    generateSOAthroughWebView(context);
                                  }
                                },
                                child: Row(
                                  children: [
                                    CustomImageView(
                                      imagePath: ImageConstant.imgDownload,
                                      height: 18.adaptSize,
                                      width: 18.adaptSize,
                                      color: setColorBasedOnTheme(
                                        context: context,
                                        lightColor: AppColors.secondaryLight,
                                        darkColor: AppColors.backgroundLight,
                                      ),
                                      margin: EdgeInsets.only(left: 10.h),
                                    ),
                                    Text(getString(lblDownloadNocProductDetail),
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall!
                                            .copyWith(
                                                color: setColorBasedOnTheme(
                                              context: context,
                                              lightColor:
                                                  AppColors.secondaryLight,
                                              darkColor:
                                                  AppColors.secondaryLight5,
                                            ))),
                                  ],
                                ),
                              );
                            },
                          )
                        : index == 5
                            ? isActiveMandate(widget.loanDetails!.mandateStatus
                                    .toString())
                                ? buildModifyMandate()
                                : Container()
                            : Container(),
                  ],
                ),

                // const Divider(),
              ],
            )
          : Container(),
    );
  }

  _buildDvider() {
    return Container(
      height: 1.v,
      margin: EdgeInsets.symmetric(vertical: 16.v, horizontal: 16.v),
      decoration: BoxDecoration(
          color: setColorBasedOnTheme(
              context: context,
              lightColor: AppColors.backgroundDarkGradient6,
              darkColor: AppColors.shadowDark)),
    );
  }

  checkChargesWidgets(BasicChargeDetails basicChargeDetails) {
    return ChargesWidgetPage(basicChargeDetails);
  }

  buildCharges(BasicChargeDetails basicChargeDetails) {
    return Column(
      children: [
        _buildCategoryTitle(getString(chargesProductDetail), 3),
        SizedBox(height: 16.v),
        checkChargesWidgets(basicChargeDetails),
      ],
    );
  }

  buildBasicDetail(BasicCustomerDetails basicCustomerDetails) {
    return Column(
      children: [
        _buildCategoryTitle(getString(basicDetailsProductDetail), 4),
        SizedBox(height: 16.v),
        BasicDetailsWidgetPage(basicCustomerDetails),
      ],
    );
  }

  int getLength(ActiveLoanDetailResponse response) {
    if (response.basicAssetDetails == null) {
      return 7;
    } else {
      return 8;
    }
  }

  List<Widget> _buildTabs6(int count) {
    List<Tab> tab = [];
    if (count == 7) {
      tab.add(Tab(
        child: Text(
          getString(loanDetailsProductDetail),
        ),
      ));
      tab.add(Tab(
          child: Text(
        getString(paymentHistoryProductDetail),
      )));

      tab.add(Tab(
        child: Text(
          getString(documentsProductDetail),
        ),
      ));
      tab.add(Tab(
        child: Text(
          getString(chargesProductDetail),
        ),
      ));
      tab.add(Tab(
        child: Text(
          getString(basicDetailsProductDetail),
        ),
      ));
      tab.add(Tab(
        child: Text(
          getString(bankDetailsProductDetail),
        ),
      ));
      tab.add(Tab(
        child: Text(
          getString(insuranceDetailsProductDetail),
        ),
      ));
    } else {
      tab.add(Tab(
        child: Text(
          getString(loanDetailsProductDetail),
        ),
      ));
      tab.add(Tab(
          child: Text(
        getString(paymentHistoryProductDetail),
      )));

      tab.add(Tab(
        child: Text(
          getString(documentsProductDetail),
        ),
      ));
      tab.add(Tab(
        child: Text(
          getString(chargesProductDetail),
        ),
      ));
      tab.add(Tab(
        child: Text(
          getString(basicDetailsProductDetail),
        ),
      ));
      tab.add(Tab(
        child: Text(
          getString(bankDetailsProductDetail),
        ),
      ));

      tab.add(Tab(
        child: Text(
          getString(assetsDetailsProductDetail),
        ),
      ));

      tab.add(Tab(
        child: Text(
          getString(insuranceDetailsProductDetail),
        ),
      ));
    }
    return tab;
  }

  buildTabs(ActiveLoanDetailResponse response) {
    if (response.basicAssetDetails == null ||
        response.basicAssetDetails!.isEmpty()) {
      return _buildTabs6(7);
    } else {
      return _buildTabs6(8);
    }
  }

  void generateSOAthroughWebView(BuildContext context) async {
    if (widget.loanDetails!.sourceSystem?.toLowerCase() == 'autofin' ||
        widget.loanDetails!.sourceSystem?.toLowerCase() == 'finnone') {
      String url = createSOAurl(widget.loanDetails as ActiveLoanData);
      context.pushNamed(Routes.generateSoaDocWebView.name, extra: url);
      context.read<ProductDetailsCubit>().getDocuments(DocumentsRequest(
          loanNumber: widget.loanDetails?.loanNumber,
          sourceSystem: widget.loanDetails?.sourceSystem,
          docFlag: 'soa'));
    }
  }

  buildModifyMandate() {
    return InkWell(
      onTap: () {
        var loanData =
        mappingLoanData(widget.loanDetails ?? ActiveLoanData());
        if (widget.loanDetails!.mandateStatus ==
            ActiveLoanStatus.active.name) {
          context.pushNamed(ach_mandate.Routes.mandateDetailsScreen.name,
              extra: {"loanData": loanData});
        }
      },
      child: Padding(
        padding: EdgeInsets.only(right: 5.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(getString(modifyMandateProductDetail),
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                        color: setColorBasedOnTheme(
                      context: context,
                      lightColor: AppColors.secondaryLight,
                      darkColor: AppColors.secondaryLight5,
                    ))),
            CustomImageView(
              imagePath: ImageConstant.imgArrowRightPink900,
              height: 20.adaptSize,
              width: 20.adaptSize,
              color: setColorBasedOnTheme(
                context: context,
                lightColor: AppColors.secondaryLight,
                darkColor: AppColors.secondaryLight5,
              ),
              margin: EdgeInsets.only(
                bottom: 0.v,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
