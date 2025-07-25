import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:otm_inventory/pages/check_in/check_in/controller/check_in_controller.dart';
import 'package:otm_inventory/pages/check_in/widgets/photos_count_view.dart';
import 'package:otm_inventory/pages/check_in/widgets/start_stop_time_box.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/utils/app_constants.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/widgets/CustomProgressbar.dart';
import 'package:otm_inventory/widgets/PrimaryButton.dart';
import 'package:otm_inventory/widgets/appbar/base_appbar.dart';
import 'package:otm_inventory/widgets/map_view/bottom_curve_container.dart';
import 'package:otm_inventory/widgets/map_view/custom_map_view.dart';
import 'package:otm_inventory/widgets/map_view/map_back_arrow.dart';
import 'package:otm_inventory/widgets/textfield/reusable/add_note_widget.dart';
import 'package:otm_inventory/widgets/textfield/reusable/drop_down_text_field.dart';

class CheckInScreen extends StatefulWidget {
  const CheckInScreen({super.key});

  @override
  State<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends State<CheckInScreen> {
  final controller = Get.put(CheckInController());

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
          title: 'check_in_'.tr,
          isCenterTitle: false,
          isBack: true,
          bgColor: dashBoardBgColor_(context),
          // widgets: actionButtons()
        ),
        body: Obx(
          () => ModalProgressHUD(
            inAsyncCall: controller.isLoading.value,
            opacity: 0,
            progressIndicator: const CustomProgressbar(),
            child: Visibility(
              visible: controller.isMainViewVisible.value,
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                        child: Column(
                          children: [
                            // SelectionScreenHeaderView(
                            //   title: 'check_in_'.tr,
                            //   onBackPressed: () {
                            //     Get.back();
                            //   },
                            // ),
                            Row(
                              children: [
                                StartStopTimeBox(
                                    title: 'check_in_'.tr,
                                    time: controller.checkInTime,
                                    address: "",
                                    isEditVisible: false.obs)
                              ],
                            ),
                            SizedBox(
                              height: 22,
                            ),
                            DropDownTextField(
                              title: 'select_address'.tr,
                              controller: controller.addressController,
                              borderRadius: 15,
                              onPressed: () {
                                controller.showSelectAddressDialog();
                              },
                            ),
                            SizedBox(
                              height: 18,
                            ),
                            DropDownTextField(
                              title: 'select_trade'.tr,
                              controller: controller.tradeController,
                              borderRadius: 15,
                              onPressed: () {
                                controller.showSelectTradeDialog();
                              },
                            ),
                            SizedBox(
                              height: 18,
                            ),
                            DropDownTextField(
                              title: 'type_of_work'.tr,
                              controller: controller.typeOfWorkController,
                              borderRadius: 15,
                              onPressed: () {
                                controller.showSelectTypeOfWorkDialog();
                              },
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            PhotosCountView(
                              title: 'photos_before'.tr,
                              count: controller.listBeforePhotos.length,
                              photosType: AppConstants.type.beforePhotos,
                              onPressed: () {
                                controller.onSelectPhotos(
                                    AppConstants.type.beforePhotos,
                                    controller.listBeforePhotos);
                              },
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            AddNoteWidget(
                              controller: controller.noteController,
                              borderRadius: 15,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: PrimaryButton(
                      buttonText: 'check_in_'.tr,
                      onPressed: () {
                        controller.checkInApi();
                      },
                      color: Colors.green,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      )),
    );
  }
}
