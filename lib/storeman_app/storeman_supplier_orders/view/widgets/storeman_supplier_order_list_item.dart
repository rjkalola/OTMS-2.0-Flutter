import 'package:belcka/buyer_app/buyer_order/model/order_info.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/text/PrimaryTextView.dart';
import 'package:belcka/widgets/text/TextViewWithContainer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/string_helper.dart';

class StoremanSupplierOrderListItem extends StatelessWidget {
  final OrderInfo item;
  final VoidCallback onTap;

  const StoremanSupplierOrderListItem({
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
                PrimaryTextView(
                  text: item.date ?? "",
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
                const SizedBox(height: 2),
                PrimaryTextView(
                  text: item.supplierName ?? item.userName ?? "",
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                const SizedBox(height: 2),
                PrimaryTextView(
                  text: "${'items_in_order'.tr}:  ${item.orderQty ?? 0}",
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
                padding: const EdgeInsets.fromLTRB(8, 1, 8, 1),
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
