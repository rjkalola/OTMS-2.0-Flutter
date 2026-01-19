import 'package:belcka/pages/check_in/check_out/controller/check_out_controller.dart';
import 'package:belcka/pages/check_in/check_out/view/widgets/check_in_out_display_note_widget.dart';
import 'package:belcka/pages/check_in/check_out/view/widgets/selected_type_of_work.dart';
import 'package:belcka/pages/check_in/check_out/view/widgets/total_check_out_amount_row.dart';
import 'package:belcka/pages/check_in/check_out/view/widgets/total_check_out_hours_row.dart';
import 'package:belcka/pages/check_in/widgets/start_stop_time_box.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/widgets/CustomProgressbar.dart';
import 'package:belcka/widgets/PrimaryButton.dart';
import 'package:belcka/widgets/appbar/base_appbar.dart';
import 'package:belcka/widgets/map_view/custom_map_view.dart';
import 'package:belcka/widgets/textfield/reusable/add_note_widget.dart';
import 'package:belcka/widgets/textfield/reusable/drop_down_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

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
                            controller.isPriceWork.value
                                ? TotalCheckOutAmountRow()
                                : TotalCheckOutHoursRow(),
                            Visibility(
                              visible: controller.isPriceWork.value
                                  ? !StringHelper.isEmptyString(controller
                                      .checkLogInfo.value.checkoutDateTime)
                                  : true,
                              child: SizedBox(
                                height: 18,
                              ),
                            ),
                            DropDownTextField(
                              title: 'address'.tr,
                              controller: controller.addressController,
                              borderRadius: 15,
                              // isArrowHide: !StringHelper.isEmptyString(
                              //     controller
                              //         .checkLogInfo.value.checkoutDateTime),
                              isArrowHide: true,
                              onPressed: () {
                                // controller.showSelectAddressDialog();
                              },
                            ),
                            SizedBox(
                              height: 18,
                            ),
                            DropDownTextField(
                              title: 'trade'.tr,
                              controller: controller.tradeController,
                              borderRadius: 15,
                              // isArrowHide: !StringHelper.isEmptyString(
                              //     controller
                              //         .checkLogInfo.value.checkoutDateTime),
                              isArrowHide: true,
                              onPressed: () {
                                // controller.showSelectTradeDialog();
                              },
                            ),
                            SizedBox(
                              height: 18,
                            ),
                            DropDownTextField(
                              title: 'type_of_work'.tr,
                              controller: controller.typeOfWorkController,
                              borderRadius: 15,
                              // isArrowHide: !StringHelper.isEmptyString(
                              //     controller
                              //         .checkLogInfo.value.checkoutDateTime),
                              isArrowHide: true,
                              onPressed: () {
                                // controller.showSelectTypeOfWorkDialog();
                              },
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            SelectedTypeOfWork(),
                            // DropDownTextField(
                            //   title: 'location'.tr,
                            //   controller: controller.locationController,
                            //   borderRadius: 15,
                            //   isArrowHide: true,
                            //   onPressed: () {},
                            // ),
                            // SizedBox(
                            //   height: 16,
                            // ),
                            // ProgressView(),
                            // SizedBox(
                            //   height: 10,
                            // ),
                            /* Row(
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
                            ),*/
                            Visibility(
                              visible: StringHelper.isEmptyString(controller
                                  .checkLogInfo.value.checkoutDateTime),
                              child: AddNoteWidget(
                                controller: controller.noteController,
                                borderRadius: 15,
                              ),
                            ),
                            CheckInOutDisplayNoteWidget(
                              note: controller.checkLogInfo.value.checkInNote,
                              labelText: 'check_in_note'.tr,
                            ),
                            CheckInOutDisplayNoteWidget(
                              note: controller.checkLogInfo.value.checkOutNote,
                              labelText: 'check_out_note'.tr,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              height: 200,
                              child: CustomMapView(
                                onMapCreated: controller.onMapCreated,
                                target: controller.center,
                                markers: controller.markers,
                                circles: controller.circles,
                              ),
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
                          // if (controller.isValidPhotos()) {
                          //   controller.checkOutApi();
                          // } else {
                          //   AppUtils.showToastMessage(
                          //       'msg_empty_after_attachment'.tr);
                          // }
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
