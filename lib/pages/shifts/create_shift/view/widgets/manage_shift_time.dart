import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/shifts/create_shift/controller/create_shift_controller.dart';
import 'package:otm_inventory/pages/shifts/create_shift/view/widgets/add_another_break_button.dart';
import 'package:otm_inventory/pages/shifts/create_shift/view/widgets/break_title_text.dart';
import 'package:otm_inventory/pages/shifts/create_shift/view/widgets/breaks_list_view.dart';
import 'package:otm_inventory/pages/shifts/create_shift/view/widgets/select_shift_time_row.dart';
import 'package:otm_inventory/utils/app_constants.dart';
import 'package:otm_inventory/utils/date_utils.dart';
import 'package:otm_inventory/widgets/cardview/card_view_dashboard_item.dart';

class ManageShiftTime extends StatelessWidget {
  ManageShiftTime({super.key});

  final controller = Get.put(CreateShiftController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => CardViewDashboardItem(
          margin: EdgeInsets.fromLTRB(12, 10, 12, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(
                height: 10,
              ),
              SelectShiftTimeRow(
                title: 'start_shift'.tr,
                value: controller.shiftInfo.value.startTime ?? "",
                onTap: () {
                  controller.showTimePickerDialog(
                      AppConstants.dialogIdentifier.selectShiftStartTime,
                      DateUtil.getDateTimeFromHHMM(
                          controller.shiftInfo.value.startTime));
                  // DateUtil.showIosTimePickerDialog();
                },
              ),
              SelectShiftTimeRow(
                title: 'end_shift'.tr,
                value: controller.shiftInfo.value.endTime ?? "",
                onTap: () {
                  controller.showTimePickerDialog(
                      AppConstants.dialogIdentifier.selectShiftEndTime,
                      DateUtil.getDateTimeFromHHMM(
                          controller.shiftInfo.value.endTime));
                },
              ),
              SizedBox(
                height: 10,
              ),
              divider_(),
              BreakTitleText(),
              Visibility(
                  visible: controller.breaksList.isNotEmpty, child: divider_()),
              BreaksListView(),
              Visibility(
                  visible: controller.breaksList.isNotEmpty &&
                      controller.breaksList.length < 5,
                  child: divider_()),
              Visibility(
                visible: controller.breaksList.isNotEmpty &&
                    controller.breaksList.length < 5,
                child: SizedBox(
                  height: 8,
                ),
              ),
              AddAnotherBreakButton(),
              SizedBox(
                height: 8,
              ),
            ],
          )),
    );
  }

  Widget divider_() => Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Divider(
          height: 0,
        ),
      );
}
