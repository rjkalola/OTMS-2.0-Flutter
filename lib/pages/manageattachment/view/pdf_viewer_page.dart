import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PdfViewerPage extends StatefulWidget {
  final String filePath; // can be local path or URL
  const PdfViewerPage({super.key, required this.filePath});

  @override
  State<PdfViewerPage> createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  // PdfControllerPinch? pdfController;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPdf();
  }

  Future<void> _loadPdf() async {
    try {
      // if (widget.filePath.startsWith('http')) {
      //   // It's a URL → download bytes first
      //   final response = await http.get(Uri.parse(widget.filePath));
      //   pdfController = PdfControllerPinch(
      //     document: PdfDocument.openData(response.bodyBytes),
      //   );
      // } else {
      //   // Local file path
      //   pdfController = PdfControllerPinch(
      //     document: PdfDocument.openFile(widget.filePath),
      //   );
      // }
    } catch (e) {
      debugPrint('Error loading PDF: $e');
    }

    if (mounted) {
      setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    // pdfController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PDF Viewer')),
      // body: isLoading
      //     ? const Center(child: CircularProgressIndicator())
      //     : PdfViewPinch(controller: pdfController!),
    );
  }
}
