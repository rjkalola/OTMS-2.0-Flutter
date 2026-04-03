import 'package:belcka/storeman_app/storeman_inventory/controller/storeman_inventory_controller.dart';
import 'package:belcka/buyer_app/purchasing/view/widgets/purchasing_screen_item_text_widget.dart';
import 'package:belcka/buyer_app/purchasing/view/widgets/purchasing_screen_item_value_widget.dart';
import 'package:belcka/buyer_app/purchasing/view/widgets/purchasing_screen_title_text_widget.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SuppliersCardView extends StatelessWidget {
  final controller = Get.put(StoremanInventoryController());

  SuppliersCardView({super.key});

  Widget _statCell({
    required VoidCallback onTap,
    required String label,
    required String value,
    required Alignment alignment,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Align(
        alignment: alignment,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            PurchasingScreenItemTextWidget(text: label),
            const SizedBox(height: 2),
            PurchasingScreenItemValueWidget(value: value),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SizedBox(
        width: double.infinity,
        child: CardViewDashboardItem(
            padding: EdgeInsets.fromLTRB(16, 12, 16, 12),
            margin: EdgeInsets.fromLTRB(14, 8, 14, 8),
            borderRadius: controller.cardRadius,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PurchasingScreenTitleWidget(title: 'suppliers'.tr),
                const SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _statCell(
                        onTap: () => controller.onSupplierOrdersItemClick(
                            AppConstants.type.upComing),
                        label: 'upcoming'.tr,
                        value: (controller.inventoryData.value.upcoming ?? 0)
                            .toString(),
                        alignment: Alignment.topLeft,
                      ),
                    ),
                    Expanded(
                      child: _statCell(
                        onTap: () => controller.onSupplierOrdersItemClick(
                            AppConstants.type.processing),
                        label: 'processing'.tr,
                        value: ((controller.inventoryData.value.processing ??
                                    0) +
                                (controller.inventoryData.value
                                        .supplierPartiallyDelivered ??
                                    0))
                            .toString(),
                        alignment: Alignment.topCenter,
                      ),
                    ),
                    Expanded(
                      child: _statCell(
                        onTap: () => controller.onSupplierOrdersItemClick(
                            AppConstants.type.onStock),
                        label: 'in_stock'.tr,
                        value: (controller.inventoryData.value.onStock ?? 0)
                            .toString(),
                        alignment: Alignment.topCenter,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _statCell(
                        onTap: () => controller.onSupplierOrdersItemClick(
                            AppConstants.type.cancelled),
                        label: 'cancelled'.tr,
                        value: (controller.inventoryData.value
                                    .supplierCancelled ??
                                0)
                            .toString(),
                        alignment: Alignment.topLeft,
                      ),
                    ),
                    const Expanded(child: SizedBox()),
                    const Expanded(child: SizedBox()),
                  ],
                ),
              ], 
            )),
      ),
    );
  }
}
