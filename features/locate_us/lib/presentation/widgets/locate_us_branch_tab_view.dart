import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:flutter/material.dart';

import '../../data/models/get_branches_res.dart';
import 'locate_us_branch_card.dart';

class BranchTabView extends StatelessWidget {
  final List<Branch> branches;
  final Widget? emptyView;
  const BranchTabView({
    super.key,
    required this.branches,
    this.emptyView,
  });

  @override
  Widget build(BuildContext context) {
    return branches.isEmpty
        ? Center(child: emptyView ?? Text(getString(msgLoUsNothingToShow)))
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //? x branches near you
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  '${branches.length} ${getString(msgLoUsBranchNear)}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),

              //? branch list
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  itemBuilder: (ctx, index) {
                    return BranchCard(
                      key: UniqueKey(),
                      branch: branches[index],
                    );
                  },
                  separatorBuilder: (ctx, index) {
                    return const Padding(
                      padding: EdgeInsets.only(bottom: 16),
                      child: Divider(
                        height: 1,
                        color: AppColors.primaryLight6,
                      ),
                    );
                  },
                  itemCount: branches.length,
                ),
              )
            ],
          );
  }
}
