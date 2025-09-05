import 'package:core/config/constant.dart';
import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/resources/image_constant.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/config/widgets/background/mf_gradient_background.dart';
import 'package:core/config/widgets/custom_buttons/mf_custom_elevated_button.dart';
import 'package:core/config/widgets/mf_appbar.dart';
import 'package:core/config/widgets/mf_progress_bar.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:core/utils/const.dart';
import 'package:core/utils/utils.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loan/features/foreclosure/data/models/get_loans_response.dart';
import 'package:service_request/config/routes/route.dart';
import 'package:service_request/features/bureau/config/bureau_const.dart';
import 'package:service_request/features/bureau/data/models/get_preset_uri_request.dart';
import 'package:service_request/features/bureau/data/models/service_data.dart';
import 'package:service_request/features/bureau/presentation/cubit/bureau_cubit.dart';
import 'package:service_request/features/bureau/presentation/screens/bottom_sheet_widget.dart';
import 'package:service_ticket/features/data/models/service_request_response.dart';
import 'package:service_ticket/features/data/models/sr_request.dart';
import 'package:service_ticket/features/presentation/cubit/service_request_cubit.dart';
import 'package:service_ticket/features/presentation/cubit/service_request_state.dart';

class ServiceBureauUploadDocuments extends StatefulWidget {
  final ServiceDataModel dataModel;

  const ServiceBureauUploadDocuments({super.key, required this.dataModel});

  @override
  _ServiceBureauUploadDocumentsState createState() =>
      _ServiceBureauUploadDocumentsState();
}

