import 'package:belcka/buyer_app/buyer_order/controller/buyer_order_controller.dart';
import 'package:belcka/buyer_app/buyer_order/view/widgets/buyer_delivered_order_list_item.dart';
import 'package:belcka/buyer_app/buyer_order/view/widgets/buyer_proceed_order_list_item.dart';
import 'package:belcka/widgets/other_widgets/no_data_found_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BuyerDeliveredOrderList extends StatelessWidget {
  BuyerDeliveredOrderList({super.key});

  final controller = Get.find<BuyerOrderController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.deliveredOrdersList.isNotEmpty
          ? ListView.separated(
              controller: controller.deliveredScrollController,
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              physics: const AlwaysScrollableScrollPhysics(),
              // shrinkWrap: true,
              itemCount: controller.deliveredOrdersList.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final item = controller.deliveredOrdersList[index];
                return BuyerDeliveredOrderListItem(
                  item: item,
                  onListItem: () => controller.onItemClick(index),
                );
                // return DeliveredBuyerOrderListItem(
                //   item: item,
                //   onListItem: () => controller.onItemClick(index),
                // );
              },
            )
          : Center(
              child: NoDataFoundWidget(),
            ),
    );
  }
}
