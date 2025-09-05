import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/resources/custom_image_view.dart';
import 'package:core/config/resources/image_constant.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/config/widgets/background/mf_gradient_background.dart';
import 'package:core/config/widgets/mf_appbar.dart';
import 'package:core/config/widgets/mf_progress_bar.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:core/config/widgets/mf_toast.dart';
import 'package:core/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:loan/features/foreclosure/data/models/get_loans_response.dart';
import 'package:product_details/data/models/active_loan_detail_request.dart';
import 'package:product_details/data/models/active_loan_detail_response.dart';
import 'package:product_details/data/models/active_loan_list_response.dart';
import 'package:product_details/data/models/documents_response.dart';
import 'package:product_details/data/models/doucments_request.dart';
import 'package:product_details/presentation/screens/activeloandetailscreen/widgets/convert_to_pdf.dart';
import 'package:product_details/presentation/screens/activeloandetailscreen/widgets/repayment_schedule_document.dart';
import 'package:product_details/utils/enum_download_file_name.dart';
import 'package:product_details/utils/services.dart';
import '../cubit/service_request_cubit.dart';
import '../cubit/service_request_state.dart';
import 'package:product_details/config/routes/route.dart'
    as product_details_route;

class DocumentDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> paramType;

  const DocumentDetailsScreen({super.key, required this.paramType});

  @override
  State<DocumentDetailsScreen> createState() => _DocumentDetailsScreenState();
}

class _DocumentDetailsScreenState extends State<DocumentDetailsScreen> {
  late LoanItem loan;
  late String docType;

  late bool isFromSOA;
  late bool isFromRS;
  late final ActiveLoanDetailResponse? basicDetails;
  late final DocumentsResponse? soaDocumentResponse;

