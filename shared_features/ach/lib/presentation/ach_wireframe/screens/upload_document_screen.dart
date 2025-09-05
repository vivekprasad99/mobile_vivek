import 'dart:async';
import 'dart:io';
import 'package:ach/config/ach_const.dart';
import 'package:ach/presentation/cubit/ach_cubit.dart';
import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/resources/custom_icon_button.dart';
import 'package:core/config/resources/custom_outlined_button.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/config/widgets/background/mf_gradient_background.dart';
import 'package:core/config/widgets/mf_appbar.dart';
import 'package:core/config/widgets/mf_progress_bar.dart';
import 'package:core/utils/const.dart';
import 'package:core/utils/size_utils.dart';
import 'package:core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:go_router/go_router.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:path/path.dart';
import '../../../data/models/get_preset_uri_request.dart';

class UploadDocScreen extends StatefulWidget {
  final String imagePath;
  final bool updateToS3;

  const UploadDocScreen({super.key, required this.imagePath, required this.updateToS3});

  @override
  State<UploadDocScreen> createState() => _UploadDocScreenState();
}

class _UploadDocScreenState extends State<UploadDocScreen> {
  XFile? _pickedFile;
  CroppedFile? _croppedFile;

  @override
  void initState() {
    super.initState();
    _pickedFile = XFile(widget.imagePath);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: customAppbar(
          context: context,
          title: getString(lblMandateCreateMandate),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        body: BlocConsumer<AchCubit, AchState>(
          listener: (context, state) {
            if (state is GetPresetUriResponseSuccessState) {
              if (state.response.code == AppConst.codeSuccess) {
                context.read<AchCubit>().uploadDocument(
                    state.response.presetURL!, File(widget.imagePath));
              } else {
                showSnackBar(
                    context: context, message: state.response.message ?? "");
              }
            } else if (state is GetPresetUriResponseFailureState) {
              showSnackBar(
                  context: context, message: getFailureMessage(state.failure));
            } else if (state is DocumentStatusSuccess) {
              context.pop(state.fileName);
            } else if (state is DocumentStatusFailure) {
              showSnackBar(
                  context: context, message: getFailureMessage(state.failure));
            } else if(state is LoadingState){
              if (state.isloading) {
                showLoaderDialog(context, getString(lblMandateLoading));
              } else {
                Navigator.of(context, rootNavigator: true).pop();
              }
            }
          },
          builder: (context, state) {
            return MFGradientBackground(
                horizontalPadding: 0.h,
                verticalPadding: 20.v,
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: double.maxFinite,
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.h,
                    vertical: 21.v,
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 5.v),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height:
                                    0.65 * MediaQuery.of(context).size.height,
                                child: Stack(
                                  children: [
                                    SizedBox(
                                        height: double.infinity,
                                        width: double.infinity,
                                        child: _isPdfFile(widget.imagePath)
                                            ? _pdfView(
                                                context, widget.imagePath)
                                            : _image(context)),
                                    const SizedBox(
                                      height: 20.0,
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(
                                            bottom: 10.h, right: 10.h),
                                        child: Align(
                                          alignment: Alignment.bottomRight,
                                          child: Visibility(
                                              visible:
                                                  !_isPdfFile(widget.imagePath),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  CustomIconButton(
                                                      height: 33.adaptSize,
                                                      width: 33.adaptSize,
                                                      padding:
                                                          EdgeInsets.all(4.h),
                                                      onTap: () {
                                                        _cropImage(context);
                                                      },
                                                      child: const Icon(
                                                          Icons.crop)),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 16.h),
                                                    child: CustomIconButton(
                                                      height: 33.adaptSize,
                                                      width: 33.adaptSize,
                                                      padding:
                                                          EdgeInsets.all(4.h),
                                                      onTap: () {
                                                        _cropImage(context);
                                                      },
                                                      child: const Icon(
                                                          Icons.rotate_right),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 18.h),
                                                    child: CustomIconButton(
                                                      height: 33.adaptSize,
                                                      width: 33.adaptSize,
                                                      onTap: () {
                                                        _cropImage(context);
                                                      },
                                                      padding:
                                                          EdgeInsets.all(4.h),
                                                      child: const Icon(
                                                          Icons.rotate_left),
                                                    ),
                                                  ),
                                                ],
                                              )),
                                        )),
                                  ],
                                ),
                              ),
                              const Spacer(),
                              CustomOutlinedButton(
                                height: 48.v,
                                text: getString(lblMandateUpload),
                                buttonStyle: ElevatedButton.styleFrom(
                                  side: BorderSide(
                                      color: Colors.transparent,
                                    ),
                                    backgroundColor:
                                        Theme.of(context).highlightColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.h),
                                    )),
                                buttonTextStyle: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(color: AppColors.white),
                                onPressed: () {
                                  if(widget.updateToS3) {
                                    String filename = basename(
                                        widget.imagePath);
                                    GetPresetUriRequest request =
                                    GetPresetUriRequest(
                                        fileName: filename,
                                        useCase: AchConst.uploadDocument,
                                        superAppId: getSuperAppId(),
                                        source: AppConst.source);
                                    context.read<AchCubit>().getPresetUri(
                                        request,
                                        operation: AchConst.uploadDocument);
                                  } else {
                                    if(_croppedFile!=null){
                                      context.pop(_croppedFile?.path);
                                    } else {
                                      context.pop(widget.imagePath);
                                    }

                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ));
          },
        ),
      ),
    );
  }

  bool _isPdfFile(String filepath) {
    String? fileMimeType = getFileExtension(filepath);
    if (AppConst.supportedFileTypes.contains(fileMimeType)) {
      return true;
    }
    return false;
  }

  Widget _image(BuildContext context) {
    if (_croppedFile != null) {
      final path = _croppedFile!.path;
      return Image.file(
        File(path),
        fit: BoxFit.cover,
        height: double.infinity,
        width: double.infinity,
        alignment: Alignment.center,
      );
    } else if (_pickedFile != null) {
      final path = _pickedFile!.path;
      return Image.file(
        File(path),
        fit: BoxFit.cover,
        height: double.infinity,
        width: double.infinity,
        alignment: Alignment.center,
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _pdfView(BuildContext context, String path) {
    final Completer<PDFViewController> controller =
        Completer<PDFViewController>();
    int? currentPage = 0;
    return PDFView(
      filePath: path,
      enableSwipe: true,
      swipeHorizontal: true,
      autoSpacing: false,
      pageFling: true,
      pageSnap: true,
      defaultPage: currentPage,
      fitPolicy: FitPolicy.BOTH,
      preventLinkNavigation: false,
      // if set to true the link is handled in flutter
      onRender: (pages) {
        setState(() {});
      },
      onError: (error) {
        setState(() {});
        log.e(error);
      },
      onPageError: (page, error) {
        setState(() {});
      },
      onViewCreated: (PDFViewController pdfViewController) {
        controller.complete(pdfViewController);
      },
      onLinkHandler: (String? uri) {},
      onPageChanged: (int? page, int? total) {
        setState(() {
          currentPage = page;
        });
      },
    );
  }

  Future<void> _cropImage(BuildContext context) async {
    if (_pickedFile != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: _pickedFile!.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: 'Cropper',
          ),
          WebUiSettings(
            context: context,
            presentStyle: CropperPresentStyle.dialog,
            boundary: const CroppieBoundary(
              width: 520,
              height: 520,
            ),
            viewPort:
                const CroppieViewPort(width: 480, height: 480, type: 'circle'),
            enableExif: true,
            enableZoom: true,
            showZoomer: true,
          ),
        ],
      );
      if (croppedFile != null) {
        setState(() {
          _croppedFile = croppedFile;
        });
      }
    }
  }
}
