import 'package:belcka/buyer_app/purchasing/view/widgets/purchasing_screen_item_text_widget.dart';
import 'package:belcka/buyer_app/purchasing/view/widgets/purchasing_screen_item_value_widget.dart';
import 'package:belcka/buyer_app/purchasing/view/widgets/purchasing_screen_title_text_widget.dart';
import 'package:belcka/storeman_app/storeman_inventory/controller/storeman_inventory_controller.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HireCardView extends StatelessWidget {
  final controller = Get.put(StoremanInventoryController());

  HireCardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => SizedBox(
      width: double.infinity,
      child: CardViewDashboardItem(
          padding: EdgeInsets.fromLTRB(16, 12, 16, 12),
          margin: EdgeInsets.fromLTRB(14, 8, 14, 8),
          borderRadius: controller.cardRadius,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PurchasingScreenTitleWidget(title: 'hire'.tr),
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
                          controller.onItemClick(AppConstants.type.newType);
                        },
                        child: Container(
                          alignment: Alignment.topLeft,
                          child: Column(
                            children: [
                              PurchasingScreenItemTextWidget(
                                  text: 'new'.tr),
                              SizedBox(
                                height: 2,
                              ),
                              PurchasingScreenItemValueWidget(
                                  value:
                                  (controller.inventoryData.value.hireNew ??
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
                          controller.onItemClick(AppConstants.type.hired);
                        },
                        child: Container(
                          alignment: Alignment.topCenter,
                          child: Column(
                            children: [
                              PurchasingScreenItemTextWidget(
                                  text: 'hired'.tr),
                              SizedBox(
                                height: 2,
                              ),
                              PurchasingScreenItemValueWidget(
                                  value: (controller.inventoryData.value.hireHired ?? 0)
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
                          controller.onItemClick(AppConstants.type.proceed);
                        },
                        child: Container(
                          alignment: Alignment.topCenter,
                          child: Column(
                            children: [
                              PurchasingScreenItemTextWidget(
                                  text: 'available'.tr),
                              SizedBox(
                                height: 2,
                              ),
                              PurchasingScreenItemValueWidget(
                                  value: (controller.inventoryData.value.hireAvailable ?? 0)
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
                          controller.onItemClick(AppConstants.type.servicing);
                        },
                        child: Container(
                          alignment: Alignment.topRight,
                          child: Column(
                            children: [
                              PurchasingScreenItemTextWidget(
                                  text: 'servicing'.tr),
                              SizedBox(
                                height: 2,
                              ),
                              PurchasingScreenItemValueWidget(
                                  value: (controller.inventoryData.value.hireServicing ?? 0)
                                      .toString()),
                            ],
                          ),
                        ),
                      )),
                ],
              ),
            ],
          )),
    ));
  }
}



