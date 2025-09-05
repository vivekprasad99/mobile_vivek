import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:help/features/utils/constant_help.dart';
import 'package:help/features/utils/help_common_widget.dart';
import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/resources/image_constant.dart';
import 'package:core/config/string_resource/Strings.dart';
import 'package:core/config/widgets/background/mf_gradient_background.dart';
import 'package:core/config/widgets/custom_buttons/mf_custom_elevated_button.dart';
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
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';

import 'package:profile/config/profile_constant.dart';
import 'package:profile/config/routes/route.dart';
import 'package:profile/data/models/upload_profile_pic_request.dart';
import 'package:profile/presentation/cubit/profile_cubit.dart';
import 'package:ach/config/routes/route.dart' as ach;
import 'package:profile/utils/utils.dart';

class ProfileUploadPhoto extends StatefulWidget {
  final String profileImage;
  const ProfileUploadPhoto({required this.profileImage, super.key});

  @override
  State<ProfileUploadPhoto> createState() => _ProfileUploadPhotoState();
}

class _ProfileUploadPhotoState extends State<ProfileUploadPhoto> {
  BuildContext? mContext;
  XFile? _pickedFile;
  String? imagePath;
  bool isImageAdded = false;

  @override
  void initState() {
    super.initState();

    mContext?.read<ProfileCubit>().imageAdded(false, "");
  }

