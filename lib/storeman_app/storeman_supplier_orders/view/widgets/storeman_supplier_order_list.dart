import 'package:belcka/buyer_app/buyer_order/model/order_info.dart';
import 'package:belcka/storeman_app/storeman_supplier_orders/controller/storeman_supplier_order_controller.dart';
import 'package:belcka/storeman_app/storeman_supplier_orders/view/widgets/storeman_supplier_order_list_item.dart';
import 'package:belcka/widgets/other_widgets/no_data_found_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StoremanSupplierOrderList extends StatelessWidget {
  final controller = Get.put(StoremanSupplierOrderController());

  StoremanSupplierOrderList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.ordersList.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.only(top: 10),
              child: ListView.separated(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: controller.ordersList.length,
                separatorBuilder: (_, __) => const SizedBox(height: 14),
                itemBuilder: (context, index) {
                  return StoremanSupplierOrderListItem(
                    item: controller.ordersList[index],
                    onTap: () {
                      controller.onItemClick(controller.ordersList[index].id??0, 0);
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
