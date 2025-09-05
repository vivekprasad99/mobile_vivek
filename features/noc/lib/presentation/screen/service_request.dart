import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/resources/app_decoration.dart';
import 'package:core/config/resources/custom_text_style.dart';
import 'package:core/config/resources/image_constant.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/config/widgets/background/mf_gradient_background.dart';
import 'package:core/config/widgets/common_widgets/mf_custom_text_field.dart';
import 'package:core/config/widgets/mf_appbar.dart';
import 'package:core/config/widgets/mf_custom_elevated_button.dart';
import 'package:core/config/widgets/mf_progress_bar.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:core/utils/const.dart';
import 'package:core/utils/size_utils.dart';
import 'package:core/utils/utils.dart';
import 'package:core/utils/validation_functions.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:noc/data/models/noc_service_req_params.dart';
import 'package:service_ticket/config/routes/route.dart' as service_route;
import 'package:service_ticket/constants/sr_constant.dart';
import 'package:service_ticket/features/data/models/get_preset_uri_request.dart';
import 'package:service_ticket/features/data/models/service_request_response.dart';
import 'package:service_ticket/features/data/models/sr_request.dart';
import 'package:service_ticket/features/presentation/cubit/service_request_cubit.dart';
import 'package:service_ticket/features/presentation/cubit/service_request_state.dart';

class ServiceRequesScreent extends StatefulWidget {
  final NocServiceReqParams data;
  const ServiceRequesScreent({
    super.key,
    required this.data,
  });

  @override
  ServiceRequesScreentState createState() => ServiceRequesScreentState();
}

