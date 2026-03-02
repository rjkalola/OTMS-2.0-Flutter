import 'package:belcka/buyer_app/buyer_order/model/order_info.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/text/PrimaryTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/buyer_order_details_controller.dart';

class BuyerOrderDetailsHeader extends StatelessWidget {
  final controller = Get.find<BuyerOrderDetailsController>();

  final OrderInfo item;
  final VoidCallback onListItem;

  BuyerOrderDetailsHeader(
      {super.key, required this.item, required this.onListItem});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor_(context),
        boxShadow: [AppUtils.boxShadow(shadowColor_(context), 10)],
        border: Border.all(width: 0.6, color: Colors.transparent),
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(28), bottomRight: Radius.circular(28)),
      ),
      child: GestureDetector(
        onTap: onListItem,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
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
                      SizedBox(
                        height: 2,
                      ),
                      PrimaryTextView(
                        text: item.supplierName ?? "",
                        fontWeight: FontWeight.w600,
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
                      SizedBox(
                        height: 2,
                      ),
                      PrimaryTextView(
                        text:
                            "${'delivery_date'.tr}: ${item.expectedDeliveryDate ?? ""}",
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      )
                    ],
                  ),
                ),
                Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    // PrimaryTextView(
                    //   text: "${'order'.tr}: ${item.orderId ?? ""}",
                    //   color: secondaryLightTextColor_(context),
                    //   fontSize: 12,
                    // ),
                    GestureDetector(
                      onTap: () {
                        controller.buyerOrderInvoiceApi(item.id ?? 0);
                      },
                      child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Icon(
                            Icons.insert_drive_file_outlined,
                            size: 30,
                          )),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
