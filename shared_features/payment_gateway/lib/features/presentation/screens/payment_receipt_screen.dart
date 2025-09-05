import 'dart:io';
import 'package:core/config/resources/app_colors.dart';
import 'package:core/config/resources/image_constant.dart';
import 'package:core/config/string_resource/strings.dart';
import 'package:core/config/widgets/mf_theme_check.dart';
import 'package:core/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_to_pdf/export_delegate.dart';
import 'package:flutter_to_pdf/export_frame.dart';
import 'package:flutter_to_pdf/options/export_options.dart';
import 'package:flutter_to_pdf/options/page_format_options.dart';
import 'package:path_provider/path_provider.dart';
import 'package:payment_gateway/features/presentation/utils/payment_mode_enum.dart';
import 'package:payment_gateway/features/presentation/utils/services/payment_screen_feed_model.dart';
import 'package:payment_gateway/features/presentation/utils/services/services.dart';
import 'package:open_file/open_file.dart';
import 'package:share_plus/share_plus.dart';

class PaymentReceiptScreen extends StatefulWidget {
  const PaymentReceiptScreen({super.key, required this.paymentData});

  final PaymentStatusDataModel paymentData;

  static const String pdfWidgetKey = "payment-receipt";

  @override
  State<PaymentReceiptScreen> createState() => _PaymentReceiptScreenState();
}

class _PaymentReceiptScreenState extends State<PaymentReceiptScreen> with WidgetsBindingObserver{
  final ExportDelegate exportDelegate = ExportDelegate(
    ttfFonts: {
      'Quicksand': 'assets/fonts/Quicksand-Regular.ttf',
      'Karla': 'assets/fonts/Karla-Regular.ttf',
    },
  );

  bool isDownload = false;

