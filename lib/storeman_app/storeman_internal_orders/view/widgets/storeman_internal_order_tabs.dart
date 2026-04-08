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
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: SizedBox(
            width: double.infinity,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              clipBehavior: Clip.none,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                HeaderFilterItem(
                  title: 'new'.tr,
                  useFlexible: false,
                  selected: (controller.selectedTab.value == InternalOrderStatus.newOrders),
                  count: controller.newCount,
                  flex: 1,
                  onTap: () {
                    controller.selectedTab.value = InternalOrderStatus.newOrders;
                    controller.loadData();
                  },
                ),
                const SizedBox(width: 6),
                HeaderFilterItem(
                  title: 'preparing'.tr,
                  useFlexible: false,
                  selected: (controller.selectedTab.value == InternalOrderStatus.preparing),
                  count: controller.preparingCount,
                  flex: 1,
                  onTap: () {
                    controller.selectedTab.value = InternalOrderStatus.preparing;
                    controller.loadData();
                  },
                ),
                const SizedBox(width: 6),
                HeaderFilterItem(
                  title: 'ready'.tr,
                  useFlexible: false,
                  selected: (controller.selectedTab.value == InternalOrderStatus.ready),
                  count: controller.readyCount,
                  flex: 1,
                  onTap: () {
                    controller.selectedTab.value = InternalOrderStatus.ready;
                    controller.loadData();
                  },
                ),
                const SizedBox(width: 6),
                HeaderFilterItem(
                  title: 'completed'.tr,
                  useFlexible: false,
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
            ),
          ),
        ));
  }
}
