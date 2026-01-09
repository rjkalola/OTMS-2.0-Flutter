import 'package:belcka/buyer_app/buyer_order/controller/buyer_order_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'buyer_order_list_item.dart';

class BuyerOrderList extends StatelessWidget {
  BuyerOrderList({super.key});

  final controller = Get.find<BuyerOrderController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: controller.ordersList.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final item = controller.ordersList[index];
          return BuyerOrderListItem(
            item: item,
            focusNode: controller.getQtyFocusNode(index),
            onAdd: () => controller.increaseQty(index),
            onRemove: () => controller.decreaseQty(index),
            onQtyTyped: (qty) => controller.setQty(index, qty),
            onDelete: () => controller.removeItem(index),
          );
        },
      ),
    );
  }
}
