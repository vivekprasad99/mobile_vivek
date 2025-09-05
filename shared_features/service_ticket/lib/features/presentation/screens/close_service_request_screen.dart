import 'package:core/config/resources/app_decoration.dart';
import 'package:core/utils/size_utils.dart';
import 'package:core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_ticket/features/presentation/screens/service_request_details.dart';
import '../../data/models/view_sr_request.dart';
import '../../data/models/view_sr_response.dart';
import '../cubit/service_request_cubit.dart';
import '../cubit/service_request_state.dart';

class CloseServiceRequestScreen extends StatelessWidget {
  const CloseServiceRequestScreen({super.key});
  @override
  Widget build(BuildContext context) {
    ViewSRRequest request = ViewSRRequest(mobileNumber: getPhoneNumber(), srStatus: 'Close');
    BlocProvider.of<ServiceRequestCubit>(context).viewServiceRequest(request);
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.maxFinite,
          decoration: AppDecoration.fillWhiteA,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 16.v),
                Padding(
                  padding: EdgeInsets.only(
                    left: 16.h,
                    right: 12.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildUserprofileSection(context),
                      SizedBox(height: 89.v),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildUserprofileSection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 5.h),
      child: BlocConsumer<ServiceRequestCubit, ServiceRequestState>(
        listener: (context, state) {

        },

        builder: (context, stateVal) {
          if(stateVal is ServiceRequestLoadingState){
            return Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Theme.of(context).primaryColor,
                ));
          }
          else if(stateVal is ViewServiceRequestSuccessState){
            return ListView.separated(
              shrinkWrap: true,
              separatorBuilder: (context, index) {
                return SizedBox(
                  height: 16.v,
                );
              },
              itemCount: stateVal.response.data?.length ?? 0,
              itemBuilder: (context, index) {
                ServiceRequest? serviceRequest = stateVal.response.data?[index];
                return ServiceRequestDetailsWidget(serviceRequest,onCompletion:(){

                });
              },
            );
          }
          return Container();
        },
      ),
    );
  }
}