  @override
  void initState() {
    super.initState();
    loan = widget.paramType['loanItem'];
    docType = widget.paramType['docType'];
    isFromSOA = docType == 'soa';
    isFromRS = docType == 'rs';
    Future.delayed(Duration.zero, () {
      if (isFromSOA) {
        _generateSOAthroughWebView(context);
      } else if (isFromRS) {
        _callLoanDetailsAPI();
      } else {
        //kfs
        _callGetDocument(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final pdfConverter = ConvertToPdf();
    return Scaffold(
      appBar: customAppbar(
          context: context,
          title: "Loan Documents",
          onPressed: () {
            context.pop();
          }),
      body: MFGradientBackground(
        horizontalPadding: 12,
        child: BlocConsumer<ServiceRequestCubit, ServiceRequestState>(
          listener: (context, state) {
            if (state is GetDocumentsSuccessState) {
              Navigator.of(context, rootNavigator: true).pop();
              pdfConverter.convertBase64ImageToPdf(
                // KFS
                context,
                state.response.kfs?.ngoGetDocumentBdoResponse?.docContent,
                isFromSOA ? DownloadsName.soa : DownloadsName.kfs,
                navigateToView: false,
              );
            } else if (state is ActiveLoansDetailsSuccessState) {
              Navigator.of(context, rootNavigator: true).pop();
              basicDetails = state.response;
            } else if (state is SOADocumentsSuccessState) {
              Navigator.of(context, rootNavigator: true).pop();
              soaDocumentResponse = state.response;
            } else if(state is ActiveLoansDetailsFailureState || state is GetDocumentsFailureState) {
              Navigator.of(context, rootNavigator: true).pop();
              toastForFailureMessage(
                  context: context, msg: getString(msgSomethingWentWrong));
            }
            else if (state is RepaymentScheduleDocumentSuccessState) {
              Navigator.of(context, rootNavigator: true).pop();
              final repaymentSchedulePdf =
              RepaymentScheduleDocument(
                  loanDetails: basicDetails,
                  documents: state.response.repaymentSchedule
                      ?.repaymentSchedule);
              repaymentSchedulePdf
                  .generatePdf(DownloadsName.repaymentschedule);
              ///todo: remove comment after test repayment schedule.
              /* Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RepaymentSchedulePdf(
                    loanDetails: basicDetails,
                    documents: state.response.repaymentSchedule,
                  ),
                ),
               ); */
            }
          },
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        leading: Container(
                          decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                          child: SvgPicture.asset(
                              ImageConstant.imgVehicleLoanIconLight),
                        ),
                        title: Text(
                            "${loan.productCategory} | ${loan.applicantName}",
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                    letterSpacing: 0.5,
                                    fontWeight: FontWeight.w500)),
                        subtitle: Text("${loan.vehicleRegistration}",
                            style: Theme.of(context).textTheme.bodyMedium),
                        trailing: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: const Color.fromRGBO(237, 224, 227, 1),
                              borderRadius: BorderRadius.circular(4)),
                          child: Text("${loan.loanStatus}",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(fontSize: 11)),
                        ),
                      ),
                      Divider(
                        color: Theme.of(context).dividerColor,
                      ),
                      Row(
                        children: [
                          Text(
                            docType == "kfs"
                                ? "Key fact statement"
                                : docType == "soa"
                                    ? "Statement of Account"
                                    : docType == "rs"
                                        ? "Repayment details"
                                        : docType,
                          ),
                          const Spacer(),
                          InkWell(
                            onTap: () {
                              DownloadsName name;
                              if (isFromRS) {
                                name = DownloadsName.repaymentschedule;
                              } else if (isFromSOA) {
                                name = DownloadsName.soa;
                              } else {
                                name = DownloadsName.kfs;
                              }
                              pdfConverter.shareDocument(
                                context,
                                name,
                              );
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
                          InkWell(
                            onTap: () {
                              if (isFromRS) {
                                _callRepaymentScheduleDocument(context);
                              } else {
                                if (isFromSOA) {
                                  if (loan.sourceSystem?.toLowerCase() ==
                                      'pennant') {
                                    pdfConverter.downloadPdfFile(
                                        context,
                                        soaDocumentResponse
                                            ?.pennantSoa?.response?.docContent,
                                        DownloadsName.soa);
                                  }
                                  else if(loan.sourceSystem?.toLowerCase() ==
                                      'finnone') {
                                    pdfConverter.downloadPdfFile(
                                        context,
                                        soaDocumentResponse?.finOneSoa?.pdfData,
                                        DownloadsName.soa);
                                  }
                                  else {
                                    pdfConverter.downloadPdfFile(
                                        context,
                                        soaDocumentResponse?.autoFinSoa?.data?.imageurl,
                                        DownloadsName.soa);
                                    }
                                } else {
                                  pdfConverter.downloadBase64Pdf(
                                    context,
                                    DownloadsName.kfs,
                                  );
                                }
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
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget buildRow(BuildContext context, String title, String subtitle,
      String title2, String subtitle2) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Text(subtitle, style: Theme.of(context).textTheme.labelSmall),
              ],
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title2,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Text(subtitle2, style: Theme.of(context).textTheme.labelSmall),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _callGetDocument(BuildContext context) {
    showLoaderDialog(context, getString(lblLoading));
    var docType = widget.paramType['docType'];
    LoanItem? loanItem = widget.paramType['loanItem'];

    if (loanItem != null) {
      BlocProvider.of<ServiceRequestCubit>(context).getDocuments(
          DocumentsRequest(
              loanNumber: loanItem.loanNumber,
              sourceSystem: loanItem.sourceSystem,
              docFlag: docType));
    }
  }

  _callSOADocument(BuildContext context) {
    showLoaderDialog(context, getString(lblLoading));
    var docType = widget.paramType['docType'];
    LoanItem? loanItem = widget.paramType['loanItem'];

    if (loanItem != null) {
      BlocProvider.of<ServiceRequestCubit>(context).getSOADocuments(
          DocumentsRequest(
              loanNumber: loanItem.loanNumber,
              sourceSystem: loanItem.sourceSystem,
              docFlag: docType));
    }
  }

  _callLoanDetailsAPI() {
    LoanItem? loanItem = widget.paramType['loanItem'];
    showLoaderDialog(context, getString(lblLoading));
    BlocProvider.of<ServiceRequestCubit>(context).getActiveLoansDetails(
        ActiveLoanDetailRequest(
            ucic: loanItem?.ucic,
            loanNumber: loanItem?.loanNumber,
            cifId: loanItem?.cif,
            sourceSystem: loanItem?.sourceSystem));
  }

  _callRepaymentScheduleDocument(BuildContext context) {
    showLoaderDialog(context, getString(lblLoading));
    var docType = widget.paramType['docType'];
    LoanItem? loanItem = widget.paramType['loanItem'];

    if (loanItem != null) {
      BlocProvider.of<ServiceRequestCubit>(context)
          .getRepaymentScheduleDocuments(DocumentsRequest(
              loanNumber: loanItem.loanNumber,
              sourceSystem: loanItem.sourceSystem,
              docFlag: docType));
    }
  }

  void _generateSOAthroughWebView(BuildContext mContext) async {
    if (loan.sourceSystem?.toLowerCase() == 'autofin') {
      final activeLoanData = ActiveLoanData(loanNumber: loan.loanNumber);
      String url = createSOAurl(activeLoanData);
      bool? result = await mContext.pushNamed(
          product_details_route.Routes.generateSoaDocWebView.name,
          extra: url);
      if (result! && mContext.mounted) {
        _callSOADocument(mContext);
      }
    } else {
      _callSOADocument(mContext);
    }
  }
}
