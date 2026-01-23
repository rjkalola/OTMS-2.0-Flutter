import 'package:belcka/buyer_app/buyer_order/model/order_info.dart';
import 'package:belcka/buyer_app/buyer_order/view/widgets/order_quantity_change_button.dart';
import 'package:belcka/buyer_app/buyer_order/view/widgets/order_quantity_text_field.dart';
import 'package:belcka/pages/user_orders/widgets/orders_title_text_view.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:flutter/material.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';

class BasketListItem extends StatefulWidget {
  final OrderInfo item;
  final VoidCallback onAdd;
  final VoidCallback onRemove;
  final Function(int qty) onQtyTyped;
  final VoidCallback onDelete;
  final FocusNode focusNode;

  const BasketListItem({
    super.key,
    required this.item,
    required this.focusNode,
    required this.onAdd,
    required this.onRemove,
    required this.onQtyTyped,
    required this.onDelete,
  });

  @override
  State<BasketListItem> createState() => _BasketListItemState();
}

class _BasketListItemState extends State<BasketListItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
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
                  url: widget.item.image,
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
                      OrdersTitleTextView(
                        text: widget.item.name,
                        fontSize: 15,
                        maxLine: 2,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.w500,
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(height: 4),
                      Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                        Expanded(
                          child: OrdersTitleTextView(
                            text: widget.item.sku,
                            fontSize: 13,
                            maxLine: 1,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                            color: secondaryExtraLightTextColor_(context),
                          ),
                        ),
                        SizedBox(width: 12,),
                        Icon(Icons.delete, size: 25, color: Colors.red),
                      ]),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          OrderQuantityChangeButton(
                              text: "-", onTap: widget.onRemove),
                          SizedBox(width: 8),
                          OrderQuantityTextField(value: widget.item.qty,
                            onChanged: widget.onQtyTyped,
                            max: widget.item.availableQty,
                            maxLength: 3,
                          ),
                          SizedBox(width: 8),
                          OrderQuantityChangeButton(
                              text: "+", onTap: widget.onAdd),
                          SizedBox(width: 8),
                          Expanded(
                            child: OrdersTitleTextView(
                              maxLine: 1,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              text: "£${widget.item.price.toStringAsFixed(2)}",
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      OrdersTitleTextView(
                        text: "Available Qty: ${widget.item.availableQty}",
                        fontSize: 13,
                        color: secondaryExtraLightTextColor_(context),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
