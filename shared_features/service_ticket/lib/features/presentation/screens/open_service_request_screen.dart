import 'package:core/config/string_resource/Strings.dart';
import 'package:core/config/widgets/background/mf_gradient_background.dart';
import 'package:core/utils/const.dart';
import 'package:core/utils/size_utils.dart';
import 'package:core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_ticket/features/presentation/screens/service_request_details.dart';
import '../../data/models/view_sr_request.dart';
import '../../data/models/view_sr_response.dart';
import '../cubit/service_request_cubit.dart';
import '../cubit/service_request_state.dart';

class OpenServiceRequestScreen extends StatelessWidget {
  const OpenServiceRequestScreen({super.key});
  @override
  Widget build(BuildContext context) {

    ViewSRRequest request = ViewSRRequest(mobileNumber: getPhoneNumber(), srStatus: "open");
    BlocProvider.of<ServiceRequestCubit>(context).viewServiceRequest(request);

    return Scaffold(
      body: MFGradientBackground(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 16.v),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildUserprofileSection(context),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildUserprofileSection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 5.h),
      child: BlocBuilder<ServiceRequestCubit, ServiceRequestState>(
        builder: (context, state) {
          if (state is ServiceRequestLoadingState) {
            return Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Theme.of(context).primaryColor,
                ));
          }
          else if (state is ViewServiceRequestSuccessState) {
            if (state.response.code == AppConst.codeSuccess && state.response.data != null) {
              return ListView.separated(
                shrinkWrap: true,
                separatorBuilder: (context, index) {
                  return SizedBox(
                    height: 16.v,
                  );
                },
                itemCount: state.response.data?.length ?? 0,
                itemBuilder: (context, index) {
                  ServiceRequest? serviceRequest = state.response.data?[index];
                  return ServiceRequestDetailsWidget(serviceRequest, onCompletion:() {
                    ViewSRRequest request = ViewSRRequest(mobileNumber: getPhoneNumber(), srStatus: "open");
                    BlocProvider.of<ServiceRequestCubit>(context).viewServiceRequest(request);
                  });
                },
              );
            }
            else {
              return Container();
            }
          }
          return Text(getString(msgSomethingWentWrong));
        },
      ),
    );
  }
}
