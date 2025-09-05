import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noc/data/models/get_loan_list_resp.dart';
import 'package:noc/presentation/cubit/noc_cubit.dart';

class NocListItem extends StatelessWidget {
  final String query;
  final LoanData loanData;
  const NocListItem({super.key, required this.loanData, required this.query});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NocCubit, NocState>(
      buildWhen: (previous, current) => current is SelectNocItem,
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            context.read<NocCubit>().setNocItem(loanData, query);
          },
          child: Container(
            padding: EdgeInsets.all(9.h),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(8.h),
              border: Border.all(
                  color: (state is SelectNocItem && state.loanData == loanData)
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.75,
                            child: Text(
                              "${loanData.productCategory} | ${loanData.loanAccountNumber.toString()}",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(letterSpacing: 0.1, height: 1.4),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(
                            height: 4.v,
                          ),
                          Text("${loanData.productName}",
                              style: Theme.of(context).textTheme.bodySmall),
                        ],
                      ),
                      const Spacer(),
                      if (state is SelectNocItem && state.loanData == loanData)
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            getString(lblVehicleRegNo),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          SizedBox(
                            height: 4.v,
                          ),
                          Text(
                            loanData.vehicleRegistration ?? "",
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            getString(lblNocFeatureNocStatus),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          Text(
                            _nocMap(loanData.nocStatus),
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(fontWeight: FontWeight.w400),
                          ),
                        ],
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
  }
}

String _nocMap(String? nocStatus) {
  if (nocStatus == null) {
    return getString(lblNotInitiated);
  } else if (nocStatus.contains("1")) {
    return getString(lblUnderProcess);
  } else if (nocStatus.contains("2")) {
    return getString(lblDelivered);
  } else if (nocStatus.contains("3")) {
    return getString(lblNocCancelled);
  }
  return nocStatus.toString();
}
