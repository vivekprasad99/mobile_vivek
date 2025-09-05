import 'package:appstatus/feature/data/models/application_status_request.dart';
import 'package:appstatus/feature/presentation/cubit/application_status_cubit.dart';
import 'package:appstatus/feature/presentation/cubit/application_status_state.dart';

import 'package:appstatus/feature/data/models/application_status_response.dart'
    as application_status_model;
import 'package:appstatus/utils/helper/constant_data.dart';
import 'package:core/config/error/failure.dart';
import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/resources/app_dimens.dart';
import 'package:core/config/resources/image_constant.dart';
import 'package:core/config/string_resource/strings.dart';

import 'package:core/config/widgets/background/mf_gradient_background.dart';
import 'package:core/config/widgets/common_widgets/stepperwidget.dart';
import 'package:core/config/widgets/mf_appbar.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:core/utils/const.dart';
import 'package:core/utils/size_utils.dart';
import 'package:core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:common/config/routes/route.dart';
import 'package:help/features/utils/constant_help.dart';
import 'package:help/features/utils/help_common_widget.dart';

// ignore_for_file: must_be_immutable
class ApplicationStatusScreen extends StatefulWidget {
  bool? isFromSideMenu;
  Function? tabnavigation;

  ApplicationStatusScreen({super.key, this.isFromSideMenu,this.tabnavigation});

  @override
  State<ApplicationStatusScreen> createState() =>
      _ApplicationStatusScreenState();
}

class _ApplicationStatusScreenState extends State<ApplicationStatusScreen> {
  GlobalKey<NavigatorState> navigatorKey = GlobalKey();
  bool _showLoader = true;
  //list is for display and compare status
  List<String> statusList = [];
  late ApplicationStatusRequest applicationStatusRequest;

