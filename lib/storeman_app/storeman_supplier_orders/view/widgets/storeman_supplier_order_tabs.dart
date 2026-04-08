import 'package:belcka/storeman_app/storeman_supplier_orders/controller/storeman_supplier_order_controller.dart';
import 'package:belcka/utils/enums/supplier_order_status.dart';
import 'package:belcka/widgets/other_widgets/header_filter_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StoremanSupplierOrderTabs extends StatelessWidget {
  StoremanSupplierOrderTabs({super.key});

  final controller = Get.find<StoremanSupplierOrderController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
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
                  title: 'all'.tr,
                  selected: (controller.selectedTab.value ==
                      SupplierOrderStatus.all),
                  count: controller.allCount,
                  useFlexible: false,
                  onTap: () {
                    controller.selectedTab.value = SupplierOrderStatus.all;
                    controller.loadData();
                  },
                ),
                const SizedBox(width: 6),
                HeaderFilterItem(
                  title: 'upcoming'.tr,
                  selected: (controller.selectedTab.value ==
                      SupplierOrderStatus.upcoming),
                  count: controller.upcomingCount,
                  useFlexible: false,
                  onTap: () {
                    controller.selectedTab.value =
                        SupplierOrderStatus.upcoming;
                    controller.loadData();
                  },
                ),
                const SizedBox(width: 6),
                HeaderFilterItem(
                  title: 'processing'.tr,
                  selected: (controller.selectedTab.value ==
                      SupplierOrderStatus.processing),
                  count: controller.processingCount,
                  useFlexible: false,
                  onTap: () {
                    controller.selectedTab.value =
                        SupplierOrderStatus.processing;
                    controller.loadData();
                  },
                ),
                const SizedBox(width: 6),
                HeaderFilterItem(
                  title: 'in_stock'.tr,
                  selected: (controller.selectedTab.value ==
                      SupplierOrderStatus.onStock),
                  count: controller.onStockCount,
                  useFlexible: false,
                  onTap: () {
                    controller.selectedTab.value = SupplierOrderStatus.onStock;
                    controller.loadData();
                  },
                ),
                const SizedBox(width: 6),
                HeaderFilterItem(
                  title: 'cancelled'.tr,
                  selected: (controller.selectedTab.value ==
                      SupplierOrderStatus.cancelled),
                  count: controller.cancelledCount,
                  useFlexible: false,
                  onTap: () {
                    controller.selectedTab.value =
                        SupplierOrderStatus.cancelled;
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
