import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:belcka/pages/check_in/select_before_after_photos/controller/select_before_after_photos_controller.dart';
import 'package:belcka/pages/check_in/select_before_after_photos/view/widgets/before_after_photos_list.dart';
import 'package:belcka/pages/check_in/select_before_after_photos/view/widgets/submit_btn_before_after_photos.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:belcka/utils/app_utils.dart';

class SelectBeforeAfterPhotosScreen extends StatefulWidget {
  const SelectBeforeAfterPhotosScreen({super.key});

  @override
  State<SelectBeforeAfterPhotosScreen> createState() =>
      _SelectBeforeAfterPhotosScreenState();
}

class _SelectBeforeAfterPhotosScreenState
    extends State<SelectBeforeAfterPhotosScreen> {
  final controller = Get.put(SelectBeforeAfterPhotosController());

  @override
  Widget build(BuildContext context) {
    AppUtils.setStatusBarColor();
    return Container(
      color: dashBoardBgColor_(context),
      child: SafeArea(
          child: Scaffold(
        backgroundColor: dashBoardBgColor_(context),
        appBar: BaseAppBar(
          appBar: AppBar(),
          // title: controller.title.value,
          title: "",
          isCenterTitle: false,
          isBack: true,
          bgColor: dashBoardBgColor_(context),
        ),
        body: Obx(
          () => ModalProgressHUD(
            inAsyncCall: controller.isLoading.value,
            opacity: 0,
            progressIndicator: const CustomProgressbar(),
            child: Column(children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Divider(
                    //   thickness: 1,
                    //   height: 1,
                    //   color: dividerColor_(context),
                    // ),
                    SizedBox(
                      height: 4,
                    ),
                    Visibility(
                      visible: controller.isBeforeEnable.value,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: TitleTextView(
                              text: 'photos_before'.tr,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          BeforeAfterPhotosList(
                            onGridItemClick: controller.onGridItemClick,
                            filesList: controller.beforePhotosList,
                            photosType: AppConstants.type.beforePhotos,
                            isEditable: controller.isEditable.value,
                          ),
                          SizedBox(
                            height: 24,
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: controller.isAfterEnable.value,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: TitleTextView(
                              text: 'photos_after'.tr,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          BeforeAfterPhotosList(
                            onGridItemClick: controller.onGridItemClick,
                            filesList: controller.afterPhotosList,
                            photosType: AppConstants.type.afterPhotos,
                            isEditable: controller.isEditable.value,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SubmitBtnBeforeAfterPhotos()
            ]),
          ),
        ),
      )),
    );
  }
}
