import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:otm_inventory/pages/check_in/check_in/controller/check_in_controller.dart';
import 'package:otm_inventory/pages/check_in/check_out/controller/check_out_controller.dart';
import 'package:otm_inventory/pages/check_in/check_out/view/widgets/total_check_out_hours_row.dart';
import 'package:otm_inventory/pages/check_in/widgets/photos_count_view.dart';
import 'package:otm_inventory/pages/check_in/widgets/start_stop_time_box.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/utils/app_constants.dart';
import 'package:otm_inventory/utils/app_utils.dart';
import 'package:otm_inventory/utils/string_helper.dart';
import 'package:otm_inventory/widgets/CustomProgressbar.dart';
import 'package:otm_inventory/widgets/PrimaryButton.dart';
import 'package:otm_inventory/widgets/appbar/base_appbar.dart';
import 'package:otm_inventory/widgets/map_view/bottom_curve_container.dart';
import 'package:otm_inventory/widgets/map_view/custom_map_view.dart';
import 'package:otm_inventory/widgets/map_view/map_back_arrow.dart';
import 'package:otm_inventory/widgets/textfield/reusable/add_note_widget.dart';
import 'package:otm_inventory/widgets/textfield/reusable/drop_down_text_field.dart';

class CheckOutScreen extends StatefulWidget {
  const CheckOutScreen({super.key});

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  final controller = Get.put(CheckOutController());

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
          title: 'check_out_'.tr,
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
                        padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
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
                                    isEditVisible: false.obs),
                                SizedBox(
                                  width: 8,
                                ),
                                StartStopTimeBox(
                                    title: 'check_out_'.tr,
                                    time: controller.checkOutTime,
                                    address: "",
                                    isEditVisible: false.obs)
                              ],
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            TotalCheckOutHoursRow(),
                            SizedBox(
                              height: 18,
                            ),
                            DropDownTextField(
                              title: 'address'.tr,
                              controller: controller.addressController,
                              borderRadius: 15,
                              isArrowHide: !StringHelper.isEmptyString(controller.checkLogInfo.value.checkoutDateTime),
                              onPressed: () {
                                controller.showSelectAddressDialog();
                              },
                            ),
                            SizedBox(
                              height: 18,
                            ),
                            DropDownTextField(
                              title: 'trade'.tr,
                              controller: controller.tradeController,
                              borderRadius: 15,
                              isArrowHide: !StringHelper.isEmptyString(controller.checkLogInfo.value.checkoutDateTime),
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
                              isArrowHide: !StringHelper.isEmptyString(controller.checkLogInfo.value.checkoutDateTime),
                              onPressed: () {
                                controller.showSelectTypeOfWorkDialog();
                              },
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                PhotosCountView(
                                  title: 'photos_before'.tr,
                                  count: controller.listBeforePhotos.length,
                                  photosType: AppConstants.type.beforePhotos,
                                  onPressed: () {
                                    // if (StringHelper.isEmptyString(controller
                                    //     .checkLogInfo.value.checkoutDateTime)) {
                                    controller.onSelectPhotos(
                                        AppConstants.type.beforePhotos,
                                        controller.listBeforePhotos);
                                    // }
                                  },
                                ),
                                PhotosCountView(
                                  title: 'photos_after'.tr,
                                  count: controller.listAfterPhotos.length,
                                  photosType: AppConstants.type.afterPhotos,
                                  onPressed: () {
                                    // if (StringHelper.isEmptyString(controller
                                    //     .checkLogInfo.value.checkoutDateTime)) {
                                    controller.onSelectPhotos(
                                        AppConstants.type.afterPhotos,
                                        controller.listAfterPhotos);
                                    // }
                                  },
                                )
                              ],
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            Visibility(
                              visible: StringHelper.isEmptyString(controller
                                  .checkLogInfo.value.checkoutDateTime),
                              child: AddNoteWidget(
                                controller: controller.noteController,
                                borderRadius: 15,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: StringHelper.isEmptyString(
                        controller.checkLogInfo.value.checkoutDateTime),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: PrimaryButton(
                        buttonText: 'check_out_'.tr,
                        onPressed: () {
                          controller.checkOutApi();
                        },
                        color: Colors.red,
                      ),
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
