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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PurchasingScreenTitleWidget(title: 'suppliers'.tr),
                SizedBox(
                  height: 6,
                ),
                Row(
                  children: [
                    Flexible(
                        flex: 1,
                        fit: FlexFit.tight,
                        child: GestureDetector(
                          onTap: () {
                            controller.onSupplierOrdersItemClick(
                                AppConstants.type.upComing);
                          },
                          child: Container(
                            alignment: Alignment.topLeft,
                            child: Column(
                              children: [
                                PurchasingScreenItemTextWidget(
                                  text: 'upcoming'.tr,
                                ),
                                SizedBox(
                                  height: 2,
                                ),
                                PurchasingScreenItemValueWidget(
                                    value: (controller
                                                .inventoryData.value.upcoming ??
                                            0)
                                        .toString()),
                              ],
                            ),
                          ),
                        )),
                    Flexible(
                        flex: 1,
                        fit: FlexFit.tight,
                        child: GestureDetector(
                          onTap: () {
                            controller.onSupplierOrdersItemClick(
                                AppConstants.type.processing);
                          },
                          child: Container(
                            alignment: Alignment.topCenter,
                            child: Column(
                              children: [
                                PurchasingScreenItemTextWidget(
                                  text: 'processing'.tr,
                                ),
                                SizedBox(
                                  height: 2,
                                ),
                                PurchasingScreenItemValueWidget(
                                    value: ((controller.inventoryData.value
                                                    .processing ??
                                                0) +
                                            (controller.inventoryData.value
                                                    .supplierPartiallyDelivered ??
                                                0))
                                        .toString()),
                              ],
                            ),
                          ),
                        )),
                    Flexible(
                        flex: 1,
                        fit: FlexFit.tight,
                        child: GestureDetector(
                          onTap: () {
                            controller.onSupplierOrdersItemClick(
                                AppConstants.type.onStock);
                          },
                          child: Container(
                            alignment: Alignment.topCenter,
                            child: Column(
                              children: [
                                PurchasingScreenItemTextWidget(
                                  text: 'in_stock'.tr,
                                ),
                                SizedBox(
                                  height: 2,
                                ),
                                PurchasingScreenItemValueWidget(
                                    value: (controller
                                                .inventoryData.value.onStock ??
                                            0)
                                        .toString()),
                              ],
                            ),
                          ),
                        )),
                    Flexible(
                        flex: 1,
                        fit: FlexFit.tight,
                        child: GestureDetector(
                          onTap: () {
                            controller.onSupplierOrdersItemClick(
                                AppConstants.type.cancelled);
                          },
                          child: Container(
                            alignment: Alignment.topRight,
                            child: Column(
                              children: [
                                PurchasingScreenItemTextWidget(
                                  text: 'cancelled'.tr,
                                ),
                                SizedBox(
                                  height: 2,
                                ),
                                PurchasingScreenItemValueWidget(
                                    value: (controller.inventoryData.value
                                                .supplierCancelled ??
                                            0)
                                        .toString()),
                              ],
                            ),
                          ),
                        )),
                  ],
                ),
              ],
            )),
      ),
    );
  }
}
