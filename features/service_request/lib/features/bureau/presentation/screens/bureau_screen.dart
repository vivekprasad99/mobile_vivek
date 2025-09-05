import 'package:common/config/routes/route.dart' as common;
import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/config/widgets/background/mf_gradient_background.dart';
import 'package:core/config/widgets/common_widgets/mf_custom_checkbox_button.dart';
import 'package:core/config/widgets/common_widgets/mf_custom_drop_down.dart';
import 'package:core/config/widgets/custom_buttons/mf_custom_elevated_button.dart';
import 'package:core/config/widgets/mf_appbar.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:core/services/di/injection_container.dart';
import 'package:core/utils/const.dart';
import 'package:core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:loan/features/foreclosure/data/models/get_loans_request.dart';
import 'package:loan/features/foreclosure/data/models/get_loans_response.dart';
import 'package:service_request/config/routes/route.dart' as bureau;
import 'package:service_request/features/bureau/data/models/bureau_response.dart';
import 'package:service_request/features/bureau/data/models/loan_payment_request.dart';
import 'package:service_request/features/bureau/data/models/reason_response.dart';
import 'package:service_request/features/bureau/data/models/service_data.dart';
import 'package:service_request/features/bureau/presentation/cubit/bureau_cubit.dart';

class BureauScreen extends StatefulWidget {
  const BureauScreen({super.key});

  @override
  State<BureauScreen> createState() => _BureauScreenState();
}

class _BureauScreenState extends State<BureauScreen> {
  bool isBureauSelect = false;
  String isReasonSelect = "";
  String isProductSelect = "";
  List<Bureau>? bureauData;
  List<Reason>? reasonData;
  List<LoanItem>? loanData;
  LoanItem? loanItem;
  bool isButtonDisable = true;
  bool isLoading = true;
  String none="none";

  @override
  void initState() {
    super.initState();
    final bureauCubit = BlocProvider.of<BureauCubit>(context);
    bureauCubit.getBureaus();
    bureauCubit.getReason();
  }

