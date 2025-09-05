import 'dart:convert';

import 'dart:io';
import 'package:camspaypro/core/res/colors.dart';
import 'package:camspaypro/helper/encrpt_decrypt.dart';
import 'package:core/config/widgets/mf_custom_elevated_button.dart';
import 'package:core/utils/pref_utils.dart';
import 'package:payment_gateway/features/data/models/get_payment_option_data_model.dart';
import 'package:payment_gateway/features/data/models/payment_cred_response_model.dart';
import 'package:payment_gateway/features/domain/models/payment_params/payment_source_system.dart';
import 'package:payment_gateway/features/domain/models/camspay_response_dc_model.dart';
import 'package:payment_gateway/features/domain/models/camspay_response_qr_model.dart';
import 'package:payment_gateway/features/presentation/screens/camspay_screen.dart';
import 'package:payment_gateway/features/presentation/utils/constants.dart';
import 'package:payment_gateway/features/presentation/utils/services/camspay_service.dart';

import 'package:core/utils/const.dart';
import 'package:core/config/resources/image_constant.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/config/widgets/background/mf_gradient_background.dart';
import 'package:core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:core/utils/size_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:payment_gateway/config/routes/route.dart';
import 'package:payment_gateway/features/data/models/get_transaction_id_request.dart';
import 'package:payment_gateway/features/data/models/update_payment_detail_request.dart';
import 'package:payment_gateway/features/domain/models/payment_model.dart';
import 'package:payment_gateway/features/domain/models/payment_params/payment_product_type.dart';
import 'package:payment_gateway/features/domain/models/payment_params/payment_type.dart';
import 'package:payment_gateway/features/presentation/cubit/payment_cubit.dart';
import 'package:payment_gateway/features/presentation/utils/payment_mode_enum.dart';
import 'package:payment_gateway/features/presentation/utils/services/payment_screen_feed_model.dart';
import 'package:payment_gateway/features/presentation/utils/services/services.dart';
import 'package:payment_gateway/features/presentation/widgets/appbar.dart';
import 'package:payment_gateway/features/presentation/widgets/error_widget.dart';
import 'package:payment_gateway/features/presentation/widgets/showCustomDailoauge.dart';
import 'package:payu_checkoutpro_flutter/payu_checkoutpro_flutter.dart';

import '../widgets/payment_option_card.dart';
import '../utils/services/hash_service.dart';
import '../utils/services/payu_params.dart';
import 'package:help/features/utils/constant_help.dart';
import 'package:help/features/utils/help_common_widget.dart';

class ChoosePaymentModeScreen extends StatefulWidget {
  const ChoosePaymentModeScreen({super.key, required this.paymentModel});
  final PaymentModel paymentModel;

  @override
  State<ChoosePaymentModeScreen> createState() =>
      _ChoosePaymentModeScreenState();
}