  Future<void> saveFile(document, String name, ActionType? actionType) async {
    try {
      if (actionType != null) {
        widget.paymentData.actionsType = actionType;
      }
      Directory? dir;
      if (Platform.isIOS) {
        dir = await getApplicationDocumentsDirectory(); 
      } else {
        dir = await getDownloadsDirectory(); 
      }
      final File file = File('${dir!.path}/$name.pdf');
      await file.writeAsBytes(await document.save());
      if (isDownload) {
        OpenFile.open(file.path);
      }
      if (!isDownload && mounted) {
        final box = context.findRenderObject() as RenderBox?;
          await Share.shareXFiles(
          [XFile(file.path)],
          sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
        ).then((value) {
          Navigator.of(context).pop();
          return value;
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    isDownload = widget.paymentData.actionsType == ActionType.download;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await createPDF(null);
    });
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (isDownload) {
        Navigator.of(context).pop();
      }
    }
    super.didChangeAppLifecycleState(state);
  }

  Future<void> createPDF(ActionType? actionType) async {
    const ExportOptions overrideOptions = ExportOptions(
      pageFormatOptions: PageFormatOptions.a4(),
    );

    final pdf = await exportDelegate.exportToPdfDocument(
        PaymentReceiptScreen.pdfWidgetKey,
        overrideOptions: overrideOptions);
    saveFile(pdf, widget.paymentData.loanNumber, actionType);
  }

  Widget staticAppBar() {
    return SizedBox(
      height: 60.v,
      child: Row(
        children: [
          InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: const Icon(Icons.arrow_back)),
          const SizedBox(
            width: 20,
          ),
          Text(getString(lblTransactionDetails),
              style: Theme.of(context).textTheme.titleLarge)
        ],
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    bool isFromForeclosure = widget.paymentData.fromScreen?.toLowerCase() == "foreclosure";
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  staticAppBar(),
                  ExportFrame(
                    frameId: PaymentReceiptScreen.pdfWidgetKey,
                    exportDelegate: exportDelegate,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Image.asset(
                                    fit: BoxFit.contain,
                                    height: 40,
                                    ImageConstant.mahindraFinance),
                              ),
                              const SizedBox(
                                width: 50,
                              ),
                              SizedBox(
                                height: 50,
                                width: 100,
                                child: Image.asset(
                                    fit: BoxFit.contain, ImageConstant.smilyFin2go),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Divider(),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                height: 28,
                                width: 22,
                                child: Image.asset(
                                    fit: BoxFit.fill, ImageConstant.rupee),
                              ),
                              Text(
                                widget.paymentData.amount,
                                style: const TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset(
                                  fit: BoxFit.contain,
                                  height: 18,
                                  width: 18,
                                  widget.paymentData.paymentStatus
                                      ? ImageConstant.checkCirclePng
                                      : ImageConstant.cancelCirclePng),
                              const SizedBox(width: 5),
                              Flexible(
                                child: Text(isFromForeclosure ? 
                                  getString(lblYourLoanIsForeclosed).replaceAll('#@#', widget.paymentData.loanNumber)
                                 : widget.paymentData.paymentStatus
                                      ? 'Payment done successfully'
                                      : "Transaction failed due to a technical error.",
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          buildInfoRow(
                              'Transaction ID', widget.paymentData.transactionId),
                          Divider(
                            color: Colors.grey.withOpacity(0.5),
                          ),
                          buildInfoRow(
                              'Loan Number', widget.paymentData.loanNumber),
                          Divider(
                            color: Colors.grey.withOpacity(0.5),
                          ),
                          buildInfoRow('Amount Paid', widget.paymentData.amount),
                          Divider(
                            color: Colors.grey.withOpacity(0.5),
                          ),
                          buildInfoRow(
                              'Mode of payment', widget.paymentData.modeOfPayment),
                          Divider(
                            color: Colors.grey.withOpacity(0.5),
                          ),
                          buildInfoRow(
                              'Customer Name', widget.paymentData.customerName),
                          Divider(
                            color: Colors.grey.withOpacity(0.5),
                          ),
                          if (widget.paymentData.paymentStatus) ...[
                            buildInfoRow('Bank Transaction ID',
                                widget.paymentData.bankTransactionID),
                            Divider(
                              color: Colors.grey.withOpacity(0.5),
                            ),
                          ],
                          buildInfoRow('Purpose of payment',
                              widget.paymentData.purposeOfPayment),
                          Divider(
                            color: Colors.grey.withOpacity(0.5),
                          ),
                          buildInfoRow('Payment made on',
                              '${dateFormatter(widget.paymentData.paymentMadeOn)} at ${timeFormatter(widget.paymentData.paymentMadeOn)}'),
                          const SizedBox(
                            height: 50,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      downloadShareActionWidget(context, ImageConstant.downloadIcon,
                          getString(lblDownload), () async {
                        createPDF(ActionType.download);
                      }),
                      const SizedBox(
                        width: 20,
                      ),
                      downloadShareActionWidget(context, null, getString(lblShare),
                          () async {
                        createPDF(ActionType.share);
                      }),
                    ],
                  ),
                ],
              ),
            ),
           Container(
              color: Colors.white,
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              child: widget.paymentData.actionsType == ActionType.download ?  const Center(child:  CircularProgressIndicator(),) : const SizedBox(),
            ),
          ],
        ),
      ),
    );
  }

  Widget downloadShareActionWidget(BuildContext context, String? iconPath,
      String title, void Function() ontap) {
    return InkWell(
      onTap: ontap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          iconPath == null
              ? Icon(
                  Icons.share_outlined,
                  color: setColorBasedOnTheme(
                      context: context,
                      lightColor: AppColors.secondaryLight,
                      darkColor: AppColors.primaryLight5),
                  size: 16,
                )
              : SvgPicture.asset(
                  iconPath,
                  height: 18.v,
                  width: 18.h,
                  colorFilter: ColorFilter.mode(
                      setColorBasedOnTheme(
                          context: context,
                          lightColor: AppColors.secondaryLight,
                          darkColor: AppColors.primaryLight5),
                      BlendMode.srcIn),
                ),
          SizedBox(
            width: 8.h,
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: setColorBasedOnTheme(
                    context: context,
                    lightColor: AppColors.secondaryLight,
                    darkColor: AppColors.primaryLight5)),
          )
        ],
      ),
    );
  }

  Widget buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (label == "Amount Paid")
                          SizedBox(
                            height: 16,
                            width: 14,
                            child: Image.asset(
                                fit: BoxFit.fill, ImageConstant.rupee),
                          ),
                        Flexible(
                          child: Text(
                            value,
                            style: const TextStyle(
                                fontSize: 16, color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
