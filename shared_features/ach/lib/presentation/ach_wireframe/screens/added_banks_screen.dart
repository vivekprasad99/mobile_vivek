import 'package:ach/config/routes/route.dart';
import 'package:ach/data/models/get_ach_loans_response.dart';
import 'package:ach/data/models/update_mandate_info.dart';
import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/resources/custom_elevated_button.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/config/widgets/background/mf_gradient_background.dart';
import 'package:core/config/widgets/mf_appbar.dart';
import 'package:core/config/widgets/mf_progress_bar.dart';
import 'package:core/config/widgets/mf_toast.dart';
import 'package:core/utils/const.dart';
import 'package:core/utils/size_utils.dart';
import 'package:core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:help/features/utils/constant_help.dart';
import 'package:help/features/utils/help_common_widget.dart';

import '../../../config/source.dart';
import '../../../data/models/fetch_bank_accoun_response.dart';
import '../../../data/models/fetch_bank_account_req.dart';
import '../../cubit/ach_cubit.dart';

class AddedBanksList extends StatefulWidget {
  final LoanData loanData;
  final List<BankData>? bankData;
  final UpdateMandateInfo updateMandateInfo;
  final Source? source;

  const AddedBanksList(
      {super.key,
      required this.loanData,
      required this.bankData,
      required this.updateMandateInfo,
      this.source});

  @override
  State<AddedBanksList> createState() => _AddedBanksListState();
}

class _AddedBanksListState extends State<AddedBanksList> {
  String? selectedApplicant;

  @override
  void initState() {
    super.initState();
    selectedApplicant =
        "${widget.loanData.cif}#&#${widget.loanData.applicantName}";
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: customAppbar(
          context: context,
          title: getString(lblMandateCreateMandate),
          onPressed: () {
            Navigator.pop(context);
          },
          actions: [HelpCommonWidget(categoryval: HelpConstantData.categoryMandateRegistration,subCategoryval: HelpConstantData.subCategoryBankSelection)],
        ),
        body: BlocListener<AchCubit, AchState>(
          listener: (context, state) {
            if (state is FetchBankAccountSuccessState) {
              if (state.response.code == AppConst.codeSuccess) {
                setState(() {});
              } else {
                toastForFailureMessage(
                    context: context, msg: getString(msgSomethingWentWrong));
              }
            } else if (state is FetchBankAccountFailureState) {
              toastForFailureMessage(
                  context: context, msg: getString(msgSomethingWentWrong));
            } else if (state is LoadingDialogState) {
              if (state.isloading) {
                showLoaderDialog(context, getString(lblMandateLoading));
              } else {
                Navigator.of(context, rootNavigator: true).pop();
              }
            }
          },
          child: MFGradientBackground(
            horizontalPadding: 14.h,
            verticalPadding: 12.v,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 5.v,
                            decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(3.h)),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(3.h),
                              child: const LinearProgressIndicator(
                                value: 0.0,
                                backgroundColor: AppColors.primaryLight5,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.primaryLight3),
                              ),
                            ),
                          ),
                          SizedBox(height: 20.v),
                          RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                  text: getString(
                                      widget.loanData.productCategory ?? ""),
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                TextSpan(
                                  text:
                                      " | ${getString(widget.loanData.loanAccountNumber ?? "")}",
                                  style: Theme.of(context).textTheme.bodyLarge,
                                )
                              ]),
                              textAlign: TextAlign.start),
                          SizedBox(height: 2.v),
                          RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                  text: getString(widget.loanData.productName ?? ""),
                                  style: Theme.of(context).textTheme.labelMedium,
                                ),
                                TextSpan(
                                  text:
                                      " | ${getString(widget.loanData.vehicleRegistration ?? "")}",
                                  style: Theme.of(context).textTheme.labelMedium,
                                )
                              ]),
                              textAlign: TextAlign.start),
                          SizedBox(height: 10.v),
                          Divider(
                            color: Theme.of(context).dividerColor,
                          ),
                          SizedBox(height: 10.v),
                          Text(
                            getString(lblSetUpAccountDetail),
                            style: Theme.of(context).textTheme.labelSmall,
                            maxLines: 2,
                          ),
                          if (widget.loanData.coApplicantCIF != null &&
                              widget.loanData.coApplicantCIF?.isNotEmpty == true)
                            SizedBox(
                              width: double.infinity,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    getString(lblMandateCreateMandateFor),
                                    style: Theme.of(context).textTheme.bodyLarge,
                                  ),
                                  SizedBox(
                                    height: 5.v,
                                  ),
                                  Text(
                                    getString(lblSetUpAccountDetail),
                                    style: Theme.of(context).textTheme.labelMedium,
                                    maxLines: 2,
                                  ),
                                  SizedBox(
                                    height: 10.v,
                                  ),
                                  RadioListTile(
                                      title: Text(
                                        getString(lblLoanApplicant) +
                                            widget.loanData.applicantName!,
                                        style: Theme.of(context).textTheme.bodyMedium,
                                      ),
                                      value:
                                          "${widget.loanData.cif}#&#${widget.loanData.applicantName}",
                                      groupValue: selectedApplicant,
                                      selected: true,
                                      activeColor: Theme.of(context).primaryColor,
                                      onChanged: (val) {
                                        selectedApplicant = val;
                                        BlocProvider.of<AchCubit>(context)
                                            .fetchBankAccount(
                                                FetchBankAccountRequest(
                                                    loanAccountNumber: widget.loanData
                                                            .loanAccountNumber ??
                                                        "",
                                                    ucic: widget.loanData.ucic ?? "",
                                                    cif: widget.loanData.cif ?? "",
                                                    superAppId: getSuperAppId(),
                                                    source: AppConst.source),
                                                widget.loanData);
                                      }),
                                  RadioListTile(
                                      title: Text(
                                        getString(lblLoanCoApplicant) +
                                            widget.loanData.coApplicantName!,
                                        style: Theme.of(context).textTheme.bodyMedium,
                                      ),
                                      value:
                                          "${widget.loanData.coApplicantCIF}#&#${widget.loanData.coApplicantName}",
                                      groupValue: selectedApplicant,
                                      activeColor: Theme.of(context).primaryColor,
                                      onChanged: (val) {
                                        selectedApplicant = val;
                                        BlocProvider.of<AchCubit>(context)
                                            .fetchBankAccount(
                                                FetchBankAccountRequest(
                                                    loanAccountNumber: widget.loanData
                                                            .loanAccountNumber ??
                                                        "",
                                                    ucic: widget.loanData.ucic ?? "",
                                                    cif: widget.loanData
                                                            .coApplicantCIF ??
                                                        "",
                                                    superAppId: getSuperAppId(),
                                                    source: AppConst.source),
                                                widget.loanData);
                                      }),
                                ],
                              ),
                            ),
                          SizedBox(height: 20.v),
                          Text(
                            getString(msgPleaseSelectAn),
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          SizedBox(height: 7.v),
                          BankItems(
                            accountList: widget.bankData,
                          )
                        ]),
                  ),
                ),
                _buildContinue(context),
                SizedBox(height: 20.v,)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContinue(BuildContext context) {
    return Stack(alignment: Alignment.bottomRight, children: [
      BlocBuilder<AchCubit, AchState>(
        builder: (context, state) {
          return CustomElevatedButton(
            isDisabled: false,
            text: getString(lblMandateContinue),
            alignment: Alignment.topCenter,
            buttonStyle: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).highlightColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.h),
                )),
            onPressed: () {
              if (selectedApplicant == null || selectedApplicant!.isEmpty) {
                selectedApplicant =
                    "${widget.loanData.cif}#&#${widget.loanData.coApplicantName}";
              }
              if (state is SelectBankState) {
                if (state.bank == null) {
                  context.pushNamed(Routes.selectBankScreen.name, extra: {
                    "loanData": widget.loanData,
                    "selectedApplicant": widget.loanData.coApplicantCIF ==
                            null
                        ? "${widget.loanData.cif}#&#${widget.loanData.applicantName}"
                        : selectedApplicant,
                    "updateMandateInfo": widget.updateMandateInfo,
                    "source": widget.source
                  });
                } else {
                  context.pushNamed(Routes.bankVerifyOptions.name, extra: {
                    "loanData": widget.loanData,
                    "bankData": state.bank,
                    "selectedApplicant": widget.loanData.coApplicantCIF ==
                            null
                        ? "${widget.loanData.cif}#&#${widget.loanData.applicantName}"
                        : selectedApplicant,
                    "updateMandateInfo": widget.updateMandateInfo
                  });
                }
              } else {
                context.pushNamed(Routes.selectBankScreen.name, extra: {
                  "loanData": widget.loanData,
                  "selectedApplicant": widget.loanData.coApplicantCIF ==
                          null
                      ? "${widget.loanData.cif}#&#${widget.loanData.applicantName}"
                      : selectedApplicant,
                  "updateMandateInfo": widget.updateMandateInfo,
                  "source": widget.source
                });
              }
            },
          );
        },
      ),
    ]);
  }
}

