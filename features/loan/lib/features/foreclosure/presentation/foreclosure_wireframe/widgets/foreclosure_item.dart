import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loan/features/foreclosure/data/models/get_loan_details_request.dart';
import 'package:loan/features/foreclosure/data/models/get_loan_details_response.dart';
import 'package:loan/features/foreclosure/data/models/get_loans_response.dart';
import 'package:loan/features/foreclosure/presentation/cubit/foreclosure_cubit.dart';

class ForeClosureItem extends StatelessWidget {
  const ForeClosureItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    LoanItem? loanItem;
    return BlocBuilder<ForeclosureCubit, ForeclosureState>(
      buildWhen: (context, state) {
        return state is ForeclosureGetLoansSuccessState;
      },
      builder: (context, state) {
        if (state is LoadingState && state.isloading) {
          return  Align(
            alignment: Alignment.bottomCenter,
            child: Center(
                child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
              strokeWidth: 2,
            )),
          );
        }
        if (state is ForeclosureGetLoansSuccessState) {
          return Expanded(
            child: ListView.separated(
              // physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              separatorBuilder: (context, index)
              {
                return Opacity(
                  opacity: 0.5,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 7.0.v),
                  ),
                );
              },
              itemCount: state.response.data?.length ?? 0,
              itemBuilder: (context, index) {
                return BlocBuilder<ForeclosureCubit, ForeclosureState>(
                  builder: (context, loanItemState) {
            
                    return GestureDetector(
                      onTap: () {
                        if (loanItem == state.response.data?[index]) {
                          return;
                        }
                        context
                            .read<ForeclosureCubit>()
                            .setLoanItem(state.response.data?[index]);
                        loanItem = state.response.data?[index];
                        GetLoanDetailsRequest request = GetLoanDetailsRequest(
                            loanNumber: loanItem?.loanNumber,
                            sourceSystem: loanItem?.sourceSystem,
                            productCategory: loanItem?.productCategory,
                            ucic: loanItem?.ucic
                        );
                        BlocProvider.of<ForeclosureCubit>(context).getLoanDetails(
                            request, state.response.data?[index] ?? LoanItem());
                      },
                      child: Container(
                          padding: EdgeInsets.all(9.h),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(
                                8.h,
                              ),
                              border: loanItem == state.response.data?[index]
                                  ? Border.all(color: AppColors.borderLight)
                                  : null),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                  left: 2.h,
                                  right: 10.h,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      // alignment: Alignment.bottomRight,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            "${state.response.data?[index].productCategory
                                                .toString()} | ${ state.response.data?[index]
                                                .loanNumber
                                                .toString()}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall),
                                        Text(
                                           "${getString(lblLoanAmount)} ₹${ state.response.data?[index]
                                               .totalAmount
                                               .toString()}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall
                                                ?.copyWith(
                                              fontWeight: FontWeight.w500,
                                                    letterSpacing: 0.5)),
                                      ],
                                    ),
                                    const Spacer(),
                                    if (loanItem == state.response.data?[index])
                                      Icon(
                                        Icons.check_circle_outline,
                                        color: Theme.of(context).primaryColor,
                                        size: 16.h,
                                      ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20.v),
            
                              Padding(
                                padding: EdgeInsets.only(right: 16.h, top: 4.h),
                                child: SizedBox(
                                  width: 244.h,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              getString(lblTotalAmount),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall,
                                            ),
                                            Text(
                                                "₹${ state.response.data?[index]
                                                    .installmentAmount
                                                    .toString()}",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelLarge),
            
                                          ],
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              getString(lblPendingAmount),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall,
                                            ),
                                            Text(
                                                "₹${ state.response.data?[index]
                                                    .totalPendingAmount
                                                    .toString()}",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelLarge),
            
                                          ],
                                        ),
                                      ),
            
                                    ],
                                  ),
                                ),
                              ),
                              if (loanItem == state.response.data?[index])
                                BlocBuilder<ForeclosureCubit, ForeclosureState>(
                                    builder: (context, state2) {
                                  if (state2 is GetLoanDetailsSuccessState &&
                                      state2.selectLoanItem ==
                                          state.response.data?[index]) {
                                    return showLockingPeriodWarning(state2,context);
                                  }
                                  if (state2 is LoadingState) {
                                    return  Center(
                                        child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Theme.of(context).primaryColor,
                                    ));
                                  }
                                  return  Text(getString(lblError));
                                }),
                              SizedBox(height: 6.v),
                            ],
                            // );
                            // }
                          )),
                    );
                    // }
                  },
                );
              },
            ),
          );
        }

        return  Text(getString(msgSomethingWentWrong));
      },
    );
  }
}

Widget showLockingPeriodWarning(GetLoanDetailsSuccessState state, BuildContext context) {
  LoanDetails? data = state.response.data;

  if (data!.isServiceRequestExist == true || data.isLockingPeriod == true) {
    String validation = (data.isServiceRequestExist ?? false)
        ?getString(msgServiceRequest2)
        : getString(msgForeclosureNot);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
             Icon(
              Icons.error_outline,
              color:Theme.of(context).primaryColor,
            ),
            SizedBox(width: 12.v),
            Flexible(
              child: Text(
                validation,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).hintColor)),
              ),

          ],
        ),
        Row(
          children: [
            SizedBox(height: 10.v),
            data.isServiceRequestExist == true
                ? Text("Service Ticket Status: ${data.serviceRequestStatus}", style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).hintColor))
                : Text(
                    " ${getString(msgLockingPeriod)} ${data.lockingPeriodEndDate ?? ""}", style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).hintColor)),

          ],
        ),
      ],
    );
  }
  return Container();
}
