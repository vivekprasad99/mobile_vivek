import 'dart:convert';
import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/config/widgets/mf_custom_elevated_button.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:core/config/widgets/mf_toast.dart';
import 'package:core/utils/const.dart';
import 'package:core/utils/pref_utils.dart';
import 'package:core/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:noc/data/models/noc_details_resp.dart';
import 'package:noc/data/models/rc_attempt_model.dart';
import 'package:noc/data/models/update_rc_details_req.dart';
import 'package:noc/presentation/cubit/noc_cubit.dart';
import 'package:noc/presentation/widgets/update_rc_failure_widget.dart';

class UpdateRcBottomsheet extends StatefulWidget {
  final String loanNumber;
  final NocData data;
  const UpdateRcBottomsheet({
    super.key,
    required this.loanNumber,
    required this.data,
  });

  @override
  State<UpdateRcBottomsheet> createState() => _UpdateRcBottomsheetState();
}

class _UpdateRcBottomsheetState extends State<UpdateRcBottomsheet> {
  final TextEditingController rcController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.v),
      width: double.infinity,
      child: BlocConsumer<NocCubit, NocState>(
        listener: (context, state) {
          if (state is GetNocDetailsSuccessState &&
              state.response.code == AppConst.codeSuccess) {
            context.pop();
            toastForSuccessMessage(
                context: context, msg: getString(lblRcUpdateSuccess));
          }
        },
        builder: (context, state) {
          if (state is UpdateRCLoadingState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  getString(lblPleaseWaitWhileWeVerifyDetails),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 24.0.v),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                MfCustomButton(
                    onPressed: () {
                      context.read<NocCubit>().cancelUpdateRc();
                    },
                    text: getString(lblNocFeatureCancel),
                    outlineBorderButton: true),
              ],
            );
          }
          if (state is GetNocDetailsSuccessState &&
              state.response.code == AppConst.codeFailure) {
            if (state.response.data != null) {
               List<String>? rcAttemptsListdencoded =
                  PrefUtils.getStringList(PrefUtils.rcAttempts);
              List<RcAttempt>? rcAttemptsList = rcAttemptsListdencoded
                  .map((item) => RcAttempt.fromJson(jsonDecode(item)))
                  .toList();
              if (rcAttemptsList
                  .map((e) => e.loanNumber)
                  .toList()
                  .contains(widget.data.loanAccountNumber)) {
                RcAttempt rcAttempt = rcAttemptsList.firstWhere((element) =>
                    element.loanNumber == widget.data.loanAccountNumber);
                int attempts = rcAttempt.attempts;
                attempts++;
                rcAttempt = rcAttempt.copyWith(attempts: attempts);
                rcAttemptsList.removeWhere((element) =>
                    element.loanNumber == widget.data.loanAccountNumber);
                rcAttemptsList.add(rcAttempt);
                List<String> searchList = rcAttemptsList
                    .map((item) => jsonEncode(item.toJson()))
                    .toList();
                PrefUtils.saveStringList(PrefUtils.rcAttempts, searchList);
                return UpdateRcFailureWidget(
                data: state.response.data!,
                attempts:attempts ,
              );
              } else {
                RcAttempt rcAttempt = RcAttempt(
                    loanNumber: widget.data.loanAccountNumber ?? "",
                    attempts: 1);
                rcAttemptsList.add(rcAttempt);
                List<String> searchList = rcAttemptsList
                    .map((item) => jsonEncode(item.toJson()))
                    .toList();
                PrefUtils.saveStringList(PrefUtils.rcAttempts, searchList);
                return UpdateRcFailureWidget(
                  data: state.response.data!,
                  attempts: 1,
                );
              }

            }
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                getString(lblUpdateVehicleDetails),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 24.0.v),
                child: TextFormField(
                  controller: rcController,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(4.h),
                      borderSide: BorderSide(
                        color: setColorBasedOnTheme(
                            context: context,
                            lightColor: AppColors.primaryLight3,
                            darkColor: AppColors.secondaryLight5),
                        width: 1,
                      ),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(4.h),
                      borderSide: BorderSide(
                        color: setColorBasedOnTheme(
                            context: context,
                            lightColor: AppColors.primaryLight3,
                            darkColor: AppColors.secondaryLight5),
                        width: 1,
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(4.h),
                      borderSide: BorderSide(
                        color: setColorBasedOnTheme(
                            context: context,
                            lightColor: AppColors.primaryLight3,
                            darkColor: AppColors.secondaryLight5),
                        width: 1,
                      ),
                    ),
                    labelStyle: Theme.of(context).textTheme.bodyLarge,
                    labelText: getString(lblEnterVehicleRegistrationNo),
                  ),
                ),
              ),
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
                        onPressed: () {
                          context.read<NocCubit>().updateRcDetails(
                                UpdateRcDetailsReq(
                                    rcNumber: rcController.text,
                                    loanNumber: widget.loanNumber,
                                    sourceSystem:
                                        widget.data.sourceSystem ?? ""),
                                widget.data,
                              );
                        },
                        text: getString(lblNocFeatureUpdate),
                        outlineBorderButton: false),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
