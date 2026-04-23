import 'package:belcka/pages/user_orders/hire_module/user_hire_products/controller/user_hire_product_controller.dart';
import 'package:belcka/pages/user_orders/hire_module/user_hire_products/view/widgets/hire_order_product_line_list_item.dart';
import 'package:belcka/pages/user_orders/hire_module/user_hire_products/view/widgets/request_hire_order_list_item.dart';
import 'package:belcka/utils/enums/hire_user_product_status.dart';
import 'package:belcka/widgets/other_widgets/no_data_found_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HireOrderStatusList extends StatelessWidget {
  const HireOrderStatusList({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UserHireProductController>();

    return Obx(() {
      final tab = controller.selectedTab.value;
      if (tab == HireUserProductStatus.available) {
        return const SizedBox.shrink();
      }

      if (tab == HireUserProductStatus.hired ||
          tab == HireUserProductStatus.inService) {
        final lines = controller.hireProductsList;
        if (lines.isEmpty) {
          return const Center(child: NoDataFoundWidget());
        }
        return Padding(
          padding: const EdgeInsets.only(top: 10),
          child: ListView.separated(
            controller: controller.ordersScrollController,
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            physics: const ClampingScrollPhysics(),
            itemCount: lines.length,
            separatorBuilder: (_, __) => const SizedBox(height: 14),
            itemBuilder: (context, index) {
              final item = lines[index];
              return HireOrderProductLineListItem(
                item: item,
                onListItem: () => controller.onHireProductLineClick(index),
                onReturnTap: tab == HireUserProductStatus.hired
                    ? () => controller.onHireProductLineReturnTap(index)
                    : null,
                isFromProfile: true,
              );
            },
          ),
        );
      }

      final orders = controller.hireOrdersList;
      if (orders.isEmpty) {
        return const Center(child: NoDataFoundWidget());
      }

      return Padding(
        padding: const EdgeInsets.only(top: 10),
        child: ListView.separated(
          controller: controller.ordersScrollController,
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          physics: const ClampingScrollPhysics(),
          itemCount: orders.length,
          separatorBuilder: (_, __) => const SizedBox(height: 14),
          itemBuilder: (context, index) {
            final item = orders[index];
            return RequestHireOrderListItem(
              item: item,
              orderListIndex: index,
              onListItem: () => controller.onHireOrderItemClick(index),
              onApproveProduct: controller.onRequestOrderApproveProductLine,
              onCancelProduct: controller.onRequestOrderCancelProductLine,
              showApproveButton: false,
              isFromProfile: true,
            );
          },
        ),
      );
    });
  }
}
