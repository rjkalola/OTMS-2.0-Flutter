import 'package:belcka/buyer_app/buyer_order/model/order_info.dart';
import 'package:belcka/buyer_app/buyer_order/view/widgets/order_quantity_display_text_view.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/text/SubTitleTextView.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProceedBuyerOrderListItem extends StatelessWidget {
  final OrderInfo item;
  final VoidCallback onListItem;

  const ProceedBuyerOrderListItem(
      {super.key,
      required this.item,
      required this.onListItem});

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
          borderRadius: 10,
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ImageUtils.setRectangleCornerCachedNetworkImage(
                    url: item.image,
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
                          text: item.name,
                          fontSize: 15,
                          maxLine: 2,
                          fontWeight: FontWeight.w500,
                        ),
                        const SizedBox(height: 4),
                        SubtitleTextView(
                          text: item.sku,
                          fontSize: 13,
                          color: secondaryExtraLightTextColor_(context),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            OrderQuantityDisplayTextView(
                              value: item.qty,
                              width: 52,
                              height: 30,
                            ),
                            const Spacer(),
                            TitleTextView(
                              text: "£${item.price.toStringAsFixed(2)}",
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        TitleTextView(
                          text: "Available Qty: ${item.availableQty}",
                          fontSize: 13,
                          color: secondaryExtraLightTextColor_(context),
                        ),
                        const SizedBox(height: 3),
                        TitleTextView(
                          text: "${'expected_qty'.tr}: 5",
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// class _ProceedBuyerOrderListItemState extends State<ProceedBuyerOrderListItem> {
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {},
//       child: Padding(
//         padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
//         child: CardViewDashboardItem(
//           borderRadius: 10,
//           padding: const EdgeInsets.fromLTRB(14, 14, 14, 6),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   ImageUtils.setRectangleCornerCachedNetworkImage(
//                     url: item.image,
//                     width: 90,
//                     height: 90,
//                     borderRadius: 4,
//                     fit: BoxFit.cover,
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         TitleTextView(
//                           text: item.name,
//                           fontSize: 15,
//                           maxLine: 2,
//                           fontWeight: FontWeight.w500,
//                         ),
//                         const SizedBox(height: 4),
//                         SubtitleTextView(
//                           text: item.sku,
//                           fontSize: 13,
//                           color: secondaryExtraLightTextColor_(context),
//                         ),
//                         const SizedBox(height: 10),
//                         Row(
//                           children: [
//                             OrderQuantityChangeButton(
//                                 text: "-", onTap: onRemove),
//                             const SizedBox(width: 8),
//                             QtyTextField(
//                               value: item.qty,
//                               max: item.availableQty,
//                               onChanged: onQtyTyped,
//                               maxLength: 3,
//                               width: 52,
//                               height: 32,
//                               focusNode: focusNode,
//                             ),
//                             const SizedBox(width: 8),
//                             OrderQuantityChangeButton(
//                                 text: "+", onTap: onAdd),
//                             const Spacer(),
//                             TitleTextView(
//                               text: "£${item.price.toStringAsFixed(2)}",
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 6),
//                         TitleTextView(
//                           text: "Available Qty: ${item.availableQty}",
//                           fontSize: 13,
//                           color: secondaryExtraLightTextColor_(context),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//               Divider(color: dividerColor_(context)),
//               Row(
//                 children: [
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         TitleTextView(
//                           text: item.projectName,
//                           fontSize: 15,
//                           fontWeight: FontWeight.w400,
//                         ),
//                         const SizedBox(height: 2),
//                         TitleTextView(
//                           text: item.userName,
//                           fontSize: 15,
//                           color: Colors.blue,
//                           fontWeight: FontWeight.w400,
//                         ),
//                       ],
//                     ),
//                   ),
//                   IconButton(
//                     icon: const Icon(Icons.delete, color: Colors.red),
//                     onPressed: onDelete,
//                   )
//                 ],
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
