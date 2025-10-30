import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_filex/open_filex.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DocumentWebView extends StatefulWidget {
  final String url; // URL or local path

  const DocumentWebView({
    super.key,
    required this.url,
  });

  @override
  State<DocumentWebView> createState() => _DocumentWebViewState();
}

class _DocumentWebViewState extends State<DocumentWebView> {
  bool _isLoading = true;
  WebViewController? _controller;

  @override
  void initState() {
    super.initState();
    _openDocument();
  }

  Future<void> _openDocument() async {
    if (widget.url.startsWith("http")) {
      final encodedUrl = Uri.encodeFull(widget.url);
      final viewerUrl =
          'https://docs.google.com/gview?embedded=true&url=$encodedUrl';

      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageStarted: (_) => setState(() => _isLoading = true),
            onPageFinished: (_) => setState(() => _isLoading = false),
            onWebResourceError: (_) => setState(() => _isLoading = false),
          ),
        )
        ..loadRequest(Uri.parse(viewerUrl));
    } else {
      // ✅ Local file → Open with default native app (Word, Excel, PDF, etc.)
      await OpenFilex.open(widget.url);
      if (mounted) Get.back(); // close viewer screen automatically
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: dashBoardBgColor_(context),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: dashBoardBgColor_(context),
          appBar: BaseAppBar(
            appBar: AppBar(),
            title: 'documents'.tr,
            isCenterTitle: false,
            isBack: true,
            bgColor: dashBoardBgColor_(context),
            // widgets: actionButtons(),
          ),
          body: Stack(
            children: [
              if (widget.url.startsWith("http") && _controller != null)
                WebViewWidget(controller: _controller!)
              else if (widget.url.startsWith("http"))
                const Center(
                  child: Text('Failed to load document'),
                ),
              if (_isLoading)
                const Center(
                  child: CustomProgressbar(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
