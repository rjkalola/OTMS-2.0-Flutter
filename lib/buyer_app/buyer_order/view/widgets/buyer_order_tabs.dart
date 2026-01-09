import 'package:belcka/buyer_app/buyer_order/controller/buyer_order_controller.dart';
import 'package:belcka/widgets/other_widgets/header_filter_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BuyerOrderTabs extends StatelessWidget {
  BuyerOrderTabs({super.key});

  final controller = Get.put(BuyerOrderController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              HeaderFilterItem(
                title: 'request'.tr,
                selected: (controller.selectedStatusFilter.value == "request"),
                count: controller.requestCount.value,
                flex: 1,
                onTap: () {
                  controller.selectedStatusFilter.value = "request";
                },
              ),
              SizedBox(
                width: 4,
              ),
              HeaderFilterItem(
                title: 'proceed'.tr,
                selected: (controller.selectedStatusFilter.value == "proceed"),
                count: controller.requestCount.value,
                flex: 1,
                onTap: () {
                  controller.selectedStatusFilter.value = "proceed";
                },
              ),
              SizedBox(
                width: 4,
              ),
              HeaderFilterItem(
                title: 'delivered'.tr,
                selected:
                    (controller.selectedStatusFilter.value == "delivered"),
                count: controller.requestCount.value,
                flex: 1,
                onTap: () {
                  controller.selectedStatusFilter.value = "delivered";
                },
              ),
            ],
          ),
        ));
  }
}
