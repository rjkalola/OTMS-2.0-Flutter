import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:belcka/pages/shifts/create_shift/controller/create_shift_controller.dart';
import 'package:belcka/pages/shifts/create_shift/model/week_day_info.dart';
import 'package:belcka/pages/shifts/create_shift/view/widgets/week_days_list.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/text/PrimaryTextView.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';

class ManageWeekDaysView extends StatelessWidget {
  ManageWeekDaysView({super.key});

  final controller = Get.put(CreateShiftController());

  @override
  Widget build(BuildContext context) {
    return CardViewDashboardItem(
        margin: EdgeInsets.fromLTRB(12, 10, 12, 10),
        child: Container(
          padding: EdgeInsets.fromLTRB(16, 14, 16, 6),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PrimaryTextView(
                text: 'select_days'.tr,
                color: primaryTextColor_(context),
                fontSize: 19,
                fontWeight: FontWeight.w600,
              ),
             /* SizedBox(
                height: 4,
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setEveryWeekdayStatus();
                    },
                    child: TitleTextView(
                      text: 'every_weekday'.tr,
                    ),
                  ),
                  SizedBox(width: 16),
                  GestureDetector(
                    onTap: () {
                      setWeekendStatus();
                    },
                    child: TitleTextView(
                      text: 'weekend'.tr,
                    ),
                  ),
                ],
              ),*/
              SizedBox(
                height: 14,
              ),
              WeekDaysList(),
              SizedBox(
                height: 12,
              ),
            ],
          ),
        ));
  }

  void resetWeekdaysStatus(bool status) {
    for (var info in controller.weekDaysList) {
      info.status = status;
    }
  }

  void setEveryWeekdayStatus() {
    controller.isSaveEnable.value = true;
    resetWeekdaysStatus(true);
    for (var info in controller.weekDaysList) {
      if (info.name!.toLowerCase() == 'saturday' ||
          info.name!.toLowerCase() == 'sunday') {
        info.status = false;
      }
    }
    controller.weekDaysList.refresh();
  }

  void setWeekendStatus() {
    controller.isSaveEnable.value = true;
    resetWeekdaysStatus(false);
    for (var info in controller.weekDaysList) {
      if (info.name!.toLowerCase() == 'saturday' ||
          info.name!.toLowerCase() == 'sunday') {
        info.status = true;
      }
    }
    controller.weekDaysList.refresh();
  }
}
