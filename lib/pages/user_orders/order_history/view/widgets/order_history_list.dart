import 'package:belcka/pages/user_orders/categories/controller/user_orders_categories_controller.dart';
import 'package:belcka/pages/user_orders/categories/view/widgets/user_orders_category_card.dart';
import 'package:belcka/pages/user_orders/order_history/controller/order_history_controller.dart';
import 'package:belcka/pages/user_orders/order_history/view/widgets/order_history_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderHistoryList extends StatelessWidget {
  OrderHistoryList({super.key});

  final controller = Get.put(OrderHistoryController());

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        children: [
          OrderCard(
            orderId: "R1053aaasadssdfskdfl;sfk;sldkf;",
            statusIndex: 2,
            lastLabel: "Delivered",
          ),
          OrderCard(
            orderId: "R1053",
            statusIndex: 0,
            lastLabel: "Collect",
          ),
          OrderCard(
            orderId: "869514",
            statusIndex: 1,
            lastLabel: "Collect",
          ),
          OrderCard(
            orderId: "45689",
            statusIndex: 2,
            lastLabel: "Delivered",
          ),
        ],
      ),
    );
  }
}
