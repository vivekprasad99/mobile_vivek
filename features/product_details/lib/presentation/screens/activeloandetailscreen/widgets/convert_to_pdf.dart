import 'dart:convert';
import 'dart:io';
import 'package:core/config/string_resource/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:product_details/utils/enum_download_file_name.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

class ConvertToPdf {
  String? _base64PdfString;

  Future<void> downloadPdfFile(context, String? downloadLink,
      DownloadsName name) async {
    if (downloadLink == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(getString(ROM1005))),
      );
      return;
    }

    try {
      final Uint8List pdfData = base64Decode(downloadLink);

      Directory? dir = Platform.isIOS
          ? await getApplicationDocumentsDirectory()
          : await getDownloadsDirectory();

      final File pdfFile = File('${dir?.path}/$name.pdf');
      await pdfFile.writeAsBytes(pdfData);

      OpenFile.open(pdfFile.path);
    } catch (e) {
      print(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(getString(msgSomethingWentWrongProductDetail))),
      );
    }
  }

  Future<void> downloadBase64Pdf(
    BuildContext context,
    DownloadsName name,
  ) {
    return convertBase64ImageToPdf(context, _base64PdfString, name);
  }

  Future<void> convertBase64ImageToPdf(
    context,
    String? downloadLink,
    DownloadsName name, {
    bool navigateToView = true,
  }) async {
    if (downloadLink == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(getString(ROM1005))),
      );
      return;
    }

    _base64PdfString = downloadLink;

    try {
      final Uint8List imageData = base64Decode(downloadLink);

      final pw.Document pdf = pw.Document();

      final pw.ImageProvider image = pw.MemoryImage(imageData);
      pdf.addPage(pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Image(image),
          );
        },
      ));

      Directory? dir = Platform.isIOS
          ? await getApplicationDocumentsDirectory()
          : await getDownloadsDirectory();

      final File file = File('${dir?.path}/$name.pdf');
      await file.writeAsBytes(await pdf.save());
      OpenFile.open(file.path);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(getString(msgSomethingWentWrongProductDetail))),
      );
    }
  }

  void shareDocument(context, DownloadsName name) async {
    Directory? dir = Platform.isIOS
        ? await getApplicationDocumentsDirectory()
        : await getDownloadsDirectory();
    final File file = File('${dir?.path}/$name.pdf');
    final isFileExist = await file.exists();
    if (isFileExist) {
      final box = context.findRenderObject() as RenderBox?;
      await Share.shareXFiles(
        [XFile(file.path)],
        sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(getString(ROM1005))),
      );
    }
  }
}
