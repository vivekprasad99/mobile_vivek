import 'package:ach/config/routes/route.dart' as ach;
import 'package:ach/data/models/payer_detail_model.dart';
import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/resources/app_decoration.dart';
import 'package:core/config/resources/custom_elevated_button.dart';
import 'package:core/config/resources/custom_text_style.dart';
import 'package:core/config/resources/image_constant.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/config/widgets/background/mf_gradient_background.dart';
import 'package:core/config/widgets/common_widgets/custom_floating_text_field.dart';
import 'package:core/config/widgets/custom_drop_down.dart';
import 'package:core/config/widgets/mf_appbar.dart';
import 'package:core/config/widgets/mf_progress_bar.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:core/config/widgets/mf_toast.dart';
import 'package:core/utils/const.dart';
import 'package:core/utils/size_utils.dart';
import 'package:core/utils/utils.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:help/features/utils/constant_help.dart';
import 'package:help/features/utils/help_common_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:service_ticket/features/data/models/service_request_response.dart';
import 'package:service_ticket/features/data/models/sr_request.dart';
import 'package:service_ticket/features/presentation/cubit/service_request_cubit.dart';
import 'package:service_ticket/features/presentation/cubit/service_request_state.dart';

import '../../../config/ach_const.dart';
import '../../../config/ach_util.dart';
import '../../../data/models/add_bank_detail_model.dart';
import '../../../data/models/get_ach_loans_response.dart';
import '../../../data/models/get_bank_list_resp.dart';
import '../../../data/models/get_preset_uri_request.dart';
import '../../../data/models/update_mandate_info.dart';
import '../../cubit/ach_cubit.dart' as ach_cubit;
import 'package:service_request/config/routes/route.dart' as service_ticket;

class NameMismatchScreen extends StatefulWidget {
  final LoanData loanData;
  final Bank selectedBank;
  final VerificationOption verificationMode;
  final String selectedApplicant;
  final BankAccountDetail bankAccountDetail;
  final VpaPayerDetail vpaPayerDetail;
  final UpdateMandateInfo updateMandateInfo;

  const NameMismatchScreen({super.key, required this.loanData, required this.selectedBank, required this.verificationMode, required this.selectedApplicant, required this.bankAccountDetail, required this.vpaPayerDetail, required this.updateMandateInfo});

  @override
  State<NameMismatchScreen> createState() => _NameMismatchScreenState();
}

class _NameMismatchScreenState extends State<NameMismatchScreen> {
  bool isImageAdded = false;
  String? imageName;
  final List<String> _listOfDocument = ['Check Leaf Image', 'PassBook'];
  String? selectedItem;
  BuildContext? mContext;
  TextEditingController textFieldController = TextEditingController();
  @override
  void initState() {
    super.initState();
    mContext?.read<ach_cubit.AchCubit>().imageAdded(false, "");
  }

