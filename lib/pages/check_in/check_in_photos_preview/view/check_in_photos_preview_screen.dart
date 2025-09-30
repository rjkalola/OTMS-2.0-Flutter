import 'package:belcka/pages/check_in/check_in_photos_preview/controller/check_in_photos_preview_controller.dart';
import 'package:belcka/pages/check_in/check_in_photos_preview/view/widgets/dot_list_view.dart';
import 'package:belcka/res/drawable.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/image_preview/controller/image_preview_controller.dart';
import 'package:belcka/pages/image_preview/view/widgets/horizontal_list_view.dart';
import 'package:belcka/pages/image_preview/view/widgets/pager_view.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';

class CheckInPhotosPreviewScreen extends StatefulWidget {
  @override
  _CheckInPhotosPreviewScreenState createState() =>
      _CheckInPhotosPreviewScreenState();
}

class _CheckInPhotosPreviewScreenState
    extends State<CheckInPhotosPreviewScreen> {
  final controller = Get.put(CheckInPhotosPreviewController());

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
              DotIndicator(),
              Divider(
                color: dividerColor_(context),
                height: 0,
                thickness: 2,
              ),
              // HorizontalListView(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                      onPressed: () {},
                      icon: ImageUtils.setSvgAssetsImage(
                          path: Drawable.deleteTeamIcon,
                          width: 22,
                          height: 22)),
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.add_circle_outline,
                        size: 28,
                      )),
                  SizedBox(
                    width: 9,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
