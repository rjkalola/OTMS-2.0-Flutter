import 'package:belcka/storeman_app/storeman_inventory/controller/storeman_inventory_controller.dart';
import 'package:belcka/storeman_app/storeman_inventory/view/widgets/inventory_dashboard_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ManageStockView extends StatelessWidget {
  final controller = Get.put(StoremanInventoryController());

  ManageStockView({super.key});

  @override
  Widget build(BuildContext context) {
    return InventoryDashboardCard(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: InkWell(
        onTap: controller.onManageStockItemClick,
        borderRadius: BorderRadius.circular(14),
        child: Row(
          children: [
            const InventoryIconBadge(
              icon: Icons.inventory_2_outlined,
              color: inventoryBlue,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'manage_stock'.tr,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: inventoryTextPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'view_and_manage_all_stock_items'.tr,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: inventoryTextSecondary,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: inventoryBlue.withOpacity(0.08),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.chevron_right_rounded,
                color: inventoryBlue,
                size: 28,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
