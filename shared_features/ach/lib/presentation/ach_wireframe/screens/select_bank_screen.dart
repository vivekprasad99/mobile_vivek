import 'package:ach/config/ach_util.dart';
import 'package:ach/config/routes/route.dart';
import 'package:ach/data/models/get_cms_bank_list_resp.dart';
import 'package:ach/data/models/popular_bank_list_res.dart';
import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/resources/custom_elevated_button.dart';
import 'package:core/config/resources/custom_text_form_field.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/config/widgets/background/mf_gradient_background.dart';
import 'package:core/config/widgets/mf_appbar.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
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
import '../../../data/models/get_ach_loans_response.dart';
import '../../../data/models/get_bank_list_resp.dart';
import '../../../data/models/update_mandate_info.dart';
import '../widgets/suggested_bank_widget.dart';
import '../../cubit/ach_cubit.dart';
import '../widgets/verification_widget.dart';

class SelectBankScreen extends StatefulWidget {
  final LoanData loanData;
  final String selectedApplicant;
  final UpdateMandateInfo updateMandateInfo;
  final Source? source;

  const SelectBankScreen(
      {super.key,
      required this.loanData,
      required this.selectedApplicant,
      required this.updateMandateInfo,
      this.source});

  @override
  State<SelectBankScreen> createState() => _SelectBankScreenState();
}

class _SelectBankScreenState extends State<SelectBankScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? selectApplicant;
  String? mandateSource = MandateSource.cams.name;
  List<CMSBank>? masterBankData;
  List<PopularBank>? popularBankData;

  @override
  void initState() {
    super.initState();
    selectApplicant = "${widget.loanData.cif}#&#${widget.loanData.applicantName}";
    context.read<AchCubit>().getCMSBankList();
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
        body: Form(
          key: _formKey,
          child: MFGradientBackground(
            horizontalPadding: 14.h,
            verticalPadding: 12.v,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: _buildActiveLoansFour(context),
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

  Widget _buildActiveLoansFour(BuildContext context) {
    return BlocListener<AchCubit, AchState>(
      listener: (context, state) {
        if (state is GetCMSBankListSuccessState) {
          if (state.response.statusCode == AppConst.codeSuccess) {
            masterBankData = state.response.data?.banks;
            context.read<AchCubit>().getPopularBankList(masterBankData);
          } else {
            toastForFailureMessage(context: context, msg: state.response.message ?? "");
          }
        } else if (state is GetCMSBankListFailureState) {
          toastForFailureMessage(context: context, msg: getFailureMessage(state.failure));
        } else if (state is GetPopularBankListSuccessState) {
          popularBankData = state.response;
          context.read<AchCubit>().getBankList();
        } else if (state is GetPopularBankListFailureState) {
          toastForFailureMessage(context: context, msg: getFailureMessage(state.failure));
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 5.v,
            decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(3.h)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(3.h),
              child: const LinearProgressIndicator(
                value: 0.2,
                backgroundColor: AppColors.primaryLight5,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryLight3),
              ),
            ),
          ),
          SizedBox(height: 20.v),
          RichText(
              text: TextSpan(children: [
                TextSpan(
                  text: getString(widget.loanData.productCategory ?? ""),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                TextSpan(
                  text: " | ${getString(widget.loanData.loanAccountNumber ?? "")}",
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
                  text: " | ${getString(widget.loanData.vehicleRegistration ?? "")}",
                  style: Theme.of(context).textTheme.labelMedium,
                )
              ]),
              textAlign: TextAlign.start),
          SizedBox(height: 10.v),
          if (widget.loanData.coApplicantCIF != null &&
              widget.loanData.coApplicantCIF?.isNotEmpty == true &&
              widget.selectedApplicant.isEmpty)
            SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    getString(lblMandateCreateMandateFor),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  RadioListTile(
                      title: Text(
                        getString(lblLoanApplicant) + widget.loanData.applicantName!,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      value: "${widget.loanData.cif}#&#${widget.loanData.applicantName}",
                      groupValue: selectApplicant,
                      selected: true,
                      activeColor: Theme.of(context).primaryColor,
                      onChanged: (val) {
                        setState(() {
                          selectApplicant = val;
                        });
                      }),
                  RadioListTile(
                      title: Text(
                        getString(lblLoanCoApplicant) + widget.loanData.coApplicantName!,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      value: "${widget.loanData.coApplicantCIF}#&#${widget.loanData.coApplicantName}",
                      groupValue: selectApplicant,
                      activeColor: Theme.of(context).primaryColor,
                      onChanged: (val) {
                        setState(() {
                          selectApplicant = val;
                        });
                      }),
                ],
              ),
            ),
          Divider(
            color: Theme.of(context).dividerColor,
          ),
          SizedBox(height: 10.v),
          Text(
            getString(lblSetUpAccountDetail),
            style: Theme.of(context).textTheme.labelSmall,
            maxLines: 2,
          ),
          SizedBox(height: 20.v),
          Text(getString(lblAccountDetails), style: Theme.of(context).textTheme.titleMedium),
          SizedBox(height: 10.v),
          BlocBuilder<AchCubit, AchState>(
            buildWhen: (prev, curr) {
              return curr is GetBankListSuccessState;
            },
            builder: (context, state) {
              if (state is LoadingState) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor,
                  ),
                );
              }
              if (state is GetBankListSuccessState) {
                if (state.response.code == AppConst.codeSuccess) {
                  mandateSource = state.response.data?.source;
                  var bankList =
                      context.read<AchCubit>().filterPopularBank(state.response.data!.banks!, popularBankData!);
                  if (mandateSource.toString().equalsIgnoreCase(MandateSource.cams.name)) {
                    bankList = context.read<AchCubit>().filterBank(bankList, masterBankData!);
                  }
                  if (bankList.isNotEmpty) {
                    return AutocompleteBankTextField(
                      banks: bankList,
                      popularBank: bankList.where((element) => (element.isPopular == true)).toList(),
                    );
                  } else {
                    return Container();
                  }
                } else {
                  return Container();
                }
              }
              return Container();
            },
          ),
          SizedBox(height: 10.v),
          const VerificationOptionWidget(),
          SizedBox(height: 20.v),
        ],
      ),
    );
  }

  Widget _buildContinue(BuildContext context) {
    return BlocBuilder<AchCubit, AchState>(
      builder: (context, state) {
        return CustomElevatedButton(
          text: getString(lblMandateContinue),
          onPressed: () {
            if (state is SelectNewBankVerificationOtpionState) {
              if (state.option != null && state.option?.optionId != VerificationMode.upi.value) {
                context.pushNamed(Routes.enterBankDetailsScreen.name, extra: {
                  "loanData": widget.loanData,
                  "selectedBank": state.bank,
                  "verificationMode": state.option,
                  "selectedApplicant": widget.loanData.coApplicantCIF == null
                      ? "${widget.loanData.cif}#&#${widget.loanData.applicantName}"
                      : widget.selectedApplicant.isEmpty
                          ? selectApplicant
                          : widget.selectedApplicant,
                  "updateMandateInfo": widget.updateMandateInfo,
                  "source": widget.source,
                  "mandateSource": mandateSource
                });
              } else if (state.option?.optionId == VerificationMode.upi.value) {
                context.pushNamed(Routes.upiScreen.name, extra: {
                  "loanData": widget.loanData,
                  "selectedBank": state.bank,
                  "verificationMode": state.option,
                  "selectedApplicant": widget.loanData.coApplicantCIF == null
                      ? "${widget.loanData.cif}#&#${widget.loanData.applicantName}"
                      : widget.selectedApplicant.isEmpty
                          ? selectApplicant
                          : widget.selectedApplicant,
                  "updateMandateInfo": widget.updateMandateInfo,
                  "source": widget.source
                });
              }
            }
          },
          buttonStyle: ElevatedButton.styleFrom(
              backgroundColor: state is SelectNewBankVerificationOtpionState && state.option != null
                  ? Theme.of(context).highlightColor
                  : Theme.of(context).disabledColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.h),
              )),
          buttonTextStyle: state is SelectNewBankVerificationOtpionState && state.option != null
              ? Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.white)
              : Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).unselectedWidgetColor),
        );
      },
    );
  }
}

