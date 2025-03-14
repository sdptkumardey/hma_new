import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
class PDFViewerPage extends StatelessWidget {
  final String pdfUrl;

  PDFViewerPage({required this.pdfUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("PDF Viewer")),
      body: SfPdfViewer.network(pdfUrl),
    );
  }
}