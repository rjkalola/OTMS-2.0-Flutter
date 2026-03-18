import 'package:belcka/res/colors.dart';
import 'package:belcka/storeman_app/storeman_internal_order_details/controller/storeman_internal_order_details_controller.dart';
import 'package:belcka/utils/app_constants.dart';
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
        final isSubQuantity = item.isSubQty ?? false;
        final deliveredQty = (double.tryParse(item.deliveredQty ?? "") ?? 0.00);
        final subQty = (double.tryParse(item.subQty ?? "") ?? 0.00);
        final qty = (double.tryParse(item.qty ?? "") ?? 0.00);
        final isItemDelivered = (item.status  == AppConstants.internalOrderStatus.delivered) ? true : false;
        final packOfUnit = item.packOfUnit ?? "";

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
                      const SizedBox(width: 16),

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
                            Row(
                              children: [
                                SubtitleTextView(
                                  text: orders[index].uuid ?? "",
                                ),
                                Spacer(),
                                TitleTextView(
                                  text: "${'qty'.tr}: ${isSubQuantity ? "${subQty.toInt()} $packOfUnit" : qty.toInt()}",
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                      ),
                    ],
                  ),
                  //SizedBox(height: 8,),
                  if (isItemDelivered)
                    Column(
                      children: [
                        Row(
                          children: [
                            Spacer(),
                            TitleTextView(
                              text: "Delivered Qty: ${isSubQuantity ? "${deliveredQty.toInt()} $packOfUnit" : deliveredQty.toInt()}",
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ],
                        ),
                        SizedBox(height: 8,),
                      ],
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
