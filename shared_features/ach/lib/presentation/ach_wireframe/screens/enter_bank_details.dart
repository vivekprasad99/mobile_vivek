import 'package:ach/config/ach_const.dart';
import 'package:ach/config/routes/route.dart';
import 'package:ach/data/models/add_bank_detail_model.dart';
import 'package:ach/data/models/payer_detail_model.dart';
import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/resources/custom_elevated_button.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/config/widgets/background/mf_gradient_background.dart';
import 'package:core/config/widgets/common_widgets/custom_floating_text_field.dart';
import 'package:core/config/widgets/common_widgets/mf_custom_drop_down.dart';
import 'package:core/config/widgets/mf_appbar.dart';
import 'package:core/config/widgets/mf_progress_bar.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:core/config/widgets/mf_toast.dart';
import 'package:core/routes/extension.dart';
import 'package:core/utils/const.dart';
import 'package:core/utils/size_utils.dart';
import 'package:core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:help/features/utils/constant_help.dart';
import 'package:help/features/utils/help_common_widget.dart';

import '../../../config/ach_util.dart';
import '../../../config/source.dart';
import '../../../data/models/get_ach_loans_response.dart';
import '../../../data/models/get_bank_list_resp.dart';
import '../../../data/models/penny_drop_req.dart';
import '../../../data/models/update_mandate_info.dart';
import '../../cubit/ach_cubit.dart';
import '../widgets/mandate_preview_bottomsheet.dart';

class EnterBankDetailsScreen extends StatefulWidget {
  final LoanData loanData;
  final Bank selectedBank;
  final VerificationOption verificationMode;
  final String selectedApplicant;
  final UpdateMandateInfo updateMandateInfo;
  final Source? source;
  final String mandateSource;

  const EnterBankDetailsScreen(
      {super.key,
      required this.loanData,
      required this.selectedBank,
      required this.verificationMode,
      required this.selectedApplicant,
      required this.updateMandateInfo,
      required this.mandateSource,
      required this.source});

  @override
  State<EnterBankDetailsScreen> createState() => _EnterBankDetailsScreenState();
}

