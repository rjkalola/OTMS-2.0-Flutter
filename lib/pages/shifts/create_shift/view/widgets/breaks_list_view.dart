import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/common/model/user_info.dart';
import 'package:otm_inventory/pages/permissions/user_list/controller/user_list_controller.dart';
import 'package:otm_inventory/pages/shifts/create_shift/controller/create_shift_controller.dart';
import 'package:otm_inventory/pages/shifts/create_shift/model/break_info.dart';
import 'package:otm_inventory/pages/shifts/create_shift/view/widgets/select_shift_time_row.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/res/drawable.dart';
import 'package:otm_inventory/routes/app_routes.dart';
import 'package:otm_inventory/utils/date_utils.dart';
import 'package:otm_inventory/utils/image_utils.dart';
import 'package:otm_inventory/widgets/switch/custom_switch.dart';

import '../../../../../../utils/app_constants.dart';

class BreaksListView extends StatelessWidget {
  BreaksListView({super.key});

  final controller = Get.put(CreateShiftController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, position) {
          BreakInfo info = controller.breaksList[position];
          return Padding(
            padding: const EdgeInsets.fromLTRB(0, 9, 0, 9),
            child: Stack(
              alignment: Alignment.centerRight,
              children: [
                Container(
                  color: Colors.transparent,
                  child: Column(
                    children: [
                      SelectShiftTimeRow(
                        title: 'start_break'.tr,
                        value: info.breakStartTime ?? "",
                        onTap: () {
                          controller.selectedBreakPosition = position;
                          controller.showTimePickerDialog(
                              AppConstants
                                  .dialogIdentifier.selectBreakStartTime,
                              DateUtil.getDateTimeFromHHMM(
                                  info.breakStartTime));
                        },
                      ),
                      SelectShiftTimeRow(
                        title: 'end_break'.tr,
                        value: info.breakEndTime ?? "",
                        onTap: () {
                          controller.selectedBreakPosition = position;
                          controller.showTimePickerDialog(
                              AppConstants
                                  .dialogIdentifier.selectBreakEndTime,
                              DateUtil.getDateTimeFromHHMM(
                                  info.breakEndTime));
                        },
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if ((controller.breaksList[position].breakId ?? 0) != 0) {
                      controller.removeBreakIdsList
                          .add((controller.breaksList[position].breakId ?? 0).toString());
                    }
                    controller.isSaveEnable.value = true;
                    controller.breaksList.removeAt(position);
                    controller.breaksList.refresh();
                  },
                  child: Padding(
                    padding: EdgeInsets.only(right: 16),
                    child: ImageUtils.setSvgAssetsImage(
                        path: Drawable.deleteTeamIcon, width: 22, height: 22),
                  ),
                ),
              ],
            ),
          );
        },
        itemCount: controller.breaksList.length,
        separatorBuilder: (context, position) => const Padding(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: Divider(
                height: 0,
                color: dividerColor,
              ),
            )));
  }
}
