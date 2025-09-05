import 'package:ach/config/ach_util.dart';
import 'package:ach/config/source.dart';
import 'package:ach/data/models/fetch_applicant_name_req.dart';
import 'package:ach/data/models/fetch_bank_account_req.dart';
import 'package:ach/data/models/update_mandate_info.dart';
import 'package:ach/presentation/cubit/ach_cubit.dart';
import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/resources/custom_image_view.dart';
import 'package:core/config/resources/image_constant.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/config/widgets/background/mf_gradient_background.dart';
import 'package:core/config/widgets/common_widgets/mf_custom_drop_down.dart';
import 'package:core/config/widgets/custom_buttons/mf_custom_elevated_button.dart';
import 'package:core/config/widgets/mf_appbar.dart';
import 'package:core/config/widgets/mf_progress_bar.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:core/config/widgets/mf_toast.dart';
import 'package:core/utils/const.dart';
import 'package:core/utils/date_time_utils.dart';
import 'package:core/utils/size_utils.dart';
import 'package:core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:loan/features/foreclosure/data/models/get_loans_request.dart';
import 'package:loan/features/foreclosure/data/models/get_loans_response.dart';
import 'package:loan/features/foreclosure/presentation/cubit/foreclosure_cubit.dart'
    as foreclosure;
import 'package:ach/config/routes/route.dart' as ach_mandate;
import 'package:common/features/search/data/model/search_response.dart';
import '../../../config/routes/route.dart';
import '../../../config/utils.dart';
import '../helper/constant_data.dart';

class SelectDetailsPage extends StatefulWidget {
  final ServicesNavigationRequest selectDetailParam;

  const SelectDetailsPage({
    required this.selectDetailParam,
    super.key});

  @override
  State<SelectDetailsPage> createState() => _SelectDetailsPageState();
}

class _SelectDetailsPageState extends State<SelectDetailsPage> {
  final TextEditingController? controller = TextEditingController();
  String? docType;

  @override
  void initState() {
    super.initState();
    _setSelectedDoc();
    _callLoanListAPI();
  }

