import 'package:belcka/buyer_app/buyer_order/view/widgets/buyer_request_order_list_item.dart';
import 'package:belcka/buyer_app/create_buyer_order/controller/create_buyer_order_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class BuyerCreateOrderItemList extends StatelessWidget {
  BuyerCreateOrderItemList({super.key});
  
  final controller = Get.find<CreateBuyerOrderController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        // shrinkWrap: true,
        itemCount: controller.buyerOrdersList.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final item = controller.buyerOrdersList[index];
          return BuyerRequestOrderListItem(
            item: item,
            onListItem: () => controller.onItemClick(index),
            // focusNode: controller.getQtyFocusNode(index),
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
