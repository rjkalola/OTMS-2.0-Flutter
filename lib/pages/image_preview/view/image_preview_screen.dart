import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/image_preview/controller/image_preview_controller.dart';
import 'package:belcka/pages/image_preview/view/widgets/horizontal_list_view.dart';
import 'package:belcka/pages/image_preview/view/widgets/pager_view.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';

class ImagePreviewScreen extends StatefulWidget {
  @override
  _ImagePreviewScreenState createState() => _ImagePreviewScreenState();
}

class _ImagePreviewScreenState extends State<ImagePreviewScreen> {
  final controller = Get.put(ImagePreviewController());

  void _onThumbnailTap(int index) {
    controller.pageController.value.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: dashBoardBgColor_(context),
        statusBarIconBrightness: Brightness.dark));
    return Container(
      color: dashBoardBgColor_(context),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: dashBoardBgColor_(context),
          appBar: BaseAppBar(
            appBar: AppBar(),
            title: "",
            isCenterTitle: false,
            isBack: true,
            bgColor: dashBoardBgColor_(context),
          ),
          body: Column(
            children: [
              Divider(
                color: dividerColor_(context),
              ),
              PagerView(),
              HorizontalListView(),
            ],
          ),
        ),
      ),
    );
  }
}
