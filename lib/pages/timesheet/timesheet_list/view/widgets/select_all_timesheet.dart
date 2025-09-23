import 'package:belcka/pages/timesheet/timesheet_list/controller/timesheet_list_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/text/PrimaryTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelectAllTimesheet extends StatelessWidget {
  SelectAllTimesheet({super.key});

  final controller = Get.put(TimeSheetListController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Visibility(
        visible: controller.isEditEnable.value ||
            controller.isEditStatusEnable.value,
        child: GestureDetector(
          onTap: () {
            if (controller.isCheckAll.value) {
              controller.unCheckAll();
            } else {
              controller.checkAll();
            }
          },
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 18, 10),
            child: Align(
              alignment: Alignment.topRight,
              child: PrimaryTextView(
                text: controller.isCheckAll.value
                    ? 'unselect_all'.tr
                    : 'select_all'.tr,
                fontSize: 17,
                color: defaultAccentColor_(context),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
