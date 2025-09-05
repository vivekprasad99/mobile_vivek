import 'package:ach/config/source.dart';
import 'package:ach/config/ach_util.dart';
import 'package:ach/data/models/fetch_applicant_name_req.dart';
import 'package:ach/data/models/fetch_bank_account_req.dart';
import 'package:ach/data/models/update_mandate_info.dart';
import 'package:ach/presentation/cubit/ach_cubit.dart';
import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/resources/image_constant.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/config/widgets/mf_progress_bar.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:core/config/widgets/mf_toast.dart';
import 'package:core/services/di/injection_container.dart';
import 'package:core/utils/const.dart';
import 'package:core/utils/size_utils.dart';
import 'package:core/utils/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ach/config/routes/route.dart' as ach_mandate;
import 'package:lead_generation/config/routes/route.dart' as lead_gen;

import 'package:flutter/material.dart';
import 'package:noc/data/models/dl_noc_req.dart';
import 'package:noc/data/models/gc_validate_req.dart';
import 'package:noc/data/models/get_loan_list_resp.dart';
import 'package:noc/data/models/noc_details_req.dart';
import 'package:noc/presentation/cubit/noc_cubit.dart';
import 'package:product_details/config/routes/route.dart';
import 'package:product_details/data/models/active_loan_list_response.dart';
import 'package:product_details/presentation/screens/activeloandetailscreen/widgets/convert_to_pdf.dart';
import 'package:product_details/presentation/screens/widget/custom_image_view.dart';
import 'package:product_details/utils/constants.dart';
import 'package:product_details/utils/date_time_convert.dart';
import 'package:product_details/utils/enum_download_file_name.dart';
import 'package:noc/config/routes/route.dart' as noc_routes;

import '../../../utils/utils.dart';
import 'package:intl/intl.dart';
// ignore_for_file: must_be_immutable
class CompletedLoansItem extends StatefulWidget {
  CompletedLoansItem(
    this.data,
    this.tabType, {
    super.key,
  });

  List<ActiveLoanData>? data;
  String tabType;

  @override
  State<CompletedLoansItem> createState() => _CompletedLoansItemState();
}

