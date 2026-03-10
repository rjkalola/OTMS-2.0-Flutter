import 'package:belcka/buyer_app/buyer_order/view/widgets/order_quantity_change_button.dart';
import 'package:belcka/buyer_app/buyer_order/view/widgets/order_quantity_display_text_view.dart';
import 'package:belcka/pages/user_orders/storeman_catalog/model/product_info.dart';
import 'package:belcka/utils/app_utils.dart';
import 'package:belcka/utils/image_utils.dart';
import 'package:belcka/widgets/text/SubTitleTextView.dart';
import 'package:flutter/material.dart';
import 'package:belcka/res/colors.dart';
import 'package:belcka/widgets/cardview/card_view_dashboard_item.dart';
import 'package:belcka/widgets/text/TitleTextView.dart';
import 'package:belcka/widgets/text/TextViewWithContainer.dart';
import 'package:belcka/utils/string_helper.dart';
import 'package:get/get.dart';

class StoremanHireProductListItem extends StatelessWidget {
  final ProductInfo item;
  final VoidCallback onAdd;
  final VoidCallback onRemove;
  final VoidCallback onListItem;

  StoremanHireProductListItem({
    super.key,
    required this.item,
    required this.onAdd,
    required this.onRemove,
    required this.onListItem,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onListItem,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
        child: Stack(
          children: [
            CardViewDashboardItem(
              borderRadius: 10,
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ImageUtils.setRectangleCornerCachedNetworkImage(
                        url: item.thumbUrl ?? "",
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
                              text: item.shortName ?? "",
                              fontSize: 15,
                              maxLine: 2,
                              fontWeight: FontWeight.w500,
                            ),
                            const SizedBox(height: 4),
                            SubtitleTextView(
                              text: item.uuid ?? "",
                              fontSize: 13,
                              color: secondaryExtraLightTextColor_(context),
                            ),
                            const SizedBox(height: 4),
                            TitleTextView(
                              text: "Qty: ${item.qty ?? 0}",
                              fontSize: 13,
                              color: secondaryExtraLightTextColor_(context),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                ],
              ),
            ),
            Visibility(
              visible: !StringHelper.isEmptyString(item.stockStatus ?? ""),
              child: Align(
                alignment: Alignment.topRight,
                child: TextViewWithContainer(
                  margin: const EdgeInsets.only(right: 25, top: 0),
                  text: item.stockStatus ?? "",
                  padding: const EdgeInsets.fromLTRB(5, 1, 5, 1),
                  fontColor: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 11,
                  boxColor: AppUtils.getProductStockStatusColor(item.stockStatusId ?? 0),
                  borderRadius: 5,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
