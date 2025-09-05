import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/resources/custom_text_style.dart';
import 'package:core/config/resources/image_constant.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/config/widgets/background/mf_gradient_background.dart';
import 'package:core/config/widgets/common_widgets/mf_custom_drop_down.dart';
import 'package:core/config/widgets/common_widgets/mf_custom_text_field.dart';
import 'package:core/config/widgets/custom_buttons/mf_custom_elevated_button.dart';
import 'package:core/config/widgets/mf_appbar.dart';
import 'package:core/config/widgets/mf_progress_bar.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:core/utils/const.dart';
import 'package:core/utils/size_utils.dart';
import 'package:core/utils/utils.dart';
import 'package:core/utils/validation_functions.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loan/features/foreclosure/data/models/get_loans_request.dart';
import 'package:loan/features/foreclosure/data/models/get_loans_response.dart';
import 'package:loan/features/foreclosure/presentation/cubit/foreclosure_cubit.dart';
import 'package:service_ticket/features/data/models/service_request_response.dart';
import '../../../../../config/routes/route.dart';
import '../../../constants/sr_constant.dart';
import '../../data/models/get_preset_uri_request.dart';
import '../../data/models/query_subquery_request.dart';
import '../../data/models/query_subquery_response.dart'
    as query_subquery_response;
import '../../data/models/query_subquery_response.dart';
import '../../data/models/sr_request.dart';
import '../cubit/service_request_cubit.dart';
import '../cubit/service_request_state.dart';
// ignore_for_file: must_be_immutable
class RaiseRequestScreen extends StatefulWidget {
  RaiseRequestScreen({super.key, this.requestMap});

  Map<String, String>? requestMap;

  @override
  State<RaiseRequestScreen> createState() => _RaiseRequestScreenState();
}

