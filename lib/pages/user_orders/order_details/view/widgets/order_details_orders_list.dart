import 'package:belcka/pages/user_orders/order_details/controller/order_details_controller.dart';
import 'package:belcka/pages/user_orders/order_details/view/widgets/order_action_buttons.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/text/SubTitleTextView.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderDetailsOrdersList extends StatelessWidget {
  OrderDetailsOrdersList({super.key});

  final controller = Get.put(OrderDetailsController());

  @override
  Widget build(BuildContext context) {

    final orderInfo = controller.orderDetails[0];
    final orders = orderInfo.orders ?? [];

    return ListView.separated(
      shrinkWrap: true,
      itemCount: orders.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = orders[index];
        return CardViewDashboardItem(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: Image.network(
                    orders[index].productThumbImage ?? "",
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stack) {
                      return Center(
                        child: Icon(
                          Icons.photo_outlined,
                          size: 70,
                          color: Colors.grey.shade300,
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(width: 12),

                /// Product details takes remaining space
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TitleTextView(
                        text: orders[index].shortName ?? "",
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),

                      const SizedBox(height: 4),

                      SubtitleTextView(
                        text: orders[index].uuid ?? "",
                      ),

                      const SizedBox(height: 4),

                      TitleTextView(
                        text: "${'qty'.tr}: ${orders[index].qty ?? ""}",
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),

                      const SizedBox(height: 4),

                      TitleTextView(
                        text: "${orderInfo.currency ?? ""}${orders[index].price ?? ""}",
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 12),
                /*
                /// Buttons fixed on right side
                SizedBox(
                  width: 120,
                  child: OrderActionButtons(
                    status: 0,
                    mainTitle: 'reorder',
                    onCancel: () {
                      print("Cancel order");
                    },
                    onReturn: () {
                      print("Return order");
                    },
                    onReorder: () {
                      print("Reorder items");
                    },
                  ),
                ),
                */
              ],
            ),
          ),
        );
      },
    );
  }
}
