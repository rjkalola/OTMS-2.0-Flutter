import 'package:belcka/buyer_app/buyer_order/model/order_info.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/res/drawable.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/text/PrimaryTextView.dart';
import 'package:belcka/widgets/text/TextViewWithContainer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/app_utils.dart';
import '../../../../utils/string_helper.dart';

class BuyerOrderListItem extends StatelessWidget {
  final OrderInfo item;
  final VoidCallback onListItem;
  final GestureTapCallback? onInvoiceClick;

  const BuyerOrderListItem({
    super.key,
    required this.item,
    required this.onListItem,
    this.onInvoiceClick,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onListItem,
      child: Stack(
        children: [
          CardViewDashboardItem(
            borderRadius: 14,
            margin: const EdgeInsets.fromLTRB(12, 7, 12, 7),
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PrimaryTextView(
                          text: item.date ?? "",
                          fontSize: 14,
                        ),
                        const SizedBox(height: 2),
                        PrimaryTextView(
                          text: [
                            if (!StringHelper.isEmptyString(item.storeName))
                              item.storeName,
                            if (!StringHelper.isEmptyString(item.supplierName))
                              item.supplierName,
                          ].join(" | "),
                          fontSize: 16,
                        ),
                        const SizedBox(height: 2),
                        PrimaryTextView(
                          text:
                              "${'total_amount'.tr}: ${item.currency ?? ""}${item.totalAmount ?? ""}",
                          fontSize: 15,
                        ),
                        const SizedBox(height: 2),
                        PrimaryTextView(
                          text:
                              "${'delivery_date'.tr}: ${item.expectedDeliveryDate ?? ""}",
                          fontSize: 15,
                        )
                      ],
                    ),
                  ),
                  Stack(
                    alignment: Alignment.topRight,
                    children: [
                      PrimaryTextView(
                        text: "${'order'.tr}: ${item.orderId ?? ""}",
                        color: secondaryLightTextColor_(context),
                        fontSize: 13,
                      ),
                      GestureDetector(
                        onTap: onInvoiceClick,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: ImageUtils.setSvgAssetsImage(
                            path: Drawable.pdfIcon,
                            width: 28,
                            height: 28,
                            color: Colors.red,
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          Visibility(
            visible: !StringHelper.isEmptyString(item.statusText),
            child: Align(
              alignment: Alignment.topLeft,
              child: TextViewWithContainer(
                margin: const EdgeInsets.only(left: 34, top: 0),
                text: item.statusText ?? "",
                padding: const EdgeInsets.fromLTRB(5, 1, 5, 1),
                fontColor: Colors.white,
                fontWeight: FontWeight.w400,
                fontSize: 11,
                boxColor: AppUtils.getOrderStatusColor(item.status ?? 0),
              ),
            ),
          )
        ],
      ),
    );
  }
}
