import 'package:belcka/storeman_app/storeman_hire_products/controller/storeman_hire_product_controller.dart';
import 'package:belcka/utils/enums/hire_product_status.dart';
import 'package:belcka/widgets/other_widgets/header_filter_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StoremanHireProductTabs extends StatelessWidget {
  StoremanHireProductTabs({super.key});

  final controller = Get.find<StoremanHireProductController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              HeaderFilterItem(
                title: 'request'.tr,
                selected: (controller.selectedTab.value == HireProductStatus.request),
                count: controller.requestCount.value,
                flex: 1,
                onTap: () {
                  controller.selectedTab.value = HireProductStatus.request;
                  controller.loadData();
                },
              ),
              const SizedBox(width: 4),
              HeaderFilterItem(
                title: 'hired'.tr,
                selected: (controller.selectedTab.value == HireProductStatus.hired),
                count: controller.hiredCount.value,
                flex: 1,
                onTap: () {
                  controller.selectedTab.value = HireProductStatus.hired;
                  controller.loadData();
                },
              ),
              const SizedBox(width: 4),
              HeaderFilterItem(
                title: 'available'.tr,
                selected: (controller.selectedTab.value == HireProductStatus.available),
                count: controller.availableCount.value,
                flex: 1,
                onTap: () {
                  controller.selectedTab.value = HireProductStatus.available;
                  controller.loadData();
                },
              ),
              const SizedBox(width: 4),
              HeaderFilterItem(
                title: 'service'.tr,
                selected: (controller.selectedTab.value == HireProductStatus.service),
                count: controller.serviceCount.value,
                flex: 1,
                onTap: () {
                  controller.selectedTab.value = HireProductStatus.service;
                  controller.loadData();
                },
              ),
            ],
          ),
        ));
  }
}
