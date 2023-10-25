import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:propertymgmt_uae/src/constants.dart';
import '../chequeandRecipts/paymentCheque1.dart';
import '../chequeandRecipts/sheetcell.dart';
import '../chequeandRecipts/tenantRecipt.dart';
import '../payment_create.dart';
import 'package:screenshot/screenshot.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:universal_html/html.dart' as html; // Import universal_html

class PaymentCheque extends StatefulWidget {
  final Map<String, dynamic>? initialData;

  const PaymentCheque({Key? key, this.initialData}) : super(key: key);

  @override
  State<PaymentCheque> createState() => _PaymentChequeState();
}

class _PaymentChequeState extends State<PaymentCheque> {
  @override
  void initState() {
    super.initState();
    if (widget.initialData != null) {
      initalData = widget.initialData!;
    }

    
  }
    bool isGeneratingPDF = false; // Track PDF generation status


  var initalData;

  final ScreenshotController screenshotController = ScreenshotController();

  Future<Uint8List?> captureScreenshot() async {
    final Uint8List? imageBytes = await screenshotController.capture();
    return imageBytes;
  }

  Future<void> generatePDF(Uint8List imageBytes) async {
  
/*     final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Image(
            pw.MemoryImage(imageBytes),
          );
        },
      ),
    ); */

  
    final pdf = pw.Document();

    // Add a single page to the document
pdf.addPage(
  pw.Page(
    margin: pw.EdgeInsets.all(10.0), // Set custom margins here
    build: (pw.Context context) {
      // Set the page size to A4
      final pageFormat = PdfPageFormat.a4;
      final pageWidth = pageFormat.width;
      final pageHeight = pageFormat.height;

      return pw.Image(
        pw.MemoryImage(imageBytes),
        width: pageWidth - 20.0, // Adjust width for margins
        height: pageHeight - 20.0, // Adjust height for margins
      );
    },
  ),
);

    final pdfBytes = await pdf.save();
    final dynamicFileName = 'PaymentCheque_${DateTime.now().toString()}.pdf';

    // For Flutter web, save the PDF using universal_html
    final blob = html.Blob([Uint8List.fromList(pdfBytes)], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..target = 'webbrowser'
      ..download = dynamicFileName; // Set your desired file name

    // Trigger a click event to download the PDF
    anchor.click();

    // Clean up
    html.Url.revokeObjectUrl(url);

    // Hide loading indicator after PDF generation
    setState(() {
      isGeneratingPDF = false;
    });
  
   
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Dimensions.screenWidth *.8,
      height: Dimensions.screenHeight *.8,
      child: Column(
        children: [
          Screenshot(
            controller: screenshotController,
            child: Column(
              children: [
                PaymentCollectionCheque(initialData: initalData),
            /*   const  SizedBox(
                  height: 30,
                ),
                // TENANT HISTORY CHEQUE
                TenantHistoryCheque(),
              const  SizedBox(
                  height: 20,
                ),
                  CustomSheetTable(),
              */
              ],
            ),
          ),
             Stack(
                  children: [
                  isGeneratingPDF?
                 Align(
                   alignment: Alignment.bottomRight,
                   child:     AutoSizeText(
                         'Generating...',
                         style: TextStyle(
                           color: Colors.green.shade300,
                           fontWeight: FontWeight.bold,
                         ),
                         minFontSize: 8,
                       ),
                 ):
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                             decoration: BoxDecoration(
          color: Colors.grey.shade300, // Specify the background color here
          borderRadius: BorderRadius.circular(10), // Optional: Add rounded corners
      ),
                          child: TextButton(
                            
                            onPressed: () async {
                                  setState(() {
        isGeneratingPDF = true; // Show loading indicator
      });
                              final imageBytes = await captureScreenshot();
                              generatePDF(imageBytes!);
                            },
                            child: Text('Generate PDF', style: TextStyle(color: Colors.black),),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}





class TenantHistoryMain extends StatefulWidget {
  final Map<String, dynamic>? initialData;

  const TenantHistoryMain({Key? key, this.initialData}) : super(key: key);

  @override
  State<TenantHistoryMain> createState() => _TenantHistoryMainState();
}

class _TenantHistoryMainState extends State<TenantHistoryMain> {
  @override
  void initState() {
    super.initState();
    if (widget.initialData != null) {
      initalData = widget.initialData!;
    }

    
  }
    bool isGeneratingPDF = false; // Track PDF generation status


  var initalData;

  final ScreenshotController screenshotController = ScreenshotController();

  Future<Uint8List?> captureScreenshot() async {
    final Uint8List? imageBytes = await screenshotController.capture();
    return imageBytes;
  }

  Future<void> generatePDF(Uint8List imageBytes) async {
  
    final pdf = pw.Document();

    // Add a single page to the document
pdf.addPage(
  pw.Page(
    margin: pw.EdgeInsets.all(10.0), // Set custom margins here
    build: (pw.Context context) {
      // Set the page size to A4
      final pageFormat = PdfPageFormat.a4;
      final pageWidth = pageFormat.width;
      final pageHeight = pageFormat.height;

      return pw.Image(
        pw.MemoryImage(imageBytes),
        width: pageWidth - 20.0, // Adjust width for margins
        height: pageHeight - 20.0, // Adjust height for margins
      );
    },
  ),
);

    final pdfBytes = await pdf.save();
    final dynamicFileName = 'TenantHistory_${DateTime.now().toString()}.pdf';

    // For Flutter web, save the PDF using universal_html
    final blob = html.Blob([Uint8List.fromList(pdfBytes)], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..target = 'webbrowser'
      ..download = dynamicFileName; // Set your desired file name

    // Trigger a click event to download the PDF
    anchor.click();

    // Clean up
    html.Url.revokeObjectUrl(url);

    // Hide loading indicator after PDF generation
    setState(() {
      isGeneratingPDF = false;
    });
  
   
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Dimensions.screenWidth *.8,
      height: Dimensions.screenHeight *.8,
      child: Column(
        children: [
          Screenshot(
            controller: screenshotController,
            child: Column(
              children: [
              
                // TENANT HISTORY CHEQUE
                TenantHistoryCheque(initialData : initalData),
              const  SizedBox(
                  height: 20,
                ),
                  CustomSheetTable(initialData: initalData),
             
              ],
            ),
          ),
             Stack(
                  children: [
                  isGeneratingPDF?
                 Align(
                   alignment: Alignment.bottomRight,
                   child:     AutoSizeText(
                         'Generating...',
                         style: TextStyle(
                           color: Colors.green.shade300,
                           fontWeight: FontWeight.bold,
                         ),
                         minFontSize: 8,
                       ),
                 ):
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                             decoration: BoxDecoration(
          color: Colors.grey.shade300, // Specify the background color here
          borderRadius: BorderRadius.circular(10), // Optional: Add rounded corners
      ),
                          child: TextButton(
                            
                            onPressed: () async {
                                  setState(() {
        isGeneratingPDF = true; // Show loading indicator
      });
                              final imageBytes = await captureScreenshot();
                              generatePDF(imageBytes!);
                            },
                            child: Text('Generate PDF', style: TextStyle(color: Colors.black),),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}
