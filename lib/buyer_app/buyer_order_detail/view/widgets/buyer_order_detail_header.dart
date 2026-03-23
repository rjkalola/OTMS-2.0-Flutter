import 'package:belcka/buyer_app/buyer_order/model/order_info.dart';
import 'package:belcka/buyer_app/buyer_order_detail/controller/buyer_order_detail_controller.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/res/drawable.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/widgets/text/PrimaryTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BuyerOrderDetailHeader extends StatelessWidget {
  final controller = Get.find<BuyerOrderDetailController>();

  final OrderInfo item;
  final VoidCallback onListItem;

  BuyerOrderDetailHeader(
      {super.key, required this.item, required this.onListItem});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor_(context),
        boxShadow: [AppUtils.boxShadow(shadowColor_(context), 10)],
        border: Border.all(width: 0.6, color: Colors.transparent),
        borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(28),
            bottomRight: Radius.circular(28)),
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
                        text: "${'store'.tr}: ${item.storeName ?? ""}",
                        fontSize: 16,
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      PrimaryTextView(
                        text: "${'supplier'.tr}: ${item.supplierName ?? ""}",
                        fontSize: 16,
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      PrimaryTextView(
                        text:
                            "${'items_qty'.tr}: ${AppUtils.formatDecimalNumber(item.orderQty ?? 0)}",
                        fontSize: 16,
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      PrimaryTextView(
                        text: "${'received_on'.tr}: ${item.date ?? ""}",
                        fontSize: 16,
                      ),
                      const SizedBox(
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
}
