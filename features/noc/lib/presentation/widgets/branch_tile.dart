import 'package:core/config/resources/app_colors.dart';
import 'package:core/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locate_us/data/models/get_branches_res.dart';
import 'package:locate_us/presentation/cubit/locate_us_cubit.dart';

class BranchTile extends StatelessWidget {
  final Branch branch;
  const BranchTile({super.key, required this.branch});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocateUsCubit, LocateUsState>(
      buildWhen: (previous, current) => current is SelectBranchState,
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(8.h),
            border: Border.all(
                color: (state is SelectBranchState && state.branch == branch)
                    ? AppColors.borderLight
                    : AppColors.primaryLight6),
          ),
          child: ListTile(
            contentPadding: EdgeInsets.only(left: 12.0.v, right: 12.0.v),
            onTap: () {
              context.read<LocateUsCubit>().selectbranch(branch);
            },
            title: Text(
              branch.name ?? "",
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              "${branch.address}",
              style: Theme.of(context).textTheme.labelSmall,
            ),
            trailing: (state is SelectBranchState && state.branch == branch)
                ? Column(
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        color: Theme.of(context).primaryColor,
                        size: 16.h,
                      ),
                    ],
                  )
                : null,
          ),
        );
      },
    );
  }
}
