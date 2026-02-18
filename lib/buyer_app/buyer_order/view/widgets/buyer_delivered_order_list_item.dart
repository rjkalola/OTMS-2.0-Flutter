import 'package:belcka/buyer_app/buyer_order/model/order_info.dart';
import 'package:belcka/buyer_app/buyer_order/view/widgets/order_quantity_display_text_view.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/text/SubTitleTextView.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:flutter/material.dart';

class BuyerDeliveredOrderListItem extends StatelessWidget {
  final OrderInfo item;
  final VoidCallback onListItem;

  const BuyerDeliveredOrderListItem(
      {super.key, required this.item, required this.onListItem});

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
                        Row(
                          children: [
                            Expanded(
                              child: TitleTextView(
                                text: item.name,
                                fontSize: 15,
                                maxLine: 2,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            // ImageUtils.setAssetsImage(
                            //     path: Drawable.deliveredImage,
                            //     width: 40,
                            //     height: 40)
                          ],
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