  @override
  Widget build(BuildContext context) {
    mContext = context;
    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: _buildAppBar(context),
        body: _buildWidget());
  }

  AppBar _buildAppBar(context) {
    return customAppbar(
        context: context,
        title: '',
        onPressed: () {
          Navigator.pop(context);
        },
        actions: [
          HelpCommonWidget(categoryval: HelpConstantData.subCategoryProfile,subCategoryval: HelpConstantData.categoryUpdatePhoto,)
        ]);
  }

  Widget _buildWidget() {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) async {
        if (state is ProfileUploadState) {
          isImageAdded = state.imageAdded;
          imagePath = state.imageName;
        } else if (state is DeleteProfilePicSuccessState) {
          isImageAdded = false;
          imagePath = "";
        } else if (state is GetPresetUriResponseSuccessState) {
          if (state.response.code == AppConst.codeSuccess) {
            if (state.useCase == ProfileConst.deleteDocument) {
              context
                  .read<ProfileCubit>()
                  .deleteDocuments(state.response.presetURL ?? "");
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
            imagePath = state.imageFile?.path;
            String? imageName = await context
                .pushNamed(ach.Routes.uploadDocumentScreen.name, extra: {
              "imagePath": state.imageFile?.path,
              "updateToS3": false
            });
            if (imageName == null) {
              if (context.mounted) {
                context.read<ProfileCubit>().imageAdded(false, "");
              }
            } else {
              if (context.mounted) {
                context.read<ProfileCubit>().imageAdded(true, imageName);
              }
            }
          } else {
            showSnackBar(context: context, message: state.errorMessage);
          }
        } else if (state is DocumentStatusFailure) {
          showSnackBar(
              context: context, message: getFailureMessage(state.failure));
        } else if (state is DocumentStatusSuccess) {
          if (state.useCase == ProfileConst.deleteDocument) {
            context.read<ProfileCubit>().imageAdded(false, "");
          }
        }
      },
      builder: (context, state) {
        return BlocConsumer<ProfileCubit, ProfileState>(
          listener: (context, state) {
            if (state is ProfileLoadingState ) {
              if(state.isloading)
              {
                  showLoaderDialog(context, getString(lblLoading));
              }
              else
              {
                Navigator.of(context, rootNavigator: true).pop();
              }
              
            } else if (state is UploadProfilePicSuccessState) {
              if (state.response.code == AppConst.codeFailure) {
                toastForFailureMessage(
                    context: context,
                    msg: getString(
                        state.response.responseCode ?? lblErrorGeneric));
              } else {
                context.pushNamed(Routes.myProfileData.name);
              }
            }
          },
          builder: (context, state) {
            if (state is UploadProfilePicFailureState) {
              toastForFailureMessage(
                  context: context, msg: getFailureMessage(state.failure));
            }
            return MFGradientBackground(
                horizontalPadding: 10.h,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      getString(lblProfilePhoto),
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontSize: 20),
                    ),
                    Center(
                      child: Column(
                        children: [
                          SizedBox(height: 30.v),
                          CircleAvatar(
                              radius: 80,
                              backgroundColor: AppColors.primaryLight5,
                              child: _image(context)),
                          SizedBox(height: 20.v),
                          GestureDetector(
                            onTap: () {
                              _buildBottomSheet(context);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  ImageConstant.imgUpload,
                                  height: 24,
                                  width: 24,
                                ),
                                Text(getString(lblUploadPhoto),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                            color: AppColors.secondaryLight)),
                              ],
                            ),
                          ),
                          SizedBox(height: 10.v),
                          GestureDetector(
                            onTap: () {
                              if (isImageAdded ||
                                  widget.profileImage.isNotEmpty) {
                                // GetPresetUriRequest request =
                                //     GetPresetUriRequest(
                                //         fileName: imagePath,
                                //         useCase: ProfileConst.deleteDocument);
                                // context.read<ProfileCubit>().getPresetUri(
                                //     request,
                                //     operation: ProfileConst.deleteDocument);
                                BlocProvider.of<ProfileCubit>(context)
                                    .uploadProfilePic(UploadProfilePhotoRequest(
                                        profileImage: "",
                                        ucic: getUCIC(),
                                        superAppId: getSuperAppId()));
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  ImageConstant.imgDelete,
                                  height: 24,
                                  width: 24,
                                ),
                                Text(getString(lbldelete),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                            color: AppColors.secondaryLight)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Padding(
                        padding: const EdgeInsets.all(16),
                        child: MfCustomButton(
                            outlineBorderButton: false,
                            onPressed: () async {
                              File imageFile = File(imagePath!);
                              Uint8List bytes = await imageFile.readAsBytes();
                              String base64String = base64Encode(bytes);
                              if (context.mounted) {
                                BlocProvider.of<ProfileCubit>(context)
                                    .uploadProfilePic(UploadProfilePhotoRequest(
                                        profileImage: base64String,
                                        ucic: getUCIC(),
                                        superAppId: getSuperAppId()));
                              }
                            },
                            text: getString(lblUpload))),
                  ],
                ));
          },
        );
      },
    );
  }

  Future<dynamic> _buildBottomSheet(BuildContext context) {
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
                          getString(lblUploadDocument),
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
                          _buildCamera(context),
                          _buildGallery(context),
                          _buildFile(context),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ));
  }

  GestureDetector _buildFile(context) {
    return GestureDetector(
      onTap: () async {
        FilePickerResult? result = await FilePicker.platform.pickFiles();
        if (result != null) {
          XFile file = XFile(result.files.single.path!);
          String? fileMimeType = getFileExtension(file.path);
          if (AppConst.supportedImageTypes.contains(fileMimeType)) {
            final fileSizeInMB = await calculateFileSize(file.path);
            if (fileSizeInMB < AppConst.maxFileSizeInMB) {
              BlocProvider.of<ProfileCubit>(context).compressImage(file);
            } else {
              displayAlertSingleAction(context, getString(msgMaxFileSizeError),
                  btnLbl: getString(lblOk), btnTap: () {
                context.pop();
              });
            }
          } else {
            displayAlertSingleAction(context, "File Type could not supported",
                btnLbl: getString(lblOk));
          }
        }
        Navigator.pop(context);
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
          Text(getString(lblFile)),
        ],
      ),
    );
  }

  GestureDetector _buildGallery(context) {
    return GestureDetector(
      onTap: () async {
        final ImagePicker picker = ImagePicker();
        final XFile? image =
            await picker.pickImage(source: ImageSource.gallery);
        if (context.mounted && image != null) {
          final fileSizeInMB = await calculateFileSize(image.path);
          if (fileSizeInMB < AppConst.maxFileSizeInMB) {
            BlocProvider.of<ProfileCubit>(context).compressImage(image);
          } else {
            displayAlertSingleAction(context, getString(msgMaxFileSizeError),
                btnLbl: getString(lblOk), btnTap: () {
              context.pop();
            });
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
          Text(getString(lblGallery)),
        ],
      ),
    );
  }

  GestureDetector _buildCamera(context) {
    return GestureDetector(
      onTap: () async {
        final ImagePicker picker = ImagePicker();
        final XFile? image =
            await picker.pickImage(source: ImageSource.camera);
        if (context.mounted && image != null) {
          final fileSizeInMB = await calculateFileSize(image.path);
          if (fileSizeInMB < AppConst.maxFileSizeInMB) {
            BlocProvider.of<ProfileCubit>(context).compressImage(image);
          } else {
            displayAlertSingleAction(context, getString(msgMaxFileSizeError),
                btnLbl: getString(lblOk), btnTap: () {
              context.pop();
            });
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
          Text(getString(lblCamera)),
        ],
      ),
    );
  }

  Widget _image(BuildContext context) {
    if (imagePath != null) {
      _pickedFile = XFile(imagePath!);
      final path = _pickedFile!.path;
      return InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FullScreenImageView(
                  image: path,
                  type: ProfileImageType.file
                ),
              ),
            );
        },
        child: CircleAvatar(
            radius: 80,
            backgroundColor: AppColors.primaryLight5,
            backgroundImage: Image.file(
              File(path),
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
              alignment: Alignment.center,
            ).image),
      );
    } else if (widget.profileImage.isNotEmpty) {
      return InkWell(
        onTap: (){
           Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FullScreenImageView(
                  image: widget.profileImage,
                  type: ProfileImageType.memory
                ),
              ),
            );
        },
        child: CircleAvatar(
            radius: 80,
            backgroundColor: AppColors.primaryLight5,
            backgroundImage: Image.memory(
              base64Decode(widget.profileImage),
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
              alignment: Alignment.center,
            ).image),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}

class FullScreenImageView extends StatelessWidget {
  final String image;
  final ProfileImageType type;

  const FullScreenImageView({super.key, required this.image, required this.type});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(getString(lblProfileImage)),
      ),
      body: Center(
        child:
        type == ProfileImageType.memory
        ?
        PhotoView(
          imageProvider:
           MemoryImage(const Base64Decoder().convert(image))
        ) :
        PhotoView(
          imageProvider:
           FileImage(File(image))
        ),
      ),
    );
  }
}
