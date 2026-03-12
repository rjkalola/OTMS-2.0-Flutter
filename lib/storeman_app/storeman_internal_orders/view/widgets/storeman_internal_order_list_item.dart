import 'package:belcka/buyer_app/buyer_order/model/order_info.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/text/PrimaryTextView.dart';
import 'package:belcka/widgets/text/TextViewWithContainer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/string_helper.dart';

class StoremanInternalOrderListItem extends StatelessWidget {
  final OrderInfo item;
  final VoidCallback onTap;

  const StoremanInternalOrderListItem({
    super.key,
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          CardViewDashboardItem(
            borderRadius: 20,
            margin: const EdgeInsets.fromLTRB(12, 7, 12, 7),
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    PrimaryTextView(
                      text: item.date ?? "",
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                    SizedBox(
                      width: 9,
                    ),
                    Expanded(
                      child: PrimaryTextView(
                        text: item.supplierName ?? item.userName ?? "",
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        textAlign: TextAlign.end,
                        maxLine: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                PrimaryTextView(
                  text:
                      "${'items_in_order'.tr}:  ${AppUtils.formatDecimalNumber(item.orderQty ?? 0)}",
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
                const SizedBox(height: 3),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    PrimaryTextView(
                      text: "${'order'.tr}: ${item.orderId ?? ""}",
                      color: secondaryLightTextColor_(context),
                      fontSize: 14,
                    ),
                    // Row(
                    //   children: [
                    //     PrimaryTextView(
                    //       text: 'chat'.tr,
                    //       color: Colors.blue,
                    //       fontSize: 16,
                    //     ),
                    //     const SizedBox(width: 4),
                    //     const Icon(
                    //       Icons.chat_bubble_outline,
                    //       color: Colors.blue,
                    //       size: 20,
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ],
            ),
          ),
          Visibility(
            visible: !StringHelper.isEmptyString(item.statusText),
            child: Positioned(
              top: 0,
              left: 32,
              child: TextViewWithContainer(
                text: item.statusText ?? "",
                padding: EdgeInsets.fromLTRB(8, 1, 8, 1),
                fontColor: Colors.white,
                fontWeight: FontWeight.w400,
                fontSize: 12,
                boxColor: AppUtils.getOrderStatusColor(item.status ?? 0),
                borderRadius: 11,
              ),
            ),
          )
        ],
      ),
    );
  }
}
