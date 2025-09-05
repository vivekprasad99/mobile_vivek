import 'package:core/config/string_resource/strings.dart';
import 'package:core/config/widgets/background/mf_gradient_background.dart';
import 'package:core/config/widgets/mf_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/models/get_branches_res.dart';
import '../widgets/locate_us_branch_tab_view_widget.dart';
import '../widgets/locate_us_icon_button.dart';
import '../widgets/locate_us_state_city_location_widget.dart';

class LocateUsBranchListScreen extends StatefulWidget {
  final List<GetBranchesResponse> res;
  const LocateUsBranchListScreen({
    super.key,
    required this.res,
  });

  @override
  State<LocateUsBranchListScreen> createState() =>
      _LocateUsBranchListScreenState();
}

class _LocateUsBranchListScreenState extends State<LocateUsBranchListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(
        context: context,
        title: getString(lblLoUsLocateUs),
        onPressed: () => Navigator.pop(context),
      ),
      body: MFGradientBackground(
        horizontalPadding: 0.w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //? Enter pincode & locate button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  //? Enter pincode
                  Expanded(
                    child: LocateUsStateCityLocationWidget(
                      text: widget.res[0].branchList?.first.location ?? '',
                    ),
                  ),

                  //? locate button
                  const LocateUsButton(),
                ],
              ),
            ),
            SizedBox(height: 8.h),

            Expanded(
              child: LocateUsBranchTabViewWidget(
                isForMap: false,
                branches: widget.res[0].branchList ?? [],
                dealers: widget.res[1].branchList ?? [],
                saved: widget.res[2].branchList ?? [],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
