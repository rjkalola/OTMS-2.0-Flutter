import 'dart:io';
import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/PrimaryButton.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:belcka/widgets/text/PrimaryTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewerPage extends StatefulWidget {
  final String url;

  const PdfViewerPage({
    super.key,
    required this.url,
  });

  @override
  State<PdfViewerPage> createState() => _PdfViewerPageState();
}

// enum PdfSourceType { network, asset, file }

class _PdfViewerPageState extends State<PdfViewerPage> {
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';

  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    Widget pdfViewer;

    if (widget.url.startsWith("http")) {
      pdfViewer = SfPdfViewer.network(
        widget.url,
        key: _pdfViewerKey,
        onDocumentLoaded: _onDocumentLoaded,
        onDocumentLoadFailed: _onDocumentLoadFailed,
      );
    } else {
      pdfViewer = SfPdfViewer.file(
        File(widget.url),
        key: _pdfViewerKey,
        onDocumentLoaded: _onDocumentLoaded,
        onDocumentLoadFailed: _onDocumentLoadFailed,
      );
    }

    return Container(
      color: dashBoardBgColor_(context),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: dashBoardBgColor_(context),
          appBar: BaseAppBar(
            appBar: AppBar(),
            title: 'pdf_viewer'.tr,
            isCenterTitle: false,
            isBack: true,
            bgColor: dashBoardBgColor_(context),
            // widgets: actionButtons(),
          ),
          body: Stack(
            children: [
              Container(
                  alignment: Alignment.centerLeft,
                  width: double.infinity,
                  height: double.infinity,
                  child: pdfViewer),
              if (_isLoading)
                const Center(
                  child: CustomProgressbar(),
                ),
              if (_hasError)
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.error_outline,
                          color: Colors.red, size: 60),
                      const SizedBox(height: 12),
                      PrimaryTextView(
                        text: _errorMessage,
                        fontSize: 16,
                      ),
                      SizedBox(height: 8),
                      PrimaryButton(
                          width: 120,
                          height: 36,
                          buttonText: 'reload'.tr,
                          fontWeight: FontWeight.w400,
                          onPressed: () {
                            setState(() => _hasError = false);
                          }),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _onDocumentLoaded(PdfDocumentLoadedDetails details) {
    setState(() => _isLoading = false);
  }

  void _onDocumentLoadFailed(PdfDocumentLoadFailedDetails details) {
    setState(() {
      _isLoading = false;
      _hasError = true;
      _errorMessage = 'Failed to load PDF:\n${details.error}';
    });
  }
}
