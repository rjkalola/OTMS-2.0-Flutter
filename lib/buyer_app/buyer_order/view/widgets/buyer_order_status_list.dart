import 'package:belcka/buyer_app/buyer_order/controller/buyer_order_controller.dart';
import 'package:belcka/buyer_app/buyer_order/view/widgets/buyer_order_list_item.dart';
import 'package:belcka/utils/enums/order_tab_type.dart';
import 'package:belcka/widgets/other_widgets/no_data_found_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Upcoming / Processing / Delivered share [BuyerOrderController.ordersList]
/// and [BuyerOrderController.ordersScrollController].
class BuyerOrderStatusList extends StatelessWidget {
  const BuyerOrderStatusList({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BuyerOrderController>();

    return Obx(() {
      final tab = controller.selectedTab.value;
      if (tab != OrderTabType.upcoming &&
          tab != OrderTabType.proceed &&
          tab != OrderTabType.delivered &&
          tab != OrderTabType.cancelled) {
        return const SizedBox.shrink();
      }

      final orders = controller.ordersList;
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
            return BuyerOrderListItem(
              item: item,
              isIncompleteLayout: controller.isIncompletedOrdersFlow,
              onListItem: () => controller.onItemClick(index),
              onInvoiceClick: () =>
                  controller.buyerOrderInvoiceApi(item.id ?? 0),
            );
          },
        ),
      );
    });
  }
}
