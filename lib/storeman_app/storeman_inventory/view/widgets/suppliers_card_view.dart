import 'package:belcka/storeman_app/storeman_inventory/controller/storeman_inventory_controller.dart';
import 'package:belcka/storeman_app/storeman_inventory/view/widgets/inventory_dashboard_widgets.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SuppliersCardView extends StatelessWidget {
  final controller = Get.put(StoremanInventoryController());

  SuppliersCardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final data = controller.inventoryData.value;
      final processing =
          (data.processing ?? 0) + (data.supplierPartiallyDelivered ?? 0);

      return InventoryDashboardCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            InventoryCardHeader(
              icon: Icons.local_shipping_outlined,
              color: inventoryBlue,
              title: 'suppliers'.tr,
              onViewAll: () => controller.onSupplierOrdersItemClick(
                AppConstants.type.upComing,
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                InventoryStatusTile(
                  label: 'upcoming'.tr,
                  value: (data.upcoming ?? 0).toString(),
                  color: inventoryBlue,
                  icon: Icons.calendar_today_outlined,
                  onTap: () => controller.onSupplierOrdersItemClick(
                    AppConstants.type.upComing,
                  ),
                ),
                const SizedBox(width: 10),
                InventoryStatusTile(
                  label: 'processing'.tr,
                  value: processing.toString(),
                  color: inventoryOrange,
                  icon: Icons.sync_rounded,
                  onTap: () => controller.onSupplierOrdersItemClick(
                    AppConstants.type.processing,
                  ),
                ),
                const SizedBox(width: 10),
                InventoryStatusTile(
                  label: 'in_stock'.tr,
                  value: (data.onStock ?? 0).toString(),
                  color: inventoryGreen,
                  icon: Icons.inventory_2_outlined,
                  onTap: () => controller.onSupplierOrdersItemClick(
                    AppConstants.type.onStock,
                  ),
                ),
                const SizedBox(width: 10),
                InventoryStatusTile(
                  label: 'cancelled'.tr,
                  value: (data.supplierCancelled ?? 0).toString(),
                  color: inventoryRed,
                  icon: Icons.cancel_outlined,
                  onTap: () => controller.onSupplierOrdersItemClick(
                    AppConstants.type.cancelled,
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
