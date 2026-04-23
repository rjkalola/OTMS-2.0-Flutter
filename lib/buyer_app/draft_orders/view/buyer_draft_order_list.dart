import 'package:belcka/buyer_app/draft_orders/controller/buyer_draft_orders_controller.dart';
import 'package:belcka/buyer_app/draft_orders/view/buyer_draft_order_list_item.dart';
import 'package:belcka/widgets/other_widgets/no_data_found_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BuyerDraftOrderList extends StatelessWidget {
  BuyerDraftOrderList({super.key});

  final controller = Get.find<BuyerDraftOrdersController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.ordersList.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.only(top: 18),
              child: ListView.separated(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                physics: const ClampingScrollPhysics(),
                // shrinkWrap: true,
                itemCount: controller.ordersList.length,
                separatorBuilder: (_, __) => const SizedBox(height: 14),
                itemBuilder: (context, index) {
                  final item = controller.ordersList[index];
                  return BuyerDraftOrderListItem(
                    item: item,
                    onListItem: () => controller.onItemClick(index),
                    onDeleteClick: () => controller.onDeleteClick(index),
                  );
                },
              ),
            )
          : Center(
              child: NoDataFoundWidget(),
            ),
    );
  }
}