class _ServiceBureauUploadDocumentsState
    extends State<ServiceBureauUploadDocuments> {
  List<String> paymentListString = List.empty(growable: true);
  List<String> creditListString = List.empty(growable: true);
  List<bool> isImageAddedList = List.empty(growable: true);
  int selectedIndPayment = -1;
  int selectedIndCredit = -1;
  String fileName = "";
  bool canAddMore = true;
  bool canCreditAddMore = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    context.read<BureauCubit>().imageAdded(false, "", -1, true);
    paymentListString = List<String>.filled(1, '');
    creditListString = List<String>.filled(1, '');
    isImageAddedList = List<bool>.filled(4, false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: customAppbar(
        context: context,
        title: getString(lblBureauServices),
        onPressed: () {
          context.pop();
        },
      ),
      body: MFGradientBackground(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              getString(lblBureauUploadDocuments),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            Text(
              getString(imageSize),
              style: Theme.of(context).textTheme.labelSmall,
            ),
            const SizedBox(height: 20),
            if (widget.dataModel.selectedReason.toString() == "1") ...[
              BlocBuilder<BureauCubit, BureauState>(
                buildWhen: (previous, current) => current is PaymentUpdatedList,
                builder: (context, state) {
                  if (state is PaymentUpdatedList) {
                    paymentListString = state.paymentList;
                    canAddMore = state.canMore;
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            getString(lblBureauPaymentReceipt),
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          if (canAddMore)
                            InkWell(
                              onTap: () {
                                context
                                    .read<BureauCubit>()
                                    .addMore(paymentListString, canAddMore);
                              },
                              child: Text(
                                getString(lblBureauAddMore),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                        color: setColorBasedOnTheme(
                                            context: context,
                                            lightColor:
                                                AppColors.secondaryLight,
                                            darkColor:
                                                AppColors.secondaryLight5)),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      ListView.separated(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        separatorBuilder: (BuildContext context, int index) =>
                            const SizedBox(height: 10),
                        itemCount: paymentListString.length,
                        itemBuilder: (context, paymentIndex) {
                          return buildDocumentUploadRow(context, paymentIndex,
                              isPayment: true);
                        },
                      ),
                    ],
                  );
                },
              ),
            ],
            const SizedBox(height: 20),
            BlocBuilder<BureauCubit, BureauState>(
              buildWhen: (previous, current) => current is CreditUpdatedList,
              builder: (context, state) {
                if (state is CreditUpdatedList) {
                  creditListString = state.creditList;
                  canCreditAddMore = state.canCreditMore;
                }

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      getString(lblCreditReport),
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    if (canCreditAddMore)
                      InkWell(
                        onTap: () {
                          context.read<BureauCubit>().addCreditMore(
                              creditListString, canCreditAddMore);
                        },
                        child: Text(
                          getString(lblBureauAddMore),
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                  color: setColorBasedOnTheme(
                                      context: context,
                                      lightColor: AppColors.secondaryLight,
                                      darkColor: AppColors.secondaryLight5)),
                        ),
                      ),
                  ],
                );
              },
            ),
            const SizedBox(height: 20),
            BlocBuilder<BureauCubit, BureauState>(
              buildWhen: (previous, current) => current is CreditUpdatedList,
              builder: (context, state) {
                return Expanded(
                  child: ListView.separated(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    separatorBuilder: (BuildContext context, int index) =>
                        const SizedBox(height: 10),
                    itemCount: creditListString.length,
                    itemBuilder: (context, creditIndex) {
                      return buildDocumentUploadRow(context, creditIndex,
                          isPayment: false);
                    },
                  ),
                );
              },
            ),
            BlocConsumer<ServiceRequestCubit, ServiceRequestState>(
              listener: (context, state) {
                // Handling success state
                if (state is ServiceRequestSuccessState) {
                  // Check if the response code is success and data is not null
                  if (state.response.code == AppConst.codeSuccess &&
                      state.response.data != null) {
                    ServiceRequestResponse serviceRequestResponse =
                        state.response;
                    if (serviceRequestResponse.data?.isNewTicket == true) {
                      context.goNamed(
                        Routes.serviceRequestBureauRaised.name,
                        extra: state.response,
                      );
                    } else {
                      List<String>? serviceRequestList =
                          state.response.data?.oldTickets ?? [];
                      if (serviceRequestList.isNotEmpty) {
                        context.pushNamed(
                          Routes.serviceRequestBureauExist.name,
                          extra: serviceRequestResponse,
                        );
                      } else {
                        showSnackBar(
                          context: context,
                          message: state.response.message ??
                              getString(msgBureauSomethingWentWrong),
                        );
                      }
                    }
                  } else {
                    showSnackBar(
                      context: context,
                      message: state.response.message ??
                          getString(msgBureauSomethingWentWrong),
                    );
                  }
                }
                // Handling failure state
                else if (state is ServiceRequestFailureState) {
                  showSnackBar(
                    context: context,
                    message: state.error.toString(),
                  );
                  Navigator.of(context).pop();
                }
                // Handling loading state
                else if (state is ServiceRequestLoadingState) {
                  if (state.isLoading) {
                    showLoaderDialog(context, getString(lblBureauLoading));
                  } else {
                    Navigator.of(context, rootNavigator: true).pop();
                  }
                }
              },
              builder: (context, state) {
                return MfCustomButton(
                  onPressed: () {
                    if (isValidSubmission()) {
                      _callCreateServiceRequestAPI(context);
                    } else {
                      showSnackBar(
                        context: context,
                        message: getString(msgPleaseUploadDocument),
                      );
                    }
                  },
                  isDisabled: isValidSubmission() ? false : true,
                  text: getString(lblBureauSubmit),
                  outlineBorderButton: false,
                );
              },
            )
          ],
        ),
      ),
    );
  }

  Widget buildDocumentUploadRow(BuildContext context, int index,
      {required bool isPayment}) {
    return BlocConsumer<BureauCubit, BureauState>(
      buildWhen: (previous, current) => previous != current,
      listener: (context, state) async {
        if (state is BureauDocumentUploadState &&
            state.imagePayment == isPayment) {
          if (isPayment && selectedIndPayment == index) {
            isImageAddedList[index] = state.imageAdded;
            paymentListString[index] = state.imageName;
            context
                .read<BureauCubit>()
                .selectFileName(paymentListString[index]);
          } else if (!isPayment && selectedIndCredit == index) {
            isImageAddedList[index] = state.imageAdded;
            creditListString[index] = state.imageName;
            context.read<BureauCubit>().selectFileName(creditListString[index]);
          }
        }

        if (state is BureauGetPresetUriResponseSuccessState) {
          if (state.response.code == AppConst.codeSuccess &&
              state.useCase == BureauConst.deleteDocument) {
            if (state.isPayment == true && selectedIndPayment == index) {
              context.read<BureauCubit>().deleteDocuments(
                  state.response.presetURL ?? "", selectedIndPayment, true);
            } else if (state.isPayment == false && selectedIndCredit == index) {
              context.read<BureauCubit>().deleteDocuments(
                  state.response.presetURL ?? "", selectedIndCredit, false);
            }
          } else {
            showSnackBar(
                context: context, message: state.response.message ?? "");
          }
        } else if (state is BureauGetPresetUriResponseFailureState) {
          showSnackBar(
              context: context, message: getFailureMessage(state.failure));
        } else if (state is BureauImageCompressForPaymentState &&
            state.compressSuccess &&
            isPayment &&
            (selectedIndPayment == index)) {
          String? imageName = await context.pushNamed(
              Routes.uploadDocScreen.name,
              extra: UploadDataModel(
                  imagePath: state.imageFile!.path.toString(),
                  index: index,
                  isPayment: true));

          if (imageName == null && context.mounted) {
            context
                .read<BureauCubit>()
                .imageAdded(false, "", selectedIndPayment, true);
          } else if (context.mounted) {
            context
                .read<BureauCubit>()
                .imageAdded(true, imageName!, selectedIndPayment, true);
          }
        } else if (state is BureauImageCompressForCreditState &&
            state.compressSuccess &&
            !isPayment &&
            (selectedIndCredit == index)) {
          String? imageName = await context.pushNamed(
              Routes.uploadDocScreen.name,
              extra: UploadDataModel(
                  imagePath: state.imageFile!.path.toString(),
                  index: index,
                  isPayment: false));

          if (imageName == null && context.mounted) {
            context
                .read<BureauCubit>()
                .imageAdded(false, "", selectedIndCredit, false);
          } else if (context.mounted) {
            context
                .read<BureauCubit>()
                .imageAdded(true, imageName!, selectedIndCredit, false);
          }
        } else if (state is BureauDocumentStatusFailure) {
          showSnackBar(
              context: context, message: getFailureMessage(state.failure));
        } else if (state is BureauDocumentStatusSuccess &&
            state.useCase == BureauConst.deleteDocument) {
          // Use the index directly from the state to check
          if (state.isPayment && state.index == selectedIndPayment) {
            _removeImage(
                context, state.isPayment, state.index, selectedIndPayment);
          } else if (!state.isPayment && state.index == selectedIndCredit) {
            _removeImage(
                context, state.isPayment, state.index, selectedIndCredit);
          }
        } else if (state is BureauUploadLoadingState) {
          if (state.isUploadLoading) {
            showLoaderDialog(context, getString(lblBureauLoading));
          } else {
            Navigator.of(context, rootNavigator: true).pop();
          }
        }
      },
      builder: (context, state) {
        String fileName =
            isPayment ? paymentListString[index] : creditListString[index];
        bool isFileNameAvailable = fileName.isNotEmpty;

        return GestureDetector(
          onTap: () {
            if (!isFileNameAvailable) {
              showBottomWidget(
                context: context,
                onCameraUpload: () async {
                  if (isPayment) {
                    selectedIndPayment = index;
                  } else {
                    selectedIndCredit = index;
                  }

                  final ImagePicker picker = ImagePicker();
                  final XFile? image = await picker.pickImage(source: ImageSource.camera);
                  if (context.mounted && image != null) {
                    if (isPayment) {
                      context.read<BureauCubit>().compressImage(image, isPayment, index);
                    } else {
                      context.read<BureauCubit>().compressImage(image, isPayment, index);
                    }
                  }
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                },
                onImageUpload: () async {
                  if (isPayment) {
                    selectedIndPayment = index;
                  } else {
                    selectedIndCredit = index;
                  }

                  final ImagePicker picker = ImagePicker();
                  final XFile? image =
                  await picker.pickImage(source: ImageSource.gallery);
                  if (context.mounted && image != null) {
                    if (isPayment) {
                      context.read<BureauCubit>().compressImage(image, isPayment, index);
                    } else {
                      context.read<BureauCubit>().compressImage(image, isPayment, index);
                    }
                  }
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                },
                onFileUpload: () async {
                  if (isPayment) {
                    selectedIndPayment = index;
                  } else {
                    selectedIndCredit = index;
                  }
                  FilePickerResult? result = await FilePicker.platform.pickFiles();
                  if (result != null) {
                    XFile file = XFile(result.files.single.path!);
                    if (context.mounted) {
                      if (isPayment) {
                        context
                            .read<BureauCubit>()
                            .compressImage(file, isPayment, index);
                      } else {
                        context
                            .read<BureauCubit>()
                            .compressImage(file, isPayment, index);
                      }
                    }
                  }
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                },
              );
            }
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: GestureDetector(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Center(
                    child: Icon(
                      Icons.upload_file_outlined,
                      size: 30,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Updated logic to display payment or credit image name
                  isFileNameAvailable
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              fileName,
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              getString(lblBureauUploadDocument),
                              style: Theme.of(context).textTheme.titleSmall,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              getString(lblBureauNoUploads),
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                          ],
                        ),
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      if (isFileNameAvailable) {
                        if (isPayment) {
                          selectedIndPayment = index;
                        } else {
                          selectedIndCredit = index;
                        }

                        if (isPayment && selectedIndPayment == index) {
                          GetPresetUriRequest request = GetPresetUriRequest(
                            fileName: fileName,
                            useCase: BureauConst.deleteDocument,
                          );
                          context.read<BureauCubit>().getPresetUri(
                                request,
                                index,
                                isPayment,
                                operation: BureauConst.deleteDocument,
                              );
                        } else if (!isPayment && selectedIndCredit == index) {
                          GetPresetUriRequest request = GetPresetUriRequest(
                            fileName: fileName,
                            useCase: BureauConst.deleteDocument,
                          );
                          context.read<BureauCubit>().getPresetUri(
                                request,
                                index,
                                isPayment,
                                operation: BureauConst.deleteDocument,
                              );
                        }
                      } else {
                        showBottomWidget(
                          context: context,
                          onCameraUpload: () async {
                            if (isPayment) {
                              selectedIndPayment = index;
                            } else {
                              selectedIndCredit = index;
                            }

                            final ImagePicker picker = ImagePicker();
                            final XFile? image = await picker.pickImage(source: ImageSource.camera);
                            if (context.mounted && image != null) {
                              if (isPayment) {
                                context.read<BureauCubit>().compressImage(image, isPayment, index);
                              } else {
                                context.read<BureauCubit>().compressImage(image, isPayment, index);
                              }
                            }
        if (context.mounted) {
          Navigator.pop(context);
        }
                          },
                          onImageUpload: () async {
                            if (isPayment) {
                              selectedIndPayment = index;
                            } else {
                              selectedIndCredit = index;
                            }

                            final ImagePicker picker = ImagePicker();
                            final XFile? image =
                            await picker.pickImage(source: ImageSource.gallery);
                            if (context.mounted && image != null) {
                              if (isPayment) {
                                context.read<BureauCubit>().compressImage(image, isPayment, index);
                              } else {
                                context.read<BureauCubit>().compressImage(image, isPayment, index);
                              }
                            }
                            if (context.mounted) {
                              Navigator.pop(context);
                            }
                          },
                          onFileUpload: () async {
                            if (isPayment) {
                              selectedIndPayment = index;
                            } else {
                              selectedIndCredit = index;
                            }
                            FilePickerResult? result =
                                await FilePicker.platform.pickFiles();
                            if (result != null) {
                              XFile file = XFile(result.files.single.path!);
                              if (context.mounted) {
                                if (isPayment) {
                                  context
                                      .read<BureauCubit>()
                                      .compressImage(file, isPayment, index);
                                } else {
                                  context
                                      .read<BureauCubit>()
                                      .compressImage(file, isPayment, index);
                                }
                              }
                            }
                            if (context.mounted) {
                              Navigator.pop(context);
                            }
                          },
                        );
                      }
                    },
                    child: SvgPicture.asset(
                      isFileNameAvailable
                          ? ImageConstant.imgDelete
                          : ImageConstant.imgUpload,
                      height: 24,
                      width: 24,
                      colorFilter: ColorFilter.mode(
                        setColorBasedOnTheme(
                          context: context,
                          lightColor: AppColors.secondaryLight,
                          darkColor: AppColors.secondaryLight5,
                        ),
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }


  bool isValidSubmission() {
    return paymentListString.any((fileName) => fileName.isNotEmpty) ||
        creditListString.any((fileName) => fileName.isNotEmpty);
  }

  void _removeImage(
      BuildContext context, bool isPayment, int index, int selectedIndex) {
    if (selectedIndex == index) {
      if (isPayment) {
        paymentListString[index] = '';
      } else {
        creditListString[index] = '';
      }
    }
  }

  String getDocumentLink() {
    paymentListString = List<String>.from(paymentListString);
    paymentListString.addAll(creditListString);
    String imgString = '';
    for (var e in paymentListString) {
      if (imgString.isNotEmpty) {
        imgString += ',';
      }
      imgString += e;
    }
    return imgString;
  }

  _callCreateServiceRequestAPI(BuildContext context) {
    LoanItem? loanItem = widget.dataModel.loanItem;
    String isLoanNotAvailable = widget.dataModel.selectedProduct;
    bool isLoanNot = isLoanNotAvailable == "none" ? true : false;
    String none = "None";
    String caseType = widget.dataModel.selectedReason;
    var request = SRRequest(
        superAppId: getSuperAppId(),
        caseType: caseType == "1"
            ? CaseType.bureauCaseType1
            : caseType == "2"
                ? CaseType.bureauCaseType2
                : caseType == "3"
                    ? CaseType.bureauCaseType3
                    : 0,
        customerId: isLoanNot ? getUCIC() : loanItem?.ucic,
        lob: isLoanNot ? none : loanItem?.lob,
        mobileNumber: getPhoneNumber(),
        productName: isLoanNot ? none : loanItem?.productName,
        customerName: getUserName(),
        documentLink: getDocumentLink(),
        channel: "App",
        description: "Bureau ${loanItem?.loanNumber}",
        productCategory: isLoanNot ? "" : loanItem?.productCategory,
        contractId: isLoanNot ? "" : loanItem?.loanNumber,
        sourceSystem: isLoanNot ? "" : loanItem?.sourceSystem);

    BlocProvider.of<ServiceRequestCubit>(context)
        .generateServiceRequest(request);
  }
}
