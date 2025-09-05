import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/utils/size_utils.dart';
import 'package:core/utils/extensions/extension.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loan/features/loan_cancellation/data/models/get_lc_list_response.dart';
import 'package:loan/features/loan_cancellation/presentation/cubit/loan_cancellation_cubit.dart';

class LoanCancellationItemList extends StatelessWidget {
  const LoanCancellationItemList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    LoanCancelItem? loanItem;
    return BlocBuilder<LoanCancellationCubit, LoanCancellationState>(
      buildWhen: (context, state) {
        return state is LoanCancellationGetLoansSuccessState;
      },
      builder: (context, state) {
        if (state is LoadingState && state.isloading) {
          return Align(
            alignment: Alignment.bottomCenter,
            child: Center(
                child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
              strokeWidth: 2,
            )),
          );
        }
        if (state is LoanCancellationGetLoansSuccessState) {
          return ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            separatorBuilder: (
              context,
              index,
            ) {
              return Opacity(
                opacity: 0.5,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 7.0.v),
                ),
              );
            },
            itemCount: state.response.data?.length ?? 0,
            itemBuilder: (context, index) {
              return BlocBuilder<LoanCancellationCubit, LoanCancellationState>(
                builder: (context, loanItemState) {
                  return GestureDetector(
                    onTap: () {
                      if (loanItem == state.response.data?[index]) {
                        return;
                      }
                      context
                          .read<LoanCancellationCubit>()
                          .setLoanItem(state.response.data?[index]);
                      loanItem = state.response.data?[index];
                    },
                    child: Container(
                        padding: EdgeInsets.all(9.h),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(8.h),
                          border: Border.all(
                              color: loanItem == state.response.data?[index]
                                  ? AppColors.borderLight
                                  : Theme.of(context).cardColor),
                        ),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.75,
                                        child: Text(
                                          "${state.response.data?[index].productCategory} | ${(state.response.data?[index].productName ?? "")}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall
                                              ?.copyWith(
                                                  letterSpacing: 0.1,
                                                  height: 1.4),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 4.v,
                                      ),
                                      Text(
                                          "${getString(lblAccountNo)} ${state.response.data?[index].loanAccountNumber.toString()}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall),
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
                            SizedBox(height: 24.v),
                            Padding(
                              padding: EdgeInsets.only(right: 16.h, top: 4.h),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        getString(lblLcLoanAmount),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                      ),
                                      SizedBox(
                                        height: 4.v,
                                      ),
                                      Text(
                                        RupeeFormatter(state.response
                                                    .data?[index].totalAmount ??
                                                0)
                                            .inRupeesFormat(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelLarge
                                            ?.copyWith(
                                                fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        getString(lblLcEmiAmount),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                      ),
                                      Text(
                                        RupeeFormatter(state
                                                    .response
                                                    .data?[index]
                                                    .totalPendingAmount ??
                                                0)
                                            .inRupeesFormat(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelLarge
                                            ?.copyWith(
                                                fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )),
                  );
                },
              );
            },
          );
        }

        return Text(getString(msgLcMsgSomethingWentWrong));
      },
    );
  }
}
