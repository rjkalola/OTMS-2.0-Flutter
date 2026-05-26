import 'package:belcka/pages/workshop/workshop_hired_tools/controller/workshop_hired_tools_controller.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/widgets/other_widgets/header_filter_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WorkshopHiredToolsTabs extends StatelessWidget {
  WorkshopHiredToolsTabs({super.key});

  final controller = Get.find<WorkshopHiredToolsController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            HeaderFilterItem(
              title: 'hired'.tr,
              selected: controller.selectedStatus.value ==
                  AppConstants.hireStatus.hired,
              onTap: controller.selectHiredTab,
            ),
            const SizedBox(width: 12),
            HeaderFilterItem(
              title: 'requested'.tr,
              selected: controller.selectedStatus.value ==
                  AppConstants.hireStatus.request,
              onTap: controller.selectRequestedTab,
            ),
          ],
        ),
      ),
    );
  }
}
