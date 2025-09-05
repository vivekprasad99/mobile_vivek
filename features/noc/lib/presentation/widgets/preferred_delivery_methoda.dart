import 'package:core/config/string_resource/strings.dart';
import 'package:core/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noc/presentation/cubit/noc_cubit.dart';

class SelectPreferredMethod extends StatelessWidget {
  final String loanNumber;
  const SelectPreferredMethod({
    required this.loanNumber,
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NocCubit, NocState>(
      buildWhen: (previous, current) => current is PreferredMethodState,
      builder: (context, state) {
        return Column(
          children: [
            SizedBox(height: 24.v),
            Text(
              getString(lblPleaseSelectYourPreferredNoc),
              style:
                  Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 14),
            ),
            SizedBox(height: 16.v),
            Row(
              children: [
                Radio<PreferredMethod>(
                  visualDensity: VisualDensity.compact,
                  activeColor: Theme.of(context).primaryColor,
                  value: PreferredMethod.branch,
                  groupValue: state is PreferredMethodState
                      ? state.preferredMethod
                      : null,
                  onChanged: (PreferredMethod? value) {
                    context
                        .read<NocCubit>()
                        .selectPreferredMethod(PreferredMethod.branch,loanNumber);
                  },
                ),
                Text(
                  getString(lblCollectFromBranch),
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w500),
                )
              ],
            ),
            Row(
              children: [
                Radio<PreferredMethod>(
                  visualDensity: VisualDensity.compact,
                  activeColor: Theme.of(context).primaryColor,
                  value: PreferredMethod.address,
                  groupValue: state is PreferredMethodState
                      ? state.preferredMethod
                      : null,
                  onChanged: (PreferredMethod? value) {
                    context
                        .read<NocCubit>()
                        .selectPreferredMethod(PreferredMethod.address,loanNumber);
                  },
                ),
                Text(
                  getString(lblDeliverToPermanentAddre),
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w500),
                )
              ],
            ),
          ],
        );
      },
    );
  }
}
