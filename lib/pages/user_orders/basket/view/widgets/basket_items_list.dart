import 'package:belcka/pages/user_orders/basket/controller/basket_controller.dart';
import 'package:belcka/pages/user_orders/basket/view/widgets/basket_list_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BasketItemsList extends StatelessWidget {

  final controller = Get.put(BasketController());

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
          return BasketListItem(
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