  @override
  void initState() {
    super.initState();
    applicationStatusRequest =
        ApplicationStatusRequest(mobileNumber: getPhoneNumber());
    BlocProvider.of<ApplicationStatusCubit>(context)
        .getApplicationStatusCategory();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ApplicationStatusCubit, ApplicationStatusState>(
      listener: (context, state) {
        if (state is ApplicationStatusSuccessState) {
          if (state.response.code == AppConst.codeFailure) {
            showSnackBar(context: context, message:getString(state.response.responseCode??""));
          }
        }
        if (state is ApplicationStatusCategorySuccessState) {
          if (state.response.message == AppConst.codeFailure) {
            showSnackBar(context: context, message: state.response.message!);
          } else {
            statusList = [ConstantData.invalidext] +
                state.response.data!
                    .map((item) => item.value.toString())
                    .toList();
            BlocProvider.of<ApplicationStatusCubit>(context)
                .getApplicationStatus(
                    applicationStatusRequest: applicationStatusRequest);
          }
        } else if (state is ApplicationStatusFailureState) {
          showSnackBar(
              context: context,
              message: (state.error as ServerFailure).message.toString());
        } else if (state is LoadingState) {
          _showLoader = state.isLoading;
        }
      },
      builder: (context, state) {
        return BlocBuilder<ApplicationStatusCubit, ApplicationStatusState>(
          buildWhen: (context, state) {
            return state is LoadingState ||
                state is ApplicationStatusSuccessState;
          },
          builder: (context, state) {
            return Scaffold(
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
              appBar: widget.isFromSideMenu ?? false
                  ? customAppbar(
                      context: context,
                      title: getString(msgApplicationStatus),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      actions: [
                        HelpCommonWidget(categoryval: HelpConstantData.categoryRegistration,subCategoryval: HelpConstantData.subCategoryDetails,)
                      ])
                  : null,
              body: MFGradientBackground(
                horizontalPadding: 0,
                child: _showLoader
                    ? Center(
                        child: CircularProgressIndicator(
                          color: Theme.of(context).primaryColor,
                        ),
                      )
                    : state is ApplicationStatusSuccessState
                        ? RefreshIndicator(
                            onRefresh: () {
                              return BlocProvider.of<ApplicationStatusCubit>(
                                      context)
                                  .getApplicationStatus(
                                      applicationStatusRequest:
                                          applicationStatusRequest);
                            },
                            child: state.response.responseCode == ConstantData.errorresponsecode
                            ? Padding(
                                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                                child: Column(
                                  mainAxisAlignment:MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      crossAxisAlignment:CrossAxisAlignment.start,
                                  children: [
                                    SvgPicture.asset(
                                      ImageConstant.illustrationIcon,
                                      colorFilter: ColorFilter.mode(
                                          setColorBasedOnTheme(
                                              context: context,lightColor: AppColors.primaryLight,
                                              darkColor: AppColors.primaryLight5),
                                          BlendMode.srcIn),
                                    ),
                                    const SizedBox( width: 13.0),
                                    Expanded(
                                      child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(getString(msgDoNotHaveLoanApplication),
                                  style: Theme.of(context).textTheme.bodyLarge),
                                  const SizedBox(height: 10.0),
                                  GestureDetector(
                                    onTap: (){
                                      context.pushNamed(Routes.home.name, extra: 1);
                                    },
                                    child:Text(getString(lblappstatusExploreNow),
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: setColorBasedOnTheme(
                                context: context,lightColor:AppColors.secondaryLight,
                                darkColor: AppColors.secondaryLight5)))),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                : ListView.builder(
                                    itemBuilder: (context, index) {
                                      return Container(
                                          margin: EdgeInsets.only(bottom: 5.v),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 15.h),
                                          child: widget.isFromSideMenu ?? false
                                              ? _buildFromSide(
                                                  state, index, context)
                                              : _buildFromSide(
                                                  state, index, context));
                                    },
                                    itemCount: state
                                            .response
                                            .loanApplicationStatusList
                                            ?.length ??
                                        0,
                                  ),
                          )
                        : Container(),
              ),
            );
          },
        );
      },
    );
  }


  Column _buildFromSide(
      ApplicationStatusSuccessState state, int index, BuildContext context) {
    return Column(
      children: [
        state.response.loanApplicationStatusList![index].applicationStatus
                .toString()
                .contains(ConstantData.completedStatusText)
            ? _buildSeeDetails(
                context, state.response.loanApplicationStatusList![index])
            : const SizedBox.shrink(),
        state.response.loanApplicationStatusList![index].lmsType
                    .toString()
                    .contains(ConstantData.vehicletext) ||
                state.response.loanApplicationStatusList![index].lmsType
                    .toString()
                    .contains(ConstantData.sfdctext)
            ? _buildAppStatusCard(
                context, state.response.loanApplicationStatusList![index])
            : state.response.loanApplicationStatusList![index].lmsType
                    .toString()
                    .contains(ConstantData.personaltext)
                ? _buildAppStatusCard(
                    context, state.response.loanApplicationStatusList![index])
                : const SizedBox.shrink(),
      ],
    );
  }

  /// Section Widget
  Widget _buildSeeDetails(
      BuildContext context, application_status_model.Data response) {
    final Brightness brightness = Theme.of(context).brightness;

    return GestureDetector(
        onTap: () {
          if(widget.tabnavigation!=null){
            widget.tabnavigation!("active");
          } 
        },
      child: Container(
        margin: EdgeInsets.only(right: 3.h),
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 13.v),
            Padding(
              padding: EdgeInsets.only(left: 13.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      response.lmsType
                              .toString()
                              .contains(ConstantData.vehicletext)
                          ? SvgPicture.asset(
                              brightness == Brightness.light
                                  ? ImageConstant.imgVehicleLoanIconLight
                                  : ImageConstant.imgVehicleLoanIconDark,
                            )
                          : SvgPicture.asset(
                              brightness == Brightness.light
                                  ? ImageConstant.imgPersonalLoanRupeeLight
                                  : ImageConstant.imgPersonalLoanRupeeDark,
                            ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: 12.h,
                          top: 4.v,
                          bottom: 4.v,
                        ),
                        child: _buildSixteen(
                          context,
                          vehicleLoan: response.applicantName!,
                          applicationID: getString(msgApplicationId) +
                              response.applicationNumber!,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                      padding: EdgeInsets.only(right: 10.v),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: Theme.of(context).primaryColor,
                        size: AppDimens.bodySmall,
                      )),
                ],
              ),
            ),
            SizedBox(height: 15.v),
            Opacity(
              opacity: 0.5,
              child: Align(
                alignment: Alignment.center,
                child: Divider(
                  indent: 12.h,
                  endIndent: 9.h,
                ),
              ),
            ),
            SizedBox(height: 6.v),
            Container(
              width: 285.h,
              margin: EdgeInsets.only(
                left: 13.h,
                right: 26.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    response.applicationStatus.toString().toUpperCase().contains(
                            ConstantData.completedStatusText
                                .toString()
                                .toUpperCase())
                        ? getString(msgCongratulations)
                        : response.subStatus ?? "",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Text(
                    response.applicationStatus.toString().toUpperCase().contains(
                            ConstantData.completedStatusText
                                .toString()
                                .toUpperCase())
                        ? getString(msgApplicationContentCongratulations)
                        : response.subStatus ?? "",
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ],
              ),
            ),
            SizedBox(height: 5.v),
            Padding(
              padding: EdgeInsets.only(left: 12.h),
              child: Text(
                response.applicationStatus
                        .toString()
                        .toUpperCase()
                        .contains(ConstantData.completedStatusText)
                    ? getString(msgYourApplication2)
                    : response.subStatus ?? "",
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ),
            SizedBox(height: 5.v),
          ],
        ),
      ),
    );
  }

  List<String> refinedStatuslist = [];