class BankItems extends StatefulWidget {
  final List<BankData>? accountList;
  const BankItems({super.key, required this.accountList});

  @override
  State<BankItems> createState() => _BankItemsState();
}

class _BankItemsState extends State<BankItems> {
  BankData? selectedbank;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: widget.accountList!.length + 1,
      itemBuilder: (context, index) {
        return BlocBuilder<AchCubit, AchState>(
          builder: (context, selectedbankState) {
            return GestureDetector(
              onTap: () {
                selectedbank =
                    index == widget.accountList!.length ? null : widget.accountList?[index];
                context.read<AchCubit>().selectBank(selectedbank);
              },
              child: index == widget.accountList?.length
                  ? Container(
                      height: 75.v,
                      decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(8.h),
                          border: selectedbank == null
                              ? Border.all(color: AppColors.borderLight)
                              : null),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.add_card_outlined,
                                  color: Theme.of(context).primaryColor,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  getString(lblAddNewAccount),
                                ),
                              ],
                            ),
                            if (selectedbank == null)
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Icon(
                                  Icons.check_circle_outline,
                                  color: Theme.of(context).primaryColor,
                                  size: 16.h,
                                ),
                              ),
                          ],
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      child: Container(
                        height: 75.v,
                        padding: const EdgeInsets.only(
                            top: 10.0, left: 20.0, bottom: 15.0),
                        decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(8.h),
                            border: selectedbank == widget.accountList?[index]
                                ? Border.all(color: AppColors.borderLight)
                                : null),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  widget.accountList![index].bankName ?? "",
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                if (selectedbank == widget.accountList?[index])
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Icon(
                                      Icons.check_circle_outline,
                                      color: Theme.of(context).primaryColor,
                                      size: 16.h,
                                    ),
                                  ),
                              ],
                            ),
                            SizedBox(height: 7.v),
                            Text(
                              formatAccountNumber(
                                  widget.accountList?[index].bankAccountNo ?? ""),
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                          ],
                        ),
                      ),
                    ),
            );
          },
        );
      },
    );
  }
}
