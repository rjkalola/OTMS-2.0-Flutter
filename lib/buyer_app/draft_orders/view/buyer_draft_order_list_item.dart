import 'package:belcka/buyer_app/buyer_order/model/order_info.dart';
import 'package:belcka/res/drawable.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/text/PrimaryTextView.dart';
import 'package:belcka/widgets/text/TextViewWithContainer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/app_utils.dart';
import '../../../../utils/string_helper.dart';

class BuyerDraftOrderListItem extends StatelessWidget {
  final OrderInfo item;
  final VoidCallback onListItem;
  final GestureTapCallback? onDeleteClick;

  const BuyerDraftOrderListItem(
      {super.key,
      required this.item,
      required this.onListItem,
      this.onDeleteClick});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onListItem,
      child: CardViewDashboardItem(
        borderRadius: 14,
        margin: const EdgeInsets.fromLTRB(12, 0, 12, 0),
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PrimaryTextView(
                      text: item.date ?? "",
                      fontSize: 14,
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    PrimaryTextView(
                      text: item.supplierName ?? "",
                      fontSize: 16,
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    PrimaryTextView(
                      text:
                          "${'total_amount'.tr}: ${item.currency ?? ""}${item.totalAmount ?? ""}",
                      fontSize: 15,
                    ),
                    // SizedBox(
                    //   height: 2,
                    // ),
                    // PrimaryTextView(
                    //   text:
                    //       "${'delivery_date'.tr}: ${item.expectedDeliveryDate ?? ""}",
                    //   fontSize: 16,
                    // )
                  ],
                ),
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  GestureDetector(
                    onTap: onDeleteClick,
                    child: ImageUtils.setSvgAssetsImage(
                        path: Drawable.deleteIcon,
                        color: Colors.red,
                        width: 24,
                        height: 24),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
