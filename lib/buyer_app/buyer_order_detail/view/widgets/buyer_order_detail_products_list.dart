import 'package:belcka/buyer_app/buyer_order_detail/controller/buyer_order_detail_controller.dart';
import 'package:belcka/buyer_app/buyer_order_detail/view/widgets/buyer_order_detail_products_list_item.dart';
import 'package:belcka/widgets/other_widgets/no_data_found_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BuyerOrderDetailProductsList extends StatelessWidget {
  BuyerOrderDetailProductsList({super.key});

  final controller = Get.find<BuyerOrderDetailController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.orderProductsList.isNotEmpty
          ? ListView.separated(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: controller.orderProductsList.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final item = controller.orderProductsList[index];
                return BuyerOrderDetailProductsListItem(
                  item: item,
                  onListItem: () => controller.onItemClick(index),
                  onAdd: () => controller.increaseQty(index),
                  onRemove: () => controller.decreaseQty(index),
                  index: index,
                  status: controller.status.value,
                );
              },
            )
          : const Center(
              child: NoDataFoundWidget(),
            ),
    );
  }
}
