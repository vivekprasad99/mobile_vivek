import 'dart:async';

import 'package:core/config/resources/app_colors.dart';
import 'package:help/features/utils/constant_help.dart';
import 'package:help/features/utils/help_common_widget.dart';
import 'package:core/config/resources/custom_text_style.dart';
import 'package:core/config/resources/image_constant.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/config/widgets/common_widgets/custom_checkbox_button.dart';
import 'package:core/config/widgets/common_widgets/custom_floating_text_field.dart';
import 'package:core/config/widgets/mf_progress_bar.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:core/config/widgets/mf_toast.dart';
import 'package:core/utils/const.dart';
import 'package:core/utils/pref_utils.dart';
import 'package:core/utils/utils.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:profile/data/models/addr_document_dropdown_model.dart';
import 'package:profile/data/models/addr_update_offline_req.dart';
import 'package:profile/data/models/customer_info_args.dart';
import 'package:profile/data/models/ocr_passport_response.dart';
import 'package:profile/data/models/ocr_voterid_response.dart'
    as voterid_response;
import 'package:profile/data/models/ocr_profile_request.dart';
import 'package:service_ticket/features/presentation/cubit/service_request_cubit.dart';
import 'package:service_ticket/features/presentation/cubit/service_request_state.dart'
    as service_request;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:service_ticket/config/routes/route.dart' as service_route;
import 'package:core/config/widgets/mf_appbar.dart';
import 'package:service_ticket/constants/sr_constant.dart';
import 'package:core/utils/size_utils.dart';
import 'package:core/config/widgets/action_buttons/sticky_floating_action_button.dart';
import 'package:core/config/widgets/background/mf_gradient_background.dart';
import 'package:core/config/widgets/custom_buttons/mf_custom_elevated_button.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:service_ticket/features/data/models/get_preset_uri_request.dart'
    as service_request_preset;
import 'package:go_router/go_router.dart';
import 'package:profile/config/profile_constant.dart';
import 'package:profile/config/routes/route.dart';
import 'package:profile/data/models/dob_gender_match_req.dart';
import 'package:profile/data/models/my_profile_model_response.dart';
import 'package:profile/data/models/name_match_req.dart';
import 'package:profile/data/models/validate_aadhaar_detail.dart';
import 'package:profile/data/models/validate_driving_license_details.dart';
import 'package:profile/data/models/validate_license_request.dart';
import 'package:profile/data/models/validate_license_response.dart';
import 'package:profile/presentation/cubit/profile_cubit.dart';
import 'package:profile/utils/utils.dart';
import 'package:profile/utils/const.dart' as profile_const;
import '../../../data/models/aadhaar_consent_req.dart';
import 'package:common/config/routes/route.dart' as common_routes;
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:intl/intl.dart';

class UpdateAddressAuth extends StatefulWidget {
  final AddressType addressType;
  final ProfileInfo profileData;
  const UpdateAddressAuth(
      {required this.addressType, required this.profileData, super.key});

  @override
  State<UpdateAddressAuth> createState() => _UpdateAddressAuthState();
}

class _UpdateAddressAuthState extends State<UpdateAddressAuth> {
  bool isImageAdded = false;
  String? imageName;
  final TextEditingController _passportVoterIDNumberController =
      TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _aadhaarNumberController =
      TextEditingController();
  final TextEditingController _billNoController = TextEditingController();
  final TextEditingController _drivingLicenseNumberController =
      TextEditingController();
  final TextEditingController _enterDOBController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  bool enableCheckbox = false;
  bool enableContinueBtn = false;
  bool showFetchedDetails = false;
  bool isResetFlag = false;
  final GlobalKey<FormState> _formKeyAddressOffline = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyAadhaar = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyDrivingLicense = GlobalKey<FormState>();
  String? selectedAuthType;
  ValidateLicenseResponse? licenseResponse;
  int currentDLValidateAttempt = 0;
  bool isSecondImageAdded = false;
  String? secondImageName;
  String? imagePath1, imagePath2;
  late BuildContext _blocContext;
  List<AddressDocumentDropdownModel>? documentList;
  bool isSingleUpload = false;
  List<DateTime?> _singleDatePickerValueWithDefaultValue = [
    DateTime.now().add(const Duration(days: 1)),
  ];
  String _actualText = '';
  Timer? _timer;

  @override
  void initState() {
    _aadhaarNumberController.text = maskString(widget.profileData.aadhaarNumber ?? "", MaskingFieldType.aadhaar);
    selectedAuthType = "select";
    documentList = getDropdownItems(widget.addressType);
    //_aadhaarNumberController.addListener(_handleTextChange);

    super.initState();
  }

    void _handleTextChange() {
    if (_timer?.isActive ?? false) {
      _timer?.cancel();
    }

    _actualText = _aadhaarNumberController.text;
    _timer = Timer(const Duration(milliseconds: 500), _maskText);

    setState(() {
      _aadhaarNumberController.value = _aadhaarNumberController.value.copyWith(
        text: _actualText,
        selection: TextSelection.collapsed(offset: _actualText.length),
      );
    });
  }

   void _maskText() {
    String maskedText;
    if (_actualText.length <= 4) {
      maskedText = 'X' * _actualText.length;
    } else if (_actualText.length <= 8) {
      maskedText = 'X' * (_actualText.length - 4) + _actualText.substring(_actualText.length - 4);
    } else {
      maskedText = 'X' * (_actualText.length - 4) + _actualText.substring(_actualText.length - 4);
    }

    setState(() {
      _aadhaarNumberController.value = _aadhaarNumberController.value.copyWith(
        text: maskedText,
        selection: TextSelection.collapsed(offset: maskedText.length),
      );
    });
  }