  @override
  Widget build(BuildContext context) {
    GetLoansRequest request = GetLoansRequest(ucic: getUCIC()); //60015640338
    BlocProvider.of<BureauCubit>(context).getLoans(request);

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: customAppbar(
            context: context,
            title: getString(lblBureauServices),
            onPressed: () {
              context.goNamed(common.Routes.home.name, extra: 4);
            }),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: BlocConsumer<BureauCubit, BureauState>(
          listener: (context, state) {
            if (state is GetPaymentSuccessState) {
              if (state.response.code == AppConst.codeSuccess) {
                if (state.response.paymentHistory != null &&
                    state.response.paymentHistory!.isNotEmpty) {
                  if (isValidDayCheck(
                      state.response.paymentHistory?.first.lastPaymentDate)) {
                    final selectedBureaus =
                        context.read<BureauCubit>().getSelectedBureaus();

                    context.pushNamed(
                        bureau.Routes.serviceBureauUploadDocuments.name,
                        extra: ServiceDataModel(
                            loanItem: loanItem,
                            selectedBureaus: selectedBureaus,
                            selectedReason: isReasonSelect,
                            selectedProduct: isProductSelect));
                  } else {
                    openBottomSheet(context,
                        state.response.paymentHistory?.first.lastPaymentDate);
                  }
                } else {
                  final selectedBureaus =
                      context.read<BureauCubit>().getSelectedBureaus();

                  context.pushNamed(
                      bureau.Routes.serviceBureauUploadDocuments.name,
                      extra: ServiceDataModel(
                          loanItem: loanItem,
                          selectedBureaus: selectedBureaus,
                          selectedReason: isReasonSelect,
                          selectedProduct: isProductSelect));
                }
              } else {
                showSnackBar(context: context, message: state.response.message);
              }
            }
          },
          builder: (context, state) {
            if (state is ButtonEnableState) {
              isButtonDisable = state.isButtonDisable;
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: MfCustomButton(
                onPressed: () {
                  if (isProductSelect == none) {
                    final selectedBureaus =
                        context.read<BureauCubit>().getSelectedBureaus();

                    context.pushNamed(
                        bureau.Routes.serviceBureauUploadDocuments.name,
                        extra: ServiceDataModel(
                            loanItem: loanItem,
                            selectedBureaus: selectedBureaus,
                            selectedReason: isReasonSelect,
                            selectedProduct: isProductSelect));
                  } else if (validateAndProceed()) {
                    PaymentRequest request = PaymentRequest(
                        loanNumber: loanItem?.loanNumber,
                        sourceSystem: loanItem?.sourceSystem);

                    BlocProvider.of<BureauCubit>(context)
                        .getLoanPayment(request);
                  }
                },
                leftIcon: (state is BureauLoadingState &&
                        state.isLoadingPaymentLastDate)
                    ? true
                    : false,
                isDisabled: isButtonDisable,
                text: getString(lblBureauProceed),
                outlineBorderButton: false,
              ),
            );
          },
        ),
        body: MFGradientBackground(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      getString(lblSelectBureau),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      getString(lblBureauSelect),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                BlocBuilder<BureauCubit, BureauState>(
                  buildWhen: (prev, curr) => curr is BureauSuccessState,
                  builder: (context, state) {
                    if (state is BureauLoadingState && state.isLoadingBureaus) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is BureauSuccessState) {
                      bureauData = state.response.data ?? [];
                      List<Widget> bureauWidgets = bureauData!.map((bureau) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                          child: multiCheckBox(
                            context,
                            bureau.name ?? "",
                            bureau.isSelected,
                            (bool? newValue) {
                              BlocProvider.of<BureauCubit>(context)
                                  .toggleSelection(
                                      bureauData!, bureauData!.indexOf(bureau));

                              context
                                  .read<BureauCubit>()
                                  .proceedButtonVisibility(bureauData ?? [],
                                      isReasonSelect, isProductSelect);
                            },
                          ),
                        );
                      }).toList();

                      return Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(4)),
                        child: Column(
                          children: bureauWidgets,
                        ),
                      );
                    } else {
                      return Text(
                        getString(lblBureauTryAfterSometime),
                      );
                    }
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                BlocBuilder<BureauCubit, BureauState>(
                  buildWhen: (prev, curr) => curr is ReasonSuccessState,
                  builder: (context, state) {
                    if (state is BureauLoadingState && state.isLoadingBureaus) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is ReasonSuccessState) {
                      reasonData = state.response.data!;

                      List<DropdownMenuEntry<String>> dropdownMenuEntries =
                          reasonData!.map((reason) {
                        return DropdownMenuEntry<String>(
                          value: reason.id ?? "",
                          label: reason.name ?? "",
                          style: MenuItemButton.styleFrom(

                            backgroundColor: setColorBasedOnTheme(
                                context: context,
                                lightColor: AppColors.white,
                                darkColor: AppColors.emptyContainerDark),

                            foregroundColor: setColorBasedOnTheme(
                                context: context,
                                lightColor: AppColors.primaryLight,
                                darkColor: AppColors.white),

                            textStyle: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(
                                    fontSize: 16, color: AppColors.white),
                          ),
                        );
                      }).toList();

                      return Center(
                        child: MfCustomDropDown(
                          menuHeight: 300,
                          title: getString(lblSelectReason),
                          dropdownMenuEntries: dropdownMenuEntries,

                          onSelected: (val) {
                            isReasonSelect = val ?? "";
                            context.read<BureauCubit>().proceedButtonVisibility(
                                bureauData ?? [],
                                isReasonSelect,
                                isProductSelect);

                            BlocProvider.of<BureauCubit>(context)
                                .isLoanNotReflect(isReasonSelect);
                          },
                        ),
                      );
                    } else {
                      return Text(
                        getString(lblBureauTryAfterSometime),
                      );
                    }
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                BlocBuilder<BureauCubit, BureauState>(
                    buildWhen: (prev, curr) =>
                        curr is GetLoansSuccessState ||
                        curr is IsShowLoanNotReflect,
                    builder: (context, state) {
                      if (state is BureauLoadingState &&
                          state.isLoadingBureaus) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is IsShowLoanNotReflect) {
                        if (state.isShowLoanNotReflect != "3") {
                          BlocProvider.of<BureauCubit>(context)
                              .getLoans(request);
                        }
                        return BlocBuilder<BureauCubit, BureauState>(
                          buildWhen: (prev, curr) =>
                              curr is IsShowLoanNotReflect,
                          builder: (context, state) {
                            if (state is IsShowLoanNotReflect) {
                              return MfCustomDropDown(
                                  title: getString(lblSelectProduct),
                                  onSelected: (val) {
                                    isProductSelect = val ?? "";
                                    context
                                        .read<BureauCubit>()
                                        .proceedButtonVisibility(
                                            bureauData ?? [],
                                            isReasonSelect,
                                            isProductSelect);
                                  },
                                  dropdownMenuEntries: [
                                    if (state.isShowLoanNotReflect == "3")
                                      DropdownMenuEntry<String>(
                                        value: none,
                                        label: 'Loan account num not available',
                                        style: MenuItemButton.styleFrom(
                                          backgroundColor: setColorBasedOnTheme(
                                              context: context,
                                              lightColor: AppColors.white,
                                              darkColor: AppColors.emptyContainerDark),

                                          foregroundColor: setColorBasedOnTheme(
                                              context: context,
                                              lightColor: AppColors.primaryLight,
                                              darkColor: AppColors.white),

                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .labelLarge
                                              ?.copyWith(
                                              fontSize: 16, color: AppColors.white),
                                        ),
                                      )
                                  ]);
                            } else {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          },
                        );
                      } else if (state is GetLoansSuccessState) {
                        loanData = state.response.data ?? [];

                        List<DropdownMenuEntry<String>> dropdownMenuEntries =
                            loanData!.map((loan) {
                          return DropdownMenuEntry<String>(
                            value: loan.loanNumber ?? "",
                            label:
                                '${loan.productCategory} (${loan.loanNumber})',
                            style: MenuItemButton.styleFrom(
                              backgroundColor: setColorBasedOnTheme(
                                  context: context,
                                  lightColor: AppColors.white,
                                  darkColor: AppColors.emptyContainerDark),

                              foregroundColor: setColorBasedOnTheme(
                                  context: context,
                                  lightColor: AppColors.primaryLight,
                                  darkColor: AppColors.white),

                              textStyle: Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(
                                  fontSize: 16, color: AppColors.white),
                            ),
                          );
                        }).toList();

                        return Center(
                          child: MfCustomDropDown(
                            menuHeight: 300,
                            onSelected: (val) {
                              // Find the selected loan item
                              loanItem = loanData!.firstWhere(
                                  (loan) => loan.loanNumber == val,
                                  orElse: () => LoanItem());

                              if (loanItem != null) {
                                loanItem = loanItem;
                                // Proceed with further actions using loanItem
                                isProductSelect = val ?? "";
                                context
                                    .read<BureauCubit>()
                                    .proceedButtonVisibility(bureauData ?? [],
                                        isReasonSelect, isProductSelect);
                              }
                            },
                            title: getString(lblSelectProduct),
                            dropdownMenuEntries: dropdownMenuEntries,
                          ),
                        );
                      } else {
                        return Text(
                          getString(lblBureauTryAfterSometime),
                        );
                      }
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool validateAndProceed() {
    isBureauSelect = bureauData!.any((element) => element.isSelected);
    if (isBureauSelect &&
        isReasonSelect.isNotEmpty &&
        isProductSelect.isNotEmpty) {
      return true;
    } else {
      showSnackBar(context: context, message: getString(lblSelectFieldsEmpty));
      return false;
    }
  }

  Widget multiCheckBox(BuildContext context, String name, bool val,
      ValueChanged<bool?> onChange) {
    return MfCustomCheckboxButton(
      padding: const EdgeInsets.all(8),
      activeColor: Theme.of(context).primaryColor,
      checkColor: Theme.of(context).scaffoldBackgroundColor,
      textAlignment: TextAlign.center,
      isExpandedText: false,
      alignment: Alignment.center,
      text: name,
      value: val,
      textStyle: Theme.of(context).textTheme.bodySmall!,
      onChange: onChange,
    );
  }

  void openBottomSheet(BuildContext context, String? lastPaymentDate) {
    showModalBottomSheet<void>(
      isScrollControlled: true,
      context: context,
      builder: (_) {
        return BlocProvider<BureauCubit>(
          create: (context) => di<BureauCubit>(),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "${getString(msgBureau1)}$lastPaymentDate ${getString(msgBureau2)}",
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                        child: MfCustomButton(
                      outlineBorderButton: true,
                      onPressed: () {
                        context.pop();
                        context.goNamed(
                          common.Routes.home.name,
                        );
                      },
                      text: getString(goToHome),
                    )),
                    const SizedBox(
                      width: 10,
                    ),
                    BlocBuilder<BureauCubit, BureauState>(
                      builder: (context, state) {
                        return Expanded(
                            child: MfCustomButton(
                          outlineBorderButton: false,
                          leftIcon: (state is BureauLoadingState &&
                                  state.isLoadingPaymentLastDate)
                              ? true
                              : false,
                          onPressed: () {
                            final selectedBureaus = context
                                .read<BureauCubit>()
                                .getSelectedBureaus();
                            context.pop();

                            context.pushNamed(
                                bureau.Routes.serviceBureauUploadDocuments.name,
                                extra: ServiceDataModel(
                                    loanItem: loanItem,
                                    selectedBureaus: selectedBureaus,
                                    selectedReason: isReasonSelect,
                                    selectedProduct: isProductSelect));
                          },
                          text: getString(raiseATicket),
                        ));
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  DateTime _parseDate(String dateStr) {
    if (dateStr.contains('-')) {
      List<String> parts = dateStr.split('-');
      int year = int.parse(parts[0]);
      int month = int.parse(parts[1]);
      int day = int.parse(parts[2]);
      return DateTime(year, month, day);
    } else {
      List<String> parts = dateStr.split('/');
      int day = int.parse(parts[0]);
      int month = int.parse(parts[1]);
      int year = int.parse(parts[2]);
      return DateTime(year, month, day);
    }
  }

  bool isValidDayCheck(String? lastPaymentDate) {
    String? lastPaymentDateStr = lastPaymentDate;
    DateTime lastPayment = _parseDate(lastPaymentDateStr!);
    DateTime currentDate = DateTime.now();
    Duration difference = currentDate.difference(lastPayment);

    if (difference.inDays <= 45) {
      return false;
    } else {
      return true;
    }
  }
}
