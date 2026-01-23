import 'package:belcka/pages/user_orders/basket/controller/basket_controller.dart';
import 'package:belcka/pages/user_orders/basket/view/widgets/basket_list_item.dart';
import 'package:belcka/pages/user_orders/order_history/controller/order_history_controller.dart';
import 'package:belcka/pages/user_orders/widgets/orders_title_text_view.dart';
import 'package:belcka/res/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderHistoryFilterItem extends StatefulWidget {

  final String title;
  final bool selected;

  const OrderHistoryFilterItem({
    super.key,
    required this.title,
    required this.selected
  });

  @override
  State<OrderHistoryFilterItem> createState() => _OrderHistoryFilterItemState();
}

class _OrderHistoryFilterItemState extends State<OrderHistoryFilterItem> {
  final controller = Get.put(OrderHistoryController());

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: widget.selected ? Colors.blueAccent : Colors.grey.shade300,
          width: 1.5,
        ),
      ),
      child: OrdersTitleTextView(
        text: widget.title,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}