class _ChoosePaymentModeScreenState extends State<ChoosePaymentModeScreen>
    implements PayUCheckoutProProtocol {
  final TextEditingController amountController = TextEditingController();
  late PayUCheckoutProFlutter _checkoutPro;

  PaymentModeEnum _selectedPaymentMode = PaymentModeEnum.upi;
  final GlobalKey paymentButtonKey = GlobalKey();
  late BuildContext _context;
  String transactionId = '';
  String bankTransactionId = '';
  bool _isLoading = false;
  String paymentGatewayName = PaymentSDKType.payU.name;
  bool hideWallet = false;
  bool hideQRcode = false;
  List<PaymentOption> paymentOptionData = [];
  

  PaymentSDKType get getSelectedPaymentSDK =>
      _selectedPaymentMode == PaymentModeEnum.card ||
              _selectedPaymentMode == PaymentModeEnum.qrCode
          ? PaymentSDKType.camspay
          : PaymentSDKType.payU;

  @override
  void initState() {
    _checkoutPro = PayUCheckoutProFlutter(this);
    _context = context;
    context.read<PaymentGatewayCubit>().getPaymentOptionData();
    super.initState();
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar:
            BlocConsumer<PaymentGatewayCubit, PaymentGatewayState>(
                listener: (context, state) {
          if (state is LoadingState && state.isLoading) {
              _isLoading = true;
            } else {
              _isLoading = false;
          }
          if (state is ChoosePaymentModeState) {
            _selectedPaymentMode = state.paymentMode;
          }
          if (state is GetPaymentOptionsState) {
            if (state.response.data.isNotEmpty) {
              paymentOptionData = state.response.data;
              setPaymentMode(state.response.data);
              context.read<PaymentGatewayCubit>().getPaymentCredentials();
            }
          }
          if (state is GetPaymentCredentialsState) {
            if (state.response.code == AppConst.codeSuccess) {
              setPaymentCredentials(state.response);
            }
          }
          if (state is GetTransactionIdResponseState) {
            if (state.response.code == AppConst.codeSuccess) {
              transactionId = state.response.transactionId;
              if (transactionId.isNotEmpty) {
                if (paymentGatewayName.toLowerCase() ==
                    PaymentConstants.paymentGatewayNameCamspay) {
                  if (_selectedPaymentMode != PaymentModeEnum.wallets) {
                    makeCamspayPayment();
                  } else {
                    showErrorDialouge(getString(lblErrorGeneric));
                  }
                } else {
                  if (_selectedPaymentMode != PaymentModeEnum.qrCode) {
                    makePayuPayment();
                  } else {
                    showErrorDialouge(getString(lblErrorGeneric));
                  }
                }
              }
            } else {
              showErrorDialouge(getString(state.response.responseCode));
            }
          }
        }, builder: (context, state) {
          if (state is PaymentGatewayFailureState) {
            return genericErrorWidget(context);
          }
          return Padding(
            padding: EdgeInsets.only(bottom: 24.h, left: 16.h, right: 16.h),
            child: SizedBox(
              child: MfCustomButton(
              outlineBorderButton: false,
              onPressed: () {
                getTransactionID(context);
              },
              text: getString(lblProceedToPay),
            )
            ),
          );
        }),
        appBar: buildCustomAppBar(
            context: context, title: getString(lblPaymentPaymentOptions),
            actions:[HelpCommonWidget(categoryval: HelpConstantData.categoryPayment,subCategoryval: HelpConstantData.subCategoryPaymentMethod,)]),
        body: BlocBuilder<PaymentGatewayCubit, PaymentGatewayState>(
          builder: (context, state) {
            if(state is LoadingState && state.isLoading){
              _isLoading = true;
            }else{
              _isLoading = false;
            }
           return  (state is PaymentGatewayFailureState)
                ? Center(
                    child: Text(getString(lblErrorGeneric)),
                  )
                : MFGradientBackground(
                    verticalPadding: 0.h,
                    showLoader: _isLoading,
                    child: SizedBox(
                      height: double.infinity,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 16.h,
                            ),
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(8)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${getString(widget.paymentModel.productType.value)} | ${widget.paymentModel.productNumber}",
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
                                    Text(widget.paymentModel.description,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium),
                                    SizedBox(
                                      height: 18.h,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(getString(lblPaymentAmountPayable),
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall),
                                        Text(
                                          rupeeFormatter(widget.paymentModel.totalPaybleAmount),
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 16.v,
                            ),
                            Text(getString(lblChoosePaymentOption),
                                style: Theme.of(context).textTheme.bodyLarge),
                            SizedBox(
                              height: 8.v,
                            ),
                            PaymentOptionCardWidget(
                              title: getString(lblDebitCard),
                              subTitle: getString(lblSaveAndPay),
                              leadingIconPath: ImageConstant.debitIcon,
                              paymentMode: PaymentModeEnum.card,
                            ),
                            SizedBox(
                              height: 16.v,
                            ),
                            PaymentOptionCardWidget(
                              title: getString(lblNetbanking),
                              subTitle: getString(lblSelectFromListOfBanks),
                              leadingIconPath: ImageConstant.netbankingIcon,
                              paymentMode: PaymentModeEnum.netBanking,
                            ),
                            if(!hideWallet)
                            ...[SizedBox(
                              height: 16.v,
                            ),
                            PaymentOptionCardWidget(
                              title: getString(lblWallets),
                              subTitle: getString(lblPhonePeAmazonMore),
                              leadingIconPath: ImageConstant.walletIcon,
                              paymentMode: PaymentModeEnum.wallets,
                            ),],
                            SizedBox(
                              height: 16.v,
                            ),
                            PaymentOptionCardWidget(
                              title: getString(lblUPI),
                              subTitle:
                                  getString(lblYouNeedToHaveRegisteredUPI),
                              showRecommended: true,
                              leadingIconPath: ImageConstant.upiIcon,
                              paymentMode: PaymentModeEnum.upi,
                            ),
                            if(!hideQRcode)
                            ...[SizedBox(
                              height: 16.v,
                            ),
                            PaymentOptionCardWidget(
                              title: getString(lblQRCode),
                              subTitle:
                                  getString(lblYouNeedToHaveRegisteredUPI),
                              leadingIconPath: ImageConstant.qrIcon,
                              paymentMode: PaymentModeEnum.qrCode,
                            )],
                          ],
                        ),
                      ),
                    ),
                  );
          },
        ));
  }

  void getTransactionID(BuildContext context) {
    setPaymentMode(paymentOptionData);
    bool isCAMSPay = paymentGatewayName.toLowerCase() ==
        PaymentConstants.paymentGatewayNameCamspay;
      var paymentParams = {
    "key": isCAMSPay
        ? CAMPSPayService.merchantid
        : PayUTestCredentials.merchantKey,
    //MY-TODO : add user details when data available...
    "productInfo": "Info",
    "firstName": "superapp user",
    "email": "superapp@superapp.com",
    "ios_surl": PayUTestCredentials.iosSurl,
    "ios_furl": PayUTestCredentials.iosFurl,
    "android_surl": PayUTestCredentials.androidSurl,
    "android_furl": PayUTestCredentials.androidFurl,
    "environment": "1", // MY-TODO : Change 1 to 0 for production...
    "userCredential": getPhoneNumber(),
    "enableNativeOTP": true,
    };
    const String camspay = "CamsPay";
    const String payu = "PayU";
    const String superApp = "SuperApp";

    context
        .read<PaymentGatewayCubit>()
      .getTransactionId(GetTransactionIdRequest(
        paymentGateway:
            isCAMSPay
                ? camspay
                : payu,
        loanAccountNumber: widget.paymentModel.productNumber,
        sourceSystem: widget.paymentModel.sourceSystem.name,
        productType: widget.paymentModel.productType.name,
        paymentDescriptionUI:
            'Payment for ${getString(widget.paymentModel.productType.value)}',
        paymentType: widget.paymentModel.paymentType.value,
        payableAmount: widget.paymentModel.totalPaybleAmount,
        paymentMode: _selectedPaymentMode.name,
        source: superApp,
        ucic: getUCIC(),
        deviceId: getDeviceId(),
        mobileNumber: getPhoneNumber(),
        superAppId: getSuperAppId(),
        merchantId: isCAMSPay
            ? CAMPSPayService.merchantid
            : PayUTestCredentials.merchantKey,
        pgRequest: paymentParams,
      ));
  }

  void setPaymentMode(List<PaymentOption> data) {
    for (var element in data) {
      if (_selectedPaymentMode.value == element.paymentmode) {
        paymentGatewayName = element.paymentgateway;
      }
      if (element.paymentmode == PaymentModeEnum.wallets.value &&
          element.paymentgateway ==
              PaymentConstants.paymentGatewayNameCamspay) {
        hideWallet = true;
      }
      if (element.paymentmode == PaymentModeEnum.qrCode.value &&
          element.paymentgateway ==
              PaymentConstants.paymentGatewayNamePayu) {
        hideQRcode = true;
      }
    }
  }

  

  @override
  generateHash(Map response) {
    Map hashResponse = HashService.generateHash(response);
    _checkoutPro.hashGenerated(hash: hashResponse);
  }

  @override
  onError(Map? response) {
    showErrorDialouge(getString(lblErrorGeneric));
  }

  @override
  onPaymentCancel(Map? response) {
    updatePaymentDetailsandNavigate(
        response: response.toString(),
        paymentStatus: PaymentStatusEnum.failure);
  }

  @override
  onPaymentFailure(response) {
    updatePaymentDetailsandNavigate(
        response: response.toString(),
        paymentStatus: PaymentStatusEnum.failure);
  }

  @override
  onPaymentSuccess(response) {
    Map<String, dynamic> data = Map<String, dynamic>.from(response);
    String payuData = data['payuResponse'];
    try {
      bankTransactionId = jsonDecode(payuData)['id'].toString();
    } catch (e) {
      bankTransactionId = '';
    }
    updatePaymentDetailsandNavigate(
        response: response.toString(),
        paymentStatus: PaymentStatusEnum.success);
  }


  void setPaymentCredentials(PaymentCredentialsResponseModel paymentCred) {
    bool isPennant =
        widget.paymentModel.sourceSystem == PaymentSourceSystem.pennant;
      CAMPSPayService.setCamsPayCred(
          isQRPayment: _selectedPaymentMode == PaymentModeEnum.qrCode,
          isPennant: isPennant,
          camsPay: paymentCred.camsPay);
      PayUTestCredentials.setPayuCred(isPennant: isPennant, payu:  paymentCred.payu);
      HashService.setSalt(isPennant: isPennant,payu:  paymentCred.payu);
  }

  void updatePaymentDetailsandNavigate(
      {required String response, required PaymentStatusEnum paymentStatus}) {
    bool isPaymentPending = (paymentStatus == PaymentStatusEnum.pending);
    bool isPaymentSuccess = (paymentStatus == PaymentStatusEnum.success);
    bool isFromForeclosure = widget.paymentModel.fromScreen?.toLowerCase() == 'foreclosure';
    PaymentStatusDataModel paymentStatusDataModel = PaymentStatusDataModel(
      imagePath: isPaymentPending
          ? ImageConstant.paymetnPending
          : isPaymentSuccess
              ? ImageConstant.congratulationIcon
              : ImageConstant.errorIcon,
      title: getString(isPaymentPending
          ? lblPaymentPending
          : isPaymentSuccess
              ? lblSuccess
              : lblPaymentFailed),
      amount: widget.paymentModel.totalPaybleAmount.toString(),
      paymentStatusIcon: isPaymentSuccess ? ImageConstant.checkCircle : null,
      paymentStausMsg:isFromForeclosure? getString(lblYourLoanIsForeclosed).replaceAll('#@#', widget.paymentModel.productNumber) : isPaymentPending
          ? getString(lblTransactionBeingProcessed)
          : isPaymentSuccess
              ? getString(lblPaymentSuccess)
              : null,
      description:
       getString(isPaymentPending
          ? msgPleaseWaitForPaymentPending
          : isPaymentSuccess
              ? msgPleaseWaitForPayment
              : msgTransactionFailedDueToTechnicalError).replaceAll('<x>', PrefUtils.getString(PrefUtils.paymentTat, AppConst.paymentTat)),
      primaryButtonTitle: getString((isPaymentSuccess || isPaymentPending)
          ? (widget.paymentModel.remainingAmount != null && isPaymentSuccess) ? '$lblPayBalance ${rupeeFormatter(widget.paymentModel.remainingAmount ?? '0')}' : lblGotoPaymentHistory
          : lblTryAgain),
      secondaryButtonTitle: getString(lblHome),
      primaryButtonClick:
          isPaymentSuccess ? (){
            if (widget.paymentModel.remainingAmount != null) {
              Navigator.popUntil(context, (route) {
                    if (route.settings.name == Routes.choosePaymentMode.name) {
                      Navigator.pop(
                          context, {PaymentConstants.remainingAmount : widget.paymentModel.remainingAmount});
                      return true;
                    }
                    return false;
                  });
                }
            }
          : () => Navigator.pop(context),
      topIconHeight: isPaymentSuccess ? 88 : 44,
      topIconWidth: isPaymentSuccess ? 48 : 44,
      transactionId: transactionId,
      modeOfPayment: _selectedPaymentMode.value,
      loanNumber: widget.paymentModel.productNumber,
      purposeOfPayment: widget.paymentModel.paymentType.value,
      bankTransactionID:isPaymentSuccess ? bankTransactionId : "",
      paymentStatus: isPaymentSuccess,
      paymentMadeOn: DateTime.now(),
      remainingAmount: widget.paymentModel.remainingAmount,
      customerName: "Test Name",// MY-TODO - profile module is pending yet...
      fromScreen: widget.paymentModel.fromScreen 
    );

    context.pushNamed(Routes.paymentSuccess.name,
        extra: paymentStatusDataModel);


    _context.read<PaymentGatewayCubit>().updatePaymentDetail(
        UpdatePaymentDetailRequest(
            uniqueTrackingId: transactionId,
            pgResponse: response,
            paymentStatusUi: paymentStatus.name));
  }



  void makeCamspayPayment() {
    String? jsonString;
    String? merRefId;
    String? encKey;
    String? data;
    String? toolbarTitle;
    String? returnValue;

    Color? startColor = AppColor.background;
    Color? endColor = AppColor.green;
    Color? toolbarColor = AppColor.blue;

    const String dc = "DC";

    
    try {
      Map<String, dynamic> jsonObject = {
        "amount": double.parse(widget.paymentModel.totalPaybleAmount)
            .toStringAsFixed(2),
        "applicationname": "Test",
        "currency": "INR",
        "devicetype": Platform.isAndroid ? AppConst.android : AppConst.ios,
        "paytype": _selectedPaymentMode.name == PaymentConstants.stringCard ? dc : _selectedPaymentMode.name,
        "reqdt": DateTime.now().toString(),
        "merchantid": CAMPSPayService.merchantid,
        "subbillerid": CAMPSPayService.subbillerid,
        "trxnid": transactionId
      };


    jsonString = json.encode(jsonObject);
    merRefId = CAMPSPayService.merRefId;
    encKey = CAMPSPayService.encKey;
    data = EncDec.encryptData(jsonString, encKey);
    toolbarTitle = CAMPSPayService.toolbarTitle;

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => Payment(data!, merRefId, startColor, endColor,
              toolbarColor, toolbarTitle)),
    ).then((response) {
      camspayPaymentCallBack(response: response, encKey: encKey, returnValue: returnValue);
    });
    } catch (e) {
      showErrorDialouge(getString(lblErrorGeneric));
    }

  }

  void camspayPaymentCallBack(
      {dynamic response, String? encKey, String? returnValue}) {
    if (response != null) {
      String decData = response.toString();
      returnValue = EncDec.decryptData(decData, encKey!);
      dynamic dynamicData = jsonDecode(returnValue);
      Map<String, dynamic> data = Map<String, dynamic>.from(dynamicData);
      if (_selectedPaymentMode == PaymentModeEnum.card) {
        CamspayResponseDcModel payResDc = CamspayResponseDcModel.fromJson(data);
        if (payResDc.msg == AppConst.codeSuccess) {
          bankTransactionId = payResDc.banktrxnrefno;
          updatePaymentDetailsandNavigate(
              response: returnValue, paymentStatus: PaymentStatusEnum.success);
        } else {
          updatePaymentDetailsandNavigate(
              response: returnValue, paymentStatus: PaymentStatusEnum.failure);
        }
      } else {
        CamspayResponseQrModel payResQr = CamspayResponseQrModel.fromJson(data);
        if (payResQr.status.data.isNotEmpty) {
          String qrStatus = payResQr.status.data.first.trxnStatus;
          if (qrStatus == AppConst.codeCaptured ||
              qrStatus == AppConst.codeSuccess) {
            bankTransactionId = payResQr.status.data.first.banktrxnno;
            updatePaymentDetailsandNavigate(
                response: returnValue,
                paymentStatus: PaymentStatusEnum.success);
          } else {
            updatePaymentDetailsandNavigate(
                response: returnValue,
                paymentStatus: PaymentStatusEnum.failure);
          }
        }
      }
    } else {
      updatePaymentDetailsandNavigate(
          response: response ?? "", paymentStatus: PaymentStatusEnum.failure);
      returnValue = "";
    }
  }


  void makePayuPayment() {
    _checkoutPro.openCheckoutScreen(
      payUPaymentParams: PayUParams.createPayUPaymentParams(
        amount: widget.paymentModel.totalPaybleAmount.toString(),
        transactionId: transactionId,
      ),
      payUCheckoutProConfig: PayUParams.createPayUConfigParams(
          paymentType: _selectedPaymentMode.name),
    );
  }
  void showErrorDialouge(String msg) {
    showDialog(
        context: context,
        builder: (context) {
          return ShowCustomDailougeWidget(
            buttonTitle: getString(lblClose),
            errorMsg: msg,
            ontap: () {
              Navigator.of(context).pop();
            },
          );
        });
  }
}