String commonSubStatustext= "";
  /// Section Widget
  Widget _buildAppStatusCard(
      BuildContext context, application_status_model.Data response) {
    final Brightness brightness = Theme.of(context).brightness;

    refinedStatuslist = List.from(statusList);
    response.applicationStatus == null ||
            response.applicationStatus == "Invalid"
        ? 0
        : refinedStatuslist.removeAt(0);

    var statusIndex = refinedStatuslist.indexWhere((element) =>
        element.toString().toUpperCase() ==
        response.applicationStatus.toString().toUpperCase());
    
        //for unknown error occurring
        var otherstatusindex=statusIndex;
    statusIndex == -1 ? statusIndex = 0 : statusIndex;
    
    //Nudges for substatus message 
    switch(response.applicationStatus){
      case (ConstantData.initiatedStatusText):
      if(response.subStatus.toString().isNotEmpty){
        commonSubStatustext= getString(lblAppstatusAnyStage);
       }else{
      commonSubStatustext= response.subStatus.toString();
       }
       case (ConstantData.underProcessStatusText):
       if(response.subStatus.toString().isNotEmpty){
        commonSubStatustext= getString(lblAppstatusAnyStage);
       }else{
       commonSubStatustext= response.subStatus.toString();
       }
       case (ConstantData.sanctionStatusText):
       if(response.subStatus.toString().isNotEmpty){
        commonSubStatustext= getString(lblAppstatusAnyStage);
       }else{
       commonSubStatustext= response.subStatus.toString();
       }
       case (ConstantData.postSanctionStatusText):
       if(response.subStatus.toString().toUpperCase().contains(ConstantData.stamptext)||response.subStatus.toString().toUpperCase().contains(ConstantData.signtext)){
        commonSubStatustext= getString(lblAppstatusPostSanctionStampNSign);
       }else if(response.subStatus.toString().toUpperCase().contains(ConstantData.mandatetext)){
        commonSubStatustext= getString(lblAppstatusPostSanctionMandateReg);
       }else if(response.subStatus.toString().isNotEmpty){
        commonSubStatustext= getString(lblAppstatusAnyStage);
       }else{
        commonSubStatustext= response.subStatus.toString();
       }
       case (ConstantData.completedStatusText):
       if(response.subStatus.toString().isNotEmpty){
        commonSubStatustext= getString(lblAppstatusAnyStage);
       }else{
       commonSubStatustext= response.subStatus.toString();
       }
       case (ConstantData.rejectedStatusText):
       commonSubStatustext= getString(lblAppstatusWithdrawn);
       case (ConstantData.withdrawnStatusText):
       commonSubStatustext= getString(lblAppstatusRejectUnderwriter);
      default:
      if(response.subStatus.toString().isNotEmpty){
        commonSubStatustext= getString(lblAppstatusAnyStage);
       }else{
        commonSubStatustext= response.subStatus.toString();
       }
    }
    return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10.v,
          ),
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12.v),
                  decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10))),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.h),
                          child: Row(
                            children: [
                              response.lmsType
                                      .toString()
                                      .contains(ConstantData.vehicletext)
                                  ? SvgPicture.asset(
                                      brightness == Brightness.light
                                          ? ImageConstant
                                              .imgVehicleLoanIconLight
                                          : ImageConstant
                                              .imgVehicleLoanIconDark,
                                    )
                                  : SvgPicture.asset(
                                      brightness == Brightness.light
                                          ? ImageConstant
                                              .imgPersonalLoanRupeeLight
                                          : ImageConstant
                                              .imgPersonalLoanRupeeDark,
                                    ),
                              Padding(
                                padding: EdgeInsets.only(
                                  left: 12.h,
                                  top: 5.v,
                                  bottom: 3.v,
                                ),
                                child: _buildSixteen(
                                  context,
                                  vehicleLoan: response.lmsType
                                              .toString()
                                              .contains(
                                                  ConstantData.vehicletext) ||
                                          response.lmsType
                                              .toString()
                                              .contains(ConstantData.sfdctext)
                                      ? getString(lbl_appStatus_VehicleLoan)
                                      : getString(lbl_appStatus_PersonalLoan),
                                  applicationID: getString(msgApplicationId) +
                                      response.applicationNumber.toString(),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                  bottom: 20.v,
                                  top: 5.v,
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 5.h,
                                  vertical: 2.v,
                                ),
                                decoration: BoxDecoration(
                                    color: setColorBasedOnTheme(
                                        context: context,
                                        lightColor: AppColors.primaryLight6,
                                        darkColor: AppColors.shadowDark),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(4))),
                                child: Text(
                                otherstatusindex==-1 ?response.applicationStatus.toString() : refinedStatuslist[statusIndex],
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                        fontSize: 11,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Opacity(
                        opacity: 0.5,
                        child: Align(
                          alignment: Alignment.center,
                          child: Divider(
                            indent: 12.h,
                            endIndent: 9.h,
                          ),
                        ),
                      ),
                      SizedBox(height: 5.v),
                      Padding(
                        padding: EdgeInsets.only(
                          left: 13.h,
                          right: 54.h,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(getString(lbl_appStatus_Name),
                                    style:
                                        Theme.of(context).textTheme.bodySmall),
                                SizedBox(height: 3.v),
                                SizedBox(
                                  width: 150.h,
                                  child: Text("${response.applicantName}",
                                      maxLines: 2,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(getString(msgDateOfCreation),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall),
                                ),
                                SizedBox(height: 3.v),
                                Text("${response.applicationDate}",
                                    style:
                                        Theme.of(context).textTheme.labelSmall),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16.v),
                      Padding(
                        padding: EdgeInsets.only(
                          left: 13.h,
                          right: 65.h,
                        ),
                        child: Row(
                          mainAxisAlignment: response.lmsType
                                  .toString()
                                  .contains(ConstantData.personaltext)
                              ? MainAxisAlignment.start
                              : MainAxisAlignment.spaceBetween,
                          children: [
                            response.lmsType
                                    .toString()
                                    .contains(ConstantData.personaltext)
                                ? const SizedBox.shrink()
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(getString(lblAssetName),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall),
                                      SizedBox(height: 4.v),
                                      SizedBox(
                                        width: 150.h,
                                        child: Text("${response.assetName}",
                                            maxLines: 2,
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelSmall),
                                      ),
                                    ],
                                  ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(getString(lbl_appStatus_Branchdetails),
                                    style:
                                        Theme.of(context).textTheme.bodySmall),
                                SizedBox(height: 4.v),
                                Text("${response.branchName}",
                                    style:
                                        Theme.of(context).textTheme.labelSmall),
                              ],
                            ),
                          ],
                        ),
                      ),
                     otherstatusindex==-1 ?const SizedBox.shrink(): SizedBox(height: 34.v),
                   otherstatusindex==-1 ?const SizedBox.shrink():   Padding(
                        padding: EdgeInsets.only(left: 12.h),
                        child: Text(
                            "${getString(msgApplicationsStatusonDate)} ${response.currentDate}",
                            style: Theme.of(context).textTheme.bodySmall),
                      ),
                      SizedBox(height: 4.v),
                     otherstatusindex==-1 ?const SizedBox.shrink():SizedBox(
                        height: 72.v,
                        width: 325.h,
                        child: Stack(
                          alignment: Alignment.topRight,
                          children: [
                            StepperWidget(
                                step: refinedStatuslist,
                                padding: const EdgeInsets.all(5.0),
                                width: MediaQuery.of(context).size.width,
                                curStep: statusIndex,
                                currentStepColor: AppColors.secondaryLight,
                                inactiveColor: AppColors.primaryLight6,
                                lineWidth: 1),
                          ],
                        ),
                      ),
                     response.subStatus.toString() != ""
                          ? otherstatusindex==-1 ?const SizedBox.shrink(): Align(
                              alignment: Alignment.center,
                              child: SizedBox(
                                height: 53.v,
                                width: 302.h,
                                child: Stack(
                                  alignment: Alignment.topRight,
                                  children: [
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 10.h,
                                          vertical: 3.v,
                                        ),
                                        decoration: BoxDecoration(
                                            color: AppColors.primaryLight6,
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SizedBox(height: 2.v),
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.error_outline_outlined,
                                                  color: AppColors
                                                      .warningIconOrangeColor,
                                                ),
                                                SizedBox(width: 5.v),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      1.43,
                                                  child: Text(
                                                      commonSubStatustext,
                                                      maxLines: 3,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .labelSmall
                                                          ?.copyWith(
                                                            fontSize: 11,
                                                            color:
                                                                setColorBasedOnTheme(
                                                              context: context,
                                                              lightColor:
                                                                  AppColors
                                                                      .textLight,
                                                              darkColor:
                                                                  AppColors
                                                                      .textLight,
                                                            ),
                                                          )),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                      SizedBox(height: 13.v),
                      response.businessExecutiveContactNumber
                                  .toString()
                                  .isNotEmpty ||
                              response.businessExecutiveName
                                  .toString()
                                  .isNotEmpty
                          ? Padding(
                              padding: EdgeInsets.only(left: 12.h, right: 12.h),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      SvgPicture.asset(
                                        brightness == Brightness.light
                                            ? ImageConstant
                                                .imgContactBusinessIconLight
                                            : ImageConstant
                                                .imgContactBusinessIconDark,
                                      ),
                                      const SizedBox(
                                        width: 5.0,
                                      ),
                                      Text(getString(msgContactBusiness),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall),
                                    ],
                                  ),
                                  Text(response.businessExecutiveContactNumber!,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: AppColors.secondaryLight,
                                          )),
                                ],
                              ),
                            )
                          : const SizedBox.shrink(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ]);
  }

  /// Common widget
  Widget _buildSixteen(
    BuildContext context, {
    required String vehicleLoan,
    required String applicationID,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          vehicleLoan,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
        SizedBox(height: 3.v),
        Text(applicationID, style: Theme.of(context).textTheme.bodyLarge)
      ],
    );
  }
}
