import 'package:belcka/buyer_app/buyer_order/controller/buyer_order_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'buyer_request_order_list_item.dart';

class BuyerRequestOrderList extends StatelessWidget {
  BuyerRequestOrderList({super.key});

  final controller = Get.find<BuyerOrderController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListView.separated(
        controller: controller.requestScrollController,
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        physics: const AlwaysScrollableScrollPhysics(),
        // shrinkWrap: true,
        itemCount: controller.requestOrdersList.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final item = controller.requestOrdersList[index];
          return BuyerRequestOrderListItem(
            item: item,
            onListItem: () => controller.onItemClick(index),
            focusNode: controller.getQtyFocusNode(index),
            onAdd: () => controller.increaseQty(index),
            onRemove: () => controller.decreaseQty(index),
            onQtyTyped: (qty) => controller.setQty(index, qty),
            onDelete: () => controller.removeItem(index),
          );
          // return DeliveredBuyerOrderListItem(
          //   item: item,
          //   onListItem: () => controller.onItemClick(index),
          // );
        },
      ),
    );
  }
}
