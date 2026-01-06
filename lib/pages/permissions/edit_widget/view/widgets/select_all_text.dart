import 'package:belcka/pages/permissions/edit_widget/controller/edit_widget_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/text/PrimaryTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelectAllText extends StatelessWidget {
  SelectAllText({super.key});

  final controller = Get.put(EditWidgetController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Visibility(
        visible: controller.userPermissionList.isNotEmpty,
        child: GestureDetector(
          onTap: () {
            if (controller.isCheckAll.value) {
              controller.unCheckAll();
            } else {
              controller.checkAll();
            }
          },
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, 8, 18, 4),
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
