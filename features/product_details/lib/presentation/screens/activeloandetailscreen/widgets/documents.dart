import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:core/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:product_details/config/routes/route.dart';
import 'package:product_details/data/models/active_loan_detail_response.dart';
import 'package:product_details/data/models/active_loan_list_response.dart';
import 'package:product_details/data/models/doucments_request.dart';
import 'package:product_details/presentation/cubit/product_details_cubit.dart';
import 'package:product_details/presentation/screens/activeloandetailscreen/widgets/convert_to_pdf.dart';
import 'package:product_details/presentation/screens/activeloandetailscreen/widgets/repayment_schedule_document.dart';
import 'package:product_details/presentation/screens/widget/custom_image_view.dart';
import 'package:product_details/utils/enum_download_file_name.dart';
import 'package:core/config/resources/image_constant.dart';
import 'package:product_details/presentation/cubit/product_details_cubit.dart'
    as product_detail;
import 'package:product_details/utils/services.dart';

class DocumentsWidgetPage extends StatefulWidget {
  const DocumentsWidgetPage(
      {super.key, required this.loanDetails, required this.basicDetails});

  final ActiveLoanData? loanDetails;
  final ActiveLoanDetailResponse? basicDetails;

  @override
  ActiveVehicleLoanDetailsWidgetemiPageState createState() =>
      ActiveVehicleLoanDetailsWidgetemiPageState();
}

