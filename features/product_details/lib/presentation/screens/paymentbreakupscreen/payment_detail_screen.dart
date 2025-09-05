import 'dart:async';
import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/config/widgets/background/mf_gradient_background.dart';
import 'package:core/config/widgets/mf_appbar.dart';
import 'package:core/utils/const.dart';
import 'package:core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:core/utils/size_utils.dart';
import 'package:auth/features/login_and_registration/presentation/login_wireframe/widgets/custom_floating_text_field.dart';
import 'package:auth/features/login_and_registration/presentation/login_wireframe/widgets/custom_elevated_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:loan/features/foreclosure/data/models/get_loan_details_request.dart';
import 'package:loan/features/foreclosure/data/models/get_loan_details_response.dart';
import 'package:payment_gateway/features/domain/models/payment_params/payment_product_type.dart';
import 'package:payment_gateway/features/domain/models/payment_params/payment_source_system.dart';
import 'package:payment_gateway/features/domain/models/payment_params/payment_type.dart';
import 'package:product_details/data/models/active_loan_detail_request.dart';
import 'package:product_details/data/models/active_loan_detail_response.dart';
import 'package:product_details/data/models/active_loan_list_response.dart';
import 'package:product_details/presentation/cubit/product_details_cubit.dart';
import 'package:product_details/presentation/screens/paymentbreakupscreen/widget/custom_bottom_sheet_emi_payment.dart';
import 'package:product_details/presentation/screens/paymentbreakupscreen/widget/custom_dialog.dart';
import 'package:product_details/presentation/screens/paymentbreakupscreen/widget/error_widget.dart';
import 'package:product_details/utils/Constants.dart';
import 'package:product_details/utils/services.dart';
import 'package:payment_gateway/config/routes/route.dart' as payment_route;
import 'package:loan/config/routes/route.dart' as loan;
import 'package:payment_gateway/features/domain/models/payment_model.dart';
import 'package:help/features/utils/constant_help.dart';
import 'package:help/features/utils/help_common_widget.dart';
// ignore_for_file: must_be_immutable
class PaymentDetailScreen extends StatefulWidget {
  PaymentDetailScreen({super.key, this.loanDetails});

  ActiveLoanData? loanDetails;

  @override
  State<PaymentDetailScreen> createState() => _PaymentDetailScreenState();
}

class _PaymentDetailScreenState extends State<PaymentDetailScreen> {
  final TextEditingController amountController = TextEditingController();

  bool showAmountWarning = false;
  bool showMoreDetails = false;
  bool isAmountInvalid = true;
  late BasicChargeDetails? basicChargeDetails;
  String amountInWOrds = '';
  double foreclosureAmount = 0.0;
  double maxCap = 0;
  LoanDetails? loanDetailData;
  bool? case1;
  bool? case2;
  bool isRemaining = false;

  final GlobalKey paymentButtonKey = GlobalKey();

