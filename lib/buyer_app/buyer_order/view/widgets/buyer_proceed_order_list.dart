import 'package:belcka/buyer_app/buyer_order/controller/buyer_order_controller.dart';
import 'package:belcka/buyer_app/buyer_order/view/widgets/buyer_proceed_order_list_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BuyerProceedOrderList extends StatelessWidget {
  BuyerProceedOrderList({super.key});

  final controller = Get.find<BuyerOrderController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListView.separated(
        controller: controller.proceedScrollController,
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        physics: const AlwaysScrollableScrollPhysics(),
        // shrinkWrap: true,
        itemCount: controller.proceedOrdersList.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final item = controller.proceedOrdersList[index];
          return BuyerProceedOrderListItem(
            item: item,
            onListItem: () => controller.onItemClick(index),
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
