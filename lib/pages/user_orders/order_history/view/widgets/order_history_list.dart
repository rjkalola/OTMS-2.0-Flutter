import 'package:belcka/pages/user_orders/categories/controller/user_orders_categories_controller.dart';
import 'package:belcka/pages/user_orders/categories/view/widgets/user_orders_category_card.dart';
import 'package:belcka/pages/user_orders/order_history/controller/order_history_controller.dart';
import 'package:belcka/pages/user_orders/order_history/view/widgets/order_history_card.dart';
import 'package:belcka/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderHistoryList extends StatelessWidget {
  OrderHistoryList({super.key});

  final controller = Get.find<OrderHistoryController>();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Obx(() {

        if (controller.orderList.isEmpty) {
          return Center(child: Text('no_orders_found'.tr));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(0),
          itemCount: controller.orderList.length,
          itemBuilder: (context, index) {
            final order = controller.orderList[index];
            return InkWell(
              onTap: (){
                var arguments = {
                  "order_id":order.orderId,
                  "canShowActionButtons": true
                };
                controller.moveToScreen(AppRoutes.orderDetailsScreen, arguments);
              },
              child: OrderHistoryCard(
                orderNumber: order.orderNumber ?? "",
                amount: "${order.currency ?? ""}${order.totalAmount ?? 0}",
                date: order.date ?? "",
                status: order.status ?? 0,
              ),
            );
          },
        );
      }),
    );
  }
}