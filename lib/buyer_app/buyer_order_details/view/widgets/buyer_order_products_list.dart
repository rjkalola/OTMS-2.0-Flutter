import 'package:belcka/buyer_app/buyer_order/controller/buyer_order_controller.dart';
import 'package:belcka/buyer_app/buyer_order/view/widgets/buyer_proceed_order_list_item.dart';
import 'package:belcka/buyer_app/buyer_order_details/controller/buyer_order_details_controller.dart';
import 'package:belcka/buyer_app/buyer_order_details/view/widgets/buyer_order_products_list_item.dart';
import 'package:belcka/widgets/other_widgets/no_data_found_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BuyerOrderProductsList extends StatelessWidget {
  BuyerOrderProductsList({super.key});

  final controller = Get.find<BuyerOrderDetailsController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.orderProductsList.isNotEmpty
          ? ListView.separated(
              // controller: controller.orderProductsList,
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: controller.orderProductsList.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final item = controller.orderProductsList[index];
                return BuyerOrderProductsListItem(
                  item: item,
                  onListItem: () => controller.onItemClick(index),
                  onAdd: () => controller.increaseQty(index),
                  onRemove: () => controller.decreaseQty(index),
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
