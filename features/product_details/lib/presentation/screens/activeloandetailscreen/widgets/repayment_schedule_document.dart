import 'dart:io';
import 'package:core/config/resources/image_constant.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:product_details/data/models/active_loan_detail_response.dart';
import 'package:product_details/data/models/documents_response.dart';
import 'package:product_details/utils/date_time_convert.dart';
import 'package:product_details/utils/date_time_utils.dart';
import 'package:product_details/utils/enum_download_file_name.dart';
import 'package:product_details/utils/string_constant.dart';

class RepaymentScheduleDocument {
  final ActiveLoanDetailResponse? loanDetails;
  final List<RepaymentSchedule>? documents;

  RepaymentScheduleDocument(
      {required this.loanDetails, required this.documents});

  Future<Uint8List> generatePdf(DownloadsName name) async {
    final pdf = pw.Document();
    final mahindraFinanceImg = PdfImage.file(
      pdf.document,
      bytes: (await rootBundle.load(ImageConstant.mahindraFinance))
          .buffer
          .asUint8List(),
    );

    final smilyFin2goImg = PdfImage.file(
      pdf.document,
      bytes: (await rootBundle.load(ImageConstant.smilyFin2go))
          .buffer
          .asUint8List(),
    );

    final rupeeImg = PdfImage.file(
      pdf.document,
      bytes: (await rootBundle.load(ImageConstant.rupee)).buffer.asUint8List(),
    );

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          _pdfCompanyImgLogo(mahindraFinanceImg, smilyFin2goImg),
          pw.SizedBox(height: 30),
          _buildLoanDetails(rupeeImg),
          pw.SizedBox(height: 18),
          if(documents != null)
          _buildTableHeader(documents!, rupeeImg),
          pw.SizedBox(height: 10),
          pw.Spacer(),
          _buildFooter(),
        ],
      ),
    );
    Directory? dir;
    if (Platform.isIOS) {
      dir = await getApplicationDocumentsDirectory();
    } else {
      dir = await getDownloadsDirectory();
    }
    final File file = File('${dir?.path}/$name.pdf');
    await file.writeAsBytes(await pdf.save());
    OpenFile.open(file.path);
    return pdf.save();
  }

  pw.Widget _pdfCompanyImgLogo(mahindraFinanceImg, smilyFin2goImg) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Container(
            height: 40,
            child: pw.Image(pw.ImageProxy(mahindraFinanceImg),
                width: 285, height: 100)),
        pw.SizedBox(width: 50),
        pw.Container(
            height: 50,
            width: 100,
            child: pw.Image(pw.ImageProxy(smilyFin2goImg),
                width: 150, height: 30)),
      ],
    );
  }

  pw.Widget _buildTableHeader(List<RepaymentSchedule> data, rupeeImg) {
    double totalInstallmentAmount = 0;
    double totalPrincipalComponent = 0;
    double totalInterestComponent = 0;

    for (var item in data) {
      totalInstallmentAmount +=
          double.tryParse(item.installmentAmount ?? '0') ?? 0;
      totalPrincipalComponent +=
          double.tryParse(item.principalComponent ?? '0') ?? 0;
      totalInterestComponent +=
          double.tryParse(item.interestComponent ?? '0') ?? 0;
    }
    return pw.Table(
      children: [
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.grey300),
          children: [
            pw.Padding(
                padding: const pw.EdgeInsets.all(12.0),
                child: pw.SizedBox(
                  width: 35,
                  child: pw.Text(
                    StringConstant.srNo,
                    style: pw.TextStyle(
                        fontSize: 11, fontWeight: pw.FontWeight.bold),
                  ),
                )),
            pw.Padding(
                padding: const pw.EdgeInsets.all(12.0),
                child: pw.SizedBox(
                  width: 70,
                  child: pw.Text(
                    StringConstant.dueDate,
                    style: pw.TextStyle(
                        fontSize: 11, fontWeight: pw.FontWeight.bold),
                  ),
                )),
            pw.Padding(
                padding: const pw.EdgeInsets.all(12.0),
                child: pw.SizedBox(
                  width: 80,
                  child: pw.Text(
                    StringConstant.installmentAmount,
                    style: pw.TextStyle(
                        fontSize: 11, fontWeight: pw.FontWeight.bold),
                  ),
                )),
            pw.Padding(
                padding: const pw.EdgeInsets.all(12.0),
                child: pw.SizedBox(
                  width: 80,
                  child: pw.Text(
                    StringConstant.principal,
                    style: pw.TextStyle(
                        fontSize: 11, fontWeight: pw.FontWeight.bold),
                  ),
                )),
            pw.Padding(
                padding: const pw.EdgeInsets.all(12.0),
                child: pw.SizedBox(
                  width: 80,
                  child: pw.Text(
                    StringConstant.interest,
                    style: pw.TextStyle(
                        fontSize: 11, fontWeight: pw.FontWeight.bold),
                  ),
                )),
            pw.Padding(
              padding: const pw.EdgeInsets.all(12.0),
              child: pw.Text(
                StringConstant.outstandingPrincipal,
                style:
                    pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold),
              ),
            ),
          ],
        ),
        ...data.map((item) {
          return pw.TableRow(
            children: [
              pw.Padding(
                padding: const pw.EdgeInsets.all(8.0),
                child: pw.Text(
                  item.installmentNumber ?? '',
                  style: const pw.TextStyle(fontSize: 11),
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(8.0),
                child: pw.Text(
                  item.dueDate ?? '',
                  style: const pw.TextStyle(fontSize: 11),
                ),
              ),
              pw.Padding(
                  padding: const pw.EdgeInsets.all(8.0),
                  child: pw.Row(children: [
                    pw.Image(pw.ImageProxy(rupeeImg), width: 10, height: 12),
                    pw.SizedBox(width: 2),
                    pw.Text(
                      item.installmentAmount ?? '',
                      style: const pw.TextStyle(fontSize: 11),
                    ),
                  ])),
              pw.Padding(
                  padding: const pw.EdgeInsets.all(8.0),
                  child: pw.Row(children: [
                    pw.Image(pw.ImageProxy(rupeeImg), width: 10, height: 12),
                    pw.SizedBox(width: 2),
                    pw.Text(
                      item.principalComponent ?? '',
                      style: const pw.TextStyle(fontSize: 11),
                    ),
                  ])),
              pw.Padding(
                  padding: const pw.EdgeInsets.all(8.0),
                  child: pw.Row(children: [
                    pw.Image(pw.ImageProxy(rupeeImg), width: 10, height: 12),
                    pw.SizedBox(width: 2),
                    pw.Text(
                      item.interestComponent ?? '',
                      style: const pw.TextStyle(fontSize: 11),
                    ),
                  ])),
              pw.Padding(
                  padding: const pw.EdgeInsets.all(8.0),
                  child: pw.Row(children: [
                    pw.Image(pw.ImageProxy(rupeeImg), width: 10, height: 12),
                    pw.SizedBox(width: 2),
                    pw.Text(
                      item.outstandingPrincipal ?? '',
                      style: const pw.TextStyle(fontSize: 11),
                    ),
                  ])),
            ],
          );
        }),
        pw.TableRow(children: [
          pw.Divider(color: PdfColors.grey300),
          pw.Divider(color: PdfColors.grey300),
          pw.Divider(color: PdfColors.grey300),
          pw.Divider(color: PdfColors.grey300),
          pw.Divider(color: PdfColors.grey300),
          pw.Divider(color: PdfColors.grey300),
        ]),
        pw.TableRow(
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(8.0),
              child: pw.Text(
                StringConstant.total,
                style:
                    pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(8.0),
              child: pw.Text(''),
            ),
            pw.Padding(
                padding: const pw.EdgeInsets.all(8.0),
                child: pw.Row(children: [
                  pw.Image(
                    pw.ImageProxy(rupeeImg),
                    width: 10,
                    height: 12,
                  ),
                  pw.SizedBox(width: 3),
                  pw.Text(
                    totalInstallmentAmount.toStringAsFixed(2),
                    style: pw.TextStyle(
                        fontSize: 11, fontWeight: pw.FontWeight.bold),
                  ),
                ])),
            pw.Padding(
                padding: const pw.EdgeInsets.all(8.0),
                child: pw.Row(children: [
                  pw.Image(pw.ImageProxy(rupeeImg), width: 10, height: 12),
                  pw.SizedBox(width: 3),
                  pw.Text(
                    totalPrincipalComponent.toStringAsFixed(2),
                    style: pw.TextStyle(
                        fontSize: 11, fontWeight: pw.FontWeight.bold),
                  ),
                ])),
            pw.Padding(
              padding: const pw.EdgeInsets.all(8.0),
              child: pw.Row(children: [
                pw.Image(pw.ImageProxy(rupeeImg), width: 10, height: 12),
                pw.SizedBox(width: 3),
                pw.Text(
                  totalInterestComponent.toStringAsFixed(2),
                  style: pw.TextStyle(
                      fontSize: 11, fontWeight: pw.FontWeight.bold),
                ),
              ]),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(8.0),
              child: pw.Text(''),
            ),
          ],
        ),
        pw.TableRow(children: [
          pw.Divider(color: PdfColors.grey300),
          pw.Divider(color: PdfColors.grey300),
          pw.Divider(color: PdfColors.grey300),
          pw.Divider(color: PdfColors.grey300),
          pw.Divider(color: PdfColors.grey300),
          pw.Divider(color: PdfColors.grey300),
        ]),
      ],
    );
  }

  pw.Widget _buildLoanDetails(PdfImage rupeeImg) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Column(
          mainAxisAlignment: pw.MainAxisAlignment.start,
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            _buildDetailColumn(StringConstant.disbursalDate,
                ConvertDateTime.convertDateFormat(loanDetails!.basicDetailsResponse!.startDate!) ?? '', rupeeImg),
            pw.SizedBox(width: 32),
            _buildDetailColumn(
                StringConstant.tenure,
                '${loanDetails?.basicDetailsResponse?.loanTenure ?? ''} ${StringConstant.months}',
                rupeeImg),
            pw.SizedBox(width: 32),
            _buildDetailColumn(StringConstant.frequency,
                loanDetails?.basicDetailsResponse?.frequency ?? '', rupeeImg),
          ],
        ),
        pw.Column(
          mainAxisAlignment: pw.MainAxisAlignment.start,
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            _buildDetailColumn(
                StringConstant.customerName,
                loanDetails?.basicCustomerDetails?.customerName ?? '',
                rupeeImg),
            _buildDetailColumn(StringConstant.loanType,
                loanDetails?.basicDetailsResponse?.loanType ?? '', rupeeImg),
            _buildDetailColumn(
                StringConstant.roi,
                '${loanDetails?.basicDetailsResponse?.interestRate ?? ''}%',
                rupeeImg),
          ],
        ),
        pw.Column(
          mainAxisAlignment: pw.MainAxisAlignment.start,
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            _buildDetailColumn(StringConstant.loanNumber,
                loanDetails?.basicDetailsResponse?.loanId ?? '', rupeeImg),
            _buildDetailColumn(
                StringConstant.loanAmount,
                loanDetails?.basicDetailsResponse?.financedAmount ?? '',
                isAmount: true,
                rupeeImg),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildDetailColumn(String title, String value, PdfImage rupeeImg,
      {bool isAmount = false}) {
    return pw.Column(
      mainAxisAlignment: pw.MainAxisAlignment.start,
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(title,
            style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 5),
        if (isAmount)
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.start,
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Image(pw.ImageProxy(rupeeImg), width: 10, height: 12),
              pw.SizedBox(width: 3),
              pw.SizedBox(
                width: 200,
                height: 30,
                child: pw.Text(value,
                    maxLines: 3,
                    style: pw.TextStyle(
                        fontSize: 14, fontWeight: pw.FontWeight.normal)),
              ),
            ],
          )
        else
          pw.SizedBox(
            width: 200,
            height: 30,
            child: pw.Text(value,
                maxLines: 3,
                style: pw.TextStyle(
                    fontSize: 14, fontWeight: pw.FontWeight.normal)),
          ),
        pw.SizedBox(height: 25),
      ],
    );
  }

  pw.Widget _buildFooter() {
    return pw.Column(
      children: [
        pw.Text(
          '${StringConstant.docDownloadDate} ${DateTime.now().format()}',
          textAlign: pw.TextAlign.center,
          style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.normal),
        ),
      ],
    );
  }
}
