import 'package:belcka/pages/payment_documents/payment_documents/controller/payment_documents_controller.dart';
import 'package:belcka/pages/timesheet/timesheet_list/controller/timesheet_list_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/text/PrimaryTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelectAllDocuments extends StatelessWidget {
  SelectAllDocuments({super.key});

  final controller = Get.put(PaymentDocumentsController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Visibility(
        visible: controller.isDownloadEnable.value ||
            controller.isDeleteEnable.value,
        child: GestureDetector(
          onTap: () {
            if (controller.isCheckAll.value) {
              controller.unCheckAll();
            } else {
              controller.checkAll();
            }
          },
          child: Padding(
            padding: EdgeInsets.only(right: 18, top: 6),
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
