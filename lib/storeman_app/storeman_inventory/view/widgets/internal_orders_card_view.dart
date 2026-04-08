import 'package:belcka/storeman_app/storeman_inventory/controller/storeman_inventory_controller.dart';
import 'package:belcka/buyer_app/purchasing/view/widgets/purchasing_screen_item_text_widget.dart';
import 'package:belcka/buyer_app/purchasing/view/widgets/purchasing_screen_item_value_widget.dart';
import 'package:belcka/buyer_app/purchasing/view/widgets/purchasing_screen_title_text_widget.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InternalOrdersCardView extends StatelessWidget {
  final controller = Get.put(StoremanInventoryController());

  InternalOrdersCardView({super.key});

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
                PurchasingScreenTitleWidget(title: 'internal_orders'.tr),
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
                            controller.onInternalOrdersItemClick(
                                AppConstants.type.newType);
                          },
                          child: Container(
                            alignment: Alignment.topLeft,
                            child: Column(
                              children: [
                                PurchasingScreenItemTextWidget(
                                  text: 'new'.tr,
                                ),
                                SizedBox(
                                  height: 2,
                                ),
                                PurchasingScreenItemValueWidget(
                                    value: (controller.inventoryData.value
                                                .internalNew ??
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
                            controller.onInternalOrdersItemClick(
                                AppConstants.type.preparing);
                          },
                          child: Container(
                            alignment: Alignment.topCenter,
                            child: Column(
                              children: [
                                PurchasingScreenItemTextWidget(
                                  text: 'preparing'.tr,
                                ),
                                SizedBox(
                                  height: 2,
                                ),
                                PurchasingScreenItemValueWidget(
                                    value: (controller.inventoryData.value
                                                .internalPreparing ??
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
                            controller.onInternalOrdersItemClick(
                                AppConstants.type.ready);
                          },
                          child: Container(
                            alignment: Alignment.topCenter,
                            child: Column(
                              children: [
                                PurchasingScreenItemTextWidget(
                                  text: 'ready'.tr,
                                ),
                                SizedBox(
                                  height: 2,
                                ),
                                PurchasingScreenItemValueWidget(
                                    value: (controller.inventoryData.value
                                                .internalReady ??
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
                            controller.onInternalOrdersItemClick(
                                AppConstants.type.collect);
                          },
                          child: Container(
                            alignment: Alignment.topRight,
                            child: Column(
                              children: [
                                PurchasingScreenItemTextWidget(
                                  text: 'completed'.tr,
                                ),
                                SizedBox(
                                  height: 2,
                                ),
                                PurchasingScreenItemValueWidget(
                                    value: ((controller.inventoryData.value
                                                    .internalCollect ??
                                                0) +
                                            (controller.inventoryData.value
                                                    .delivered ??
                                                0))
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
