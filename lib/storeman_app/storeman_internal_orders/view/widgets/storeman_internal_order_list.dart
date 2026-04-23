import 'package:belcka/buyer_app/buyer_order/model/order_info.dart';
import 'package:belcka/storeman_app/storeman_internal_orders/controller/storeman_internal_order_controller.dart';
import 'package:belcka/storeman_app/storeman_internal_orders/view/widgets/storeman_internal_order_list_item.dart';
import 'package:belcka/widgets/other_widgets/no_data_found_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StoremanInternalOrderList extends StatelessWidget {
  final controller = Get.find<StoremanInternalOrderController>();

  StoremanInternalOrderList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.ordersList.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.only(top: 10),
              child: ListView.separated(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                physics: const ClampingScrollPhysics(),
                itemCount: controller.ordersList.length,
                separatorBuilder: (_, __) => const SizedBox(height: 14),
                itemBuilder: (context, index) {
                  return StoremanInternalOrderListItem(
                    item: controller.ordersList[index],
                    onTap: () {
                      controller.onItemClick(index);
                    },
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
