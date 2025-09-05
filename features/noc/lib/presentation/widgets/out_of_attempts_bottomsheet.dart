import 'package:common/config/routes/app_route.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/config/widgets/mf_custom_elevated_button.dart';
import 'package:core/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noc/config/routes/route.dart';
import 'package:noc/data/models/noc_details_resp.dart';
import 'package:noc/data/models/noc_service_req_params.dart';
import 'package:noc/presentation/cubit/noc_cubit.dart';

class OutOfAttemptsBottomsheet extends StatelessWidget {
  final NocData data;
  const OutOfAttemptsBottomsheet({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<NocCubit>(context),
      child: Container(
        padding: EdgeInsets.all(16.v),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 44.v,
            ),
            SizedBox(height: 4.v),
            Text(
              getString(lblyYouareoutofattempts),
              style: Theme.of(context).textTheme.titleLarge,
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
                      onPressed: () {
                        AppRoute.router.pushNamed(
                          Routes.servicerequestscreen.name,
                          extra: NocServiceReqParams(
                              loanAccountNumber: data.loanAccountNumber,
                              lob: data.lob,
                              mobileNumber: data.mobileNumber,
                              productName: data.productName,
                              sourceSystem: data.sourceSystem,
                              productCategory: data.productCategory,
                              srType: "delivery",
                              caseType: 66),
                        );
                      },
                      text: getString(labelRaiseRequest),
                      outlineBorderButton: false),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
