import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/config/widgets/common_widgets/mf_custom_drop_down.dart';
import 'package:core/config/widgets/common_widgets/mf_custom_text_field.dart';
import 'package:core/config/widgets/custom_buttons/mf_custom_elevated_button.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:service_ticket/features/data/models/reopen_case_request.dart';
import '../../../data/models/reopen_reason_response.dart';
import '../../../data/models/view_sr_response.dart';
import '../../cubit/service_request_cubit.dart';
import '../../cubit/service_request_state.dart';
// ignore_for_file: must_be_immutable
class ReOpenRequestWidget extends StatelessWidget {
  ServiceRequest? serviceRequest;
  ReOpenRequestWidget({super.key, this.serviceRequest});

  @override
  Widget build(BuildContext context) {

    TextEditingController? description = TextEditingController();
    String? selectedReason;

    BlocProvider.of<ServiceRequestCubit>(context).fetchReopenReasons();
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(28),
        topRight: Radius.circular(28),
      )),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 20,
              ),
              Text(
                getString(lblReopenRequest),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(
                height: 20,
              ),
              BlocConsumer<ServiceRequestCubit, ServiceRequestState>(
                listener: (context, state){
                  if(state is ReopenServiceRequestSuccessState) {
                      context.pop();
                      Navigator.pop(context,true);
                  }
                },
                builder: (context, state) {
                  if (state is FetchReopenReasonsSuccessState) {
                    List<ReopenReason> data = state.response.data ?? [];
                    return MfCustomDropDown(
                        title: getString(lblSelectReason),
                        onSelected: (selectedValue){
                          selectedReason = selectedValue;
                        },
                        dropdownMenuEntries: data
                            .map((e) => DropdownMenuEntry<String>(
                                value: e.value ?? "",
                                label: e.value ?? "",
                                style: MenuItemButton.styleFrom(
                                  foregroundColor: AppColors.primaryLight,
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .labelMedium
                                      ?.copyWith(
                                          fontSize: 16,
                                          color: AppColors.textLight),
                                )))
                            .toList());
                  }
                  return Container();
                },
              ),
              const SizedBox(
                height: 20,
              ),
              MfCustomFloatingTextField(
                controller: description,
                labelText: getString(lblEnterDescription),
                borderDecoration: UnderlineInputBorder(
                  borderRadius: BorderRadius.zero,
                  borderSide: BorderSide(
                    color: setColorBasedOnTheme(
                      context: context,
                      lightColor: AppColors.primaryLight,
                      darkColor: AppColors.secondaryLight5,
                    ),
                    width: 1,
                  ),
                ),
                textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: setColorBasedOnTheme(
                      context: context,
                      lightColor: AppColors.primaryLight,
                      darkColor: AppColors.secondaryLight5,
                    )),
                labelStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: setColorBasedOnTheme(
                      context: context,
                      lightColor: AppColors.primaryLight,
                      darkColor: AppColors.secondaryLight5,
                    )),
                textInputAction: TextInputAction.done,
                textInputType: TextInputType.text,
                validator: (value) {
                  return null;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: MfCustomButton(
                        onPressed: () {
                          context.pop();
                        },
                        text: getString(lblCancel),
                        outlineBorderButton: true),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: MfCustomButton(
                        onPressed: () {
                          var request = ReopenCaseRequest(
                              caseNumber: serviceRequest?.caseNumber,
                              sourceSystem: serviceRequest?.sourceSystem,
                              reopenRemark: selectedReason,
                              reopenUnsatisfiedRemark: description.text,
                          );
                          BlocProvider.of<ServiceRequestCubit>(context).reopenCase(request);
                        },
                        text: getString(lblReopen),
                        outlineBorderButton: false),
                  ),
                ],
              ),
              const SizedBox(
                height: 40,
              ),
            ]),
      ),
    );
  }
}
