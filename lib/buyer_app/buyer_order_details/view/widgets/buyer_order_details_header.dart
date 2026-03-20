import 'package:belcka/buyer_app/buyer_order/model/order_info.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/res/drawable.dart';
import 'package:belcka/utils/app_constants.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/image_utils.dart';
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
                      // getDetailRow('order_date'.tr, item.date ?? ""),
                      // SizedBox(
                      //   height: 2,
                      // ),
                      // getDetailRow('store'.tr, item.storeName ?? ""),
                      PrimaryTextView(
                        text: "${'order_date'.tr}: ${item.date ?? ""}",
                        fontSize: 16,
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      PrimaryTextView(
                        text: "${'store'.tr}: ${item.storeName ?? ""}",
                        fontSize: 16,
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      PrimaryTextView(
                        text: "${'supplier'.tr}: ${item.supplierName ?? ""}",
                        fontSize: 16,
                      ),

                      SizedBox(
                        height: 3,
                      ),
                      PrimaryTextView(
                        text:
                            "${'total_amount'.tr}: ${item.currency ?? ""}${item.totalAmount ?? ""}",
                        fontSize: 16,
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      PrimaryTextView(
                        text:
                            "${'delivery_date'.tr}: ${item.expectedDeliveryDate ?? ""}",
                        fontSize: 16,
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Row(
                        children: [
                          PrimaryTextView(
                            text: "${'status'.tr}: ",
                            fontSize: 16,
                            color: primaryTextColor_(context),
                          ),
                          PrimaryTextView(
                            // text: (item.status) ==
                            //         AppConstants.orderStatus.received
                            //     ? "Received"
                            //     : item.statusText ?? "",
                            text: item.statusText ?? "",
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color:
                                AppUtils.getOrderStatusColor(item.status ?? 0),
                          )
                        ],
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
                          child: ImageUtils.setSvgAssetsImage(
                              path: Drawable.pdfIcon,
                              width: 36,
                              height: 36,
                              color: Colors.red)),
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

  Widget getDetailRow(String title, String value) {
    return RichText(
      text: TextSpan(
        style: TextStyle(fontSize: 15, color: primaryTextColor_(Get.context!)),
        children: [
          TextSpan(
              text: "$title: ",
              style: TextStyle(
                  color: primaryTextColor_(Get.context!),
                  fontWeight: FontWeight.w500,
                  fontSize: 15)),
          TextSpan(
            text: value,
            style: TextStyle(
                color: primaryTextColor_(Get.context!),
                fontWeight: FontWeight.normal,
                fontSize: 15),
          ),
        ],
      ),
    );
  }
}