  @override
  Widget build(BuildContext context) {
    mContext = context;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: customAppbar(
          context: context,
          title: getString(lblMandateCreateMandate),
          onPressed: () {
            Navigator.pop(context);
          },
          actions: [HelpCommonWidget(categoryval: HelpConstantData.categoryMandateRegistration,subCategoryval: HelpConstantData.subCategoryVerification)],
        ),
        body: MFGradientBackground(
          horizontalPadding: 0.h,
          verticalPadding: 20.v,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // SizedBox(height: 28.v),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 5.v),
                    padding: EdgeInsets.symmetric(horizontal: 15.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 56,
                          color: setColorBasedOnTheme(
                              context: context,
                              lightColor: AppColors.secondaryLight,
                              darkColor: AppColors.primaryLight5),
                        ),
                        const SizedBox(height: 15,),
                        Padding(
                          padding: EdgeInsets.only(left: 1.h),
                          child: Text(
                            getString(lblNameMismatch),
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ),
                        SizedBox(height: 15.v),
                        Container(
                          decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(8)),
                          child: Padding(
                            padding: EdgeInsets.all(12.h),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.error,
                                      size: 12.67,
                                      color: AppColors.iconColor,
                                    ),
                                    Text(
                                      " ${getString(msgSorryWeCould)}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 17.v),
                                Container(
                                  width: 291.h,
                                  margin: EdgeInsets.only(
                                    left: 1.h,
                                    right: 37.h,
                                  ),
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: getString(lblPleaseUpload),
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelSmall,
                                        ),
                                        TextSpan(
                                          text: getString(msgChequeLeafImage),
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelSmall
                                              ?.copyWith(
                                                  fontWeight: FontWeight.w700),
                                        ),
                                        TextSpan(
                                          text:
                                              getString(forFurtherConfirmation),
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelSmall,
                                        ),
                                      ],
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 26.v),
                        _buildReferenceDocWidget(context),
                        SizedBox(height: 26.v),
                        _buildUploadDocWidget(context),
                        SizedBox(height: 43.v),
                        Padding(
                          padding: EdgeInsets.only(left: 1.h),
                          child: Builder(
                            builder: (
                              context,
                            ) {
                              return MfCustomFloatingTextField(
                                autofocus: false,
                                controller: textFieldController,
                                hintText: getString(msgMandateRemarksOptional),
                                textStyle:
                                    Theme.of(context).textTheme.bodyLarge,
                                hintStyle:
                                    Theme.of(context).textTheme.bodyLarge,
                                borderDecoration: UnderlineInputBorder(
                                  borderRadius: BorderRadius.circular(4.h),
                                  borderSide: BorderSide(
                                    color: setColorBasedOnTheme(
                                        context: context,
                                        lightColor: AppColors.primaryLight,
                                        darkColor: AppColors.secondaryLight5),
                                    width: 1,
                                  ),
                                ),
                                textInputAction: TextInputAction.done,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: _buildContinue(context),
      ),
    );
  }

  Widget _buildReferenceDocWidget(BuildContext context) {
    return Container(
      height: 64.v,
      width: 328.h,
      margin: EdgeInsets.only(left: 1.h),
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomDropDown(
              icon: SvgPicture.asset(
                fit: BoxFit.cover,
                ImageConstant.imgDropDown,
                height: 40.h,
                width: 40.h,
              ),
              hintText: getString(msgReferenceDocument),
              items:
                  _listOfDocument.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium
                        ?.copyWith(fontSize: 16),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                selectedItem = value;
              })
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildUploadDocWidget(BuildContext context) {
    return BlocConsumer<ach_cubit.AchCubit, ach_cubit.AchState>(
      listener: (context, state) async {
        if (state is ach_cubit.DocumentUploadState) {
          isImageAdded = state.imageAdded;
          imageName = state.imageName;
        }
        if (state is ach_cubit.GetPresetUriResponseSuccessState) {
          if (state.response.code == AppConst.codeSuccess) {
            if (state.useCase == AchConst.deleteDocument) {
              context
                  .read<ach_cubit.AchCubit>()
                  .deleteDocuments(state.response.presetURL ?? "");
            }
          } else {
            toastForFailureMessage(
                context: context,
                msg: state.response.message ?? "");
          }
        } else if (state is ach_cubit.GetPresetUriResponseFailureState) {
          toastForFailureMessage(
              context: context,
              msg: getFailureMessage(state.failure));
        } else if (state is ach_cubit.ImageCompressState) {
          if (state.compressSuccess) {
            String? imageName = await context.pushNamed(
                ach.Routes.uploadDocumentScreen.name,
                extra: {"imagePath":  state.imageFile?.path, "updateToS3": true});
            if (imageName == null) {
              if(context.mounted) {
                context.read<ach_cubit.AchCubit>().imageAdded(false, "");
              }
            } else {
              if(context.mounted) {
                context.read<ach_cubit.AchCubit>().imageAdded(true, imageName);
              }
            }
          } else {
            displayAlertSingleAction(context,state.errorMessage,btnLbl: getString(lblMandateOk), btnTap: () {
              context.pop();
            });
          }
        } else if (state is ach_cubit.DocumentStatusFailure) {
          toastForFailureMessage(
              context: context,
              msg: getFailureMessage(state.failure));
        } else if (state is ach_cubit.DocumentStatusSuccess) {
          if (state.useCase == AchConst.deleteDocument) {
            context.read<ach_cubit.AchCubit>().imageAdded(false, "");
          }
        } else if(state is ach_cubit.LoadingState){
          if (state.isloading) {
            showLoaderDialog(context, getString(lblMandateLoading));
          } else {
            Navigator.of(context, rootNavigator: true).pop();
          }
        } else if(state is ach_cubit.LoadingDialogState){
          if (state.isloading) {
            showLoaderDialog(context, getString(lblMandateLoading));
          } else {
            Navigator.of(context, rootNavigator: true).pop();
          }
        }
      },
      builder: (context, state) {
        return BlocBuilder<ach_cubit.AchCubit, ach_cubit.AchState>(
          builder: (context, state) {
            return Container(
              color: Theme.of(context).cardColor,
              height: 135.v,
              width: 328.h,
              margin: EdgeInsets.only(left: 1.h),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                          backgroundColor: Theme.of(context).cardColor,
                          context: context,
                          builder: (_) => Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(
                                  getString(lblAchUploadDocument),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceAround,
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        final picker = ImagePicker();
                                        final XFile? image =
                                        await picker.pickImage(source: ImageSource.camera);
                                        if (context.mounted &&
                                            image != null) {
                                          context.read<ach_cubit.AchCubit>().compressImage(image);
                                        }
                                        if(context.mounted) {
                                          Navigator.pop(context);
                                        }
                                      },
                                      child: Column(
                                        children: [
                                          Container(
                                            decoration:
                                            const BoxDecoration(
                                                shape:
                                                BoxShape.circle),
                                            child: Icon(
                                              Icons.camera_alt_outlined,
                                              size: 40,
                                              color: setColorBasedOnTheme(
                                                  context: context,
                                                  lightColor: AppColors
                                                      .primaryLight,
                                                  darkColor:
                                                  Colors.white),
                                            ),
                                          ),
                                          SizedBox(height: 5.h,),
                                          Text(
                                            getString(lblLoginCamera),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall,
                                          ),
                                        ],
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        final picker = ImagePicker();
                                        final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                                        if (context.mounted && image != null) {
                                          context.read<ach_cubit.AchCubit>().compressImage(image);
                                        }
                                        if(context.mounted) {
                                          Navigator.pop(context);
                                        }
                                      },
                                      child: Column(
                                        children: [
                                          Container(
                                            decoration:
                                            const BoxDecoration(
                                                shape:
                                                BoxShape.circle),
                                            child: Icon(
                                              Icons.image_outlined,
                                              size: 40,
                                              color: setColorBasedOnTheme(
                                                  context: context,
                                                  lightColor: AppColors
                                                      .primaryLight,
                                                  darkColor:
                                                  Colors.white),
                                            ),
                                          ),
                                          SizedBox(height: 5.h,),
                                          Text(
                                            getString(lblMandateGallery),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall,
                                          ),
                                        ],
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        FilePickerResult? result =
                                        await FilePicker.platform.pickFiles();
                                        if (result != null) {
                                          XFile file = XFile(
                                              result.files.single.path!);
                                          if(context.mounted) {
                                            context.read<ach_cubit.AchCubit>().compressImage(file);
                                          }
                                        }
                                        if(context.mounted) {
                                          Navigator.pop(context);
                                        }
                                      },
                                      child: Column(
                                        children: [
                                          Container(
                                            decoration:
                                            const BoxDecoration(
                                                shape:
                                                BoxShape.circle),
                                            child: Icon(
                                              Icons.description_outlined,
                                              size: 40,
                                              color: setColorBasedOnTheme(
                                                  context: context,
                                                  lightColor: AppColors
                                                      .primaryLight,
                                                  darkColor:
                                                  Colors.white),
                                            ),
                                          ),
                                          SizedBox(height: 5.h,),
                                          Text(
                                            getString(lblMandateFile),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ));
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 10.v),
                      padding: EdgeInsets.symmetric(
                        horizontal: 15.h,
                        vertical: 6.v,
                      ),
                      decoration: AppDecoration.outlineGray.copyWith(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadiusStyle.roundedBorder8,
                        border: Border.all(color: Colors.transparent),
                      ),
                      child: Row(
                        children: [
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Icon(
                                Icons.upload_file,
                                color: setColorBasedOnTheme(
                                    context: context,
                                    lightColor: AppColors.primaryLight,
                                    darkColor: Colors.white),
                              )),
                          Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(
                                  left: 17.h,
                                  top: 4.v,
                                ),
                                child: !isImageAdded
                                    ? Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      getString(lblAchUploadDocument),
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium
                                          ?.copyWith(
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text(getString(lblMandateNoUploads),
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall),
                                  ],
                                )
                                    : Text(
                                  getFormattedFileName(imageName ?? ""),
                                  style: CustomTextStyles
                                      .titleSmallPoppinsErrorContainer,
                                ),
                              )),
                          Align(
                              alignment: Alignment.centerRight,
                              child: InkWell(
                                  onTap: () {
                                    if (isImageAdded) {
                                      GetPresetUriRequest request =
                                      GetPresetUriRequest(
                                          fileName: imageName,
                                          useCase:
                                          AchConst.deleteDocument,
                                          superAppId: getSuperAppId(), source: AppConst.source);
                                      context.read<ach_cubit.AchCubit>().getPresetUri(
                                          request,
                                          operation: AchConst.deleteDocument);
                                    }
                                  },
                                  child: SvgPicture.asset(
                                    isImageAdded
                                        ? ImageConstant.imgDelete
                                        : ImageConstant.imgUpload,
                                    height: 24,
                                    width: 24,
                                      colorFilter: ColorFilter.mode(
                                          setColorBasedOnTheme(
                                              context: context,
                                              lightColor: AppColors.primaryLight,
                                              darkColor: Colors.white),
                                          BlendMode.srcIn)
                                  )))
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 5.h,
                      right: 5.h,
                    ),
                    child: Container(
                      width: 300.h,
                      margin: EdgeInsets.only(left: 7.h),
                      child: Text(
                        getString(msgImageFileSize),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildContinue(BuildContext context) {
    return BlocConsumer<ServiceRequestCubit, ServiceRequestState>(
      listener: (context, state) {
        if (state is ServiceRequestSuccessState) {
          if (state.response.code == AppConst.codeSuccess && state.response.data != null) {
            ServiceRequestResponse serviceRequestResponse = state.response;
            if (serviceRequestResponse.data?.isNewTicket == true) {
              context.goNamed(service_ticket.Routes.serviceRequestBureauRaised.name,
                  extra: state.response);
            }
            else {
              List<String>? serviceRequestList = state.response.data?.oldTickets ?? [];
              if (serviceRequestList.isNotEmpty) {
                ServiceRequestResponse serviceRequestResponse = state.response;
                context.pushNamed(service_ticket.Routes.serviceRequestBureauExist.name,
                    extra: serviceRequestResponse);
              }
              else {
                showSnackBar(
                    context: context, message: state.response.message ?? getString(msgSomethingWentWrong));
              }
            }
          } else {
            displayAlertSingleAction(
                context, state.response.message ?? "",
                btnLbl: getString(lblMandateOk), btnTap: () {
              context.pop();
            });
            context.pop();
          }
        } else if (state is ServiceRequestFailureState) {
          toastForFailureMessage(context: context, msg: getFailureMessage(state.error));
          context.pop();
        } else if (state is ServiceRequestLoadingState) {
          if (state.isLoading) {
            showLoaderDialog(context, getString(lblMandateLoading));
          } else {
            Navigator.of(context, rootNavigator: true).pop();
          }
        }
      },
      builder: (context, state) {
        return BlocBuilder<ach_cubit.AchCubit, ach_cubit.AchState>(
          builder: (context, state) {
            return CustomElevatedButton(
              text: getString(lblMandateContinue),
              margin: EdgeInsets.only(
                left: 16.h,
                right: 16.h,
                bottom: 20.v,
              ),
              buttonStyle: ElevatedButton.styleFrom(
                  backgroundColor: isImageAdded != false
                      ? Theme.of(context).highlightColor
                      : Theme.of(context).disabledColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.h),
                  )),
              buttonTextStyle: isImageAdded != false
                  ? Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: AppColors.white)
                  : Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).unselectedWidgetColor),
              onPressed: () async {
                if (isImageAdded) {
                  if (context.mounted) {
                    if(getVerificationModeShortCode(widget.verificationMode.optionId??"").shortCode == VerificationMode.upi.shortCode){
                      // var request = GenerateUpiMandateRequest(
                      //     amount: widget.loanData.installmentAmount,
                      //     mandatestartdate: getCurrentDate(),
                      //     mandateenddate: widget.loanData.endDate,
                      //     payername: widget.vpaPayerDetail.payerName,
                      //     payervpa: widget.vpaPayerDetail.payerVpa,
                      //     pattern: AchConst.createMandatePattern,
                      //     revokeable: AchConst.achRevokeable,
                      //     redirecturl: "");
                      // context.read<AchCubit>().generateUpiMandateReq(request);

                      var request = SRRequest(
                        caseType: AchConst.caseTypeCreateEMandate,
                        customerId: getUCIC(),
                        lob:widget.loanData.lob,
                        mobileNumber: getPhoneNumber(),
                        productName:widget.loanData.productName,
                        category: AchConst.srCategoryAchMandate,
                        documentLink: imageName,
                        customerName: getUserName(),
                        subCategory: AchConst.srSubCategoryAchMandate,
                        channel: AchConst.srChannelAchMandate,
                        srType: AchConst.srRequestTypeAchMandate,
                        description: "N/A",
                        productCategory: widget.loanData.productCategory,
                        contractId: widget.loanData.loanAccountNumber,
                        sourceSystem: widget.loanData.sourceSystem,
                        remarks: textFieldController.text.isNotEmpty ? textFieldController.text : "N/A", ocrRequired: "Y");

                      context.read<ServiceRequestCubit>().generateServiceRequest(request);

                      // context.read<ach_cubit.AchCubit>().generateSR(
                      //     GenerateSrRequest(
                      //         caseType: AchConst.caseTypeCreateEMandate,
                      //         customerName: widget.selectedApplicant.split("#&#")[1],
                      //         customerId: getSuperAppId(),
                      //         category: AchConst.srCategoryAchMandate,
                      //         subCategory: AchConst.srSubCategoryAchMandate,
                      //         srType: AchConst.srRequestTypeAchMandate,
                      //         inAppNotification: "0",
                      //         lob: widget.loanData.lob,
                      //         productName: widget.loanData.productName,
                      //         channel: AchConst.srChannelAchMandate,
                      //         mobileNumber: getPhoneNumber(),
                      //         description: "N/A",
                      //         remarks: textFieldController.text.isNotEmpty ? textFieldController.text : "N/A",
                      //         documentLink: imageName,
                      //         productCategory: widget.loanData.productCategory,
                      //         sourceSystem: widget.loanData.sourceSystem,
                      //         contractId: widget.loanData.loanAccountNumber),
                      //     AchConst.srCreateMandate);
                    } else {
                      // var request = GenerateMandateRequest(
                      //     accountholdername: widget.selectedApplicant.split("#&#")[1],
                      //     accounttype: widget.bankAccountDetail.accountType,
                      //     authenticationmode: getVerificationModeShortCode(widget.verificationMode.optionId ?? "").shortCode,
                      //     bankcode: widget.selectedBank.bankCode,
                      //     emailid: "",
                      //     mandateType: getMandateType(widget.verificationMode.optionName??""),
                      //     mobileno: getPhoneNumber(),
                      //     accountnumber: widget.bankAccountDetail.bankAccountNo,
                      //     amount: widget.loanData.installmentAmount,
                      //     ifsc: widget.bankAccountDetail.ifscCode,
                      //     mandatestartdate: getCurrentDate(),
                      //     mandateenddate: widget.loanData.endDate,
                      //     pan: "",
                      //     frequencydeduction: AchConst.frequencydeduction,
                      //     payername: "",
                      //     payervpa: "",
                      //     productName: widget.loanData.productName,
                      //     sourceSystem: widget.loanData.sourceSystem,
                      //     pattern: AchConst.createMandatePattern,
                      //     revokeable: AchConst.achRevokeable,
                      //     redirecturl: "");
                      // context.read<AchCubit>().generateMandateReq(request);

                      var request = SRRequest(
                        caseType: AchConst.caseTypeCreateEMandate,
                        customerId: getUCIC(),
                        lob:widget.loanData.lob,
                        mobileNumber: getPhoneNumber(),
                          customerName: getUserName(),
                        productName:widget.loanData.productName,
                        category: AchConst.srCategoryAchMandate,
                        documentLink: imageName,
                        subCategory: AchConst.srSubCategoryAchMandate,
                        channel: AchConst.srChannelAchMandate,
                        srType: AchConst.srRequestTypeAchMandate,
                        productCategory: widget.loanData.productCategory,
                        contractId: widget.loanData.loanAccountNumber,
                        bankAccountNo: widget.bankAccountDetail.bankAccountNo,
                        ifscCode: widget.bankAccountDetail.ifscCode,
                        sourceSystem: widget.loanData.sourceSystem,
                        ocrRequired: "Y",
                        description: textFieldController.text.isNotEmpty ? textFieldController.text : "N/A",
                        remarks: textFieldController.text.isNotEmpty ? textFieldController.text : "N/A");

                      context.read<ServiceRequestCubit>().generateServiceRequest(request);

                      // context.read<ach_cubit.AchCubit>().generateSR(
                      //     GenerateSrRequest(
                      //         caseType: AchConst.caseTypeCreateEMandate,
                      //         customerName:
                      //             widget.selectedApplicant.split("#&#")[1],
                      //         customerId: getSuperAppId(),
                      //         category: AchConst.srCategoryAchMandate,
                      //         subCategory: AchConst.srSubCategoryAchMandate,
                      //         srType: AchConst.srRequestTypeAchMandate,
                      //         inAppNotification: "0",
                      //         lob: widget.loanData.lob,
                      //         productName: widget.loanData.productName,
                      //         channel: AchConst.srChannelAchMandate,
                      //         mobileNumber: getPhoneNumber(),
                      //         description: "N/A",
                      //         remarks: textFieldController.text.isNotEmpty ? textFieldController.text : "N/A",
                      //         bankAccountNo:
                      //             widget.bankAccountDetail.bankAccountNo,
                      //         documentLink: imageName,
                      //         ifscCode: widget.bankAccountDetail.ifscCode,
                      //         productCategory: widget.loanData.productCategory,
                      //         sourceSystem: widget.loanData.sourceSystem,
                      //         contractId: widget.loanData.loanAccountNumber),
                      //     AchConst.srCreateMandate);
                    }
                  }
                }
              },
            );
          },
        );
      },
    );
  }
}
