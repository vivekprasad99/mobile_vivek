import 'package:core/config/managers/quick_action_manager.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/config/widgets/mf_progress_bar.dart';
import 'package:core/config/widgets/mf_toast.dart';
import 'package:core/utils/const.dart';
import 'package:core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:share_plus/share_plus.dart';

import '../../data/models/get_branches_res.dart';
import '../../data/models/save_branches_req.dart';
import '../cubit/locate_us_cubit.dart';
import '../utils/image_constants.dart';
import '../utils/map_utils.dart';
import 'locate_us_branch_action_button.dart';

class BranchCard extends StatefulWidget {
  final Branch branch;

  const BranchCard({
    super.key,
    required this.branch,
  });

  @override
  State<BranchCard> createState() => _BranchCardState();
}

class _BranchCardState extends State<BranchCard> {
  late bool isSaved;

  @override
  void initState() {
    super.initState();
    isSaved = context.read<LocateUsCubit>().isBranchSaved(widget.branch);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //? branch name & bookmark button
        Row(
          children: [
            //? branch name
            Text(
              widget.branch.name ?? '',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const Spacer(),

            //? Bookmark button
            IconButton(
              style: IconButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)),
              ),
              onPressed: () async {
                if (widget.branch.code != null) {
                  showLoaderDialog(context, getString(lblLoUsLoading));
                  final result = await context.read<LocateUsCubit>().saveBranch(
                        SaveBranchRequest(
                          code: widget.branch.code!,
                          saveBranch: !isSaved,
                          superAppId: getSuperAppId(),
                        ),
                        branch: widget.branch,
                      );
                  if (context.mounted) {
                    Navigator.of(context, rootNavigator: true).pop();
                  }
                  result.fold(
                      (l) => toastForFailureMessage(
                            context: context,
                            msg: getFailureMessage(l),
                          ), (r) {
                    if (r.code == AppConst.codeFailure) {
                      toastForFailureMessage(
                        context: context,
                        msg: getString(r.responseCode ?? ""),
                      );
                    } else {
                      setState(() {
                        isSaved = !isSaved;
                      });
                    }
                  });
                }
              },
              icon: SvgPicture.asset(
                isSaved ? ImageConstant.bookmarkFilled : ImageConstant.bookmark,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        //? Address
        Text(
          widget.branch.address ?? '',
          style: Theme.of(context).textTheme.labelSmall,
        ),
        const SizedBox(height: 4),

        //? Address Metadata
        Builder(builder: (context) {
          String text = '';
          if ((widget.branch.distance ?? 0.0) != 0.0) {
            text += "${widget.branch.distance!.toStringAsFixed(2)} km away • ";
          }
          text += getString(msgLoUsOpenClose);
          return Text(
            text,
            style: Theme.of(context).textTheme.labelSmall!.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 11,
                ),
          );
        }),
        const SizedBox(height: 12),

        //? action buttons
        Row(
          children: [
            //? Get direction
            Builder(builder: (context) {
              final isLocationAvailable = ((widget.branch.lat ?? 0.0) != 0.0 &&
                  (widget.branch.lon ?? 0.0) != 0.0);
              return Visibility(
                visible: isLocationAvailable,
                child: BranchActionButton(
                  text: getString(lblLoUsBranchGetDirection),
                  icon: Icons.fork_right,
                  onTap: () {
                    if (isLocationAvailable) {
                      MapsUtils.launchCoordinates(
                          widget.branch.lat!, widget.branch.lon!);
                    }
                  },
                ),
              );
            }),
            const SizedBox(width: 24),

            //? Call
            Builder(builder: (context) {
              final isMobileAvailable = (widget.branch.number ?? '').isNotEmpty;
              return Visibility(
                visible: isMobileAvailable,
                child: BranchActionButton(
                  text: getString(lblLoUsBranchCall),
                  icon: Icons.call_outlined,
                  onTap: () {
                    if (isMobileAvailable) {
                      QuickActionManager().makePhoneCall(
                        widget.branch.number!,
                        context,
                      );
                    }
                  },
                ),
              );
            }),
            const SizedBox(width: 24),

            //? Share
            BranchActionButton(
              text: getString(lblLoUsBranchShare),
              icon: Icons.share_outlined,
              onTap: () {
                String text = '';
                if ((widget.branch.name ?? '').isNotEmpty) {
                  text += '${widget.branch.name!}\n';
                }
                if ((widget.branch.address ?? '').isNotEmpty) {
                  text += '${widget.branch.address!}\n';
                }
                if ((widget.branch.number ?? '').isNotEmpty) {
                  text += '${widget.branch.number!}\n';
                }
                if (widget.branch.lat != null && widget.branch.lon != null) {
                  text +=
                      MapsUtils.shareUri(widget.branch.lat!, widget.branch.lon!)
                          .toString();
                }
                Share.share(text);
              },
            ),
          ],
        )
      ],
    );
  }
}
