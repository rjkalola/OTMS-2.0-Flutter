import 'package:belcka/buyer_app/buyer_order/model/order_info.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/widgets/buttons/order_quantity_change_button.dart';
import 'package:belcka/widgets/text/SubTitleTextView.dart';
import 'package:belcka/widgets/textfield/order_quantity_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';

class BuyerOrderListItem extends StatefulWidget {
  final OrderInfo item;
  final VoidCallback onAdd;
  final VoidCallback onRemove;
  final Function(int qty) onQtyTyped;
  final VoidCallback onDelete;
  final FocusNode focusNode;

  const BuyerOrderListItem({
    super.key,
    required this.item,
    required this.focusNode,
    required this.onAdd,
    required this.onRemove,
    required this.onQtyTyped,
    required this.onDelete,
  });

  @override
  State<BuyerOrderListItem> createState() => _BuyerOrderListItemState();
}

class _BuyerOrderListItemState extends State<BuyerOrderListItem> {
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
                      TitleTextView(
                        text: widget.item.name,
                        fontSize: 15,
                        maxLine: 2,
                        fontWeight: FontWeight.w500,
                      ),
                      const SizedBox(height: 4),
                      SubtitleTextView(
                        text: widget.item.sku,
                        fontSize: 13,
                        color: secondaryExtraLightTextColor_(context),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          OrderQuantityChangeButton(
                              text: "-", onTap: widget.onRemove),
                          const SizedBox(width: 8),
                          QtyTextField(
                            value: widget.item.qty,
                            max: widget.item.availableQty,
                            onChanged: widget.onQtyTyped,
                            maxLength: 3,
                            width: 52,
                            height: 32,
                            focusNode: widget.focusNode,
                          ),
                          const SizedBox(width: 8),
                          OrderQuantityChangeButton(
                              text: "+", onTap: widget.onAdd),
                          const Spacer(),
                          TitleTextView(
                            text: "£${widget.item.price.toStringAsFixed(2)}",
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      TitleTextView(
                        text: "Available Qty: ${widget.item.availableQty}",
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
                        text: widget.item.projectName,
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                      const SizedBox(height: 2),
                      TitleTextView(
                        text: widget.item.userName,
                        fontSize: 15,
                        color: Colors.blue,
                        fontWeight: FontWeight.w400,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: widget.onDelete,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