class _RaiseRequestScreenState extends State<RaiseRequestScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController? mobileNumberController;
  TextEditingController? descriptionValueController;
  TextEditingController? productController;
  TextEditingController? passwordController;

  List<query_subquery_response.Data>? _querySubQueryList;
  List<SubQuery>? subQuery;
  LoanItem? _selectedLoanItem;
  var srParams = <String, String>{};

  bool isImageAdded = false;
  String? imageName;

  bool isSecondImageAdded = false;
  String? secondImageName;
  TextEditingController? _queryController;
  TextEditingController? _subQueryController;

  String? requestType;
  String? requestId;

  @override
  void initState() {
    super.initState();
    context.read<ServiceRequestCubit>().imageAdded(false, "");
    _queryController = TextEditingController();
    _subQueryController = TextEditingController();

    requestType = widget.requestMap?['type'];
    requestId = widget.requestMap?['id'];

    fetchQuerySubQueryAPI();
  }

  void fetchQuerySubQueryAPI() {
    FetchQuerySubQueryRequest request =
        FetchQuerySubQueryRequest(type: requestType);
    BlocProvider.of<ServiceRequestCubit>(context).fetchQuerySubQuery(request);
  }

  @override
  Widget build(BuildContext buildContext) {
    return SafeArea(
      child: BlocListener<ServiceRequestCubit, ServiceRequestState>(
        listener: (context, state) {
          if (state is ServiceRequestSuccessState) {
            if (state.response.code == AppConst.codeSuccess &&
                state.response.data != null) {
              ServiceRequestResponse serviceRequestResponse = state.response;
              if (serviceRequestResponse.data?.isNewTicket == true) {
                context.goNamed(Routes.requestAcknowledgeScreen.name,
                    extra: state.response);
              } else {
                List<String>? serviceRequestList =
                    state.response.data?.oldTickets ?? [];
                if (serviceRequestList.isNotEmpty) {
                  ServiceRequestResponse serviceRequestResponse =
                      state.response;
                  context.pushNamed(Routes.serviceTicketExist.name,
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
              context: buildContext,
              title: getString(labelRaiseRequest),
              onPressed: () {
                buildContext.pop();
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
                    BlocBuilder<ServiceRequestCubit, ServiceRequestState>(
                      builder: (context, state) {
                        if (state is QuerySubQuerySuccessState) {
                          _querySubQueryList = state.response.data;
                          _setDefaultParameter();
                        }
                        else if (state is SelectedQueryState) {
                          if (_querySubQueryList != null) {
                            for (var element in _querySubQueryList!) {
                              if (element.query == state.name) {
                                subQuery = element.subQuery;
                                requestId = element.tid;
                                _setDefaultParameter();
                              }
                            }
                          }
                        }
                        else if (state is QuerySubQueryFailureState) {
                          showSnackBar(
                              context: context, message: getFailureMessage(state.error));
                        }
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: MfCustomDropDown<String>(
                                title: getString(lblQueryFor),
                                selectedController: _queryController,
                                dropdownMenuEntries: _querySubQueryList
                                        ?.map((e) => DropdownMenuEntry<String>(
                                            value: e.query ?? "",
                                            label: e.query ?? "",
                                            style: MenuItemButton.styleFrom(
                                              foregroundColor:
                                                  AppColors.primaryLight,
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .labelMedium
                                                  ?.copyWith(
                                                      fontSize: 16,
                                                      color:
                                                          AppColors.textLight),
                                            )))
                                        .toList() ??
                                    [],
                                onSelected: (dynamic newValue) {
                                  if (newValue != null) {
                                    srParams['query'] = newValue;
                                    context
                                        .read<ServiceRequestCubit>()
                                        .selectQuery(newValue);
                                  }
                                },
                              ),
                            ),
                            SizedBox(height: 10.v),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: MfCustomDropDown(
                                title: getString(lblSubQuery),
                                selectedController: _subQueryController,
                                dropdownMenuEntries: subQuery
                                        ?.map(
                                            (e) => DropdownMenuEntry<SubQuery>(
                                                value: e,
                                                label: e.name ?? "",
                                                style: MenuItemButton.styleFrom(
                                                  foregroundColor:
                                                      AppColors.primaryLight,
                                                  textStyle: Theme.of(context)
                                                      .textTheme
                                                      .labelMedium
                                                      ?.copyWith(
                                                          fontSize: 16,
                                                          color: AppColors
                                                              .textLight),
                                                )))
                                        .toList() ??
                                    [],
                                onSelected: (dynamic subQuery) {
                                  if (subQuery is SubQuery) {
                                    srParams['subQuery'] = subQuery.name ?? "";
                                    srParams['caseType'] = subQuery.caseType ?? "";
                                    _getLoanList();
                                  }
                                },
                              ),
                            )
                          ],
                        );
                      },
                    ),
                    SizedBox(height: 10.v),
                    BlocBuilder<ForeclosureCubit, ForeclosureState>(
                      buildWhen: (previous, current) =>
                          current is ForeclosureGetLoansSuccessState ||
                          current is LoadingState,
                      builder: (context, state) {
                        if (state is LoadingState && state.isloading) {
                          return Center(
                              child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Theme.of(context).primaryColor,
                          ));
                        }
                        if (state is ForeclosureGetLoansSuccessState) {
                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: MfCustomDropDown<String>(
                                  title: getString(lblProductFor),
                                  dropdownMenuEntries: state.response.data
                                          ?.map((e) =>
                                              DropdownMenuEntry<String>(
                                                  value: e.productName ?? "",
                                                  label: e.productName ?? "",
                                                  style:
                                                      MenuItemButton.styleFrom(
                                                    foregroundColor:
                                                        AppColors.primaryLight,
                                                    textStyle: Theme.of(context)
                                                        .textTheme
                                                        .labelMedium
                                                        ?.copyWith(
                                                            fontSize: 16,
                                                            color: AppColors
                                                                .textLight),
                                                  )))
                                          .toList() ??
                                      [],
                                  onSelected: (dynamic newValue) {
                                    if (newValue != null) {
                                      srParams['productName'] = newValue;
                                      List<LoanItem>? loanList =
                                          state.response.data ?? [];
                                      for (var element in loanList) {
                                        if (element.productName == newValue) {
                                          _selectedLoanItem = element;
                                        }
                                      }
                                    }
                                  },
                                ),
                              ),
                              SizedBox(height: 10.v),
                              MfCustomFloatingTextField(
                                controller: descriptionValueController,
                                onChange: (text) {
                                  srParams['description'] = text;
                                },
                                labelText: getString(labelDescription),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    getString(lblUploadDocumentOptional),
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
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
                                          getString(lblAddMore),
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
                              MfCustomFloatingTextField(
                                controller: passwordController,
                                obscureText: true,
                                onChange: (text) {
                                  srParams['documentPassword'] = text;
                                },
                                labelText: getString(lblDocumentPassword),
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
                              SizedBox(height: 8.v),
                              MfCustomFloatingTextField(
                                controller: mobileNumberController,
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
                                validator: (value) {
                                  if (!isValidPhone(value)) {
                                    return getString(enterValidNumber);
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 15.v),
                              BlocBuilder<ForeclosureCubit, ForeclosureState>(
                                builder: (context, state) {
                                  if (state is LoadingState &&
                                      state.isloading) {
                                    return Center(
                                        child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Theme.of(context).primaryColor,
                                    ));
                                  }
                                  return _bottomButtons(context);
                                },
                              ),
                            ],
                          );
                        }
                        return Container();
                      },
                    ),
                    //const Spacer(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _getLoanList() {
    GetLoansRequest request = GetLoansRequest(ucic: getUCIC());
    BlocProvider.of<ForeclosureCubit>(context).getLoans(request);
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
                Routes.serviceUploadDocument.name,
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
                      decoration: BoxDecoration(
                        color: Theme
                            .of(context)
                            .cardColor,
                        borderRadius: BorderRadius.circular(8),
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
                        return GestureDetector(
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
                                            style:
                                                const TextStyle(fontSize: 27),
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
                                                          source: ImageSource
                                                              .camera);
                                                  if (context.mounted &&
                                                      image != null) {
                                                    context
                                                        .read<
                                                            ServiceRequestCubit>()
                                                        .compressImage(image,
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
                                                            context: context,
                                                            lightColor: AppColors
                                                                .primaryLight,
                                                            darkColor:
                                                                Colors.white),
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
                                                          source: ImageSource
                                                              .gallery);
                                                  if (context.mounted &&
                                                      image != null) {
                                                    context
                                                        .read<
                                                            ServiceRequestCubit>()
                                                        .compressImage(image,
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
                                                        Icons.image_outlined,
                                                        size: 48,
                                                        color: setColorBasedOnTheme(
                                                            context: context,
                                                            lightColor: AppColors
                                                                .primaryLight,
                                                            darkColor:
                                                                Colors.white),
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
                                                    XFile file = XFile(result
                                                        .files.single.path!);
                                                    if (context.mounted) {
                                                      context
                                                          .read<
                                                              ServiceRequestCubit>()
                                                          .compressImage(file,
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
                                                            context: context,
                                                            lightColor: AppColors
                                                                .primaryLight,
                                                            darkColor:
                                                                Colors.white),
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
                            decoration: BoxDecoration(
                              color: Theme
                                  .of(context)
                                  .cardColor,
                              borderRadius: BorderRadius.circular(8),
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

  /// Section Widget
  Widget _bottomButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          BlocBuilder<ServiceRequestCubit, ServiceRequestState>(
            builder: (context, state) {
              return MfCustomButton(
                  onPressed: () {
                    if (_submitButtonValidation()) {
                      _callCreateServiceRequestAPI(context);
                    } else {
                      showSnackBar(
                          context: context,
                          message: getString(lblSelectRequiredFields));
                    }
                  },
                  text: getString(labelSubmit),
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

  _callCreateServiceRequestAPI(BuildContext context) {
    var request = SRRequest(
      superAppId: getSuperAppId(),
      customerId: getUCIC(),
      customerName: getUserName(),
      contractId: _selectedLoanItem?.loanNumber ?? "",
      lob: _selectedLoanItem?.lob ?? "",
      mobileNumber: _selectedLoanItem?.mobileNumber ?? "",
      productName: _selectedLoanItem?.productName ?? "",
      caseType: int.parse(srParams['caseType'] ?? ""),
      documentLink: _getDocumentLink(),
      alternateNumber: srParams['alternateNumber'] ?? "",
      description: srParams['description'] ?? "",
      sourceSystem: _selectedLoanItem?.sourceSystem,
      productCategory: _selectedLoanItem?.productCategory,
      channel: "App",
      srType: "Request",
    );

    BlocProvider.of<ServiceRequestCubit>(context)
        .generateServiceRequest(request);
  }

  _getDocumentLink() {
    if (isImageAdded == true && isSecondImageAdded == true) {
      return '$imageName,$secondImageName';
    } else if (isImageAdded == true && isSecondImageAdded == false) {
      return imageName ?? "";
    } else if (isImageAdded == false && isSecondImageAdded == true) {
      return secondImageName ?? "";
    }
  }

  _setDefaultParameter() {
    if (_querySubQueryList != null) {
      for (var element in _querySubQueryList!) {
        if (element.tid == requestId) {
          var queryName = element.query ?? '';
          _queryController?.text = queryName;

          if ((element.subQuery?.length ?? 0) > 0) {
            SubQuery? defaultSubQuery = element.subQuery?.first;
            var subQueryName = defaultSubQuery?.name ?? '';
            _subQueryController?.text = subQueryName;

            srParams['query'] = queryName;
            srParams['subQuery'] = subQueryName;
            srParams['caseType'] = defaultSubQuery?.caseType ?? "";

            _getLoanList();
          }
        }
      }
    }
  }

  bool _submitButtonValidation() {
    return (srParams['query'] ?? '').isNotEmpty &&
        (srParams['subQuery'] ?? '').isNotEmpty &&
        (_selectedLoanItem?.productName ?? '').isNotEmpty &&
        (srParams['caseType'] ?? '').isNotEmpty;
  }
}
