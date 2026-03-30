import 'package:belcka/pages/user_orders/order_history/controller/order_history_controller.dart';
import 'package:belcka/pages/user_orders/order_history/view/widgets/order_history_filter_tab_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderHistoryFilterTabs extends StatelessWidget {
  OrderHistoryFilterTabs({super.key});

  final controller = Get.put(OrderHistoryController());

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children:  [
          OrderHistoryFilterTabItem(label:'all'.tr, filter: OrderFilter.all),
          OrderHistoryFilterTabItem(label:'ready'.tr, filter: OrderFilter.ready),
          OrderHistoryFilterTabItem(label: 'delivered'.tr, filter: OrderFilter.delivered),
          OrderHistoryFilterTabItem(label: 'collected'.tr, filter: OrderFilter.collected),
          OrderHistoryFilterTabItem(label: 'returned'.tr, filter: OrderFilter.returned),
          OrderHistoryFilterTabItem(label: 'cancelled'.tr, filter: OrderFilter.cancelled),
        ],
      ),
    );
  }
}