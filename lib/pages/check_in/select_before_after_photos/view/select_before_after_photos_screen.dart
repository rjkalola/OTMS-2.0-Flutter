import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:otm_inventory/pages/check_in/select_before_after_photos/controller/select_before_after_photos_controller.dart';
import 'package:otm_inventory/pages/check_in/select_before_after_photos/view/widgets/before_after_photos_list.dart';
import 'package:otm_inventory/pages/check_in/select_before_after_photos/view/widgets/submit_btn_before_after_photos.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/widgets/CustomProgressbar.dart';
import 'package:otm_inventory/widgets/appbar/base_appbar.dart';
import 'package:otm_inventory/utils/app_utils.dart';
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
      color: backgroundColor_(context),
      child: SafeArea(
          child: Scaffold(
        backgroundColor: backgroundColor_(context),
        appBar: BaseAppBar(
          appBar: AppBar(),
          title: controller.title.value,
          isCenterTitle: false,
          isBack: true,
        ),
        body: Obx(
          () => ModalProgressHUD(
            inAsyncCall: controller.isLoading.value,
            opacity: 0,
            progressIndicator: const CustomProgressbar(),
            child: Column(children: [
              Expanded(
                child: Column(
                  children: [
                     Divider(
                      thickness: 1,
                      height: 1,
                      color: dividerColor_(context),
                    ),
                    BeforeAfterPhotosList(
                      onGridItemClick: controller.onGridItemClick,
                      filesList: controller.filesList,
                      photosType: controller.photosType,
                    ),
                    const SizedBox(
                      height: 6,
                    ),
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
