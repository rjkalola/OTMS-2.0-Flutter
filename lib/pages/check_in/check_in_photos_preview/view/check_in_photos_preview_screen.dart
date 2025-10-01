import 'package:belcka/pages/check_in/check_in_photos_preview/controller/check_in_photos_preview_controller.dart';
import 'package:belcka/pages/check_in/check_in_photos_preview/view/widgets/dot_list_view.dart';
import 'package:belcka/pages/check_in/check_in_photos_preview/view/widgets/pager_view.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/res/drawable.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

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
    return Obx(
      () => PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop || result != null) return;
          controller.onBackPress();
        },
        child: Container(
          color: dashBoardBgColor_(context),
          child: SafeArea(
            child: Scaffold(
              backgroundColor: dashBoardBgColor_(context),
              appBar: BaseAppBar(
                appBar: AppBar(),
                title: controller.title.value,
                isCenterTitle: false,
                isBack: false,
                bgColor: dashBoardBgColor_(context),
                onBackPressed: () {
                  controller.onBackPress();
                },
              ),
              body: ModalProgressHUD(
                inAsyncCall: controller.isLoading.value,
                opacity: 0,
                progressIndicator: const CustomProgressbar(),
                child: Column(
                  children: [
                    Divider(
                      color: dividerColor_(context),
                    ),
                    PagerView(),
                    DotIndicator(),
                    Visibility(
                      visible: controller.isEditable,
                      child: Divider(
                        color: dividerColor_(context),
                        height: 0,
                        thickness: 2,
                      ),
                    ),
                    // HorizontalListView(),
                    Visibility(
                      visible: controller.isEditable,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Visibility(
                            visible: controller.filesList.length > 1,
                            child: IconButton(
                                onPressed: () {
                                  controller.showRemoveAttachmentDialog();
                                },
                                icon: ImageUtils.setSvgAssetsImage(
                                    path: Drawable.deleteTeamIcon,
                                    width: 22,
                                    height: 22)),
                          ),
                          IconButton(
                              onPressed: () {
                                controller.showAttachmentOptionsDialog();
                              },
                              icon: Icon(
                                Icons.add_circle_outline,
                                size: 28,
                              )),
                          SizedBox(
                            width: 9,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
