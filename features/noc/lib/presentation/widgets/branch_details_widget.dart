
import 'package:core/config/string_resource/strings.dart';
import 'package:core/utils/size_utils.dart';
import 'package:flutter/material.dart';

class BranchDetailsWidget extends StatelessWidget {
  final String? branchName;
  final String? branchLocation;
  const BranchDetailsWidget({
    super.key,
    required this.branchLocation,
    required this.branchName,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16.v),
        Text(
          getString(lblBranchName),style: Theme.of(context).textTheme.bodySmall,
        ),
        SizedBox(height: 4.v,),
        Text(
          branchName??"",style: Theme.of(context).textTheme.labelSmall,
        ),
        SizedBox(height: 16.v,),
        Text(
          getString(lblBranchLocation),style: Theme.of(context).textTheme.bodySmall,
        ),
         SizedBox(height: 4.v,),
        Text(
         branchLocation??"",style: Theme.of(context).textTheme.labelSmall,
        ),
      ],
    );
  }
}