class ServiceRequesScreentState extends State<ServiceRequesScreent> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController description = TextEditingController();
  final TextEditingController alternateNumber = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  var srParams = <String, String>{};

  bool isImageAdded = false;
  String? imageName;

  bool isSecondImageAdded = false;
  String? secondImageName;

  @override
  void initState() {
    context.read<ServiceRequestCubit>().imageAdded(false, "");
    super.initState();
  }

  @override
  void dispose() {
    description.dispose();
    alternateNumber.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocListener<ServiceRequestCubit, ServiceRequestState>(
        listener: (context, state) {
          if (state is ServiceRequestSuccessState) {
            if (state.response.code == AppConst.codeSuccess &&
                state.response.data != null) {
              ServiceRequestResponse serviceRequestResponse = state.response;
              if (serviceRequestResponse.data?.isNewTicket == true) {
                context.goNamed(
                    service_route.Routes.requestAcknowledgeScreen.name,
                    extra: state.response);
              } else {
                List<String>? serviceRequestList =
                    state.response.data?.oldTickets ?? [];
                if (serviceRequestList.isNotEmpty) {
                  ServiceRequestResponse serviceRequestResponse =
                      state.response;
                  context.pushNamed(
                      service_route.Routes.serviceTicketExist.name,
                      extra: serviceRequestResponse);
                } else {
                  showSnackBar(
                      context: context,
                      message: state.response.message ??
                          getString(msgSomethingWentWrong));
                }
              }
            } else {
              showSnackBar(
                  context: context,
                  message: state.response.message ??
                      getString(msgSomethingWentWrong));
            }
          } else if (state is ServiceRequestFailureState) {
            showSnackBar(context: context, message: state.error.toString());
          }
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: customAppbar(
              context: context,
              title: getString(labelRaiseRequest),
              onPressed: () {
                context.pop();
              }),
          body: MFGradientBackground(
            horizontalPadding: 20,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10.v),
                    Text(
                      widget.data.srType == "update"
                          ? getString(lblRcUpdateDetailsMismatch)
                          : getString(lblNocNotDelivered),
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Text(
                      "${getString(loanNo)} ${widget.data.loanAccountNumber ?? ""}",
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    SizedBox(height: 10.v),
                    Column(
                      children: [
                        SizedBox(height: 10.v),
                        MfCustomFloatingTextField(
                          controller: description,
                          onChange: (text) {
                            srParams['description'] = text;
                          },
                          labelText: getString(labelDescription),
                          textStyle:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: setColorBasedOnTheme(
                                    context: context,
                                    lightColor: AppColors.primaryLight,
                                    darkColor: AppColors.secondaryLight5,
                                  )),
                          labelStyle:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: setColorBasedOnTheme(
                                    context: context,
                                    lightColor: AppColors.primaryLight,
                                    darkColor: AppColors.secondaryLight5,
                                  )),
                          alignment: Alignment.center,
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
                        ),
                        SizedBox(height: 20.v),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Upload documents (optional)",
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            GestureDetector(
                              onTap: () {
                                context
                                    .read<ServiceRequestCubit>()
                                    .selectAddMore(true);
                              },
                              child: BlocBuilder<ServiceRequestCubit,
                                  ServiceRequestState>(
                                buildWhen: (previous, current) =>
                                    current is SelectedAddMoreState,
                                builder: (context, state) {
                                  if (state is SelectedAddMoreState &&
                                      state.isMulitpleEnabled == true) {
                                    return Container();
                                  }
                                  return Text(
                                    "Add More",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                            color: Theme.of(context)
                                                .highlightColor),
                                  );
                                },
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 10.v),
                        Text(
                          getString(messageUpload),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                        SizedBox(height: 10.v),
                        _buildUploadDocWidget(context),
                        SizedBox(height: 8.v),
                        MfCustomFloatingTextField(
                          controller: alternateNumber,
                          onChange: (text) {
                            srParams['alternateNumber'] = text;
                          },
                          labelText: getString(messageAlternateMobile),
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
                          textStyle:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: setColorBasedOnTheme(
                                    context: context,
                                    lightColor: AppColors.primaryLight,
                                    darkColor: AppColors.secondaryLight5,
                                  )),
                          labelStyle:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: setColorBasedOnTheme(
                                    context: context,
                                    lightColor: AppColors.primaryLight,
                                    darkColor: AppColors.secondaryLight5,
                                  )),
                          textInputAction: TextInputAction.done,
                          textInputType: TextInputType.phone,
                          validator: (value) {
                            if (!isValidPhone(value)) {
                              return getString(enterValidNumber);
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 15.v),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          floatingActionButton: _bottomButtons(context),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        ),
      ),
    );
  }

  Widget _bottomButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BlocBuilder<ServiceRequestCubit, ServiceRequestState>(
            builder: (context, state) {
              return MfCustomButton(
                  onPressed: () {
                    _callCreateServiceRequestAPI(context);
                  },
                  text: getString(labelNOCFeatureSubmit),
                  leftIcon:
                      (state is ServiceRequestLoadingState && state.isLoading)
                          ? true
                          : false,
                  outlineBorderButton: false);
            },
          ),
          const SizedBox(
            height: 20,
          ),
          MfCustomButton(
              onPressed: () {
                context.pop();
              },
              text: getString(labelBack),
              outlineBorderButton: true),
        ],
      ),
    );
  }

  Widget _buildUploadDocWidget(BuildContext context) {
    return BlocConsumer<ServiceRequestCubit, ServiceRequestState>(
      listener: (context, state) async {
        if (state is DocumentUploadState) {
          if (state.isSecondImage == true) {
            isSecondImageAdded = state.imageAdded;
            secondImageName = state.imageName;
          } else {
            isImageAdded = state.imageAdded;
            imageName = state.imageName;
          }
        }
        if (state is GetPresetUriResponseSuccessState) {
          if (state.response.code == AppConst.codeSuccess) {
            if (state.useCase == SRConst.deleteDocument) {
              context.read<ServiceRequestCubit>().deleteDocuments(
                  state.response.presetURL ?? "", state.isSecondImage);
            }
          } else {
            showSnackBar(
                context: context, message: state.response.message ?? "");
          }
        } else if (state is GetPresetUriResponseFailureState) {
          showSnackBar(
              context: context, message: getFailureMessage(state.failure));
        } else if (state is ImageCompressState) {
          if (state.compressSuccess) {
            String? imageName = await context.pushNamed(
                service_route.Routes.serviceUploadDocument.name,
                extra: state.imageFile?.path);
            if (imageName == null) {
              if (context.mounted) {
                context
                    .read<ServiceRequestCubit>()
                    .imageAdded(false, "", isSecondImage: state.isSecondImage);
              }
            } else {
              if (context.mounted) {
                context.read<ServiceRequestCubit>().imageAdded(true, imageName,
                    isSecondImage: state.isSecondImage);
              }
            }
          } else {
            showSnackBar(context: context, message: state.errorMessage);
          }
        } else if (state is DocumentStatusFailure) {
          showSnackBar(
              context: context, message: getFailureMessage(state.failure));
        } else if (state is DocumentStatusSuccess) {
          if (state.useCase == SRConst.deleteDocument) {
            context
                .read<ServiceRequestCubit>()
                .imageAdded(false, "", isSecondImage: state.isSecondImage);
          }
        } else if (state is UploadLoadingState) {
          if (state.isUploadLoading) {
            showLoaderDialog(context, getString(lblLoading));
          } else {
            Navigator.of(context, rootNavigator: true).pop();
          }
        }
      },
      builder: (context, state) {
        return BlocBuilder<ServiceRequestCubit, ServiceRequestState>(
          builder: (context, state) {
            return Container(
              width: 328.h,
              margin: EdgeInsets.only(left: 1.h),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (_) => Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      getString(lblUploadDocument),
                                      style: const TextStyle(fontSize: 27),
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
                                                await picker.pickImage(
                                                    source: ImageSource.camera);
                                            if (context.mounted &&
                                                image != null) {
                                              context
                                                  .read<ServiceRequestCubit>()
                                                  .compressImage(image);
                                            }
                                            if (context.mounted) {
                                              Navigator.pop(context);
                                            }
                                          },
                                          child: Column(
                                            children: [
                                              Container(
                                                decoration: const BoxDecoration(
                                                    shape: BoxShape.circle),
                                                child: Icon(
                                                  Icons.camera_alt_outlined,
                                                  size: 48,
                                                  color: setColorBasedOnTheme(
                                                      context: context,
                                                      lightColor: AppColors
                                                          .primaryLight,
                                                      darkColor: Colors.white),
                                                ),
                                              ),
                                              Text(
                                                getString(lblCamera),
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
                                            final XFile? image =
                                                await picker.pickImage(
                                                    source:
                                                        ImageSource.gallery);
                                            if (context.mounted &&
                                                image != null) {
                                              context
                                                  .read<ServiceRequestCubit>()
                                                  .compressImage(image);
                                            }
                                            if (context.mounted) {
                                              Navigator.pop(context);
                                            }
                                          },
                                          child: Column(
                                            children: [
                                              Container(
                                                decoration: const BoxDecoration(
                                                    shape: BoxShape.circle),
                                                child: Icon(
                                                  Icons.image_outlined,
                                                  size: 48,
                                                  color: setColorBasedOnTheme(
                                                      context: context,
                                                      lightColor: AppColors
                                                          .primaryLight,
                                                      darkColor: Colors.white),
                                                ),
                                              ),
                                              Text(
                                                getString(lblGallery),
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
                                                await FilePicker.platform
                                                    .pickFiles();
                                            if (result != null) {
                                              XFile file = XFile(
                                                  result.files.single.path!);
                                              if (context.mounted) {
                                                context
                                                    .read<ServiceRequestCubit>()
                                                    .compressImage(file);
                                              }
                                            }
                                            if (context.mounted) {
                                              Navigator.pop(context);
                                            }
                                          },
                                          child: Column(
                                            children: [
                                              Container(
                                                decoration: const BoxDecoration(
                                                    shape: BoxShape.circle),
                                                child: Icon(
                                                  Icons.description_outlined,
                                                  size: 48,
                                                  color: setColorBasedOnTheme(
                                                      context: context,
                                                      lightColor: AppColors
                                                          .primaryLight,
                                                      darkColor: Colors.white),
                                                ),
                                              ),
                                              Text(
                                                getString(lblFile),
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
                        borderRadius: BorderRadius.circular(
                          8.0,
                        ),
                        border: Border.all(color: Colors.transparent),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.upload_file,
                            color: setColorBasedOnTheme(
                                context: context,
                                lightColor: AppColors.primaryLight,
                                darkColor: Colors.white),
                          ),
                          Padding(
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
                                        getString(lblUploadDocument),
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium
                                            ?.copyWith(
                                                fontWeight: FontWeight.w500),
                                      ),
                                      Text(getString(lblNoUploads),
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelSmall),
                                    ],
                                  )
                                : Text(
                                    imageName ?? "",
                                    style: CustomTextStyles
                                        .titleSmallPoppinsErrorContainer,
                                  ),
                          ),
                          const Spacer(),
                          InkWell(
                              onTap: () {
                                if (isImageAdded) {
                                  GetPresetUriRequest request =
                                      GetPresetUriRequest(
                                          fileName: imageName,
                                          useCase: SRConst.deleteDocument);
                                  context
                                      .read<ServiceRequestCubit>()
                                      .getPresetUri(request,
                                          operation: SRConst.deleteDocument);
                                }
                              },
                              child: SvgPicture.asset(
                                isImageAdded
                                    ? ImageConstant.imgDelete
                                    : ImageConstant.imgUpload,
                                height: 24,
                                width: 24,
                              ))
                        ],
                      ),
                    ),
                  ),
                  BlocBuilder<ServiceRequestCubit, ServiceRequestState>(
                    buildWhen: (previous, current) =>
                        current is SelectedAddMoreState,
                    builder: (context, state) {
                      if (state is SelectedAddMoreState &&
                          state.isMulitpleEnabled == true) {
                        //adding one more image upload option
                        return Column(
                          children: [
                            MfCustomFloatingTextField(
                              controller: passwordController,
                              onChange: (text) {
                                srParams['documentPassword'] = text;
                              },
                              labelText: "Document password (optional)",
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
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                      color: setColorBasedOnTheme(
                                    context: context,
                                    lightColor: AppColors.primaryLight,
                                    darkColor: AppColors.secondaryLight5,
                                  )),
                              labelStyle: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                      color: setColorBasedOnTheme(
                                    context: context,
                                    lightColor: AppColors.primaryLight,
                                    darkColor: AppColors.secondaryLight5,
                                  )),
                              textInputAction: TextInputAction.done,
                              textInputType: TextInputType.phone,
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                    context: context,
                                    builder: (_) => Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                getString(lblUploadDocument),
                                                style: const TextStyle(
                                                    fontSize: 27),
                                              ),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () async {
                                                      final picker =
                                                          ImagePicker();
                                                      final XFile? image =
                                                          await picker.pickImage(
                                                              source:
                                                                  ImageSource
                                                                      .camera);
                                                      if (context.mounted &&
                                                          image != null) {
                                                        context
                                                            .read<
                                                                ServiceRequestCubit>()
                                                            .compressImage(
                                                                image,
                                                                isSecondImage:
                                                                    true);
                                                      }
                                                      if (context.mounted) {
                                                        Navigator.pop(context);
                                                      }
                                                    },
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          decoration:
                                                              const BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle),
                                                          child: Icon(
                                                            Icons
                                                                .camera_alt_outlined,
                                                            size: 48,
                                                            color: setColorBasedOnTheme(
                                                                context:
                                                                    context,
                                                                lightColor:
                                                                    AppColors
                                                                        .primaryLight,
                                                                darkColor:
                                                                    Colors
                                                                        .white),
                                                          ),
                                                        ),
                                                        Text(
                                                          getString(lblCamera),
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodySmall,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () async {
                                                      final picker =
                                                          ImagePicker();
                                                      final XFile? image =
                                                          await picker.pickImage(
                                                              source:
                                                                  ImageSource
                                                                      .gallery);
                                                      if (context.mounted &&
                                                          image != null) {
                                                        context
                                                            .read<
                                                                ServiceRequestCubit>()
                                                            .compressImage(
                                                                image,
                                                                isSecondImage:
                                                                    true);
                                                      }
                                                      if (context.mounted) {
                                                        Navigator.pop(context);
                                                      }
                                                    },
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          decoration:
                                                              const BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle),
                                                          child: Icon(
                                                            Icons
                                                                .image_outlined,
                                                            size: 48,
                                                            color: setColorBasedOnTheme(
                                                                context:
                                                                    context,
                                                                lightColor:
                                                                    AppColors
                                                                        .primaryLight,
                                                                darkColor:
                                                                    Colors
                                                                        .white),
                                                          ),
                                                        ),
                                                        Text(
                                                          getString(lblGallery),
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodySmall,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () async {
                                                      FilePickerResult? result =
                                                          await FilePicker
                                                              .platform
                                                              .pickFiles();
                                                      if (result != null) {
                                                        XFile file = XFile(
                                                            result.files.single
                                                                .path!);
                                                        if (context.mounted) {
                                                          context
                                                              .read<
                                                                  ServiceRequestCubit>()
                                                              .compressImage(
                                                                  file,
                                                                  isSecondImage:
                                                                      true);
                                                        }
                                                      }
                                                      if (context.mounted) {
                                                        Navigator.pop(context);
                                                      }
                                                    },
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          decoration:
                                                              const BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle),
                                                          child: Icon(
                                                            Icons
                                                                .description_outlined,
                                                            size: 48,
                                                            color: setColorBasedOnTheme(
                                                                context:
                                                                    context,
                                                                lightColor:
                                                                    AppColors
                                                                        .primaryLight,
                                                                darkColor:
                                                                    Colors
                                                                        .white),
                                                          ),
                                                        ),
                                                        Text(
                                                          getString(lblFile),
                                                          style:
                                                              Theme.of(context)
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
                                  borderRadius:
                                  BorderRadius.circular(
                                    8.0,
                                  ),
                                  border: Border.all(color: Colors.transparent),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.upload_file,
                                      color: setColorBasedOnTheme(
                                          context: context,
                                          lightColor: AppColors.primaryLight,
                                          darkColor: Colors.white),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        left: 17.h,
                                        top: 4.v,
                                      ),
                                      child: !isSecondImageAdded
                                          ? Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  getString(lblUploadDocument),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .labelMedium
                                                      ?.copyWith(
                                                          fontWeight:
                                                              FontWeight.w500),
                                                ),
                                                Text(getString(lblNoUploads),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .labelSmall),
                                              ],
                                            )
                                          : Text(
                                              secondImageName ?? "",
                                              style: CustomTextStyles
                                                  .titleSmallPoppinsErrorContainer,
                                            ),
                                    ),
                                    const Spacer(),
                                    InkWell(
                                        onTap: () {
                                          if (isSecondImageAdded) {
                                            GetPresetUriRequest request =
                                                GetPresetUriRequest(
                                                    fileName: secondImageName,
                                                    useCase:
                                                        SRConst.deleteDocument);
                                            context
                                                .read<ServiceRequestCubit>()
                                                .getPresetUri(request,
                                                    operation:
                                                        SRConst.deleteDocument,
                                                    isSecondImage: true);
                                          }
                                        },
                                        child: SvgPicture.asset(
                                          isSecondImageAdded
                                              ? ImageConstant.imgDelete
                                              : ImageConstant.imgUpload,
                                          height: 24,
                                          width: 24,
                                        ))
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                      return Container();
                    },
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

  _callCreateServiceRequestAPI(BuildContext context) {
    var request = SRRequest(
      customerId: getUCIC(),
      contractId: widget.data.loanAccountNumber ?? "",
      lob: widget.data.lob ?? "",
      mobileNumber: widget.data.mobileNumber ?? "",
      productName: widget.data.productName ?? "",
      caseType: widget.data.caseType,
      category: srParams['query'] ?? "",
      subCategory: srParams['subQuery'] ?? "",
      documentLink: getDocumentLink(),
      alternateNumber: srParams['alternateNumber'] ?? "",
      description: srParams['description'] ?? "",
      sourceSystem: widget.data.sourceSystem,
      productCategory: widget.data.productCategory,
      channel: "App",
      srType: "Request",
      customerName: getUserName(),
    );

    BlocProvider.of<ServiceRequestCubit>(context)
        .generateServiceRequest(request);
  }

  getDocumentLink() {
    if (isImageAdded == true && isSecondImageAdded == true) {
      return '$imageName,$secondImageName';
    } else if (isImageAdded == true && isSecondImageAdded == false) {
      return imageName ?? "";
    } else if (isImageAdded == false && isSecondImageAdded == true) {
      return secondImageName ?? "";
    }
  }
}
