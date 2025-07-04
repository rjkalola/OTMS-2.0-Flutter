import 'package:flutter/material.dart';
import 'package:otm_inventory/widgets/appbar/base_appbar.dart';
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

  @override
  void initState() {
    super.initState();
    print("widget.url:"+widget.url);
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:BaseAppBar(
        appBar: AppBar(),
        title: widget.pageTitle ?? "",
        isCenterTitle: false,
        bgColor: dashBoardBgColor,
        isBack: true,
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}