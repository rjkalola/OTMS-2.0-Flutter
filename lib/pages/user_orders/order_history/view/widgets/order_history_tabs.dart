import 'package:belcka/buyer_app/buyer_order/controller/buyer_order_controller.dart';
import 'package:belcka/pages/user_orders/order_history/controller/order_history_controller.dart';
import 'package:belcka/widgets/other_widgets/header_filter_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderHistoryTabs extends StatelessWidget {
  OrderHistoryTabs({super.key});

  final controller = Get.put(OrderHistoryController());

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          HeaderFilterItem(
            title: 'All'.tr,
            selected: true,
            count: 0,
            flex: 1,
            onTap: () {
              //controller.selectedStatusFilter.value = "request";
            },
          ),
          SizedBox(
            width: 4,
          ),
          HeaderFilterItem(
            title: 'Delivered'.tr,
            selected: false,
            count: 0,
            flex: 1,
            onTap: () {
              //controller.selectedStatusFilter.value = "proceed";
            },
          ),
          SizedBox(
            width: 4,
          ),
          HeaderFilterItem(
            title: 'Collected'.tr,
            selected:false,
            count: 0,
            flex: 1,
            onTap: () {
              //controller.selectedStatusFilter.value = "delivered";
            },
          ),
          HeaderFilterItem(
            title: 'Returned'.tr,
            selected:false,
            count: 0,
            flex: 1,
            onTap: () {
              //controller.selectedStatusFilter.value = "delivered";
            },
          ),
          HeaderFilterItem(
            title: 'Cancelled'.tr,
            selected:false,
            count: 0,
            flex: 1,
            onTap: () {
              //controller.selectedStatusFilter.value = "delivered";
            },
          ),
        ],
      ),
    );
  }
}
