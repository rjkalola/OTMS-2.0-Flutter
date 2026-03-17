import 'package:belcka/res/colors.dart';
import 'package:belcka/storeman_app/storeman_internal_order_details/controller/storeman_internal_order_details_controller.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/text/SubTitleTextView.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderDetailsOrdersList extends StatelessWidget {
  OrderDetailsOrdersList({super.key});

  final controller = Get.put(StoremanInternalOrderDetailsController());

  @override
  Widget build(BuildContext context) {

    final orderInfo = controller.orderDetails[0];
    final orders = orderInfo.orders ?? [];

    return ListView.separated(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: orders.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = orders[index];
        return Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
          child: CardViewDashboardItem(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ImageUtils.setRectangleCornerCachedNetworkImage(
                        url: orders[index].productThumbImage ?? "",
                        width: 90,
                        height: 90,
                        borderRadius: 4,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(width: 12),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TitleTextView(
                              text: orders[index].shortName ?? "",
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                            const SizedBox(height: 8),
                            SubtitleTextView(
                              text: orders[index].uuid ?? "",
                            ),
                            const SizedBox(height: 4),
                            TitleTextView(
                              text: "${'qty'.tr}: ${(orders[index].qty ?? "")}",
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                            const SizedBox(height: 4),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8,),
                  if (controller.canShowActionButtons)
                  Divider(
                    color: dividerColor_(context),
                  ),
                  if (controller.canShowActionButtons)
                  Row(
                    children: [
                      Spacer(),
                      ElevatedButton.icon(
                        onPressed: () {
                          print('Re-order button pressed');
                          controller.orderAgainAction(false, index);
                        },
                        icon: Icon(Icons.refresh),
                        label: TitleTextView(text: "reorder".tr,
                          fontSize: 15,
                          color: Colors.white,
                        fontWeight: FontWeight.w500,),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
