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
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark));
    return Container(
      color: backgroundColor,
      child: SafeArea(
          child: Scaffold(
        backgroundColor: backgroundColor,
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
                    const Divider(
                      thickness: 1,
                      height: 1,
                      color: dividerColor,
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