class ActiveVehicleLoanDetailsWidgetemiPageState
    extends State<DocumentsWidgetPage>
    with AutomaticKeepAliveClientMixin<DocumentsWidgetPage> {
  int length = 3;

  String buttonType = "";

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final Brightness brightness = Theme.of(context).brightness;
    return Container(
      child: _buildLastTransactions(brightness),
    );
  }

  Widget _buildLastTransactions(Brightness brightness) {
    final pdfConverter = ConvertToPdf();
    return Align(
      alignment: Alignment.center,
      child: Container(
          margin: EdgeInsets.symmetric(horizontal: 16.h),
          padding: EdgeInsets.all(12.h),
          decoration: BoxDecoration(
            color: brightness == Brightness.light
                ? AppColors.backgroundLight5
                : AppColors.cardDark,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    getString(lblStatementOfAccountProductDetail),
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          pdfConverter.shareDocument(
                              context, DownloadsName.soa);
                        },
                        child: Icon(
                          Icons.share_outlined,
                          color: setColorBasedOnTheme(
                              context: context,
                              lightColor: AppColors.secondaryLight,
                              darkColor: AppColors.primaryLight5),
                          size: 16,
                        ),
                      ),
                      BlocConsumer<ProductDetailsCubit, ProductDetailsState>(
                        listener: (context, state) {
                          if (state is product_detail.LoadingState &&
                              state.isloading) {
                            const Align(
                              alignment: Alignment.bottomCenter,
                              child: Center(
                                  child: CircularProgressIndicator(
                                color: Colors.red,
                                strokeWidth: 2,
                              )),
                            );
                          }
                          if (state is GetDocumentsSuccessState) {
                            if (widget.loanDetails?.sourceSystem
                                    ?.toLowerCase() ==
                                'pennant') {
                              pdfConverter.downloadPdfFile(
                                  context,
                                  state.response.pennantSoa?.response
                                      ?.docContent,
                                  DownloadsName.soa);
                            } else if (widget.loanDetails?.sourceSystem
                                    ?.toLowerCase() ==
                                'finnone') {
                              pdfConverter.downloadPdfFile(
                                  context,
                                  state.response.finOneSoa?.pdfData,
                                  DownloadsName.soa);
                            } else if (widget.loanDetails?.sourceSystem
                                    ?.toLowerCase() ==
                                'autofin') {
                              pdfConverter.downloadPdfFile(
                                  context,
                                  state.response.autoFinSoa?.data?.imageurl,
                                  DownloadsName.soa);
                            }
                          }
                        },
                        builder: (context, state) {
                          return InkWell(
                            onTap: () {
                              buttonType = "Download";
                              if (widget.loanDetails?.sourceSystem
                                      ?.toLowerCase() ==
                                  'pennant') {
                                BlocProvider.of<ProductDetailsCubit>(context)
                                    .getDocuments(DocumentsRequest(
                                        loanNumber:
                                            widget.loanDetails?.loanNumber,
                                        sourceSystem:
                                            widget.loanDetails?.sourceSystem,
                                        docFlag: 'soa',empCode: widget.loanDetails?.mobileNumber));
                              } else if (widget.loanDetails?.sourceSystem
                                      ?.toLowerCase() ==
                                  'finnone') {
                                BlocProvider.of<ProductDetailsCubit>(context)
                                    .getDocuments(DocumentsRequest(
                                        loanNumber:
                                            widget.loanDetails?.loanNumber,
                                        sourceSystem:
                                            widget.loanDetails?.sourceSystem,
                                        docFlag: 'soa',empCode: widget.loanDetails?.mobileNumber));
                              } else {
                                generateSOAthroughWebView(context);
                              }
                            },
                            child: CustomImageView(
                              imagePath: ImageConstant.imgDownload,
                              height: 18.adaptSize,
                              width: 18.adaptSize,
                              color: setColorBasedOnTheme(
                                context: context,
                                lightColor: AppColors.secondaryLight,
                                darkColor: AppColors.backgroundLight,
                              ),
                              margin: EdgeInsets.only(left: 10.h),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
              Divider(
                height: 25.v,
                color: Theme.of(context).dividerColor,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    getString(lblRepaymentProductDetail),
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  Row(
                    children: [
                      InkWell(
                        onTap: () async {
                          pdfConverter.shareDocument(
                              context, DownloadsName.repaymentschedule);
                        },
                        child: Icon(
                          Icons.share_outlined,
                          color: setColorBasedOnTheme(
                              context: context,
                              lightColor: AppColors.secondaryLight,
                              darkColor: AppColors.primaryLight5),
                          size: 16,
                        ),
                      ),
                      BlocConsumer<ProductDetailsCubit, ProductDetailsState>(
                        listener: (context, state) {
                          if (state is product_detail.LoadingState &&
                              state.isloading) {
                            const Align(
                              alignment: Alignment.bottomCenter,
                              child: Center(
                                  child: CircularProgressIndicator(
                                color: Colors.red,
                                strokeWidth: 2,
                              )),
                            );
                          }

                          if (state is GetRepaymentScheduleSuccessState) {
                            final repaymentSchedulePdf =
                                RepaymentScheduleDocument(
                                    loanDetails: widget.basicDetails,
                                    documents: state.response.repaymentSchedule
                                        ?.repaymentSchedule);
                            repaymentSchedulePdf
                                .generatePdf(DownloadsName.repaymentschedule);
                          }
                        },
                        builder: (context, state) {
                          return InkWell(
                            onTap: () {
                              BlocProvider.of<ProductDetailsCubit>(context)
                                  .getRepaymentScheduleDocuments(
                                      DocumentsRequest(
                                          loanNumber:
                                              widget.loanDetails?.loanNumber,
                                          sourceSystem:
                                              widget.loanDetails?.sourceSystem,
                                          docFlag: 'rs'));
                            },
                            child: CustomImageView(
                              imagePath: ImageConstant.imgDownload,
                              height: 18.adaptSize,
                              width: 18.adaptSize,
                              color: setColorBasedOnTheme(
                                context: context,
                                lightColor: AppColors.secondaryLight,
                                darkColor: AppColors.backgroundLight,
                              ),
                              margin: EdgeInsets.only(left: 10.h),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
              Divider(
                height: 25.v,
                color: Theme.of(context).dividerColor,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    getString(lblKfsProductDetail),
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  Row(
                    children: [
                      InkWell(
                        onTap: () async {
                          pdfConverter.shareDocument(
                              context, DownloadsName.kfs);
                        },
                        child: Icon(
                          Icons.share_outlined,
                          color: setColorBasedOnTheme(
                              context: context,
                              lightColor: AppColors.secondaryLight,
                              darkColor: AppColors.primaryLight5),
                          size: 18.adaptSize,
                        ),
                      ),
                      BlocConsumer<ProductDetailsCubit, ProductDetailsState>(
                        listener: (context, state) {
                          if (state is product_detail.LoadingState &&
                              state.isloading) {
                            const Align(
                              alignment: Alignment.bottomCenter,
                              child: Center(
                                  child: CircularProgressIndicator(
                                color: Colors.black,
                                strokeWidth: 2,
                              )),
                            );
                          }

                          if (state is GetKfsSuccessState) {
                            pdfConverter.convertBase64ImageToPdf(
                              context,
                              state.response.kfs?.ngoGetDocumentBdoResponse
                                  ?.docContent,
                              DownloadsName.kfs,
                            );
                          }
                        },
                        builder: (context, state) {
                          return InkWell(
                            onTap: () {
                              BlocProvider.of<ProductDetailsCubit>(context)
                                  .getKfsDocuments(DocumentsRequest(
                                      loanNumber:
                                          widget.loanDetails?.loanNumber,
                                      sourceSystem:
                                          widget.loanDetails?.sourceSystem,
                                      docFlag: 'kfs',empCode: widget.loanDetails?.mobileNumber));
                            },
                            child: CustomImageView(
                              imagePath: ImageConstant.imgDownload,
                              height: 18.adaptSize,
                              width: 18.adaptSize,
                              color: setColorBasedOnTheme(
                                context: context,
                                lightColor: AppColors.secondaryLight,
                                darkColor: AppColors.backgroundLight,
                              ),
                              margin: EdgeInsets.only(left: 10.h),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          )),
    );
  }

  void generateSOAthroughWebView(BuildContext context) async {
    if (widget.loanDetails!.sourceSystem?.toLowerCase() == 'autofin' ||
        widget.loanDetails!.sourceSystem?.toLowerCase() == 'finnone') {
      String url = createSOAurl(widget.loanDetails as ActiveLoanData);
      bool? result = await context.pushNamed(Routes.generateSoaDocWebView.name,
          extra: url);
      if (result!) {
        context.read<ProductDetailsCubit>().getDocuments(DocumentsRequest(
            loanNumber: widget.loanDetails?.loanNumber,
            sourceSystem: widget.loanDetails?.sourceSystem,
            docFlag: 'soa',empCode: widget.loanDetails?.mobileNumber));
      }
     }

  }
}
