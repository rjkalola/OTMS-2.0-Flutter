import 'package:belcka/buyer_app/buyer_order/model/order_info.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/text/PrimaryTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BuyerProceedOrderListItem extends StatelessWidget {
  final OrderInfo item;
  final VoidCallback onListItem;
  final GestureTapCallback? onInvoiceClick;

  const BuyerProceedOrderListItem(
      {super.key,
      required this.item,
      required this.onListItem,
      this.onInvoiceClick});

  // @override
  // State<ProceedBuyerOrderListItem> createState() =>
  //     _ProceedBuyerOrderListItemState();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onListItem,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
        child: CardViewDashboardItem(
          borderRadius: 14,
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
    // return GestureDetector(
    //   onTap: onListItem,
    //   child: Padding(
    //     padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
    //     child: CardViewDashboardItem(
    //       borderRadius: 10,
    //       padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
    //       child: Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           Row(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               ImageUtils.setRectangleCornerCachedNetworkImage(
    //                 url: item.image,
    //                 width: 90,
    //                 height: 90,
    //                 borderRadius: 4,
    //                 fit: BoxFit.cover,
    //               ),
    //               const SizedBox(width: 12),
    //               Expanded(
    //                 child: Column(
    //                   crossAxisAlignment: CrossAxisAlignment.start,
    //                   children: [
    //                     TitleTextView(
    //                       text: item.name,
    //                       fontSize: 15,
    //                       maxLine: 2,
    //                       fontWeight: FontWeight.w500,
    //                     ),
    //                     const SizedBox(height: 4),
    //                     SubtitleTextView(
    //                       text: item.sku,
    //                       fontSize: 13,
    //                       color: secondaryExtraLightTextColor_(context),
    //                     ),
    //                     const SizedBox(height: 10),
    //                     Row(
    //                       children: [
    //                         OrderQuantityDisplayTextView(
    //                           value: item.qty,
    //                           width: 52,
    //                           height: 30,
    //                         ),
    //                         const Spacer(),
    //                         TitleTextView(
    //                           text: "£${item.price.toStringAsFixed(2)}",
    //                           fontSize: 16,
    //                           fontWeight: FontWeight.bold,
    //                         ),
    //                       ],
    //                     ),
    //                     const SizedBox(height: 6),
    //                     TitleTextView(
    //                       text: "Available Qty: ${item.availableQty}",
    //                       fontSize: 13,
    //                       color: secondaryExtraLightTextColor_(context),
    //                     ),
    //                     const SizedBox(height: 3),
    //                     TitleTextView(
    //                       text: "${'expected_qty'.tr}: 5",
    //                       fontSize: 14,
    //                       fontWeight: FontWeight.w400,
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }
}
