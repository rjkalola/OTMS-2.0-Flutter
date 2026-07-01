import 'package:belcka/storeman_app/storeman_inventory/controller/storeman_inventory_controller.dart';
import 'package:belcka/storeman_app/storeman_inventory/view/widgets/inventory_dashboard_widgets.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HireCardView extends StatelessWidget {
  final controller = Get.put(StoremanInventoryController());

  HireCardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final data = controller.inventoryData.value;

      return InventoryDashboardCard(
        child: Column(
          children: [
            InventoryCardHeader(
              icon: Icons.groups_outlined,
              color: inventoryGreen,
              title: 'hire'.tr,
              onViewAll: () =>
                  controller.onHireItemClick(AppConstants.type.request),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                InventoryInlineStat(
                  label: 'request'.tr,
                  value: (data.hireRequested ?? 0).toString(),
                  color: inventoryBlue,
                  onTap: () =>
                      controller.onHireItemClick(AppConstants.type.request),
                ),
                const InventoryVerticalDivider(),
                InventoryInlineStat(
                  label: 'hired'.tr,
                  value: (data.hireHired ?? 0).toString(),
                  color: inventoryGreen,
                  onTap: () =>
                      controller.onHireItemClick(AppConstants.type.hired),
                ),
                const InventoryVerticalDivider(),
                InventoryInlineStat(
                  label: 'available'.tr,
                  value: (data.hireAvailable ?? 0).toString(),
                  color: inventoryOrange,
                  onTap: () =>
                      controller.onHireItemClick(AppConstants.type.available),
                ),
                const InventoryVerticalDivider(),
                InventoryInlineStat(
                  label: 'servicing'.tr,
                  value: (data.hireServiced ?? 0).toString(),
                  color: inventoryPurple,
                  onTap: () =>
                      controller.onHireItemClick(AppConstants.type.servicing),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
