import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/check_in/clock_in/view/widgets/timesheet_button.dart';
import 'package:otm_inventory/res/drawable.dart';

class FooterButtonsViewStartWork extends StatelessWidget {
  const FooterButtonsViewStartWork({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
      child: Row(
        children: [
          TimesheetButton(
            title: 'timesheet'.tr,
            imageAssetsPath: Drawable.timesheetClockInScreenIcon,
            imageWidth: 36,
            imageHeight: 36,
          ),
          TimesheetButton(
            title: 'requests'.tr,
            imageAssetsPath: Drawable.myRequestClockInScreenIcon,
            imageWidth: 26,
            imageHeight: 26,
          ),
          TimesheetButton(
            title: 'team'.tr,
            imageAssetsPath: Drawable.teamClockInScreenIcon,
            imageWidth: 28,
            imageHeight: 28,
          ),
        ],
      ),
    );
  }
}
