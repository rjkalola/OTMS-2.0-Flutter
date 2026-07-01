import 'package:belcka/storeman_app/storeman_inventory/controller/storeman_inventory_controller.dart';
import 'package:belcka/storeman_app/storeman_inventory/view/widgets/inventory_dashboard_widgets.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InternalOrdersCardView extends StatelessWidget {
  final controller = Get.put(StoremanInventoryController());

  InternalOrdersCardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final data = controller.inventoryData.value;
      final completed = (data.internalCollect ?? 0) + (data.delivered ?? 0);

      return InventoryDashboardCard(
        child: Column(
          children: [
            InventoryCardHeader(
              icon: Icons.assignment_outlined,
              color: inventoryPurple,
              title: 'internal_orders'.tr,
              onViewAll: () => controller.onInternalOrdersItemClick(
                AppConstants.type.newType,
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                InventoryInlineStat(
                  label: 'new'.tr,
                  value: (data.internalNew ?? 0).toString(),
                  color: inventoryBlue,
                  onTap: () => controller.onInternalOrdersItemClick(
                    AppConstants.type.newType,
                  ),
                ),
                const InventoryVerticalDivider(),
                InventoryInlineStat(
                  label: 'preparing'.tr,
                  value: (data.internalPreparing ?? 0).toString(),
                  color: inventoryOrange,
                  onTap: () => controller.onInternalOrdersItemClick(
                    AppConstants.type.preparing,
                  ),
                ),
                const InventoryVerticalDivider(),
                InventoryInlineStat(
                  label: 'ready'.tr,
                  value: (data.internalReady ?? 0).toString(),
                  color: inventoryGreen,
                  onTap: () => controller.onInternalOrdersItemClick(
                    AppConstants.type.ready,
                  ),
                ),
                const InventoryVerticalDivider(),
                InventoryInlineStat(
                  label: 'completed'.tr,
                  value: completed.toString(),
                  color: inventoryPurple,
                  onTap: () => controller.onInternalOrdersItemClick(
                    AppConstants.type.collect,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