  @override
  Widget build(BuildContext context) {
    LoanItem? loanItem;
    Brightness brightness = Theme.of(context).brightness;
    ButtonStyle menuStyle = MenuItemButton.styleFrom(
      foregroundColor: AppColors.primaryLight,
      textStyle: Theme.of(context)
          .textTheme
          .labelMedium
          ?.copyWith(fontSize: 16, color: AppColors.textLight),
    );
    var cardName = widget.selectDetailParam.cardName;
    controller?.text = widget.selectDetailParam.cardType?? "";

    return Scaffold(
      appBar: customAppbar(
          context: context,
          title: cardName == "loan" ? getString(lblLoanDocument) : getString(lblEMandates),
          onPressed: () {
            context.pop();
          }),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: BlocListener<AchCubit, AchState>(
          listener: (context, state) {
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
                    context: context, msg: getString(msgSomethingWentWrong));
              }
            } else if (state is FetchBankAccountFailureState) {
              toastForFailureMessage(
                  context: context, msg: getString(msgSomethingWentWrong));
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
            padding: const EdgeInsets.only(right: 12, left: 12, bottom: 28),
            child: MfCustomButton(
                onPressed: () {
                  if (cardName == "eMandates") {
                    if (loanItem != null) {
                      var loanData = mappingLoanData(loanItem ?? LoanItem());
                      if (isActiveMandate(loanItem?.mandateStatus ?? "")) {
                        context.pushNamed(
                            ach_mandate.Routes.mandateDetailsScreen.name,
                            extra: {"loanData": loanData});
                      } else if (isSetMandate(loanItem?.mandateStatus ?? "")) {
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
                    } else {
                      toastForFailureMessage(
                          context: context, msg: getString(msgSelectLoan));
                    }
                  } else {
                    if(loanItem != null){
                      context.pushNamed(Routes.documentDetailsScreen.name,
                          extra: {'docType': docType, 'loanItem': loanItem});
                    }else{
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(getString(lblSelectLoanAccount))),
                      );
                    }
                  }
                },
                text: getString(lblContinue),
                outlineBorderButton: false),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: MFGradientBackground(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            cardName == 'loan'
                ? MfCustomDropDown(
                    title: getString(lblSelect),
                    selectedController: controller,
                    onSelected: (newValue) {
                      if (newValue is String) {
                        controller?.text = newValue;
                      }
                      _setSelectedDoc(newValue);
                    },
                    dropdownMenuEntries: [
                        DropdownMenuEntry<String>(
                            value: getString(lblRepaymentSchedule),
                            label: getString(lblRepaymentSchedule),
                            style: menuStyle),
                        DropdownMenuEntry<String>(
                            value: getString(lbl_statementOfAcount),
                            label: getString(lbl_statementOfAcount),
                            style: menuStyle),
                        DropdownMenuEntry<String>(
                            value: getString(lblKeyFactStatement),
                            label: getString(lblKeyFactStatement),
                            style: menuStyle),
                      ])
                : MfCustomDropDown(
                    title: getString(lblSelect),
                    selectedController: controller,
                    onSelected: (newValue) {
                      if (newValue is String) {
                        controller?.text = newValue;
                        _callLoanListAPI();
                      }
                    },
                    dropdownMenuEntries: [
                      DropdownMenuEntry<String>(
                          value: getString(lblCreate), label:getString(lblCreate), style: menuStyle),
                      DropdownMenuEntry<String>(
                          value: getString(lblModify), label: getString(lblModify), style: menuStyle),
                    ],
                  ),
            Expanded(
              child: BlocBuilder<foreclosure.ForeclosureCubit,
                  foreclosure.ForeclosureState>(
                buildWhen: (context, state) {
                  return state is foreclosure.ForeclosureGetLoansSuccessState ||
                      state is foreclosure.LoadingState;
                },
                builder: (context, state) {
                  if (state is foreclosure.LoadingState) {
                    return state.isloading
                        ? Align(
                            alignment: Alignment.bottomCenter,
                            child: Center(
                                child: CircularProgressIndicator(
                              color: Theme.of(context).primaryColor,
                              strokeWidth: 2,
                            )),
                          )
                        : Container();
                  }
                  if (state is foreclosure.ForeclosureGetLoansSuccessState) {
                    if (state.response.code == AppConst.codeSuccess &&
                        (state.response.data?.isNotEmpty ?? false)) {
                      List<LoanItem>? loanList = state.response.data;

                      if (cardName == "eMandates") {
                        List<LoanItem>? filteredLoanList = [];
                        if (controller?.text.equalsIgnoreCase("Create") ??
                            false) {
                          filteredLoanList = state.response.data
                              ?.where((element) =>
                          (!isActiveMandate(element.mandateStatus ?? "") && !element.loanStatus.toString().equalsIgnoreCase("Closed") && !isMandateDisable(element.mandateStatus ?? "", element.sourceSystem ?? "")))
                              .toList();
                        } else {
                          filteredLoanList = state.response.data
                              ?.where((element) =>
                          (isActiveMandate(element.mandateStatus ?? "") && !element.loanStatus.toString().equalsIgnoreCase("Closed") && !isMandateDisable(element.mandateStatus ?? "", element.sourceSystem ?? "")))
                              .toList();
                        }
                        loanList = filteredLoanList;
                      }
                      return loanList!.isNotEmpty
                          ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 28),
                                Text(
                                  getString(lblSelectALoan),
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                const SizedBox(height: 8),
                                Expanded(
                                  child: ListView.separated(
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      LoanItem responseLoanItem = LoanItem();
                                      responseLoanItem = loanList![index];
                                      return BlocBuilder<
                                          foreclosure.ForeclosureCubit,
                                          foreclosure.ForeclosureState>(
                                        builder: (context, loanItemState) {
                                          return GestureDetector(
                                            onTap: () {
                                              if (loanItem ==
                                                  responseLoanItem) {
                                                return;
                                              }
                                              context
                                                  .read<
                                                      foreclosure
                                                      .ForeclosureCubit>()
                                                  .setLoanItem(
                                                      responseLoanItem);
                                              loanItem = responseLoanItem;
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 0,
                                                      vertical: 8),
                                              decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                      .cardColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.h),
                                                  border: loanItem ==
                                                          responseLoanItem
                                                      ? Border.all(
                                                          color: AppColors
                                                              .borderLight)
                                                      : null),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  ListTile(
                                                    leading: Container(
                                                      decoration: const BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          8))),
                                                      child: (responseLoanItem
                                                                      .productCategory ??
                                                                  "")
                                                              .toLowerCase()
                                                              .contains(ConstantData
                                                                  .vehicleLoanText)
                                                          ? SvgPicture.asset(
                                                              brightness ==
                                                                      Brightness
                                                                          .light
                                                                  ? ImageConstant
                                                                      .imgVehicleLoanIconLight
                                                                  : ImageConstant
                                                                      .imgVehicleLoanIconDark,
                                                            )
                                                          : SvgPicture.asset(
                                                              brightness ==
                                                                      Brightness
                                                                          .light
                                                                  ? ImageConstant
                                                                      .imgPersonalLoanRupeeLight
                                                                  : ImageConstant
                                                                      .imgPersonalLoanRupeeDark,
                                                            ),
                                                    ),
                                                    title: Text(
                                                        "${responseLoanItem.productCategory.toString()} | ${responseLoanItem.loanNumber.toString()}",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodySmall
                                                            ?.copyWith(
                                                                letterSpacing:
                                                                    0.5,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500)),
                                                    subtitle: Text(
                                                        getSubtitle(
                                                                responseLoanItem) ??
                                                            "",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyMedium),
                                                  ),
                                                  Divider(
                                                    color: Theme.of(context)
                                                        .dividerColor,
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 16.0,
                                                        vertical: 10),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                getString(lblEmiAmount),
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .bodySmall,
                                                              ),
                                                              Text(
                                                                  "₹${responseLoanItem.installmentAmount}",
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .labelSmall),
                                                            ],
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 20,
                                                        ),
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                getString(lblNextDueDate),
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .bodySmall,
                                                              ),
                                                              Builder(builder:
                                                                  (context) {
                                                                final date =
                                                                    responseLoanItem
                                                                        .nextDuedate
                                                                        ?.formatDate();
                                                                return Text(
                                                                    date ?? '',
                                                                    style: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .labelSmall);
                                                              }),
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
                                        },
                                      );
                                    },
                                    separatorBuilder: (context, index) {
                                      return Opacity(
                                        opacity: 0.5,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 8.0.v),
                                        ),
                                      );
                                    },
                                    itemCount: loanList.length,
                                  ),
                                ),
                              ],
                            )
                          : _buildEmptyScreen(context);
                    } else {
                      _buildEmptyScreen(context);
                    }
                  }
                  return Text(getString(msgSomethingWentWrong));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _callLoanListAPI() {
    GetLoansRequest request = GetLoansRequest(ucic: getUCIC());
    BlocProvider.of<foreclosure.ForeclosureCubit>(context).getLoans(request);
  }

  void _setSelectedDoc([String? selectedDoc]) {
    docType = selectedDoc ?? widget.selectDetailParam.cardType ?? '';
    docType = docType?.toLowerCase();
    if (docType == 'Key fact statement'.toLowerCase()) {
      docType = 'kfs';
    } else if (docType == 'Statement Of Account'.toLowerCase()) {
      docType = 'soa';
    } else {
      docType = "rs";
    }
  }
}

_buildEmptyScreen(BuildContext context) {
  return Align(
    alignment: Alignment.center,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
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
        Text(getString(lblNoProducts),
            style: Theme.of(context).textTheme.bodyLarge),
      ],
    ),
  );
}

getSubtitle(LoanItem? loanItem) {
  return loanItem?.productCategory?.toLowerCase() == 'vehicle loan'
      ? loanItem?.vehicleRegistration ?? ""
      : '${getString(lblLoanAmount)} ₹ ${loanItem?.totalAmount}';
}
