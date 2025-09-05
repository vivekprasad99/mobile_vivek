
import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/config/widgets/mf_custom_elevated_button.dart';
import 'package:core/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:noc/data/models/noc_details_resp.dart';
import 'package:noc/presentation/cubit/noc_cubit.dart';
import 'package:noc/presentation/widgets/out_of_attempts_bottomsheet.dart';

class UpdateRcFailureWidget extends StatelessWidget {
  final NocData data;
  final int attempts;
  const UpdateRcFailureWidget(
      {super.key, required this.data, required this.attempts});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.error_outline,
          size: 44.v,
        ),
        SizedBox(height: 4.v),
        Text(
          getString(msgErrorCheckVehRno),
          style: Theme.of(context).textTheme.titleLarge,
        ),
        SizedBox(height: 4.v),
        Text(
          getString(msgOneAttemptLeft),
          style:
              Theme.of(context).textTheme.labelMedium?.copyWith(fontSize: 16),
        ),
        SizedBox(height: 8.v),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 12.7.v,
              color: data.isCustNameMatched == true
                  ? AppColors.successGreenColor
                  : AppColors.iconColor,
            ),
            SizedBox(width: 4.v),
            Text(
              getString(lblcustomerno),
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: data.isCustNameMatched == true
                      ? AppColors.successGreenColor
                      : AppColors.iconColor),
            ),
          ],
        ),
        SizedBox(height: 4.v),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 12.7.v,
              color: data.isChassisMatched == true
                  ? AppColors.successGreenColor
                  : AppColors.iconColor,
            ),
            SizedBox(width: 4.v),
            Text(
              getString(lblchasisno),
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: data.isChassisMatched == true
                      ? AppColors.successGreenColor
                      : AppColors.iconColor),
            ),
          ],
        ),
        SizedBox(height: 4.v),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 12.7.v,
              color: data.isEngineMatched == true
                  ? AppColors.successGreenColor
                  : AppColors.iconColor,
            ),
            SizedBox(width: 4.v),
            Text(
              getString(lblvehicleno),
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: data.isEngineMatched == true
                      ? AppColors.successGreenColor
                      : AppColors.iconColor),
            ),
          ],
        ),
        SizedBox(height: 4.v),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle_outline,
                size: 12.7.v,
                color: data.isFinancerMatched == true
                    ? AppColors.successGreenColor
                    : AppColors.iconColor),
            SizedBox(width: 4.v),
            Text(
              getString(lblfinancename),
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: data.isFinancerMatched == true
                      ? AppColors.successGreenColor
                      : AppColors.iconColor),
            ),
          ],
        ),
        SizedBox(height: 16.v),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.425,
              child: MfCustomButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  text: getString(lblNocFeatureCancel),
                  outlineBorderButton: true),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.425,
              child: MfCustomButton(
                  onPressed: () async {
                    if (attempts < 2) {
                      context.read<NocCubit>().cancelUpdateRc();
                    } else {
                      context.pop();
                      showModalBottomSheet(
                          context: context,
                          builder: (_) => BlocProvider.value(
                                value: BlocProvider.of<NocCubit>(context),
                                child: OutOfAttemptsBottomsheet(data: data),
                              ));
                    }
                  },
                  text: getString(lblNocFeatureRetry),
                  outlineBorderButton: false),
            ),
          ],
        ),
      ],
    );
  }
}
