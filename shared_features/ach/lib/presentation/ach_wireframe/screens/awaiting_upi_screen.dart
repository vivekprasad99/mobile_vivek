import 'dart:async';

import 'package:ach/config/ach_util.dart';
import 'package:ach/data/models/check_vpa_status_req.dart';
import 'package:ach/data/models/check_vpa_status_res.dart';
import 'package:ach/data/models/madate_res_model.dart';
import 'package:ach/presentation/cubit/ach_cubit.dart';
import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/resources/image_constant.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/config/widgets/background/mf_gradient_background.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:core/config/widgets/mf_toast.dart';
import 'package:core/utils/const.dart';
import 'package:core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../../config/routes/route.dart';
import '../../../data/models/awaiting_vpa_model.dart';
import '../../../data/models/update_mandate_info.dart';
import 'package:common/config/routes/route.dart' as common_routes;

class AwaitingUpiScreen extends StatefulWidget {
  final AwaitingVPAModel awaitingVPAModel;
  final UpdateMandateInfo updateMandateInfo;

  const AwaitingUpiScreen({super.key, required this.awaitingVPAModel, required this.updateMandateInfo});

  @override
  State<AwaitingUpiScreen> createState() => _AwaitingUpiScreenState();
}

class _AwaitingUpiScreenState extends State<AwaitingUpiScreen> {
  Timer? _timer;
  Timer? _pollingTimer;
  int _start = 240;
  bool currentRequestInProgress = false;
  @override
  void initState() {
     startTimer();
    _startPolling();
    super.initState();
  }

  void _startPolling() {
    _pollingTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if(currentRequestInProgress == false) {
        currentRequestInProgress = true;
        context.read<AchCubit>().checkVpaStatus(CheckVpaStatusReq(
            refNo: widget.awaitingVPAModel.refNo,
            trxnNo: widget.awaitingVPAModel.trxnNo, actionType: "MANDATE_STATUS", superAppId: getSuperAppId(), source: AppConst.source));
      }
    });
  }
  
  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          _pollingTimer?.cancel();
          _timer?.cancel();
          toastForFailureMessage(context: context, msg: getString(msgVpaAuthFail));
          context.pushReplacementNamed(Routes.mandateSuccessScreen.name, extra: {"loanData": widget.awaitingVPAModel.loanData, "bankName": widget.awaitingVPAModel.bankName, "verificationMode":widget.awaitingVPAModel.verificationMode, "selectedApplicant": widget.awaitingVPAModel.selectedApplicant,
            "accountNumber": widget.awaitingVPAModel.vpaData?.vpa, "mandateResponse" : MandateResponseModel(), "vpaStatus":VpaStatus(status: "PENDING", statusdesc: ""), "updateMandateInfo" : widget.updateMandateInfo
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // appBar: customAppbar(context: context, title: ""),
        body: BlocListener<AchCubit, AchState>(
          listener: (context, state) {
            if(state is CheckVpaStatusSuccessState){
              currentRequestInProgress = false;
              if(state.response.code == AppConst.codeSuccess){
                if(state.response.data?.status == VPAStatus.active.status){
                  _pollingTimer?.cancel();
                  _timer?.cancel();
                  context.pushReplacementNamed(Routes.mandateSuccessScreen.name, extra: {"loanData": widget.awaitingVPAModel.loanData, "bankName": widget.awaitingVPAModel.bankName, "verificationMode":widget.awaitingVPAModel.verificationMode, "selectedApplicant": widget.awaitingVPAModel.selectedApplicant,
                    "accountNumber": widget.awaitingVPAModel.vpaData?.vpa,  "mandateResponse" : MandateResponseModel(), "vpaStatus":state.response.data, "updateMandateInfo" : widget.updateMandateInfo
                  });
                } else if(state.response.data?.status == VPAStatus.revoked.status  || state.response.data?.status == VPAStatus.pause.status || state.response.data?.status == VPAStatus.rejected.status){
                  _pollingTimer?.cancel();
                  _timer?.cancel();
                  context.pushReplacementNamed(Routes.mandateSuccessScreen.name, extra: {"loanData": widget.awaitingVPAModel.loanData, "bankName": widget.awaitingVPAModel.bankName, "verificationMode":widget.awaitingVPAModel.verificationMode, "selectedApplicant": widget.awaitingVPAModel.selectedApplicant,
                    "accountNumber": widget.awaitingVPAModel.vpaData?.vpa, "mandateResponse" : MandateResponseModel() , "vpaStatus":state.response.data, "updateMandateInfo" : widget.updateMandateInfo
                  });
                } else {
                  currentRequestInProgress = false;
                }
              } else {
                currentRequestInProgress = false;
              }
            } else if(state is CheckVpaStatusFailureState){
              currentRequestInProgress = false;
            }
          },
          child: MFGradientBackground(
          horizontalPadding: 16,
          verticalPadding: 16,
          child: SingleChildScrollView(
            child: SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  Text(
                    getString(lblAwaitingPaymentTitle),
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(
                    height: 22,
                  ),
                  Stack(
                    children: [
                      SizedBox(
                        height: 118,
                        width: 118,
                        child: CircularProgressIndicator(
                          color: setColorBasedOnTheme(
                              context: context,
                              lightColor: AppColors.indicatorLight,
                              darkColor: AppColors.indicatorDark),
                          value: _start / 240,
                          strokeWidth: 10,
                        ),
                      ),
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            formattedTime(timeInSecond: _start),
                            // "$minutes:$seconds",
                            style: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 28,
                  ),
                  Text(
                    getString(lblAwaitingPaymentDesc),
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(
                    height: 28,
                  ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: setColorBasedOnTheme(
                          context: context,
                          lightColor: Colors.white,
                          darkColor: AppColors.cardDark),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                         Text(
                            getString(lblHowItWorks),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          _buildRow(ImageConstant.achUpi,getString(lblHowItWorksDesc1)),
                          const SizedBox(
                            height: 16,
                          ),
                          _buildRow(ImageConstant.achNotification,getString(lblHowItWorksDesc2)),
                          const SizedBox(
                            height: 16,
                          ),
                          _buildRow(ImageConstant.achCheck,getString(lblHowItWorksDesc3)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  InkWell(child:  Center(child: Text(
                    getString(lblCancelProcess),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.secondaryLight),
                  )), onTap: () {
                    displayAlertWithAction(context, getString(msgCancelMandateProcess),
                        rightBtnLbl: getString(lblYes), rightBtnTap: () {
                          Navigator.of(context).popUntil(ModalRoute.withName(common_routes.Routes.home.name));
                        }, leftBtnLbl:  getString(lblNo), leftBtnTap: null);
                  },),
                ],
              ),
            ),
          ),
        ),
),
      ),
    );
  }

  String formattedTime({required int timeInSecond}) {
    int sec = timeInSecond % 60;
    int min = (timeInSecond / 60).floor();
    String minute = min.toString().length <= 1 ? "0$min" : "$min";
    String second = sec.toString().length <= 1 ? "0$sec" : "$sec";
    return "$minute:$second";
  }

  Widget _buildRow(String imageName, String label){
   return Row( children: [
      SvgPicture.asset(
          imageName,
          height: 30,
          width: 30,
          colorFilter: ColorFilter.mode(
            setColorBasedOnTheme(
              context: context,
              lightColor: AppColors.primaryLight,
              darkColor: AppColors.white,
            ),
            BlendMode.srcIn,
          )),
      const SizedBox(
        width: 10,
      ),
      Flexible(child:  Text(
        getString(label),
        maxLines: 2,
        style: Theme.of(context).textTheme.labelMedium,
      )),
    ],);
  }
}
