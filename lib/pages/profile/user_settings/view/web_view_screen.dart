import 'package:flutter/material.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../../res/colors.dart';

class MyWebViewScreen extends StatefulWidget {
  final String url;
  final String pageTitle;

  const MyWebViewScreen({Key? key, required this.url, required this.pageTitle}) : super(key: key);

  @override
  State<MyWebViewScreen> createState() => _MyWebViewScreenState();
}

class _MyWebViewScreenState extends State<MyWebViewScreen> {
  late final WebViewController _controller;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            setState(() {
              isLoading = true;
            });
          },
          onPageFinished: (url) {
            setState(() {
              isLoading = false;
            });
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:BaseAppBar(
        appBar: AppBar(),
        title: widget.pageTitle ?? "",
        isCenterTitle: false,
        bgColor: dashBoardBgColor_(context),
        isBack: true,
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (isLoading)
            const Center(
              child: CustomProgressbar(),
            ),
        ],
      ),
    );
  }
}