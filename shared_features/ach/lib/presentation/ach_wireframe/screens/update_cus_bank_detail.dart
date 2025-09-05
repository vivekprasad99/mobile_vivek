import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/resources/custom_elevated_button.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/config/widgets/background/mf_gradient_background.dart';
import 'package:core/config/widgets/common_widgets/custom_floating_text_field.dart';
import 'package:core/config/widgets/common_widgets/mf_custom_drop_down.dart';
import 'package:core/config/widgets/mf_appbar.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:core/utils/size_utils.dart';
import 'package:core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:help/features/utils/constant_help.dart';
import 'package:help/features/utils/help_common_widget.dart';
import '../../../config/ach_util.dart';
import '../../../data/models/fetch_bank_accoun_response.dart';
import '../../../data/models/get_ach_loans_response.dart';
import '../../../data/models/get_bank_list_resp.dart';
import '../../../data/models/update_mandate_info.dart';
import '../widgets/mandate_preview_bottomsheet.dart';

class UpdateCusBankDetail extends StatefulWidget {
  final LoanData loanData;
  final BankData bankData;
  final VerificationOption verificationMode;
  final String selectedApplicant;
  final UpdateMandateInfo updateMandateInfo;
  final String source;

  const UpdateCusBankDetail(
      {super.key,
      required this.loanData,
      required this.bankData,
      required this.verificationMode,
      required this.selectedApplicant,
      required this.updateMandateInfo,
      required this.source});

  @override
  State<UpdateCusBankDetail> createState() => _UpdateCusBankDetailState();
}

class _UpdateCusBankDetailState extends State<UpdateCusBankDetail> {
  List<AccountType> accountType = <AccountType>[
    AccountType.savingAccount,
    AccountType.currentAccount
  ];
  ValueNotifier<bool> isValidated = ValueNotifier<bool>(false);
  final TextEditingController ifscCode = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AccountType? selectedAccountType;

  @override
  void initState() {
    super.initState();
    if (widget.bankData.ifscCode?.isNotEmpty == true) {
      ifscCode.text = widget.bankData.ifscCode!;
    }
    selectedAccountType = accountType.first;
  }

  @override
  void dispose() {
    ifscCode.dispose();
    super.dispose();
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
        body: MFGradientBackground(
          horizontalPadding: 14.h,
          verticalPadding: 12.v,
          child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10.v),
                          Container(
                            height: 5.v,
                            decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(3.h)),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(3.h),
                              child: const LinearProgressIndicator(
                                value: 0.2,
                                backgroundColor: AppColors.primaryLight5,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.primaryLight3),
                              ),
                            ),
                          ),
                          SizedBox(height: 20.v),
                          _buildActiveLoansFour(context, widget.bankData),
                          SizedBox(height: 10.v),
                          _ifscCodeWidget(context),
                          SizedBox(height: 10.v),
                          _accountTypeWidget1(context),
                        ],
                      ),
                    ),
                  ),
                  _buildContinue(
                      context: context,
                      loanData: widget.loanData,
                      bankData: widget.bankData,
                      verificationMode: widget.verificationMode,
                      accountType: selectedAccountType ?? AccountType.savingAccount,
                      selectedApplicant: widget.selectedApplicant),
                  SizedBox(height: 20.v,)
                ],
              )),
        )
      ),
    );
  }

  Widget _buildActiveLoansFour(BuildContext context, BankData bankData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(8.h),
              border: null),
          child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        bankData.bankName ?? "",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                  SizedBox(height: 7.v),
                  Text(
                    formatAccountNumber(bankData.bankAccountNo ?? ""),
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ],
              )),
        ),
        SizedBox(height: 20.v),
        Text(
          getString(msfConfirmBankDetail),
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(letterSpacing: 0.15),
        ),
      ],
    );
  }

  Widget _ifscCodeWidget(BuildContext context) {
    return MfCustomFloatingTextField(
        textCapitalization: TextCapitalization.characters,
      labelText: getString(msgEnterBranchIfsc),
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
      controller: ifscCode,
      onChange: (val) {
        validateForm();
      },
        inputFormatters: [
          IFSCInputFormatter(),
        ],
      validator: (value) {
        if (value!.isEmpty || !isValidIFSC(value)) {
          return getString(msgErrorInvalidIFSC);
        }
        return null;
      }
    );
  }

  Widget _buildContinue(
      {required BuildContext context,
      required LoanData loanData,
      required BankData bankData,
      required VerificationOption verificationMode,
      required AccountType accountType,
      required String selectedApplicant}) {
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
                    showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (_) => MandatePreviewBottomSheet(
                              loanData: loanData,
                              verificationMode: verificationMode,
                              bankCode: bankData.bankCode ?? "",
                              bankName: bankData.bankName ?? "",
                              accountType: accountType,
                              bankAccountNumber:
                                  bankData.bankAccountNo ?? "",
                              ifscCode: ifscCode.text,
                              selectedApplicant: selectedApplicant,
                              payerName: "",
                              payerVpa: "",
                              updateMandateInfo: widget.updateMandateInfo,
                              mandateSource: widget.source,
                            ));
                  }
                : null,
          );
        });
  }

  Widget _accountTypeWidget1(BuildContext context) {
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

  void validateForm() {
    _formKey.currentState!.validate();
    if (ifscCode.text.isNotEmpty && selectedAccountType != null && isValidIFSC(ifscCode.text)) {
      isValidated.value = true;
    } else {
      isValidated.value = false;
    }
  }
}
