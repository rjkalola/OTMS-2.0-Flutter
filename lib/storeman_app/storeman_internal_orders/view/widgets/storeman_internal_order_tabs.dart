import 'package:belcka/storeman_app/storeman_internal_orders/controller/storeman_internal_order_controller.dart';
import 'package:belcka/utils/enums/internal_order_status.dart';
import 'package:belcka/widgets/other_widgets/header_filter_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StoremanInternalOrderTabs extends StatelessWidget {
  StoremanInternalOrderTabs({super.key});

  final controller = Get.find<StoremanInternalOrderController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              HeaderFilterItem(
                title: 'new'.tr,
                selected: (controller.selectedTab.value == InternalOrderStatus.newOrders),
                count: controller.newCount,
                flex: 1,
                onTap: () {
                  controller.selectedTab.value = InternalOrderStatus.newOrders;
                  controller.loadData();
                },
              ),
              const SizedBox(width: 4),
              HeaderFilterItem(
                title: 'preparing'.tr,
                selected: (controller.selectedTab.value == InternalOrderStatus.preparing),
                count: controller.preparingCount,
                flex: 1,
                onTap: () {
                  controller.selectedTab.value = InternalOrderStatus.preparing;
                  controller.loadData();
                },
              ),
              const SizedBox(width: 4),
              HeaderFilterItem(
                title: 'ready'.tr,
                selected: (controller.selectedTab.value == InternalOrderStatus.ready),
                count: controller.readyCount,
                flex: 1,
                onTap: () {
                  controller.selectedTab.value = InternalOrderStatus.ready;
                  controller.loadData();
                },
              ),
              const SizedBox(width: 4),
              HeaderFilterItem(
                title: 'collected'.tr,
                selected: (controller.selectedTab.value == InternalOrderStatus.collected),
                count: controller.collectedCount,
                flex: 1,
                onTap: () {
                  controller.selectedTab.value = InternalOrderStatus.collected;
                  controller.loadData();
                },
              ),
            ],
          ),
        ));
  }
}