class _CompletedLoansItemState extends State<CompletedLoansItem> {
  int loanLength = 2;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AchCubit, AchState>(
      listener: (context, state) {
        if (state is FetchBankAccountSuccessState) {
          if (state.response.code == AppConst.codeSuccess) {
            if (state.response.data != null &&
                state.response.data!.isNotEmpty) {
              context
                  .pushNamed(ach_mandate.Routes.addedBanksScreen.name, extra: {
                "loanData": state.loanItem,
                "bankData": state.response.data,
                "updateMandateInfo": UpdateMandateInfo()
              });
            } else {
              context
                  .pushNamed(ach_mandate.Routes.selectBankScreen.name, extra: {
                "loanData": state.loanItem,
                "selectedApplicant": "",
                "updateMandateInfo": UpdateMandateInfo(),
                "source": Source()
              });
            }
          } else {
            toastForFailureMessage(
                context: context, msg: getString(msgSomethingWentWrong));
          }
        } else if (state is FetchBankAccountFailureState) {
          toastForFailureMessage(
              context: context, msg: getString(msgSomethingWentWrong));
        } else if (state is FetchApplicantNameSuccessState) {
          if (state.response.code == AppConst.codeSuccess) {
            var loanData = state.loanData;
            loanData?.applicantName = state.response.data?.applicantName ?? "";
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
                context: context, msg: getString(msgSomethingWentWrong));
          }
        } else if (state is FetchApplicantNameFailureState) {
          toastForFailureMessage(
              context: context, msg: getString(msgSomethingWentWrong));
        } else if (state is LoadingDialogState) {
          if (state.isloading) {
            showLoaderDialog(context, getString(lblLoading));
          } else {
            Navigator.of(context, rootNavigator: true).pop();
          }
        }
      },
      child: Padding(
          padding: EdgeInsets.only(
            left: 16.h,
            right: 13.h,
          ),
          child: Column(
            children: [
              if (widget.data != null)
                ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  separatorBuilder: (
                    context,
                    index,
                  ) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0.v),
                      child: const SizedBox(),
                    );
                  },
                  itemCount: widget.data!.length < 2
                      ? widget.data!.length
                      : loanLength,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        context.pushNamed(Routes.productsLoanDetailPage.name,
                            extra: widget.data![index]);
                      },
                      child: activeLoanItemWidget(
                        context,
                        widget.data![index],
                      ),
                    );
                  },
                ),
              const SizedBox(
                height: 10,
              ),
              (widget.data!.length > 2 && (loanLength < widget.data!.length))
                  ? Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 20.v),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              loanLength = widget.data?.length ?? 0;
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 1.v),
                                child: Text(
                                  getString(seeMoreProductDetail),
                                  style: TextStyle(
                                    color: setColorBasedOnTheme(
                                      context: context,
                                      lightColor: AppColors.secondaryLight,
                                      darkColor: AppColors.secondaryLight5,
                                    ),
                                  ),
                                ),
                              ),
                              CustomImageView(
                                imagePath: ImageConstant.imgArrowDownRed700,
                                height: 24.adaptSize,
                                width: 24.adaptSize,
                                color: setColorBasedOnTheme(
                                  context: context,
                                  lightColor: AppColors.secondaryLight,
                                  darkColor: AppColors.secondaryLight5,
                                ),
                                margin: EdgeInsets.only(left: 3.h),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ],
          )),
    );
  }

  Widget activeLoanItemWidget(BuildContext context, ActiveLoanData datum) {
    final Brightness brightness = Theme.of(context).brightness;
    String dueDate = '';

    if ((datum.totalAmountOverdue ?? 0) > 0) {
      dueDate = ConvertDateTime.convert(
          DateFormat('yyyy-MM-dd').format(DateTime.now()));
    } else {
      dueDate = ConvertDateTime.convert(datum.nextDuedate ?? '');
    }
    return Container(
      padding: EdgeInsets.all(12.h),
      decoration: BoxDecoration(
          color: brightness == Brightness.light
              ? AppColors.backgroundLight5
              : AppColors.cardDark,
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: brightness == Brightness.light
                        ? AppColors.backgroundDarkGradient4
                        : AppColors.shadowDark),
                child: CustomImageView(
                  height: 25.v,
                  width: 25.v,
                  margin: const EdgeInsets.all(12),
                  imagePath:
                      datum.productCategory!.equalsIgnoreCase("vehicle loan")
                          ? ImageConstant.imgCar
                          : ImageConstant.personalLoans,
                  color: brightness == Brightness.light
                      ? AppColors.primaryLight
                      : AppColors.backgroundDarkGradient6,
                ),
              ),
              SizedBox(
                width: 10.v,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(datum.productCategory ?? "",
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontWeight: FontWeight.w500)),
                  SizedBox(height: 5.v),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: Text(
                        datum.productCategory!.equalsIgnoreCase('Vehicle Loan')
                            ? datum.vehicleRegistration!
                            : "",
                        style: Theme.of(context).textTheme.bodyMedium),

                  ),
                ],
              ),
              const Spacer(),
              CustomImageView(
                imagePath: ImageConstant.imgArrowRightPink900,
                height: 30.adaptSize,
                width: 30.adaptSize,
                color: setColorBasedOnTheme(
                  context: context,
                  lightColor: AppColors.secondaryLight,
                  darkColor: AppColors.secondaryLight5,
                ),
                margin: EdgeInsets.only(
                  top: 12.v,
                  bottom: 4.v,
                ),
              ),
            ],
          ),
          SizedBox(height: 17.v),
          Container(
            color: setColorBasedOnTheme(
                context: context,
                lightColor: AppColors.backgroundDarkGradient4,
                darkColor: AppColors.shadowDark),
            width: MediaQuery.of(context).size.width,
            height: 1,
          ),
          SizedBox(height: 20.v),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(getString(lblLoanNoProductDetail),
                      style: Theme.of(context).textTheme.bodyMedium),
                  SizedBox(height: 2.v),
                  Text(datum.loanNumber.toString(),
                      style: Theme.of(context).textTheme.labelMedium),
                  SizedBox(height: 17.v),
                  Text(
                    widget.tabType.equalsIgnoreCase('completed')
                        ? getString(lblLoanAmountProductDetail)
                        : datum.productCategory!
                                .equalsIgnoreCase('Personal Loan')
                            ? getString(lblLoanAmountProductDetail)
                            : getString(registrationNoProductDetail),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(height: 1.v),
                  Text(
                    widget.tabType.equalsIgnoreCase('completed')
                        ? formatCurrency(datum.installmentAmount!)
                        : datum.productCategory!
                                .equalsIgnoreCase('Personal Loan')
                            ?formatCurrency(datum.totalAmount!)
                            : datum.vehicleRegistration!,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.tabType.equalsIgnoreCase('completed')
                        ? getString(lblClosedDateProductDetail)
                        : getString(totalAmountPayableProductDetail),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(height: 2.v),
                  Text(
                      widget.tabType.equalsIgnoreCase('completed')
                          ? dueDate
                          : PaymentConstants.rupeeSymbol +
                              datum.totalAmount.toString(),
                      style: Theme.of(context).textTheme.labelMedium),
                  SizedBox(height: 17.v),
                  datum.productCategory!.equalsIgnoreCase('Personal Loan')
                      ? Container()
                      : Text(
                          widget.tabType.equalsIgnoreCase('completed')
                              ? getString(lblNocStatusProductDetail)
                              : getString(nextDueDateProductDetail),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                  SizedBox(height: 4.v),
                  datum.productCategory!.equalsIgnoreCase('Personal Loan')
                      ? Container()
                      : Text(
                          widget.tabType.equalsIgnoreCase('completed')
                              ? getString(lblAvailableProductDetail)
                              : dueDate,
                          style: Theme.of(context).textTheme.labelMedium),
                ],
              )
            ],
          ),
          SizedBox(height: 23.v),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              widget.tabType.equalsIgnoreCase("Active")
                  ? _buildModifyMandate(context, brightness, datum)
                  : Expanded(child: Container()),
              SizedBox(
                width: 17.v,
              ),
              _buildPayNow(context, brightness, datum),
            ],
          ),
          SizedBox(height: 4.v),
        ],
      ),
    );
  }

  DateTime myDate = DateTime.now();

  Widget _buildModifyMandate(
      BuildContext context, Brightness brightness, ActiveLoanData datum) {
    return Expanded(
      child: ElevatedButton(
          style: ButtonStyle(
              padding: MaterialStateProperty.all(EdgeInsets.zero),
              backgroundColor:
                  MaterialStateProperty.all(Theme.of(context).cardColor),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      side: BorderSide(
                          color: brightness == Brightness.light
                              ? AppColors.secondaryLight
                              : AppColors.secondaryLight5)))),
          onPressed: () {
            if (isActiveMandate(datum.mandateStatus ?? "")) {
              if (datum.productCategory!.equalsIgnoreCase("personal loan")) {
                context.pushNamed(lead_gen.Routes.leadGeneration.name,
                    pathParameters: {
                      'leadType': "personal_top_up",
                    });
              } else {
                context.pushNamed(lead_gen.Routes.leadGeneration.name,
                    pathParameters: {
                      'leadType': "vehicle_top_up",
                    });
              }
            } else {
              var loanData = mappingLoanData(datum);
              BlocProvider.of<AchCubit>(context).fetchApplicantName(
                  FetchApplicantNameReq(
                      loanNumber: datum.loanNumber ?? "",
                      ucic: datum.ucic ?? "",
                      cif: datum.cif ?? "",
                      sourceSystem: datum.sourceSystem ?? "",
                      superAppId: getSuperAppId(),
                      source: AppConst.source),
                  loanData);
            }
          },
          child: Text(
              isActiveMandate(datum.mandateStatus ?? "")
                  ? getString(lblAvailTopUpProductDetail)
                  : getString(lblCreateMandateProductDetail),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: setColorBasedOnTheme(
                      context: context,
                      lightColor: AppColors.secondaryLight,
                      darkColor: AppColors.secondaryLight5)))),
    );
  }

  /// Section Widget
  Widget _buildPayNow(
      BuildContext context, Brightness brightness, ActiveLoanData datum) {
    return Expanded(
      child: BlocProvider(
        create: (context) => di<NocCubit>(),
        child: BlocConsumer<NocCubit, NocState>(
          listener: (context, state) {
            if (state is DownloadNocLoading) {
              showLoaderDialog(context, getString(lblLoading));
            }
            if (state is GreenChannelLoading) {
              showLoaderDialog(context, getString(lblLoading));
            }
            if (state is DownloadNocSuccessState) {
              Navigator.of(context, rootNavigator: true).pop();
              if (state.response.code == AppConst.codeFailure) {
                toastForFailureMessage(
                    context: context, msg: getString(msgSomethingWentWrong));
              }
              if (state.response.code == AppConst.codeSuccess) {
                final pdfConverter = ConvertToPdf();
                pdfConverter.downloadPdfFile(
                    context, state.response.data.docContent, DownloadsName.noc);
              }
            }
            if (state is GreenChannelValidationSuccessState) {
              Navigator.of(context, rootNavigator: true).pop();
              if (state.response.code == AppConst.codeFailure) {
                toastForFailureMessage(
                    context: context, msg: getString(msgSomethingWentWrong));
              }
              if (state.response.data?.errorCodes == null ||
                  state.response.data?.errorCodes?.isEmpty == true) {
                context.pushNamed(
                  noc_routes.Routes.nocDetails.name,
                  extra: NocDetailsReq(
                      loanNumber: state.data.loanAccountNumber,
                      ucic: state.data.ucic,
                      productCategory: state.data.productCategory,
                      productName: state.data.productName,
                      endDate: state.data.endDate?.toIso8601String(),
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
                  state.response.data?.errorCodes?.map((e) => e.errorCode).toList().contains("8") ==
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
                  state.response.data?.errorCodes
                          ?.map((e) => e.errorCode)
                          .toList()
                          .contains("13") ==
                      true ||
                  state.response.data?.errorCodes
                          ?.map((e) => e.errorCode)
                          .toList()
                          .contains("14") ==
                      true ||
                  state.response.data?.errorCodes
                          ?.map((e) => e.errorCode)
                          .toList()
                          .contains("16") ==
                      true ||
                  state.response.data?.errorCodes?.map((e) => e.errorCode).toList().contains("17") == true) {
                context.pushNamed(
                  noc_routes.Routes.visitBranch.name,
                );
              } else {
                context.pushNamed(
                  noc_routes.Routes.nocDetails.name,
                  extra: NocDetailsReq(
                      loanNumber: state.data.loanAccountNumber,
                      ucic: state.data.ucic,
                      productCategory: state.data.productCategory,
                      productName: state.data.productName,
                      endDate: state.data.endDate?.toIso8601String(),
                      mobileNumber: state.data.mobileNumber,
                      lob: state.data.lob,
                      sourceSystem: state.data.sourceSystem,
                      nocStatus: state.data.nocStatus,
                      containsRc: state.response.data?.errorCodes
                              ?.map((e) => e.errorCode)
                              .toList()
                              .contains("7") ==
                          true),
                );
              }
            }
          },
          builder: (context, state) => ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      Theme.of(context).highlightColor),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          side: BorderSide(
                              color: Theme.of(context).highlightColor)))),
              onPressed: () {
                if (widget.tabType.equalsIgnoreCase("Active")) {
                  datum.totalPayableAmount = datum.totalAmount;
                  context.pushNamed(Routes.productsPaymentsDetailPage.name,
                      extra: datum);
                } else {
                  if (datum.productCategory
                          ?.equalsIgnoreCase("personal loan") ==
                      true) {
                    context.read<NocCubit>().downloadNoc(
                        DlNocReq(finReference: datum.loanNumber ?? ""));
                  } else if (datum.dpd != null &&
                      (int.tryParse(datum.dpd ?? "0") ?? 0) > 30) {
                    context.pushNamed(noc_routes.Routes.visitBranch.name);
                  } else {
                    context.read<NocCubit>().greenChannelValidationtails(
                        GcValidateReq(loanAccountNumber: datum.loanNumber),
                        LoanData.fromJson(datum.toJson()));
                  }
                }
              },
              child: Text(
                  widget.tabType.equalsIgnoreCase("Active")
                      ? getString(payNowProductDetail)
                      : datum.productCategory
                                  ?.equalsIgnoreCase("personal loan") ==
                              true
                          ? getString(lblDownloadNocProductDetail)
                          : getString(viewNocProductDetail),
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: AppColors.white))),
        ),
      ),
    );
  }

  String formatCurrency(double amount) {
    final formatter = NumberFormat.currency(locale: 'en_IN', symbol: '₹');
    return formatter.format(amount);
  }
}
