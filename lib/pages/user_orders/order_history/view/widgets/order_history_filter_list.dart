import 'package:belcka/pages/user_orders/basket/controller/basket_controller.dart';
import 'package:belcka/pages/user_orders/basket/view/widgets/basket_list_item.dart';
import 'package:belcka/pages/user_orders/order_history/controller/order_history_controller.dart';
import 'package:belcka/pages/user_orders/order_history/view/widgets/order_history_filter_item.dart';
import 'package:belcka/pages/user_orders/widgets/orders_title_text_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderHistoryFilterList extends StatelessWidget {

  final controller = Get.put(OrderHistoryController());

  OrderHistoryFilterList({super.key});

  @override

  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          OrderHistoryFilterItem(title: "All", selected: true,),
          OrderHistoryFilterItem(title: "Delivered", selected: false,),
          OrderHistoryFilterItem(title: "Collected", selected: false,),
          OrderHistoryFilterItem(title: "Returned", selected: false,),
          OrderHistoryFilterItem(title: "Cancelled", selected: false,),
        ],
      ),
    );
  }
}