  @override
  void dispose() {
    //_aadhaarNumberController.removeListener(_handleTextChange);
    _aadhaarNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _blocContext = context;
    return MultiBlocListener(
      listeners: [
        BlocListener<ServiceRequestCubit, service_request.ServiceRequestState>(
            listener: (context, state) async {
          if (state is service_request.ImageCompressState) {
            if (state.compressSuccess) {
              String? imageName = await context.pushNamed(
                  service_route.Routes.serviceUploadDocument.name,
                  extra: state.imageFile?.path);
              if (imageName == null) {
                if (context.mounted) {
                  context.read<ServiceRequestCubit>().imageAdded(false, "",
                      isSecondImage: state.isSecondImage);
                }
              } else {
                if (context.mounted) {
                  context.read<ServiceRequestCubit>().imageAdded(
                      true, imageName,
                      isSecondImage: state.isSecondImage);
                }
              }

              if (state.isSecondImage != null) {
                if (state.isSecondImage!) {
                  imagePath2 = state.imageFile?.path;
                }
              } else {
                imagePath1 = state.imageFile?.path;
              }
            } else {
              toastForFailureMessage(
                  context: context, msg: getString(msgMaxProfileFileSizeError));
            }
          }
        }),
        BlocListener<ProfileCubit, ProfileState>(listener: (context, state) {
          if (state is ValidateLicenseSuccessState) {
            if (state.response.code == AppConst.codeFailure) {
              currentDLValidateAttempt++;
              if (currentDLValidateAttempt <
                  ProfileConst.maxDLValidationAttempt) {
                toastForFailureMessage(
                    context: context,
                    msg: "${getString(msgErrorInvalidDL1)} ${ProfileConst.maxDLValidationAttempt - currentDLValidateAttempt} ${getString(msgErrorInvalidDL2)} ");
              } else {
                displayAlertSingleAction(context, getString(msgErrorInvalidDLMax),
                    btnLbl: getString(lblProfileOk), btnTap: () {
                  Navigator.of(context)
                      .popUntil(ModalRoute.withName(Routes.myProfileData.name));
                });
              }
            } else {
              licenseResponse = state.response;
              BlocProvider.of<ProfileCubit>(context)
                  .validateNameMatch(NameMatchReq(
                sourceName: widget.profileData.customerName ?? "",
                targetName: licenseResponse?.name,
                ucic: getUCIC(),
                superAppId: getSuperAppId(),
              ));
            }
          } else if (state is NameMatchSuccessState) {
            if (state.response.code == AppConst.codeFailure) {
              context.pushNamed(Routes.myProfileNameMismatch.name, extra: {
                "errorTitle": getString(lblSorryAuthenticateDetail),
                "errorMessage": getString(msgVisitBranch)
              });
            } else {
              if (state.response.score! >= ProfileConst.nameMatchScore) {
                BlocProvider.of<ProfileCubit>(context).validateDOBGenderMatch(
                    DobGenderMatchRequest(
                        sourceDob: _enterDOBController.text,
                        targetDob: widget.profileData.dob ?? ""));
              } else {
                context.pushNamed(Routes.myProfileNameMismatch.name, extra: {
                  "errorTitle": getString(lblSorryAuthenticateDetail),
                  "errorMessage": getString(msgVisitBranch)
                });
              }
            }
          } else if (state is NameMatchFailureState ||
              state is DobGenderMatchFailureState) {
            context.pushNamed(Routes.myProfileNameMismatch.name, extra: {
              "errorTitle": getString(lblSorryAuthenticateDetail),
              "errorMessage": getString(msgVisitBranch)
            });
          } else if (state is DobGenderMatchSuccessState) {
            if (state.response.code == AppConst.codeFailure) {
              context.pushNamed(Routes.myProfileNameMismatch.name, extra: {
                "errorTitle": getString(lblSorryAuthenticateDetail),
                "errorMessage": getString(msgVisitBranch)
              });
            } else {
              if (state.response.dobScore! >= 100) {
                context.pushNamed(Routes.myProfileConfirmDetails.name, extra: {
                  "confirmScreenType":
                      ConfirmDetailScreenType.addressDrivingLicenseDetails,
                  "validateDrivingLicenseDetail": ValidateDrivingLicenseDetail(
                      drivingLicenseNo: _drivingLicenseNumberController.text,
                      dob: licenseResponse?.dob,
                      address: licenseResponse?.address,
                      custName: licenseResponse?.name,
                      addressType: widget.addressType),
                  "addressType": widget.addressType
                });
              } else {
                context.pushNamed(Routes.myProfileNameMismatch.name, extra: {
                  "errorTitle": getString(lblSorryAuthenticateDetail),
                  "errorMessage": getString(msgVisitBranch)
                });
              }
            }
          } else if (state is GetAadhaarConsentSuccessState) {
            if (state.response.code == AppConst.codeSuccess) {
              var validateAadhaarDetail = ProfileExtras(
                  custName: widget.profileData.customerName ?? "",
                  newPhoneNumber: "",
                  aadhaarNumber: _aadhaarNumberController.text,
                  transactionId: state.response.transactionId,
                  operation: Operation.updateAddress,
                  profileInfo: widget.profileData,
                  addressType: widget.addressType);
              context.pushNamed(Routes.myProfileOtpScreen.name, extra: {
                "otpScreenType": OtpScreenType.aadhaarOtp,
                "mobileNumber": getPhoneNumber(),
                "validateAadhaarDetail": validateAadhaarDetail, "customerInfoArg" : CustomerInfoArg()
              });
            } else {
              toastForFailureMessage(
                  context: context,
                  msg: getString(
                      state.response.responseCode ?? lblProfileErrorGeneric));
            }
          } else if (state is GetAadhaarConsentFailureState) {
            toastForFailureMessage(
                context: context, msg: getFailureMessage(state.failure));
          } else if (state is ProfileLoadingState) {
            if (state.isloading) {
              showLoaderDialog(context, getString(lblLoading));
            } else {
              Navigator.of(context, rootNavigator: true).pop();
            }
          } else if (state is AddressUpdateOfflineSuccessState) {
            if (state.response.code == AppConst.codeSuccess) {
              toastForSuccessMessage(
                  context: context, msg: getString(state.response.responseCode ?? lblProfileErrorGeneric));
              Navigator.of(context).popUntil(
                  ModalRoute.withName(common_routes.Routes.home.name));
              context.pushNamed(Routes.myProfileData.name);
            } else {
              toastForFailureMessage(
                  context: context, msg: getString(state.response.responseCode ?? lblProfileErrorGeneric));
            }
          } else if (state is AddressUpdateOfflineFailureState) {
            toastForFailureMessage(
                context: context, msg: getFailureMessage(state.failure));
          }
        }),
      ],
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        floatingActionButton: const StickyFloatingActionButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: customAppbar(
            context: context,
            title: '',
            onPressed: () {
              Navigator.pop(context);
            },
            actions: [
              HelpCommonWidget(categoryval: HelpConstantData.subCategoryProfile,subCategoryval: HelpConstantData.subCategoryDetails,)
            ]),
        body:
            BlocBuilder<ProfileCubit, ProfileState>(builder: (context, state) {
          if (state is AddressUpdateConsentState) {
            enableCheckbox = state.isAddressConsent;
          }
          if (state is AadhaarConsentState) {
            enableCheckbox = state.isAadhaarConsent;
          }
          if (state is AuthDropDownState) {
            selectedAuthType = state.dropdownValue;
          } else if (state is ValidateLicenseFailureState) {
            toastForFailureMessage(
                context: context, msg: getString(msgErrorDlFailure));
          }
          else if (state is UpdateLicenseAddressSuccessState) {
            if (state.response.code == AppConst.codeFailure) {
              toastForFailureMessage(
                context: context,
                msg: state.response.message ?? "",
              );
            } else {}
          } else if (state is OcrPassportFrontSuccessState) {
            if (state.response.code == AppConst.codeFailure) {
              toastForFailureMessage(
                context: context,
                msg: getString(state.response.responseCode ?? lblProfileErrorGeneric),
              );
            } else {
              List<Result>? response = state.response.result;
              if (response != null && response.isNotEmpty) {
                for (Result passportInfo in response) {
                  if (passportInfo.docType ==
                      profile_const.AppConst.passportFront) {
                    _passportVoterIDNumberController.text =
                        passportInfo.passportNum ?? "";
                    _expiryDateController.text = passportInfo.doe ?? "";
                  } else if (passportInfo.docType ==
                      profile_const.AppConst.passportBack) {
                    _addressController.text = passportInfo.address ?? "";
                  }
                }
              }

              if (isSecondImageAdded) {
                convertImgToBase64(imagePath2).then((value) {
                  BlocProvider.of<ProfileCubit>(context).ocrPassportBack(
                      OCRProfileRequest(
                          fileB64: value,
                          docType: profile_const.AppConst.passportBack,
                          source: AppConst.source));
                });
              }
              showFetchedDetails = true;
            }
          } else if (state is OcrPassportFrontFailureState) {
            toastForFailureMessage(
                context: context, msg: getString(lblProfileErrorGeneric));
          } else if (state is OcrPassportBackSuccessState) {
            if (state.response.code == AppConst.codeFailure) {
              toastForFailureMessage(
                context: context,
                msg: getString(state.response.responseCode ?? lblProfileErrorGeneric),
              );
            } else {
              List<Result>? response = state.response.result;
              if (response != null && response.isNotEmpty) {
                for (Result passportInfo in response) {
                  if (passportInfo.docType ==
                      profile_const.AppConst.passportFront) {
                    _passportVoterIDNumberController.text =
                        passportInfo.passportNum ?? "";
                    _expiryDateController.text = passportInfo.doe ?? "";
                  } else if (passportInfo.docType ==
                      profile_const.AppConst.passportBack) {
                    _addressController.text = passportInfo.address ?? "";
                  }
                }
              }
              showFetchedDetails = true;
            }
          } else if (state is OcrPassportBackFailureState) {
            toastForFailureMessage(
                context: context, msg: getString(lblProfileErrorGeneric));
          } else if (state is OcrVoterFrontSuccessState) {
            if (state.response.code == AppConst.codeFailure) {
              toastForFailureMessage(
                  context: context,
                  msg: getString(
                      state.response.responseCode ?? lblProfileErrorGeneric));
            } else {
              List<voterid_response.Result>? response = state.response.result;
              if (response != null && response.isNotEmpty) {
                for (voterid_response.Result voterIdInfo in response) {
                  if (voterIdInfo.docType ==
                          profile_const.AppConst.voterIDFront ||
                      voterIdInfo.docType ==
                          profile_const.AppConst.voterIDNewFront) {
                    _passportVoterIDNumberController.text =
                        voterIdInfo.voterId ?? "";
                  } else if (voterIdInfo.docType ==
                          profile_const.AppConst.voterIDBack ||
                      voterIdInfo.docType ==
                          profile_const.AppConst.voterIDNewBack) {
                    _addressController.text = voterIdInfo.address ?? "";
                  }
                }
              }
              if (isSecondImageAdded) {
                convertImgToBase64(imagePath2).then((value) {
                  BlocProvider.of<ProfileCubit>(context).ocrVoterBack(
                      OCRProfileRequest(
                          fileB64: value,
                          docType: selectedAuthType ==
                                  AddressAuthDropdownType.voterID.value
                              ? profile_const.AppConst.voterIDBack
                              : profile_const.AppConst.voterIDNewBack,
                          source: AppConst.source));
                });
              }
              showFetchedDetails = true;
            }
          } else if (state is OcrVoterFrontFailureState) {
            toastForFailureMessage(
                context: context, msg: getString(lblProfileErrorGeneric));
          } else if (state is OcrVoterBackSuccessState) {
            if (state.response.code == AppConst.codeFailure) {
              toastForFailureMessage(
                context: context,
                msg: getString(state.response.responseCode ?? lblProfileErrorGeneric),
              );
            } else {
              List<voterid_response.Result>? response = state.response.result;
              if (response != null && response.isNotEmpty) {
                for (voterid_response.Result voterIdInfo in response) {
                  if (voterIdInfo.docType ==
                          profile_const.AppConst.voterIDFront ||
                      voterIdInfo.docType ==
                          profile_const.AppConst.voterIDNewFront) {
                    _passportVoterIDNumberController.text =
                        voterIdInfo.voterId ?? "";
                  } else if (voterIdInfo.docType ==
                          profile_const.AppConst.voterIDBack ||
                      voterIdInfo.docType ==
                          profile_const.AppConst.voterIDNewBack) {
                    _addressController.text = voterIdInfo.address ?? "";
                  }
                }
              }
              showFetchedDetails = true;
            }
          } else if (state is OcrVoterBackFailureState) {
            toastForFailureMessage(
                context: context, msg: getString(lblProfileErrorGeneric));
          }
          return _buildWidget(context);
        }),
      ),
    );
  }

  Widget _buildWidget(BuildContext context) {
    return BlocBuilder<ServiceRequestCubit,
        service_request.ServiceRequestState>(builder: (context, state) {
      if (!isResetFlag) {
        if (state is service_request.DocumentUploadState) {
          if (state.isSecondImage == true) {
            isSecondImageAdded = state.imageAdded;
            secondImageName = state.imageName;
          } else {
            isImageAdded = state.imageAdded;
            imageName = state.imageName;
          }
          enableContinueBtn = true;
        }
      }
      isResetFlag = false;
      return MFGradientBackground(
        horizontalPadding: 16.h,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    getString(lblAuth),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 10.v),
                  Text(
                    getString(lblAddressAuthConsent),
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  SizedBox(height: 20.v),
                  _buildDropDown(),
                  SizedBox(height: 10.v),
                  if (selectedAuthType == "select")
                    Text(
                      getString(lblAdressDocumentProof),
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  if (selectedAuthType == "select") SizedBox(height: 10.v),
                  selectedAuthType == AddressAuthDropdownType.aadhaar.value
                      ? _buildAadhaarCard(context)
                      : selectedAuthType ==
                              AddressAuthDropdownType.drivingLicense.value
                          ? _buildDrivingLicense(context)
                          : selectedAuthType ==
                                      AddressAuthDropdownType.passport.value ||
                                  selectedAuthType ==
                                      AddressAuthDropdownType.voterID.value ||
                                  selectedAuthType ==
                                      AddressAuthDropdownType.voterIDNew.value
                              ? Column(
                                  children: [
                                    _buildPassport(context),
                                    enableContinueBtn && showFetchedDetails
                                        ? _buildFetchDetails(context)
                                        : const SizedBox()
                                  ],
                                )
                              : selectedAuthType != "select" &&
                                      selectedAuthType !=
                                          AddressAuthDropdownType
                                              .passport.value &&
                                      selectedAuthType !=
                                          AddressAuthDropdownType
                                              .voterID.value &&
                                      selectedAuthType !=
                                          AddressAuthDropdownType
                                              .voterIDNew.value &&
                                      selectedAuthType !=
                                          AddressAuthDropdownType
                                              .aadhaar.value &&
                                      selectedAuthType !=
                                          AddressAuthDropdownType
                                              .drivingLicense.value
                                  ? Column(
                                      children: [
                                        _buildSingleDocUpload(context),
                                        enableContinueBtn
                                            ? _buildFetchDetails(context)
                                            : const SizedBox()
                                      ],
                                    )
                                  : Container(),
                ],
              )),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: setColorBasedOnTheme(
                    context: context,
                    lightColor: Colors.white,
                    darkColor: AppColors.cardDark),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline,
                        color: AppColors.yellowIconColor),
                    const SizedBox(
                      width: 8,
                    ),
                    Flexible(
                        child: Text(
                          getString(msgAddressAuthVisitBranch),
                        ))
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10,),
            MfCustomButton(
                isDisabled: selectedAuthType == "select"
                    ? true
                    : selectedAuthType ==
                                AddressAuthDropdownType.aadhaar.value ||
                            selectedAuthType ==
                                AddressAuthDropdownType.drivingLicense.value
                        ? !enableCheckbox
                        : !enableContinueBtn,
                outlineBorderButton: false,
                onPressed: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  if (showFetchedDetails) {
                    if (_addressController.text.isEmpty) {
                      displayAlertSingleAction(
                          context, getString(msgEnterAddress),
                          btnLbl: getString(lblProfileOk));
                      return;
                    }
                    String address = "";
                    if (selectedAuthType ==
                        AddressAuthDropdownType.passport.value) {
                      if (_passportVoterIDNumberController.text.isEmpty) {
                        displayAlertSingleAction(
                            context, getString(msgEnterPassportNo),
                            btnLbl: getString(lblProfileOk));
                        return;
                      } else if (_expiryDateController.text.isEmpty) {
                        displayAlertSingleAction(
                            context, getString(msgEnterExpiry),
                            btnLbl: getString(lblProfileOk));
                        return;
                      }
                      address =
                          "Passport No == ${_passportVoterIDNumberController.text}, Expiry Date  == ${_expiryDateController.text}, address == ${_addressController.text}";
                    } else if (selectedAuthType ==
                            AddressAuthDropdownType.voterID.value ||
                        selectedAuthType ==
                            AddressAuthDropdownType.voterIDNew.value) {
                      if (_passportVoterIDNumberController.text.isEmpty) {
                        displayAlertSingleAction(
                            context, getString(msgEnterVoterId),
                            btnLbl: getString(lblProfileOk));
                        return;
                      }
                      address =
                          "VoterId No == ${_passportVoterIDNumberController.text}, address == ${_addressController.text}";
                    } else {
                      address =
                          "Bill No == ${_billNoController.text}, address == ${_addressController.text}";
                    }

                    BlocProvider.of<ProfileCubit>(context).updateAddressOffline(
                        AddressUpdateOfflineRequest(
                            superAppId: getSuperAppId(),
                            combinedAddress: address,
                            sameAsMainAddress: PrefUtils.getBool(
                                PrefUtils.isAddressSameAsCurrent, false),
                            ucic: getUCIC(),
                            addrType: widget.addressType.value,
                            source: AppConst.source,
                            documentId: getDocumentLink(),
                            consentFlag: true,
                            customerName:
                                widget.profileData.customerName));
                  } else {
                    if (selectedAuthType ==
                        AddressAuthDropdownType.aadhaar.value) {
                      if (_formKeyAadhaar.currentState!.validate()) {
                        String userAgent = await getUserAgent();
                        var aadhaarConsent = AadhaarConsentReq(
                          source: AppConst.source,
                          purpose: AppConst.updateAddressJourney,
                          userName: widget.profileData.customerName ?? "",
                          superAppId: getSuperAppId(),
                          aadhaarNo: _aadhaarNumberController.text,
                          userAgent: userAgent
                        );

                        BlocProvider.of<ProfileCubit>(context)
                            .getAadhaarConsent(aadhaarConsent);
                      }
                    } else if (selectedAuthType ==
                        AddressAuthDropdownType.drivingLicense.value) {
                      if (_formKeyDrivingLicense.currentState!.validate()) {
                        BlocProvider.of<ProfileCubit>(context).validateLicense(
                            ValidateLicenseRequest(
                                dlNo: _drivingLicenseNumberController.text,
                                dob: _enterDOBController.text,
                                ucic: getUCIC(),
                                source: AppConst.source,
                                superAppId: getSuperAppId()));
                      }
                    } else if (selectedAuthType !=
                            AddressAuthDropdownType.passport.value &&
                        selectedAuthType !=
                            AddressAuthDropdownType.voterID.value &&
                        selectedAuthType !=
                            AddressAuthDropdownType.voterIDNew.value &&
                        selectedAuthType !=
                            AddressAuthDropdownType.aadhaar.value &&
                        selectedAuthType !=
                            AddressAuthDropdownType.drivingLicense.value) {
                      if (_addressController.text.isEmpty) {
                        displayAlertSingleAction(
                            context, getString(msgEnterAddress),
                            btnLbl: getString(lblProfileOk));
                        return;
                      } else if (_billNoController.text.isEmpty) {
                        displayAlertSingleAction(
                            context, getString(msgEnterBillNo),
                            btnLbl: getString(lblProfileOk));
                        return;
                      }
                      String address =
                          "Bill No == ${_billNoController.text}, address == ${_addressController.text}";
                      BlocProvider.of<ProfileCubit>(context)
                          .updateAddressOffline(AddressUpdateOfflineRequest(
                              superAppId: getSuperAppId(),
                              combinedAddress: address,
                              sameAsMainAddress: PrefUtils.getBool(
                                  PrefUtils.isAddressSameAsCurrent, false),
                              ucic: getUCIC(),
                              addrType: widget.addressType.value,
                              source: AppConst.source,
                              documentId: imageName,
                              consentFlag: true,
                              customerName:
                                  widget.profileData.customerName));
                    } else if (selectedAuthType ==
                        AddressAuthDropdownType.passport.value) {
                      convertImgToBase64(imagePath1).then((value) {
                        BlocProvider.of<ProfileCubit>(context).ocrPassportFront(
                            OCRProfileRequest(
                                fileB64: value,
                                docType: profile_const.AppConst.passportFront,
                                source: AppConst.source));
                      });
                    } else if (selectedAuthType ==
                            AddressAuthDropdownType.voterID.value ||
                        selectedAuthType ==
                            AddressAuthDropdownType.voterIDNew.value) {
                      convertImgToBase64(imagePath1).then((value) {
                        BlocProvider.of<ProfileCubit>(context).ocrVoterFront(
                            OCRProfileRequest(
                                fileB64: value,
                                docType: selectedAuthType ==
                                        AddressAuthDropdownType.voterIDNew.value
                                    ? profile_const.AppConst.voterIDNewFront
                                    : profile_const.AppConst.voterIDFront,
                                source: AppConst.source));
                      });
                    }
                  }
                },
                text: getString(lblProfileContinue))
          ],
        ),
      );
    });
  }

  DropdownMenu<AddressDocumentDropdownModel> _buildDropDown() {
    return DropdownMenu(
      menuStyle: MenuStyle(backgroundColor: MaterialStateProperty.all<Color>(
        setColorBasedOnTheme(context: context, 
            lightColor: AppColors.backgroundLight5, 
            darkColor: AppColors.shadowDark))),
      onSelected: (AddressDocumentDropdownModel? dropdownModel) {
        resetScreenDropdownChange();
        if (dropdownModel!.value != AddressAuthDropdownType.aadhaar.value &&
            dropdownModel.value != AddressAuthDropdownType.aadhaar.value &&
            dropdownModel.value != AddressAuthDropdownType.passport.value &&
            dropdownModel.value !=
                AddressAuthDropdownType.drivingLicense.value &&
            dropdownModel.value != AddressAuthDropdownType.voterID.value &&
            dropdownModel.value != AddressAuthDropdownType.voterIDNew.value) {
          isSingleUpload = true;
        } else {
          isSingleUpload = false;
        }

        context.read<ProfileCubit>().selectAuthType(dropdownModel);
      },
      textStyle:
          Theme.of(context).textTheme.labelMedium?.copyWith(fontSize: 16),
      label: Text(
        getString(lblAdressDocumentSelect),
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      width: MediaQuery.of(context).size.width * 0.92,
      selectedTrailingIcon: const Icon(
        Icons.keyboard_arrow_up,
        color: AppColors.primaryLight3,
      ),
      trailingIcon: const Icon(
        Icons.keyboard_arrow_down,
        color: AppColors.primaryLight3,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        activeIndicatorBorder: BorderSide(
          color: AppColors.primaryLight5,
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.primaryLight3,
          ),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.primaryLight3,
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.primaryLight3,
          ),
        ),
      ),
      dropdownMenuEntries: documentList!
          .map<DropdownMenuEntry<AddressDocumentDropdownModel>>(
              (AddressDocumentDropdownModel dropdownModel) {
        return DropdownMenuEntry<AddressDocumentDropdownModel>(
          value: dropdownModel,
          label: dropdownModel.value!,
          style: MenuItemButton.styleFrom(
            foregroundColor: setColorBasedOnTheme(
              context: context, 
              lightColor: AppColors.textLight, 
              darkColor: AppColors.backgroundLight5),
            textStyle: Theme.of(context)
                .textTheme
                .labelMedium
                ?.copyWith(fontSize: 16, ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildUploadDocWidget(
      BuildContext context, String uploadText, int uploadIndex) {
    return BlocListener<ServiceRequestCubit,
            service_request.ServiceRequestState>(
        listener: (context, state) {
          if (state is service_request.GetPresetUriResponseSuccessState) {
            if (state.response.code == AppConst.codeSuccess) {
              if (state.useCase == SRConst.deleteDocument) {
                context.read<ServiceRequestCubit>().deleteDocuments(
                    state.response.presetURL ?? "", state.isSecondImage);
              }
            } else {
              showSnackBar(
                  context: context, message: state.response.message ?? "");
            }
          } else if (state
              is service_request.GetPresetUriResponseFailureState) {
            showSnackBar(
                context: context, message: getFailureMessage(state.failure));
          } else if (state is service_request.UploadLoadingState) {
            if (state.isUploadLoading) {
              showLoaderDialog(context, getString(lblLoading));
            } else {
              Navigator.of(context, rootNavigator: true).pop();
            }
          } else if (state is service_request.DocumentStatusSuccess) {
            if (state.useCase == SRConst.deleteDocument) {
              context
                  .read<ServiceRequestCubit>()
                  .imageAdded(false, "", isSecondImage: state.isSecondImage);
              enableContinueBtn = false;
            }
          }
        },
        child: SizedBox(
          height: 60.h,
          width: 330.h,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: GestureDetector(
                  onTap: () {
                    _buildBottomSheet(context, uploadIndex);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 15.h,
                      vertical: 6.v,
                    ),
                    decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8))),
                    child: Row(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: InkWell(
                            onTap: () {},
                            child: SvgPicture.asset(
                              colorFilter: ColorFilter.mode(
                                  setColorBasedOnTheme(
                                      context: context,
                                      lightColor: AppColors.primaryLight,
                                      darkColor: AppColors.backgroundLight5),
                                  BlendMode.srcIn),
                              ImageConstant.imgUpload,
                              height: 24.adaptSize,
                              width: 24.adaptSize,
                            ),
                          ),
                        ),
                        Expanded(
                            child: Padding(
                          padding: EdgeInsets.only(
                            left: 16.h,
                            top: 8.v,
                          ),
                          child: uploadIndex == 1
                              ? !isImageAdded
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          getString(uploadText),
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelMedium,
                                        ),
                                        Text(
                                          getString(lblNoUploads),
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelSmall,
                                        ),
                                      ],
                                    )
                                  : Text(
                                      imageName ?? "",
                                      style: CustomTextStyles
                                          .titleSmallPoppinsErrorContainer,
                                    )
                              : !isSecondImageAdded
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          getString(uploadText),
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelMedium,
                                        ),
                                        Text(
                                          getString(lblNoUploads),
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelSmall,
                                        ),
                                      ],
                                    )
                                  : Text(
                                      secondImageName ?? "",
                                      style: CustomTextStyles
                                          .titleSmallPoppinsErrorContainer,
                                    ),
                        )),
                        Align(
                            alignment: Alignment.centerRight,
                            child: InkWell(
                                onTap: () {
                                  if (isImageAdded) {
                                    service_request_preset.GetPresetUriRequest
                                        request = service_request_preset
                                            .GetPresetUriRequest(
                                                fileName: imageName,
                                                useCase:
                                                    SRConst.deleteDocument);
                                    context
                                        .read<ServiceRequestCubit>()
                                        .getPresetUri(request,
                                            operation: SRConst.deleteDocument);
                                  }
                                },
                                child: SvgPicture.asset(
                                  colorFilter: ColorFilter.mode(
                                      setColorBasedOnTheme(
                                          context: context,
                                          lightColor: AppColors.secondaryLight,
                                          darkColor:
                                              AppColors.backgroundLight5),
                                      BlendMode.srcIn),
                                  uploadIndex == 1
                                      ? isImageAdded
                                          ? ImageConstant.imgDelete
                                          : ImageConstant.imgUpload
                                      : isSecondImageAdded
                                          ? ImageConstant.imgDelete
                                          : ImageConstant.imgUpload,
                                  height: 16.adaptSize,
                                  width: 16.adaptSize,
                                )))
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }


  Future<dynamic> _buildBottomSheet(BuildContext context, int uploadIndex) {
    return showModalBottomSheet(
        showDragHandle: false,
        backgroundColor: Theme.of(context).cardColor,
        context: context,
        builder: (_) => SizedBox(
              height: 191.h,
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 18.0, right: 18.0, top: 18.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          getString(lblProfileUploadDocument),
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        TextButton(
                            child: Text(
                              getString(lblcancel),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                      color: Theme.of(context).highlightColor),
                            ),
                            onPressed: () {
                              context.pop();
                            }),
                      ],
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildCamera(context, uploadIndex),
                          _buildGallery(context, uploadIndex),
                          _buildFile(context, uploadIndex),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ));
  }

  GestureDetector _buildFile(context, uploadIndex) {
    return GestureDetector(
      onTap: () async {
        FilePickerResult? result = await FilePicker.platform.pickFiles();
        if (result != null) {
          XFile file = XFile(result.files.single.path!);
          if (_blocContext.mounted) {
            if (uploadIndex == 1) {
              _blocContext.read<ServiceRequestCubit>().compressImage(file,
                  filesize: ProfileConst.profileMaxFileSize);
            } else {
              _blocContext.read<ServiceRequestCubit>().compressImage(file,
                  isSecondImage: true,
                  filesize: ProfileConst.profileMaxFileSize);
            }
          }
        }
        if (_blocContext.mounted) {
          Navigator.pop(context);
        }
      },
      child: Column(
        children: [
          Icon(Icons.description_outlined,
              size: 48,
              color: setColorBasedOnTheme(
                context: context,
                lightColor: AppColors.primaryLight,
                darkColor: AppColors.primaryLight5,
              )),
          Text(getString(lblProfileFile)),
        ],
      ),
    );
  }

  GestureDetector _buildGallery(context, uploadIndex) {
    return GestureDetector(
      onTap: () async {
        final ImagePicker picker = ImagePicker();
        final XFile? image =
            await picker.pickImage(source: ImageSource.gallery);
        if (_blocContext.mounted && image != null) {
          if (uploadIndex == 1) {
            context.read<ServiceRequestCubit>().compressImage(image,
                filesize: ProfileConst.profileMaxFileSize);
          } else {
            context.read<ServiceRequestCubit>().compressImage(image,
                isSecondImage: true, filesize: ProfileConst.profileMaxFileSize);
          }
        }
        Navigator.pop(context);
      },
      child: Column(
        children: [
          Icon(Icons.image_outlined,
              size: 48,
              color: setColorBasedOnTheme(
                context: context,
                lightColor: AppColors.primaryLight,
                darkColor: AppColors.primaryLight5,
              )),
          Text(getString(lblProfileGallery)),
        ],
      ),
    );
  }

  GestureDetector _buildCamera(context, uploadIndex) {
    return GestureDetector(
      onTap: () async {
        final ImagePicker picker = ImagePicker();
        final XFile? image =
            await picker.pickImage(source: ImageSource.camera);
        if (_blocContext.mounted && image != null) {
          if (uploadIndex == 1) {
            _blocContext.read<ServiceRequestCubit>().compressImage(image,
                filesize: ProfileConst.profileMaxFileSize);
          } else {
            _blocContext.read<ServiceRequestCubit>().compressImage(image,
                isSecondImage: true, filesize: ProfileConst.profileMaxFileSize);
          }
        }
        Navigator.pop(context);
      },
      child: Column(
        children: [
          Icon(
            Icons.photo_camera_outlined,
            size: 48,
            color: setColorBasedOnTheme(
              context: context,
              lightColor: AppColors.primaryLight,
              darkColor: AppColors.primaryLight5,
            ),
          ),
          Text(getString(lblProfileCamera)),
        ],
      ),
    );
  }

  Widget _buildPassport(BuildContext context) {
    return Column(children: [
      Row(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(top: 10),
            child: Text(
              getString(labelUploadDocuments),
              style: const TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Icon(
              Icons.help_outline,
              size: 16.h,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
      Container(
        margin: const EdgeInsets.only(top: 10),
        child: SizedBox(
          child: Text(getString(lblmsgImageFileSize),
              style: Theme.of(context).textTheme.labelSmall),
        ),
      ),
      SizedBox(height: 10.v),
      _buildUploadDocWidget(context, lblFirstPageUpload, 1),
      SizedBox(height: 10.v),
      _buildUploadDocWidget(context, lblLastPageUpload, 2),
    ]);
  }

  Widget _buildSingleDocUpload(BuildContext context) {
    return Column(children: [
      Row(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(top: 10),
            child: Text(
              getString(labelUploadDocuments),
              style: const TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Icon(
              Icons.help_outline,
              size: 16.h,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
      Container(
        margin: const EdgeInsets.only(top: 10),
        child: SizedBox(
          child: Text(getString(lblmsgImageFileSize),
              style: Theme.of(context).textTheme.labelSmall),
        ),
      ),
      SizedBox(height: 10.v),
      _buildUploadDocWidget(context, lblFirstPageUpload, 1),
      SizedBox(height: 10.v),
    ]);
  }

  Widget _buildAddress(BuildContext context) {
    return MfCustomFloatingTextField(
      onChange: (value) {},
      controller: _addressController,
      labelText: getString(lblAddress),
      textStyle: Theme.of(context).textTheme.bodySmall,
      labelStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: setColorBasedOnTheme(
            context: context,
            lightColor: AppColors.primaryLight,
            darkColor: AppColors.secondaryLight5,
          )),
      validator: (value) {
        if (value != null) {
          if (value.isEmpty) {
            return getString(enterAddress);
          }
        }
        return null;
      },
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
    );
  }

  Widget _buildDrivingLicense(BuildContext context) {
    return Form(
      key: _formKeyDrivingLicense,
      child: Column(
        children: [
          MfCustomFloatingTextField(
            onChange: (value) {},
            controller: _drivingLicenseNumberController,
            labelText: getString(lblEnterDrivingLicense),
            textStyle: Theme.of(context).textTheme.bodySmall,
            labelStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: setColorBasedOnTheme(
                  context: context,
                  lightColor: AppColors.primaryLight,
                  darkColor: AppColors.secondaryLight5,
                )),
            validator: (value) {
              if (value != null) {
                if (value.isEmpty) {
                  return getString(enterValidDrivingLicense);
                }
              }
              return null;
            },
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
          const SizedBox(
            height: 20,
          ),
          MfCustomFloatingTextField(
            controller: _enterDOBController,
            hintText: "dd/mm/yyyy",
            textInputType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9/]')),
              LengthLimitingTextInputFormatter(10),
              DateInputFormatter(),
            ],
            suffix: InkWell(child: Icon(Icons.calendar_month, color: Theme.of(context).primaryColor), onTap: (){
              final config = CalendarDatePicker2WithActionButtonsConfig(
                  calendarType: CalendarDatePicker2Type.single,
                  lastDate: DateTime.now(),
                  selectedDayHighlightColor: setColorBasedOnTheme(
                      context: context,
                      lightColor: AppColors.primaryLight,
                      darkColor: AppColors.secondaryLight5),
                  weekdayLabelTextStyle: Theme.of(context).textTheme.bodyMedium,
                  dayTextStyle: Theme.of(context).textTheme.bodyMedium,
                  controlsTextStyle: Theme.of(context).textTheme.bodyMedium);
              showCalendarDatePicker2Dialog(
                config: config,
                dialogSize: const Size(325, 400),
                value: _singleDatePickerValueWithDefaultValue,
                context: context,
              ).then((value) {

                _singleDatePickerValueWithDefaultValue = value!;
                var data = DateFormat('dd/MM/yyyy').format(DateTime.parse(value.first.toString()));
                _enterDOBController.text = data;
              });
            },),
            onChange: (value) {},
            textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: setColorBasedOnTheme(
                  context: context,
                  lightColor: AppColors.primaryLight,
                  darkColor: AppColors.secondaryLight5,
                )),
            labelStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: setColorBasedOnTheme(
                  context: context,
                  lightColor: AppColors.primaryLight,
                  darkColor: AppColors.secondaryLight5,
                )),
            labelText: getString(lblLicensedob),
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
            validator: (value) {
              if (value != null) {
                if (value.isEmpty) {
                  return getString(lblProfileEnterValidDob);
                }
              }
              return null;
            },
          ),
          const SizedBox(
            height: 30,
          ),
          _buildCustomCheck(context, AddressAuthDropdownType.drivingLicense)
        ],
      ),
    );
  }

  Widget _buildFetchDetails(BuildContext context) {
    return Form(
      key: _formKeyAddressOffline,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            getString(lblFetchDetails),
            style: Theme.of(context).textTheme.labelSmall,
          ),
          SizedBox(height: 10.v),
          MfCustomFloatingTextField(
            onChange: (value) {},
            controller: selectedAuthType ==
                        AddressAuthDropdownType.passport.value ||
                    selectedAuthType == AddressAuthDropdownType.voterID.value ||
                    selectedAuthType == AddressAuthDropdownType.voterIDNew.value
                ? _passportVoterIDNumberController
                : _billNoController,
            labelText: selectedAuthType ==
                    AddressAuthDropdownType.passport.value
                ? getString(lblPassportNo)
                : selectedAuthType == AddressAuthDropdownType.voterID.value ||
                        selectedAuthType ==
                            AddressAuthDropdownType.voterIDNew.value
                    ? getString(lblVoterID)
                    : selectedAuthType == AddressAuthDropdownType.offlineAadhaar.value ? getString(lblAadhaarNumber) : selectedAuthType == AddressAuthDropdownType.offlineDrivingLicense.value? getString(lblDlNumber) : getString(lblBillNo),
            textStyle: Theme.of(context).textTheme.bodySmall,
            labelStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: setColorBasedOnTheme(
                  context: context,
                  lightColor: AppColors.primaryLight,
                  darkColor: AppColors.secondaryLight5,
                )),
            validator: (value) {
              if (value != null) {
                if (value.isEmpty) {
                  return selectedAuthType ==
                          AddressAuthDropdownType.passport.value
                      ? getString(lblPassportNo)
                      : selectedAuthType ==
                                  AddressAuthDropdownType.voterID.value ||
                              selectedAuthType ==
                                  AddressAuthDropdownType.voterIDNew.value
                          ? getString(lblVoterID)
                          : getString(lblBillNo);
                }
              }
              return null;
            },
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
          const SizedBox(
            height: 20,
          ),
          if (selectedAuthType == AddressAuthDropdownType.passport.value)
            MfCustomFloatingTextField(
              controller: _expiryDateController,
              hintText: "dd/mm/yyyy",
              textInputType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9/]')),
                LengthLimitingTextInputFormatter(10),
                DateInputFormatter(),
              ],
              suffix: InkWell(child: Icon(Icons.calendar_month, color: Theme.of(context).primaryColor), onTap: (){
                final config = CalendarDatePicker2WithActionButtonsConfig(
                    calendarType: CalendarDatePicker2Type.single,
                    lastDate: DateTime.now(),
                    selectedDayHighlightColor: setColorBasedOnTheme(
                        context: context,
                        lightColor: AppColors.primaryLight,
                        darkColor: AppColors.secondaryLight5),
                    weekdayLabelTextStyle: Theme.of(context).textTheme.bodyMedium,
                    dayTextStyle: Theme.of(context).textTheme.bodyMedium,
                    controlsTextStyle: Theme.of(context).textTheme.bodyMedium);
                showCalendarDatePicker2Dialog(
                  config: config,
                  dialogSize: const Size(325, 400),
                  value: _singleDatePickerValueWithDefaultValue,
                  context: context,
                ).then((value) {

                  _singleDatePickerValueWithDefaultValue = value!;
                  var data = DateFormat('dd/MM/yyyy').format(DateTime.parse(value.first.toString()));
                  _expiryDateController.text = data;
                });
              },),
              onChange: (value) {},
              textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: setColorBasedOnTheme(
                    context: context,
                    lightColor: AppColors.primaryLight,
                    darkColor: AppColors.secondaryLight5,
                  )),
              labelStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: setColorBasedOnTheme(
                    context: context,
                    lightColor: AppColors.primaryLight,
                    darkColor: AppColors.secondaryLight5,
                  )),
              labelText: getString(lblExpiryDate),
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
              validator: (value) {
                if (value != null) {
                  if (value.isEmpty) {
                    return getString(enterValidExpiry);
                  }
                }
                return null;
              },
            ),
          if (selectedAuthType == AddressAuthDropdownType.passport.value ||
              selectedAuthType == AddressAuthDropdownType.voterID.value ||
              selectedAuthType == AddressAuthDropdownType.voterIDNew.value)
            const SizedBox(
              height: 20,
            ),
          _buildAddress(context)
        ],
      ),
    );
  }

  Widget _buildAadhaarCard(BuildContext context) {
    return Form(
      key: _formKeyAadhaar,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MfCustomFloatingTextField(
            maxLength: 12,
            onChange: (value) {},
            inputFormatters: [LengthLimitingTextInputFormatter(12)],
            controller: _aadhaarNumberController,
            labelText: getString(lblEnterAadhar),
            textInputType: TextInputType.number,
            textStyle: Theme.of(context).textTheme.bodySmall,
            labelStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: setColorBasedOnTheme(
                  context: context,
                  lightColor: AppColors.primaryLight,
                  darkColor: AppColors.secondaryLight5,
                )),
            validator: (value) {
              if (value != null) {
                if (value.isEmpty) {
                  return getString(enterAadhaarNo);
                }
              }
              return null;
            },
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
          const SizedBox(
            height: 20,
          ),
          _buildCustomCheck(context, AddressAuthDropdownType.aadhaar)
        ],
      ),
    );
  }

  resetScreenDropdownChange() {
    setState(() {
      enableCheckbox = false;
      isResetFlag = true;
      enableContinueBtn = false;
      imageName = "";
      secondImageName = "";
      isImageAdded = false;
      isSecondImageAdded = false;
      showFetchedDetails = false;
    });
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

  CustomCheckboxButton _buildCustomCheck(
      BuildContext context, AddressAuthDropdownType checkType) {
    return CustomCheckboxButton(
      activeColor: Theme.of(context).primaryColor,
      checkColor: Theme.of(context).scaffoldBackgroundColor,
      textAlignment: TextAlign.start,
      isExpandedText: true,
      alignment: Alignment.center,
      text: checkType == AddressAuthDropdownType.drivingLicense
          ? getString(lblDirvingLicenseConsent)
          : getString(lblAadhaarConsent),
      value: enableCheckbox,
      textStyle: Theme.of(context).textTheme.labelSmall,
      onChange: (value) {
        switch (checkType) {
          case AddressAuthDropdownType.aadhaar:
            context.read<ProfileCubit>().updateAadhaarConsent(value);
            break;
          case AddressAuthDropdownType.drivingLicense:
            context
                .read<ProfileCubit>()
                .updateDrivingLicenseAddressConsent(value);
            break;
          default:
        }
      },
    );
  }
}