  @override
  void initState() {
    amountController.text = rupeeFormatter(
        (widget.loanDetails?.totalPayableAmount ?? 0).toString());
    if ((widget.loanDetails?.totalPayableAmount ?? 0) == 0) {
      isAmountInvalid = false;
    }
    amountInWOrds =
        numberToWords((widget.loanDetails?.totalPayableAmount ?? 0).toInt())
            .toCapitalized();

    GetLoanDetailsRequest getLoanDetailsRequest = GetLoanDetailsRequest(
      ucic: widget.loanDetails?.ucic,
      loanNumber:  widget.loanDetails?.loanNumber,
      sourceSystem: widget.loanDetails?.sourceSystem,
      productCategory: widget.loanDetails?.productCategory
    );
    context
        .read<ProductDetailsCubit>()
        .getForeClosureDetails(getLoanDetailsRequest);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: customAppbar(
            context: context,
            title: getString(lblPaymentOptionsProductDetail),
            onPressed: () {
              Navigator.pop(context, isRemaining ? PaymentConstants.resetLoanList  : '');
            },
            actions: [HelpCommonWidget(categoryval: HelpConstantData.categoryPayment,subCategoryval: HelpConstantData.subCategoryPaymentBreakupCalculation,)]
          ),
          body: MFGradientBackground(
              verticalPadding: 0.h,
              child: BlocConsumer<ProductDetailsCubit, ProductDetailsState>(
                listenWhen: (previous, current) {
                  if (current is GetForeClosureDetailsSuccessState ||
                  current is GetActiveLoansDetailsSuccessState ||
                  current is  GetLoanDetailsSuccessState){
                    return true;
                  } else {
                    return false;
                  }
                },
                listener: (context, state) {
                  if (state is GetForeClosureDetailsSuccessState) {
                    if (state.response.message == AppConst.codeSuccess) {
                      if (state.response.data != null) {
                        foreclosureAmount =
                            double.parse((state.response.data!.totalAmountToPay ?? '0'));
                      }

                      GetLoanDetailsRequest getLoanDetailsRequest =
                          GetLoanDetailsRequest(
                              ucic: widget.loanDetails!.ucic,
                              loanNumber: widget.loanDetails?.loanNumber,
                              sourceSystem: widget.loanDetails?.sourceSystem,
                              productCategory:
                                  widget.loanDetails?.productCategory);
                      context
                          .read<ProductDetailsCubit>()
                          .getLoanDetails(getLoanDetailsRequest);
                    }
                  }

                  if (state is GetLoanDetailsSuccessState) {
                    loanDetailData = state.response.data;
                    BlocProvider.of<ProductDetailsCubit>(context)
                        .getActiveLoansDetails(ActiveLoanDetailRequest(
                            ucic: widget.loanDetails!.ucic,
                            loanNumber: widget.loanDetails!.loanNumber,
                            cifId: widget.loanDetails!.coApplicantCif,
                            sourceSystem: widget.loanDetails!.sourceSystem));
                  }
                  if (state is GetActiveLoansDetailsSuccessState) {
                    //TODO - Will have to remove this static value once API is working fine..
                    if(state.response.basicDetailsResponse?.numberOfPaidInstallments == '-'){
                         maxCap = 10000000;
                    }else{
                    double tenure = double.parse(
                        state.response.basicDetailsResponse?.loanTenure ?? '0');
                    double noOfPaidEMI = double.parse(
                        state.response.basicDetailsResponse?.numberOfPaidInstallments ?? '0');
                    double installmentAmount = double.parse(
                        state.response.basicDetailsResponse?.instalmentAmount ?? '0');
                    maxCap = (tenure - noOfPaidEMI) * installmentAmount;
                    }
                  }
                },
                buildWhen: (previous, current) {
                  if (current is GetActiveLoansDetailsFailureState ||
                      current is GetActiveLoansDetailsSuccessState ||
                      current is GetForeClosureDetailsFailureState ||
                      current is GetForeClosureDetailsSuccessState ||
                      current is GetLoanDetailsFailureState ||
                      current is LoadingState) {
                    return true;
                  } else {
                    return false;
                  }
                },
                builder: (context, state) {
                  if (state is LoadingState && state.isloading) {
                    return const Align(
                      alignment: Alignment.bottomCenter,
                      child: Center(
                          child: CircularProgressIndicator(
                        color: Colors.black,
                        strokeWidth: 2,
                      )),
                    );
                  }
                  if(state is GetForeClosureDetailsFailureState){
                       return genericErrorWidget(context);
                  }
                  if(state is GetLoanDetailsFailureState){
                       return genericErrorWidget(context);
                  }
                  if (state is GetActiveLoansDetailsFailureState) {
                    return genericErrorWidget(context);
                  }
                  if (state is GetForeClosureDetailsSuccessState) {
                    if(state.response.message == AppConst.codeFailure){
                    return genericErrorWidget(context);
                    }
                  }
                  if (state is GetActiveLoansDetailsSuccessState) {
                    return CustomScrollView(
                      slivers: [
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 16.h,
                              ),
                              Text(
                                "${widget.loanDetails?.productCategory ?? ""} | ${widget.loanDetails?.loanNumber ?? ""}",
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              if ((widget.loanDetails?.productCategory ?? "")
                                      .toLowerCase() ==
                                  getString(PaymentProductType.vl.value)
                                      .toLowerCase())
                                Text(
                                  "${widget.loanDetails?.productName ?? ''} | ${widget.loanDetails?.vehicleRegistration ?? ""}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium
                                      ?.copyWith(
                                        letterSpacing: 0.06,
                                        height: 18 / 14,
                                      ),
                                ),
                              SizedBox(
                                height: 16.h,
                              ),
                              Divider(
                                height: 1.h,
                                color: Theme.of(context).dividerColor,
                              ),
                              SizedBox(
                                height: 16.h,
                              ),
                              _buildAmountInputField(context),
                              SizedBox(
                                height: 5.h,
                              ),
                              BlocBuilder<ProductDetailsCubit,
                                  ProductDetailsState>(
                                buildWhen: (previous, current) =>
                                    current is PayableAmountValidationState,
                                builder: (context, state) {
                                  if (state is PayableAmountValidationState) {
                                    isAmountInvalid = state.isAmountValid;
                                    amountInWOrds =
                                        state.amountInWords.toCapitalized();
                                  }
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        left: 12.0, right: 12),
                                    child: Text(
                                        isAmountInvalid
                                            ? amountInWOrds
                                            : getAmountAsDouble(
                                                        amountController.text) <
                                                    PaymentConstants
                                                        .minimumPayableAmount
                                                ? getString(
                                                    lblMinAmountCannotBeLessProductDetail)
                                                : getMaxCapWarningMsg(
                                                    maxCap: maxCap),
                                        style: isAmountInvalid
                                            ? Theme.of(context)
                                                .textTheme
                                                .labelSmall
                                            : Theme.of(context)
                                                .textTheme
                                                .labelSmall
                                                ?.copyWith(
                                                    color: AppColors
                                                        .textFieldErrorColor)),
                                  );
                                },
                              ),
                              SizedBox(
                                height: 24.h,
                              ),
                              _amountBreakupWidget(state),
                              Expanded(
                                  child: SizedBox(
                                height: 10.h,
                              )),
                              BlocBuilder<ProductDetailsCubit,
                                  ProductDetailsState>(
                                buildWhen: (previous, current) =>
                                    current is PayableAmountValidationState,
                                builder: (context, state) {
                                  return CustomElevatedButton(
                                    key: paymentButtonKey,
                                    onPressed: isAmountInvalid
                                        ? () {
                                            FocusManager.instance.primaryFocus
                                                ?.unfocus();
                                            validateAndNavigate();
                                          }
                                        : null,
                                    text: getString(lblProceedToPayProductDetail),
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 3.h),
                                    buttonStyle: ElevatedButton.styleFrom(
                                        backgroundColor: isAmountInvalid
                                            ? Theme.of(context).highlightColor
                                            : Theme.of(context).disabledColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.h),
                                        )),
                                    buttonTextStyle: isAmountInvalid
                                        ? Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(color: AppColors.white)
                                        : Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                                color: Theme.of(context)
                                                    .unselectedWidgetColor),
                                  );
                                },
                              ),
                              SizedBox(
                                height: 24.h,
                              )
                            ],
                          ),
                        )
                      ],
                    );
                  }
                  return Container();
                },
              ))),
    );
  }



  void validateAndNavigate() {
    double enteredAmount = getAmountAsDouble(amountController.text);
    double amountPayable = (widget.loanDetails?.totalPayableAmount ?? 0.0);

    if (enteredAmount == amountPayable) {
      navigateToChoosePayment(enteredAmount);
      return;
    }
     case1 =
        (enteredAmount > foreclosureAmount) && (enteredAmount > amountPayable);

     case2 =
        (amountPayable < enteredAmount) && (enteredAmount < foreclosureAmount);
    customBottomSheetForEMIPayment(
      context,
      caseOneDesign: case1!,
      payableAmount: amountPayable.toString(),
      payingAmount: enteredAmount.toString(),
      primaryButtonTitle:
          case1! ? getString(lblYesForecloseLoanProductDetail) : getString(lblYesConfirmPayProductDetail),
      secondaryButtonTitle: getString(lblNoChangeAmountProductDetail),
      excessAmount: (enteredAmount - amountPayable).abs().toString(),
      description: case1!
          ? getAmountValidationMsg(
              enteredAmount: enteredAmount, forecloseAmount: foreclosureAmount)
          : case2!
              ? getString(msgExcessWillBeAdjustedProductDetail)
              : getString(msgChargesMightAccumulateDuesProductDetail),
      primaryCallback: () {
        Navigator.of(context).pop();
        if (case1! && loanDetailData!=null) {
          context.pushNamed(
            loan.Routes.foreclosureDetail.name,
            extra: loanDetailData,
          );
        } else {
          navigateToChoosePayment(enteredAmount);
        }
      },
      secondaryCallback: () {
        Navigator.of(context).pop();
      },
      resetCallBack: (){
         case1 = null;
        case2 = null;
      }
    );
  }

  Future<Object?> navigateToChoosePayment(num enteredAmount) {
    PaymentProductType? paymentProductType = context
        .read<ProductDetailsCubit>()
        .getPaymentProductType(
            productCategory: widget.loanDetails?.productCategory);
    PaymentSourceSystem? paymentSourceSystem = context
        .read<ProductDetailsCubit>()
        .getSourceSystem(sourceSystem: widget.loanDetails?.sourceSystem);

    if (paymentSourceSystem != null && paymentProductType != null) {
      isRemaining = ((case1 != null && case2 != null) && (!case1! && !case2!));
      return context
          .pushNamed(
        payment_route.Routes.choosePaymentMode.name,
        extra: PaymentModel(
            productType: paymentProductType,
            sourceSystem: paymentSourceSystem,
            productNumber: widget.loanDetails!.loanNumber!,
            paymentType: PaymentType.emi,
            totalPaybleAmount: enteredAmount.toString(),
            remainingAmount: isRemaining
                ? ((widget.loanDetails?.totalPayableAmount ?? 0) -
                        enteredAmount)
                    .toStringAsFixed(2)
                : null,
            description:
                "${widget.loanDetails?.productName ?? ''} | ${widget.loanDetails?.vehicleRegistration ?? ""}"),
      )
          .then((value) {
        case1 = null;
        case2 = null;
        isRemaining = false;
        try {
          if (value != null &&
              (value as Map<dynamic, dynamic>)[
                      PaymentConstants.remainingAmount] !=
                  null) {
            isRemaining = true;
            widget.loanDetails?.totalPayableAmount =
                double.parse(value[PaymentConstants.remainingAmount] ?? '0');
            amountController.text = rupeeFormatter(
                (widget.loanDetails?.totalPayableAmount ?? 0).toString());
            if ((widget.loanDetails?.totalPayableAmount ?? 0) == 0) {
              isAmountInvalid = false;
            }
            amountInWOrds = numberToWords(
                    (widget.loanDetails?.totalPayableAmount ?? 0).toInt())
                .toCapitalized();

            GetLoanDetailsRequest getLoanDetailsRequest = GetLoanDetailsRequest(
                ucic: widget.loanDetails?.ucic,
                loanNumber: widget.loanDetails?.loanNumber,
                sourceSystem: widget.loanDetails?.sourceSystem,
                productCategory: widget.loanDetails?.productCategory);
            context
                .read<ProductDetailsCubit>()
                .getForeClosureDetails(getLoanDetailsRequest);
          }
        } catch (e) {
          showDialog(
              context: context,
              builder: (context) {
                return ShowCustomDialogWidget(
                  errorMsg: getString(lblErrorGenericProductDetail),
                  ontap: () {
                    Navigator.of(context).pop();
                  },
                );
              });
        }

        return null;
      });
    } else {
      return showDialog(
          context: context,
          builder: (context) {
            return ShowCustomDialogWidget(
              errorMsg: getString(lblErrorGenericProductDetail),
              ontap: () {
                Navigator.of(context).pop();
              },
            );
          });
    }
  }

  Widget _buildAmountInputField(BuildContext context) {
    return BlocListener<ProductDetailsCubit, ProductDetailsState>(
      listener: (context, state) {
        if (state is PayableAmountValidationState) {
          isAmountInvalid = state.isAmountValid;
        }
      },
      child: CustomFloatingTextField(
        onChange: (amount) {
          if(amount.split('.').length > 1){
            List<String> array = amount.split('.');
            amount = "${array[0]}.${array[1]}";
          }
          amountController.text = rupeeFormatter(amount);
          context
              .read<ProductDetailsCubit>()
              .setPayableAmountValidation(amount,maxCap);
        },
        onTap: () async {
          if (paymentButtonKey.currentContext != null) {
            await Future.delayed(const Duration(milliseconds: 500));
            RenderObject? object =
                paymentButtonKey.currentContext!.findRenderObject();
            if (object != null) {
              object.showOnScreen();
            }
          }
        },
        autofocus: false,
        controller: amountController,
        textStyle: Theme.of(context)
            .textTheme
            .labelLarge
            ?.copyWith(fontWeight: FontWeight.w400),
        labelText: getString(lblAmountPayableProductDetail),
        labelStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
              letterSpacing: 0.06,
            ),
        textInputAction: TextInputAction.done,
        textInputType: TextInputType.number,
        borderDecoration: UnderlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(
            color: Theme.of(context).unselectedWidgetColor,
            width: 1,
          ),
        ),
      ),
    );
  }

  Widget _amountBreakupWidget(GetActiveLoansDetailsSuccessState loanDetailState) {
    return BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
      buildWhen: (previous, current) => (current is AmountDetailsState),
      builder: (context, state) {
        if (state is AmountDetailsState) {
          showMoreDetails = state.showMoreDetails;
        }
        if (state is GetActiveLoansDetailsSuccessState) {
          basicChargeDetails = state.response.basicChargeDetails;
        }
        final Brightness brightness = Theme.of(context).brightness;
        return Container(
          decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  getString(lblBreakUpProductDetail),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                SizedBox(
                  height: 12.h,
                ),
                if ((double.parse(loanDetailState.response.basicDetailsResponse?.installmentOverdue ?? '0')) <= 0) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        getString(lblUpcomingEMIProductDetail),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        RupeeFormatter(
                                double.parse(loanDetailState.response.basicDetailsResponse?.instalmentAmount ?? '0'))
                            .inRupeesFormat(),
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 12.h,
                  ),
                ],
                if (double.parse(loanDetailState.response.basicDetailsResponse?.installmentOverdue ?? '0') > 0) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(getString(emiOverdueProductDetail),
                          style: Theme.of(context).textTheme.bodySmall),
                      Text(
                          RupeeFormatter(
                                 double.parse(loanDetailState.response.basicDetailsResponse?.installmentOverdue ?? '0'))
                              .inRupeesFormat(),
                          style: Theme.of(context).textTheme.labelSmall),
                    ],
                  ),
                  SizedBox(
                    height: 12.h,
                  ),
                ],
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        context
                            .read<ProductDetailsCubit>()
                            .showAmountDetails(!showMoreDetails);
                      },
                      child: Row(
                        children: [
                          Text(getString(lblChargesProductDetail),
                              style: Theme.of(context).textTheme.bodySmall),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(getString(lblDetailsProductDetail),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w400,
                                      color: brightness == Brightness.light
                                          ? AppColors.secondaryLight
                                          : AppColors.secondaryLight5)),
                          Icon(
                            showMoreDetails
                                ? Icons.expand_less
                                : Icons.expand_more,
                            color: brightness == Brightness.light
                                ? AppColors.secondaryLight
                                : AppColors.secondaryLight5,
                            size: 14,
                          ),
                        ],
                      ),
                    ),
                    Text(
                      RupeeFormatter(getCharges()).inRupeesFormat(),
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                ),
                SizedBox(
                  height: 12.h,
                ),
                if (showMoreDetails) ...[
                  _chargesDetailsWidget(context,
                      label: getString(lblChequeReturnChargesProductDetail),
                      amount: RupeeFormatter(double.parse(
                              basicChargeDetails?.chequeReturnCharges ?? '0'))
                          .inRupeesFormat(),
                      subLabel: "Lorem ipsum simple dummy text"),
                  SizedBox(
                    height: 12.h,
                  ),
                  _chargesDetailsWidget(context,
                      label: getString(lblAdditionalInterestChargesProductDetail),
                      amount: RupeeFormatter(double.parse(
                              basicChargeDetails?.additionalInterestCharges ??
                                  '0'))
                          .inRupeesFormat(),
                      subLabel: "Lorem ipsum simple dummy textLorem ipsum "),
                  SizedBox(
                    height: 12.h,
                  ),
                  _chargesDetailsWidget(context,
                      label: getString(lblRepossessionChargesProductDetail),
                      amount: RupeeFormatter(double.parse(
                              basicChargeDetails?.repossessionCharges ?? '0'))
                          .inRupeesFormat(),
                      subLabel: "Lorem ipsum simple dummy textLorem ipsum "),
                  SizedBox(
                    height: 12.h,
                  ),
                  _chargesDetailsWidget(context,
                      label: getString(lblOtherChargesProductDetail),
                      amount: RupeeFormatter(double.parse(
                              basicChargeDetails?.otherCharges ?? '0'))
                          .inRupeesFormat(),
                      subLabel: "Lorem ipsum simple dummy text"),
                  SizedBox(
                    height: 12.h,
                  ),
                ],
                Divider(
                  height: 1.h,
                  color: AppColors.primaryLight6,
                ),
                SizedBox(
                  height: 12.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(getString(lblTotalProductDetail),
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontWeight: FontWeight.w600)),
                    Text(
                      RupeeFormatter(
                              (widget.loanDetails?.totalPayableAmount ?? 0))
                          .inRupeesFormat(),
                      style: Theme.of(context)
                          .textTheme
                          .labelMedium
                          ?.copyWith(fontWeight: FontWeight.w500),
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Column _chargesDetailsWidget(BuildContext context,
      {required String label,
      required String amount,
      required String subLabel}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child:
                    Text(label, style: Theme.of(context).textTheme.bodySmall)),
            Text(amount, style: Theme.of(context).textTheme.labelSmall),
          ],
        ),
      ],
    );
  }

  num getCharges() {
    try {
      double sum =
          double.parse(basicChargeDetails?.additionalInterestCharges ?? '0') +
              double.parse(basicChargeDetails?.chequeReturnCharges ?? '0') +
              double.parse(basicChargeDetails?.otherCharges ?? '0') +
              double.parse(basicChargeDetails?.repossessionCharges ?? '0');
      return sum;
    } catch (e) {
      return 0;
    }
  }
}
