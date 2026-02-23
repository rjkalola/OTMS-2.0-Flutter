import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/date_utils.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/other_widgets/right_arrow_widget.dart';
import 'package:belcka/widgets/text/PrimaryTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart' show Inst;

import '../../controller/stop_shift_controller.dart';

class CurrentHourTime extends StatelessWidget {
   CurrentHourTime({super.key});
  final controller = Get.put(StopShiftController());

  @override
  Widget build(BuildContext context) {
    return CardViewDashboardItem(
        borderRadius: 10,
        padding: EdgeInsets.fromLTRB(10, 6, 10, 6),
        child: Column(
          // mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Visibility(
                visible: (controller.workLogInfo.value.requestStatus ?? 0) ==
                    AppConstants.status.pending,
                child: PrimaryTextView(
                  textAlign: TextAlign.start,
                  text: DateUtil.seconds_To_HH_MM(
                      controller.workLogInfo.value.oldPayableWorkSeconds ?? 0),
                  color: primaryTextColor_(context),
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                )),
            Visibility(
                visible: (controller.workLogInfo.value.requestStatus ?? 0) ==
                    AppConstants.status.pending,
                child: Icon(
                  Icons.keyboard_arrow_down_outlined,
                  size: 26,
                  color: Colors.grey,
                )),
            PrimaryTextView(
              textAlign: TextAlign.start,
              text: !controller.isEdited.value
                  ? (!StringHelper.isEmptyString(
                          controller.workLogInfo.value.workEndTime))
                      ? DateUtil.seconds_To_HH_MM(
                          controller.initialTotalWorkTime.value)
                      : "Working"
                  : DateUtil.seconds_To_HH_MM(
                      controller.updatedTotalWorkingTime.value),
              color: getColor(context),
              fontSize: 15,
              fontWeight: FontWeight.w500,
            )
          ],
        ));
  }

  Color getColor(BuildContext context) {
    Color color = primaryTextColor_(context);
    if (controller.isEdited.value) {
      color = Colors.red;
    } else {
      if (!StringHelper.isEmptyString(
          controller.workLogInfo.value.workEndTime)) {
        color = AppUtils.getStatusColor(
            controller.workLogInfo.value.requestStatus ?? 0);
      } else {
        color = defaultAccentColor_(context);
      }
    }
    return color;
  }
}
