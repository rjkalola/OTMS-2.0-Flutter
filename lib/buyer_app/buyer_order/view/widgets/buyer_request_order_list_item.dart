import 'package:belcka/buyer_app/buyer_order/model/order_info.dart';
import 'package:belcka/buyer_app/buyer_order/view/widgets/order_quantity_change_button.dart';
import 'package:belcka/buyer_app/buyer_order/view/widgets/order_quantity_display_text_view.dart';
import 'package:belcka/buyer_app/buyer_order/view/widgets/order_quantity_text_field.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/widgets/text/SubTitleTextView.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';

class BuyerRequestOrderListItem extends StatelessWidget {
  final OrderInfo item;
  final VoidCallback onAdd;
  final VoidCallback onRemove;
  final Function(int qty) onQtyTyped;
  final VoidCallback onDelete;
  final VoidCallback onListItem;
  // final FocusNode focusNode;

  const BuyerRequestOrderListItem(
      {super.key,
      required this.item,
      // required this.focusNode,
      required this.onAdd,
      required this.onRemove,
      required this.onQtyTyped,
      required this.onDelete,
      required this.onListItem});

  // @override
  // State<RequestBuyerOrderListItem> createState() =>
  //     _RequestBuyerOrderListItemState();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onListItem,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
        child: CardViewDashboardItem(
          borderRadius: 10,
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 6),
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
                            OrderQuantityChangeButton(
                                text: "-", onTap: onRemove),
                            const SizedBox(width: 8),
                            OrderQuantityDisplayTextView(
                              value: item.qty,
                              width: 52,
                              height: 30,
                            ),
                            // OrderQuantityTextField(
                            //   value: item.qty,
                            //   max: item.availableQty,
                            //   onChanged: onQtyTyped,
                            //   maxLength: 3,
                            //   width: 52,
                            //   height: 32,
                            //   focusNode: focusNode,
                            // ),
                            const SizedBox(width: 8),
                            OrderQuantityChangeButton(text: "+", onTap: onAdd),
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
                      ],
                    ),
                  ),
                ],
              ),
              Divider(color: dividerColor_(context)),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TitleTextView(
                          text: item.projectName,
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                        const SizedBox(height: 2),
                        TitleTextView(
                          text: item.userName,
                          fontSize: 15,
                          color: Colors.blue,
                          fontWeight: FontWeight.w400,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: onDelete,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

// class _RequestBuyerOrderListItemState extends State<RequestBuyerOrderListItem> {
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