class _EnterBankDetailsScreenState extends State<EnterBankDetailsScreen> {
  List<AccountType> accountType = <AccountType>[
    AccountType.savingAccount,
    AccountType.currentAccount
  ];
  ValueNotifier<bool> isValidated = ValueNotifier<bool>(false);
  final TextEditingController accountNumber = TextEditingController();
  final TextEditingController reAccountNumber = TextEditingController();
  final TextEditingController ifscCode = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int currentAttempt = 0;
  AccountType? selectedAccountType;
  @override
  void dispose() {
    accountNumber.dispose();
    reAccountNumber.dispose();
    ifscCode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    selectedAccountType = accountType.first;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: customAppbar(
          context: context,
          title: widget.source?.title ?? getString(lblMandateCreateMandate),
          onPressed: () {
            Navigator.pop(context);
          },
          actions: [HelpCommonWidget(categoryval: HelpConstantData.categoryMandateRegistration,subCategoryval: HelpConstantData.subCategoryBankSelection)],
        ),
        body: MFGradientBackground(
          horizontalPadding: 14.h,
          verticalPadding: 12.v,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                    child: Form(
                        key: _formKey,
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
                                  value: 0.3,
                                  backgroundColor: AppColors.primaryLight5,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      AppColors.primaryLight3),
                                ),
                              ),
                            ),
                            SizedBox(height: 20.v),
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(8.h)),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, right: 10.0, bottom: 20.0, top: 20.0),
                                child: Text(
                                  widget.selectedBank.bankName ?? "",
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                              ),
                            ),
                            SizedBox(height: 10.v),
                            Padding(
                              padding: EdgeInsets.only(left: 7.h),
                              child: Text(getString(lblAccountDetails),
                                  style: Theme.of(context).textTheme.titleMedium),
                            ),
                            _buildAccountNumberWidget(context),
                            SizedBox(height: 10.v),
                            _confirmAccountNumberWidget(context),
                            SizedBox(height: 10.v),
                            _ifscCodeWidget(context),
                            SizedBox(height: 10.v),
                            _accountTypeWidget(context),

                          ],
                        ))),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: setColorBasedOnTheme(
                      context: context,
                      lightColor: Colors.white,
                      darkColor: AppColors.cardDark),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline,
                          color: AppColors.yellowIconColor),
                      const SizedBox(
                        width: 8,
                      ),
                      Flexible(
                          child: Text(
                            getString(msgToVerifyYourBank),
                          ))
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.v,),
              _buildContinue(
                  context: context,
                  loanData: widget.loanData,
                  selectedBank: widget.selectedBank,
                  verificationMode: widget.verificationMode,
                  accountType: selectedAccountType ?? AccountType.savingAccount,
                  selectedApplicant: widget.selectedApplicant),
              SizedBox(height: 20.v,),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAccountNumberWidget(BuildContext context) {
    return MfCustomFloatingTextField(
      labelText: getString(msgEnterAccountNumber),
      textInputAction: TextInputAction.next,
      textInputType: TextInputType.number,
      alignment: Alignment.topCenter,
      controller: accountNumber,
      onChange: (value) {
        validateForm();
      },
      borderDecoration: UnderlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(
          color: setColorBasedOnTheme(
            context: context,
            lightColor: AppColors.primaryLight,
            darkColor: AppColors.secondaryLight5,
          ),
          width: 1,
        ),
      ),

      textStyle: Theme.of(context)
          .textTheme
          .bodySmall
          ?.copyWith(
          color: setColorBasedOnTheme(
            context: context,
            lightColor: AppColors.primaryLight,
            darkColor: AppColors.secondaryLight5,
          )),
      labelStyle: Theme.of(context)
          .textTheme
          .bodySmall
          ?.copyWith(
          color: setColorBasedOnTheme(
            context: context,
            lightColor: AppColors.primaryLight,
            darkColor: AppColors.secondaryLight5,
          )),
      validator: (value) {
        if (value!.isEmpty || !isValidBankAccount(value)) {
          return getString(msgErrorEnterBankAccount);
        }
        return null;
      }
    );
  }

  Widget _confirmAccountNumberWidget(BuildContext context) {
    return MfCustomFloatingTextField(
      controller: reAccountNumber,
      labelText: getString(msgReEnterAccount),
        textStyle: Theme.of(context)
            .textTheme
            .bodySmall
            ?.copyWith(
            color: setColorBasedOnTheme(
              context: context,
              lightColor: AppColors.primaryLight,
              darkColor: AppColors.secondaryLight5,
            )),
        labelStyle: Theme.of(context)
            .textTheme
            .bodySmall
            ?.copyWith(
            color: setColorBasedOnTheme(
              context: context,
              lightColor: AppColors.primaryLight,
              darkColor: AppColors.secondaryLight5,
            )),
      textInputAction: TextInputAction.next,
      textInputType: TextInputType.number,
      borderDecoration: UnderlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(
          color: setColorBasedOnTheme(
            context: context,
            lightColor: AppColors.primaryLight,
            darkColor: AppColors.secondaryLight5,
          ),
          width: 1,
        ),
      ),
      onChange: (val) {
        validateForm();
      },
      validator: (value) {
        if (value!.isEmpty || accountNumber.text != value) {
          return getString(msgErrorSameBankAccount);
        }
        return null;
      }
    );
  }

  /// Section Widget
  Widget _ifscCodeWidget(BuildContext context) {
    return MfCustomFloatingTextField(
      labelText: getString(msgEnterBranchIfsc),
      textCapitalization: TextCapitalization.characters,
      hintText: getString(msgEnterBranchIfsc),
      borderDecoration: UnderlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(
          color: setColorBasedOnTheme(
            context: context,
            lightColor: AppColors.primaryLight,
            darkColor: AppColors.secondaryLight5,
          ),
          width: 1,
        ),
      ),
        textStyle: Theme.of(context)
            .textTheme
            .bodySmall
            ?.copyWith(
            color: setColorBasedOnTheme(
              context: context,
              lightColor: AppColors.primaryLight,
              darkColor: AppColors.secondaryLight5,
            )),
        labelStyle: Theme.of(context)
            .textTheme
            .bodySmall
            ?.copyWith(
            color: setColorBasedOnTheme(
              context: context,
              lightColor: AppColors.primaryLight,
              darkColor: AppColors.secondaryLight5,
            )),
      textInputAction: TextInputAction.next,
      textInputType: TextInputType.text,
        inputFormatters: [
          IFSCInputFormatter(),
        ],
      controller: ifscCode,
      onChange: (val) {
        validateForm();
      },
      validator: (value) {
        if (value!.isEmpty || !isValidIFSC(value)) {
          return getString(msgErrorInvalidIFSC);
        }
        return null;
      }
    );
  }


  Widget _accountTypeWidget(BuildContext context) {
    return MfCustomDropDown<AccountType>(
      title: getString(lblAccountType),
      initialValue: AccountType.savingAccount,
      onSelected: (val) {
        selectedAccountType = val;
        validateForm();
      },
      textStyle: Theme.of(context)
          .textTheme
          .bodySmall
          ?.copyWith(
          color: setColorBasedOnTheme(
            context: context,
            lightColor: AppColors.primaryLight,
            darkColor: AppColors.secondaryLight5,
          )),
      dropdownMenuEntries: accountType
          .map(
            (e) => DropdownMenuEntry(
              value: e,
              label: e.label,
            ),
          )
          .toList(),
    );
  }

  Widget _buildContinue(
      {required BuildContext context,
      required LoanData loanData,
      required Bank selectedBank,
      required VerificationOption verificationMode,
      required AccountType accountType,
      required String selectedApplicant}) {
    return BlocConsumer<AchCubit, AchState>(
      listener: (context, state) {
        if (state is PennyDropSuccessState) {
          currentAttempt++;
          if (currentAttempt >= AchConst.maxPennyDropAttempt) {
            isValidated.value = false;
          }
          if (state.response.code == AppConst.codeSuccess) {
            if (state.response.pennyDropDetail?.accountStatus ==
                AchConst.activePennyDropAccount) {
              if (state.response.pennyDropDetail?.nameMatchSuccess ?? false) {
                if (widget.source != null &&
                    widget.source?.purpose == Purpose.pennyDrop) {
                  GoRouter.of(context).popUntilPath(
                    widget.source?.callBackRoute ?? '',
                  );
                  return;
                }
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (_) => MandatePreviewBottomSheet(
                        loanData: loanData,
                        verificationMode: verificationMode,
                        bankCode: selectedBank.bankCode ?? "",
                        bankName: selectedBank.bankName ?? "",
                        accountType: accountType,
                        bankAccountNumber: accountNumber.text,
                        ifscCode: ifscCode.text,
                        selectedApplicant: selectedApplicant,
                        payerName: "",
                        payerVpa: "",
                        updateMandateInfo: widget.updateMandateInfo,
                        source: widget.source,
                        mandateSource: widget.mandateSource));
              } else {
                var bankAccountDetail = BankAccountDetail();
                bankAccountDetail.bankAccountNo = accountNumber.text;
                bankAccountDetail.accountType = selectedAccountType?.value;
                bankAccountDetail.ifscCode = ifscCode.text;
                context.pushNamed(Routes.nameMismatchScreen.name, extra: {
                  "loanData": widget.loanData,
                  "selectedBank": widget.selectedBank,
                  "selectedApplicant": widget.selectedApplicant,
                  "verificationMode": widget.verificationMode,
                  "bankAccountDetail": bankAccountDetail,
                  "vpaPayerDetail": VpaPayerDetail(),
                  "updateMandateInfo": widget.updateMandateInfo
                });
              }
            } else {
              toastForFailureMessage(
                  context: context,
                  msg: getString(msgPennyDropInActiveAccount));
            }
          } else {
            toastForFailureMessage(
                context: context, msg: getString(msgSomethingWentWrong));
          }
        } else if (state is PennyDropFailureState) {
          currentAttempt++;
          if (currentAttempt >= AchConst.maxPennyDropAttempt) {
            isValidated.value = false;
          }
          toastForFailureMessage(
              context: context, msg: getString(msgPennyDropInActiveAccount));
        } else if (state is LoadingDialogState) {
          if (state.isloading) {
            showLoaderDialog(context, getString(lblMandateLoading));
          } else {
            Navigator.of(context, rootNavigator: true).pop();
          }
        }
      },
      builder: (context, state) {
        return ValueListenableBuilder(
            valueListenable: isValidated,
            builder: (context, bool isValid, child) {
              return CustomElevatedButton(
                text: getString(lblMandateContinue),
                buttonStyle: ElevatedButton.styleFrom(
                    backgroundColor: isValid
                        ? Theme.of(context).highlightColor
                        : Theme.of(context).disabledColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.h),
                    )),
                buttonTextStyle: isValid
                    ? Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: AppColors.white)
                    : Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).unselectedWidgetColor),
                onPressed: isValid
                    ? () {
                        if (currentAttempt < AchConst.maxPennyDropAttempt) {
                          context.read<AchCubit>().pennyDrop(
                                PennyDropReq(
                                    beneficiaryAccount: accountNumber.text,
                                    beneficiaryIFSC: ifscCode.text,
                                    customerName: widget.selectedApplicant
                                        .split('#&#')[1],
                                    mobileNumber: getPhoneNumber(),
                                    loanAccountNumber:
                                        loanData.loanAccountNumber,
                                    ucic: getUCIC(),
                                    verificationMode:
                                        getVerificationModeShortCode(widget
                                                    .verificationMode
                                                    .optionId ??
                                                "")
                                            .shortCode,
                                    accountType: selectedAccountType?.value,
                                    superAppId: getSuperAppId(),
                                    source: AppConst.source),
                              );
                        }
                      }
                    : null,
              );
            });
      },
    );
  }

  void validateForm() {
    _formKey.currentState!.validate();
    if (accountNumber.text.isNotEmpty &&
        reAccountNumber.text.isNotEmpty &&
        accountNumber.text == reAccountNumber.text &&
        ifscCode.text.isNotEmpty && isValidIFSC(ifscCode.text) &&
        selectedAccountType != null) {
      isValidated.value = true;
    } else {
      isValidated.value = false;
    }
  }
}
