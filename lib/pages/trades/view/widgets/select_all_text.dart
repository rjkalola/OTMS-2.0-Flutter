import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:otm_inventory/pages/permissions/company_permissions/controller/company_permission_controller.dart';
import 'package:otm_inventory/pages/permissions/user_permissions/controller/user_permission_controller.dart';
import 'package:otm_inventory/pages/trades/controller/trades_controller.dart';
import 'package:otm_inventory/res/colors.dart';
import 'package:otm_inventory/widgets/text/PrimaryTextView.dart';

class SelectAllText extends StatelessWidget {
  SelectAllText({super.key});

  final controller = Get.put(TradesController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GestureDetector(
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
              color: defaultAccentColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