class AutocompleteBankTextField extends StatelessWidget {
  final List<Bank> banks;
  final List<Bank> popularBank;

  const AutocompleteBankTextField({super.key, required this.banks, required this.popularBank});

  static String _displayStringForOption(Bank option) => option.bankName!;

  @override
  Widget build(BuildContext context) {
    Bank? bank;
    return Autocomplete<Bank>(
      displayStringForOption: _displayStringForOption,
      fieldViewBuilder: (BuildContext context, TextEditingController textEditingController, FocusNode focusNode,
          VoidCallback onFieldSubmitted) {
        return BlocBuilder<AchCubit, AchState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextFormField(
                  hintText: getString(lblEnterBankName),
                  textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: setColorBasedOnTheme(
                        context: context,
                        lightColor: AppColors.primaryLight,
                        darkColor: AppColors.secondaryLight5,
                      )),
                  hintStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: setColorBasedOnTheme(
                        context: context,
                        lightColor: AppColors.primaryLight,
                        darkColor: AppColors.secondaryLight5,
                      )),
                  textInputAction: TextInputAction.done,
                  controller: textEditingController,
                  focusNode: focusNode,
                  onChanged: (value) {
                    if (state is SelectNewBankState) {
                      if (value.toLowerCase() != state.bank?.bankName) {
                        context.read<AchCubit>().selectNewBank(null);
                      }
                    }
                  },
                  borderDecoration: UnderlineInputBorder(
                    borderRadius: BorderRadius.zero,
                    borderSide: BorderSide(
                      color: setColorBasedOnTheme(
                        context: context,
                        lightColor: AppColors.primaryLight3,
                        darkColor: AppColors.secondaryLight5,
                      ),
                      width: 1,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                popularBank.isEmpty? Container() : SizedBox(
                  height: 50,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: popularBank.where((element) => element.isPopular == true).length <= 4
                        ? popularBank.where((element) => element.isPopular == true).length
                        : 4,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(right: 10.h, top: 8.0),
                        child: SuggestedItemWidget(
                          bank: popularBank[index],
                          isSelected: bank == popularBank[index],
                          onSelectedChipView: (val) {
                            bank = popularBank[index];
                            textEditingController.text = bank?.bankName ?? "";
                            FocusScope.of(context).unfocus();
                            context.read<AchCubit>().selectNewBank(bank);
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text == '') {
          return const Iterable<Bank>.empty();
        }

        return banks.where(
          (Bank option) {
            return option.bankName!.toLowerCase().toString().contains(textEditingValue.text.toLowerCase());
          },
        );
      },
      onSelected: (option) {
        context.read<AchCubit>().selectNewBank(option);
      },
    );
  }
}
